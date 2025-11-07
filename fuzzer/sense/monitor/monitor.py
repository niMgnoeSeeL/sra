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
from pathlib import Path
from typing import Optional, Set, TextIO
from datetime import datetime

from config import MonitorConfig
from flow_db import FlowDatabase
from shm_protocol import discover_executions, parse_execution
from event_processor import EventProcessor, Statistics


logger = logging.getLogger(__name__)


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
        
        self.shm_dir = Path(config.shared_memory.shm_dir)
        self.output_file: Optional[TextIO] = None
        self.running = False
        self.executions_processed = 0
        
        logger.info(f"FlowMonitor initialized with {flow_db}")
    
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
        last_stats_time = time.time()
        
        try:
            while self.running:
                # Discover new executions (returns PIDs with existing shared memory files)
                pids = discover_executions(
                    self.shm_dir,
                    self.config.shared_memory.flow_events_prefix
                )
                
                # Process all discovered executions
                for pid in pids:
                    try:
                        self._process_execution(pid)
                        self.executions_processed += 1
                        
                        # Check if we've hit max executions
                        if (self.config.processing.max_executions and 
                            self.executions_processed >= self.config.processing.max_executions):
                            logger.info(f"Reached max executions limit: {self.config.processing.max_executions}")
                            self.running = False
                            break
                            
                    except Exception as e:
                        logger.error(f"Error processing PID {pid}: {e}", exc_info=True)
                        # If processing fails, try to cleanup to avoid retry loop
                        try:
                            self._cleanup_execution(pid)
                        except:
                            pass
                
                
                # TODO: Update sensitivity
                
                # Print periodic statistics
                if self.config.statistics.print_interval > 0:
                    now = time.time()
                    if now - last_stats_time >= self.config.statistics.print_interval:
                        self._print_statistics()
                        last_stats_time = now
                
                # Sleep before next poll
                time.sleep(self.config.shared_memory.poll_interval)
                
        except KeyboardInterrupt:
            logger.info("Received interrupt, shutting down...")
        
        finally:
            self.stop()
    
    def stop(self) -> None:
        """Stop the monitoring service and cleanup."""
        logger.info("Stopping flow monitor service")
        
        # Print final statistics
        if self.config.statistics.print_summary:
            self._print_statistics(final=True)
        
        # Cleanup output
        if self.output_file and self.output_file != sys.stdout:
            self.output_file.close()
        
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
    
    def _process_execution(self, pid: int) -> None:
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
            
            # Update statistics
            self.statistics.update(analysis)
            
            # Output results
            self._output_analysis(analysis)
            
            # Cleanup shared memory if configured
            if self.config.cleanup.auto_cleanup:
                self._cleanup_execution(pid)
            
            logger.info(f"Processed PID={pid}: {len(analysis.completed_flows)} flows completed")
            
        except Exception as e:
            logger.error(f"Failed to process PID={pid}: {e}", exc_info=True)
            raise
    
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
