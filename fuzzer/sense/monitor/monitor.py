"""
Main flow monitor service.

This module implements the core monitoring loop that:
1. Polls /dev/shm for new executions
2. Parses shared memory regions
3. Correlates events and detects completed flows
4. Outputs results in JSONL format
5. Tracks statistics
"""

import time
import json
import sys
import logging
import csv
from pathlib import Path
from typing import Optional, Set, TextIO, Dict, List
from datetime import datetime

from config import MonitorConfig
from flow_db import FlowDatabase
from shm_protocol import discover_executions, parse_execution, ExecutionNotCompleteError
from event_processor import EventProcessor, Statistics
from analysis_db import SensitivityAnalysisDatabase
from reachability_estimator import ReachabilityEstimator
from enum import Enum, auto

# Add SRA to path — vendored copy at fuzzer/sense/sra/,
# with fallback to rq2/sra/ for development outside the devcontainer
_sra_local = str(Path(__file__).resolve().parents[1])  # fuzzer/sense/
_sra_rq2 = str(Path(__file__).resolve().parents[3] / "rq2")  # sra/rq2/
for _p in [_sra_local, _sra_rq2]:
    if _p not in sys.path:
        sys.path.insert(0, _p)



logger = logging.getLogger(__name__)

class ProcessExecutionResult(Enum):
    """Result of processing a single execution."""
    SUCCESS = auto()
    NOT_COMPLETE = auto()
    FILE_NOT_FOUND = auto()
    ERROR = auto()

class FlowMonitor:
    """
    Main flow monitoring service.
    
    Continuously monitors /dev/shm for completed executions and processes
    flow events to detect completed taint flows.
    """
    
    def __init__(self, config: MonitorConfig, flow_db: FlowDatabase):
        """
        Initialize flow monitor.
        
        Args:
            config: Monitor configuration
            flow_db: Flow database with flow definitions
        """
        self.config = config
        self.flow_db = flow_db
        self.processor = EventProcessor(flow_db)
        self.statistics = Statistics()
        self.analysis_db = SensitivityAnalysisDatabase(flow_db)

        # Load CFG and construct SRA Graph for reachability estimation
        sra_graph = None
        if config.cfg.cfg_path:
            sra_graph = self._load_cfg(config.cfg.cfg_path)

        self.reachability = ReachabilityEstimator(flow_db, sra_graph)

        self.shm_dir = Path(config.shared_memory.shm_dir)
        self.output_file: Optional[TextIO] = None
        self.running = False
        self.executions_processed = 0
        self.failed_executions = 0
        
        # CSV tracking for sensitivity over time
        self.csv_enabled = config.sensitivity_csv.enabled
        self.csv_interval = config.sensitivity_csv.interval_seconds
        self.csv_num_samples = config.sensitivity_csv.num_samples
        
        # Determine CSV output path - if relative, place it in same dir as output file
        csv_path = Path(config.sensitivity_csv.output_path)
        if not csv_path.is_absolute() and config.output.destination != "-":
            # Place CSV in same directory as the output JSONL file
            output_dir = Path(config.output.destination).parent
            self.csv_output_path = output_dir / csv_path
        else:
            self.csv_output_path = csv_path
        
        self.csv_data: Dict[int, List[float]] = {}  # flow_id -> [sensitivity_at_t0, sensitivity_at_t1, ...]
        self.csv_timestamps: List[float] = []  # [0, 5, 10, 15, ...]
        self.start_time: Optional[float] = None
        
        logger.info(f"FlowMonitor initialized with {flow_db}")
        if self.csv_enabled:
            logger.info(f"CSV tracking enabled: {self.csv_output_path} (interval={self.csv_interval}s)")
    
    @staticmethod
    def _load_cfg(cfg_path: str):
        """Load pre-built CFG JSON and construct SRA Graph."""
        from sra.estimator import Graph

        logger.info(f"Loading CFG from {cfg_path}")
        with open(cfg_path, 'r') as f:
            cfg_inter = json.load(f)

        # Convert linenums from lists back to sets (JSON serializes sets as lists)
        for node_info in cfg_inter["nodes"].values():
            if node_info.get("linenums") is not None:
                node_info["linenums"] = set(node_info["linenums"])

        graph = Graph(cfg_inter)
        logger.info(f"CFG loaded: {len(cfg_inter['nodes'])} nodes, "
                     f"{len(graph.intra_cfgs)} functions")
        return graph

    def start(self) -> None:
        """Start the monitoring service."""
        logger.info("Starting flow monitor service")
        
        # Setup output
        self._setup_output()
        
        # Cleanup stale regions on startup if configured
        if self.config.cleanup.cleanup_on_startup:
            self._cleanup_stale_regions()
        
        # Main monitoring loop
        self.running = True
        self.start_time = time.time()
        last_stats_time = time.time()
        last_csv_time = time.time()
        
        try:
            while self.running:
                # Discover new executions (returns PIDs with existing shared memory files)
                pids = discover_executions(
                    self.shm_dir,
                    self.config.shared_memory.flow_events_prefix
                )
                
                # Check if we should stop before processing
                if not self.running:
                    break
                
                # Process all discovered executions
                for pid in pids:
                    # Check if we should stop during processing
                    if not self.running:
                        break
                    
                    try:
                        exe_result = self._process_execution(pid)
                        if exe_result == ProcessExecutionResult.SUCCESS:
                            self.executions_processed += 1
                        elif exe_result == ProcessExecutionResult.NOT_COMPLETE:
                            continue
                        elif exe_result == ProcessExecutionResult.FILE_NOT_FOUND:
                            self.failed_executions += 1
                            continue
                        else: 
                            self.failed_executions += 1
                        
                        # Check if we've hit max executions
                        if (self.config.processing.max_executions and 
                            self.executions_processed >= self.config.processing.max_executions):
                            logger.info(f"Reached max executions limit: {self.config.processing.max_executions}")
                            self.running = False
                            break
                            
                    except Exception as e:
                        if not self.running:
                            # Exit requested, we just tried to access shared memory that may no longer exist
                            break
                        
                        logger.error(f"Error processing PID {pid}: {e}", exc_info=True)
                        # If processing fails, try to cleanup to avoid retry loop
                        try:
                            self._cleanup_execution(pid)
                        except:
                            pass
                
                # Print periodic statistics
                if self.config.statistics.print_interval > 0:
                    now = time.time()
                    if now - last_stats_time >= self.config.statistics.print_interval:
                        self._print_statistics()
                        last_stats_time = now
                
                # Update CSV data periodically
                if self.csv_enabled:
                    now = time.time()
                    if now - last_csv_time >= self.csv_interval:
                        self._update_csv_data()
                        last_csv_time = now
                
                # Sleep before next poll
                time.sleep(self.config.shared_memory.poll_interval)
                
        except KeyboardInterrupt:
            logger.info("Received interrupt, shutting down...")
        
        finally:
            self.stop()
    
    def request_shutdown(self) -> None:
        """Request graceful shutdown of the monitor."""
        logger.info("Shutdown requested")
        self.running = False
    
    def stop(self) -> None:
        """Stop the monitoring service and cleanup."""
        logger.info("Stopping flow monitor service")
        
        # Print final statistics
        if self.config.statistics.print_summary:
            self._print_statistics(final=True)
        
        # Print sensitivity analysis
        if self.analysis_db.total_executions > 0:
            logger.info("Generating flow sensitivity analysis...")
            self.analysis_db.statistic()
        
        # Write final CSV output
        if self.csv_enabled and self.csv_data:
            self._write_csv_file()
        
        # Flush and close output file
        if self.output_file:
            try:
                self.output_file.flush()  # Ensure all data is written
                if self.output_file != sys.stdout:
                    self.output_file.close()
                logger.info("Output file closed successfully")
            except Exception as e:
                logger.error(f"Error closing output file: {e}")
        
        # Cleanup shared memory if configured
        if self.config.cleanup.cleanup_on_exit:
            self._cleanup_all_regions()
        
        logger.info("Flow monitor stopped")
    
    def _setup_output(self) -> None:
        """Setup output file/stream."""
        if self.config.output.destination == "-":
            self.output_file = sys.stdout
            logger.info("Output: stdout")
        else:
            output_path = Path(self.config.output.destination)
            output_path.parent.mkdir(parents=True, exist_ok=True)
            self.output_file = open(output_path, 'w', buffering=(
                1 if self.config.output.buffered else 0
            ))
            logger.info(f"Output: {output_path}")
    
    def _process_execution(self, pid: int) -> Optional[ProcessExecutionResult]:
        """
        Process a single execution.
        
        Args:
            pid: Process ID to process
        """
        logger.debug(f"Processing execution PID={pid}")
        
        try:
            # Parse execution data
            execution = parse_execution(
                pid,
                self.shm_dir,
                self.config.shared_memory.flow_events_prefix,
                self.config.shared_memory.coverage_prefix
            )
            
            # Analyze events
            analysis = self.processor.process_execution(execution)

            # Store analysis in database
            self.analysis_db.add(analysis)

            # Update reachability estimator
            self.reachability.update(analysis)

            # Update statistics
            self.statistics.update(analysis)
            
            # Output results
            self._output_analysis(analysis)
            
            # Cleanup shared memory if configured
            if self.config.cleanup.auto_cleanup:
                self._cleanup_execution(pid)
            
            logger.info(f"Processed PID={pid}: {len(analysis.completed_flows)} flows completed")

        except ExecutionNotCompleteError:
            # Execution still running, skip for now and will retry on next poll
            logger.debug(f"Execution PID={pid} not yet complete, skipping")
            return ProcessExecutionResult.NOT_COMPLETE
        except FileNotFoundError as e:
            # suppress if shared memory regions disappeared
            # FIXME: this needs to be fixed later on, suppress this for now
            logger.error(f"Failed to process PID={pid}: {e}", exc_info=True)
            return ProcessExecutionResult.FILE_NOT_FOUND           
        except Exception as e:
            logger.error(f"Failed to process PID={pid}: {e}", exc_info=True)
            raise

        return ProcessExecutionResult.SUCCESS
    
    def _output_analysis(self, analysis) -> None:
        """
        Output analysis results.
        
        Args:
            analysis: ExecutionAnalysis to output
        """
        if not self.output_file:
            return
        
        output_data = {
            'timestamp': datetime.utcnow().isoformat() + 'Z',
            'execution': analysis.to_dict()
        }
        
        if self.config.output.format == 'jsonl':
            # JSON Lines format (one line per execution)
            json.dump(output_data, self.output_file)
            self.output_file.write('\n')
        else:
            # Pretty-printed JSON
            json.dump(output_data, self.output_file, indent=2)
            self.output_file.write('\n')
        
        if self.config.output.flush_each:
            self.output_file.flush()
    
    def _print_statistics(self, final: bool = False) -> None:
        """Print current statistics to logger."""
        prefix = "=== FINAL STATISTICS ===" if final else "=== Statistics ==="
        logger.info(f"\n{prefix}")

        stats_str = str(self.statistics)
        for line in stats_str.split('\n'):
            logger.info(line)

        # Print reachability estimates
        if self.reachability.total_executions > 0:
            reachability_report = self.reachability.report()
            for line in reachability_report.split('\n'):
                logger.info(line)
    
    def _cleanup_execution(self, pid: int) -> None:
        """
        Cleanup shared memory regions for a specific PID.
        
        Args:
            pid: Process ID to cleanup
        """
        flow_path = self.shm_dir / f"{self.config.shared_memory.flow_events_prefix}{pid}"
        coverage_path = self.shm_dir / f"{self.config.shared_memory.coverage_prefix}{pid}"
        
        try:
            if flow_path.exists():
                flow_path.unlink()
                logger.debug(f"Cleaned up {flow_path}")
        except Exception as e:
            logger.warning(f"Failed to cleanup {flow_path}: {e}")
        
        try:
            if coverage_path.exists():
                coverage_path.unlink()
                logger.debug(f"Cleaned up {coverage_path}")
        except Exception as e:
            logger.warning(f"Failed to cleanup {coverage_path}: {e}")
    
    def _cleanup_stale_regions(self) -> None:
        """Cleanup stale shared memory regions on startup."""
        logger.info("Cleaning up stale shared memory regions...")
        
        # Find all flow event regions
        pids = discover_executions(
            self.shm_dir,
            self.config.shared_memory.flow_events_prefix
        )
        
        cleaned = 0
        for pid in pids:
            self._cleanup_execution(pid)
            cleaned += 1
        
        logger.info(f"Cleaned up {cleaned} stale regions")
    
    def _cleanup_all_regions(self) -> None:
        """Cleanup all monitored shared memory regions."""
        logger.info("Cleaning up all shared memory regions...")
        
        # Find and cleanup all remaining regions
        pids = discover_executions(
            self.shm_dir,
            self.config.shared_memory.flow_events_prefix
        )
        
        for pid in pids:
            self._cleanup_execution(pid)
    
    def _update_csv_data(self) -> None:
        """
        Update CSV data with current sensitivity values.
        
        This method is called periodically (every csv_interval seconds) to
        capture a snapshot of flow sensitivities at the current timestamp.
        """
        if not self.start_time:
            return
        
        # Calculate elapsed time since monitoring started
        elapsed = time.time() - self.start_time
        timestamp = int(elapsed / self.csv_interval) * self.csv_interval
        
        # Get current sensitivity analysis
        sensitivity_results = self.analysis_db.analysis(num_samples=self.csv_num_samples)
        
        # Record timestamp if this is a new timepoint
        if not self.csv_timestamps or timestamp > self.csv_timestamps[-1]:
            self.csv_timestamps.append(timestamp)
            logger.debug(f"CSV snapshot at t={timestamp}s: {len(sensitivity_results)} flows")
        
        # Update sensitivity values for all flows at this timestamp
        for flow_id, flow_sens in sensitivity_results.items():
            if flow_id not in self.csv_data:
                # Initialize this flow's data with None for all previous timestamps
                self.csv_data[flow_id] = [None] * (len(self.csv_timestamps) - 1)
            
            # Ensure the flow has entries for all timestamps (pad with None if needed)
            while len(self.csv_data[flow_id]) < len(self.csv_timestamps) - 1:
                self.csv_data[flow_id].append(None)
            
            # Add current sensitivity value
            self.csv_data[flow_id].append(flow_sens.sensitivity)
        
        # Pad flows that didn't complete at this timestamp with None
        for flow_id in self.csv_data:
            if len(self.csv_data[flow_id]) < len(self.csv_timestamps):
                self.csv_data[flow_id].append(None)
    
    def _write_csv_file(self) -> None:
        """
        Write the sensitivity CSV file to disk.
        
        CSV format:
        - First column: flow_id
        - Subsequent columns: sensitivity values at each timestamp (t=0s, t=5s, t=10s, ...)
        - Header row contains timestamps
        """
        try:
            # Create output directory if needed
            self.csv_output_path.parent.mkdir(parents=True, exist_ok=True)
            
            with open(self.csv_output_path, 'w', newline='') as csvfile:
                writer = csv.writer(csvfile)
                
                # Write header row: flow_id, t=0s, t=5s, t=10s, ...
                header = ['flow_id'] + [f't={int(t)}s' for t in self.csv_timestamps]
                writer.writerow(header)
                
                # Write data rows: one row per flow
                for flow_id in sorted(self.csv_data.keys()):
                    row = [flow_id] + [
                        f'{val:.6f}' if val is not None else ''
                        for val in self.csv_data[flow_id]
                    ]
                    writer.writerow(row)
            
            logger.info(f"Wrote sensitivity CSV to {self.csv_output_path}")
            logger.info(f"  {len(self.csv_data)} flows × {len(self.csv_timestamps)} timestamps")
            
        except Exception as e:
            logger.error(f"Failed to write CSV file: {e}", exc_info=True)


def setup_logging(config: MonitorConfig) -> None:
    """
    Setup logging based on configuration.
    
    Args:
        config: Monitor configuration
    """
    level = getattr(logging, config.logging.level.upper())
    
    handlers = []
    
    if config.logging.destination:
        # Log to file
        log_path = Path(config.logging.destination)
        log_path.parent.mkdir(parents=True, exist_ok=True)
        handler = logging.FileHandler(log_path)
    else:
        # Log to stderr
        handler = logging.StreamHandler(sys.stderr)
    
    handler.setFormatter(logging.Formatter(config.logging.format))
    handlers.append(handler)
    
    logging.basicConfig(
        level=level,
        handlers=handlers
    )
    
    # Set level for our logger
    logger.setLevel(level)
