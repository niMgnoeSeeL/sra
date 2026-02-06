"""
Event correlation and flow analysis.

This module handles:
- Correlating SOURCE and SINK events by data hash
- Detecting completed flows
- Analyzing coverage of intermediate locations
- Computing flow statistics
"""

from typing import Dict, List, Set, Optional, NamedTuple
from dataclasses import dataclass, field
from collections import defaultdict
import logging

from shm_protocol import ParsedFlowEvent, ParsedExecution
from flow_db import FlowDatabase, FlowDef


logger = logging.getLogger(__name__)


class FlowCompletion(NamedTuple):
    """Information about a completed flow."""
    flow_id: int
    source_event: ParsedFlowEvent
    sink_event: ParsedFlowEvent
    time_delta_ns: int
    intermediate_coverage: Set[int]  # Set of intermediate location IDs that were hit

@dataclass
class ExecutionAnalysis:
    """Analysis results for a single execution."""
    pid: int
    total_events: int
    source_events: List[ParsedFlowEvent] = field(default_factory=list)
    sink_events: List[ParsedFlowEvent] = field(default_factory=list)
    completed_flows: List[FlowCompletion] = field(default_factory=list)
    coverage_hits: Dict[int, int] = field(default_factory=dict)  # loc_id -> hit_count
    
    def to_dict(self) -> dict:
        """Convert to dictionary for JSON output."""
        return {
            'pid': self.pid,
            'total_events': self.total_events,
            'num_sources': len(self.source_events),
            'num_sinks': len(self.sink_events),
            'completed_flows': [
                {
                    'flow_id': fc.flow_id,
                    'source_id': fc.source_event.id,
                    'sink_id': fc.sink_event.id,
                    'source_hash': f'0x{fc.source_event.data_hash:016x}',
                    'sink_hash': f'0x{fc.sink_event.data_hash:016x}',
                    'source_size': fc.source_event.data_size,
                    'sink_size': fc.sink_event.data_size,
                    'time_delta_ns': fc.time_delta_ns,
                    'time_delta_us': fc.time_delta_ns / 1000,
                    'intermediate_coverage': list(fc.intermediate_coverage)
                }
                for fc in self.completed_flows
            ],
            'coverage': {
                str(loc_id): count 
                for loc_id, count in sorted(self.coverage_hits.items())
            }
        }


class EventProcessor:
    """
    Process execution events and correlate flows.
    
    This processor:
    1. Separates SOURCE and SINK events
    2. Correlates events by (src_id, sink_id, data_hash)
    3. Analyzes coverage of intermediate locations
    4. Detects completed flows based on flow definitions
    """
    
    def __init__(self, flow_db: FlowDatabase):
        """
        Initialize event processor.
        
        Args:
            flow_db: Flow database with flow definitions
        """
        self.flow_db = flow_db
        
    def process_execution(self, execution: ParsedExecution) -> ExecutionAnalysis:
        """
        Process a single execution and analyze flows.
        
        Args:
            execution: Parsed execution data (events + coverage)
            
        Returns:
            ExecutionAnalysis with correlation results
        """
        logger.debug(f"Processing execution PID={execution.pid} with {len(execution.events)} events")
        
        analysis = ExecutionAnalysis(
            pid=execution.pid,
            total_events=len(execution.events)
        )
        
        # Separate events by type
        for event in execution.events:
            if event.type == 'SOURCE':
                analysis.source_events.append(event)
            elif event.type == 'SINK':
                analysis.sink_events.append(event)
        
        logger.debug(f"  {len(analysis.source_events)} sources, {len(analysis.sink_events)} sinks")
        
        # Parse coverage map
        analysis.coverage_hits = self._parse_coverage(execution.coverage)
        logger.debug(f"  {len(analysis.coverage_hits)} coverage locations hit")
        
        # Correlate events to find completed flows
        analysis.completed_flows = self._correlate_flows(
            analysis.source_events,
            analysis.sink_events,
            analysis.coverage_hits
        )
        
        logger.debug(f"  {len(analysis.completed_flows)} completed flows")
        
        return analysis
    
    def _parse_coverage(self, coverage_data: bytes) -> Dict[int, int]:
        """
        Parse coverage map bytes into location -> hit_count mapping.
        
        Args:
            coverage_data: Raw coverage map (each byte is hit count)
            
        Returns:
            Dictionary of loc_id -> hit_count (only non-zero counts)
        """
        coverage = {}
        for loc_id, count in enumerate(coverage_data):
            if count > 0:
                coverage[loc_id] = count
        return coverage
    
    def _correlate_flows(self, 
                        source_events: List[ParsedFlowEvent],
                        sink_events: List[ParsedFlowEvent],
                        coverage: Dict[int, int]) -> List[FlowCompletion]:
        """
        Correlate SOURCE and SINK events to detect completed flows.
        
        A flow is considered COMPLETE in an execution if and only if:
        1. The source location is covered at least once (before any sink)
        2. The sink location is covered at least once (after the source)
        3. ALL intermediate locations are covered (order doesn't matter)
        
        We do NOT report partially covered flows.
        
        Args:
            source_events: List of SOURCE events
            sink_events: List of SINK events
            coverage: Coverage map (loc_id -> hit_count)
            
        Returns:
            List of completed flows (only flows with full coverage)
        """
        completed = []
        
        # Index events by ID for faster lookup
        sources_by_id = defaultdict(list)
        for src_event in source_events:
            sources_by_id[src_event.id].append(src_event)
        
        sinks_by_id = defaultdict(list)
        for sink_event in sink_events:
            sinks_by_id[sink_event.id].append(sink_event)
        
        # Check each flow definition
        for flow_id, flow_def in self.flow_db.flows.items():
            logger.debug(f"  Checking flow {flow_id}: SRC_{flow_def.source_id} -> SINK_{flow_def.sink_id}")
            
            # Get candidate source and sink events for this flow
            cndt_src_events = sources_by_id.get(flow_def.source_id, [])
            cndt_sink_events = sinks_by_id.get(flow_def.sink_id, [])
            
            if not cndt_src_events:
                logger.debug(f"    ✗ No source events for SRC_{flow_def.source_id}")
                continue
                
            if not cndt_sink_events:
                logger.debug(f"    ✗ No sink events for SINK_{flow_def.sink_id}")
                continue
            
            # Check if ALL intermediate locations are covered
            if not all(loc_id in coverage for loc_id in flow_def.intermediate_ids):
                logger.debug(f"    ✗ Missing intermediate coverage for flow {flow_id}")
                continue
            
            # Find valid source->sink pairs (source before sink)
            for cndt_src_event in cndt_src_events:
                for cndt_sink_event in cndt_sink_events:
                    # Check temporal ordering (source must come before sink)
                    if cndt_src_event.timestamp_ns >= cndt_sink_event.timestamp_ns:
                        continue
                    
                    time_delta = cndt_sink_event.timestamp_ns - cndt_src_event.timestamp_ns
                    
                    completion = FlowCompletion(
                        flow_id=flow_id,
                        source_event=cndt_src_event,
                        sink_event=cndt_sink_event,
                        time_delta_ns=time_delta,
                        intermediate_coverage=coverage.keys()
                    )
                    
                    completed.append(completion)
                    logger.debug(f"    ✓ COMPLETE FLOW: "
                               f"src_hash=0x{cndt_src_event.data_hash:016x}, "
                               f"sink_hash=0x{cndt_sink_event.data_hash:016x}, "
                               f"delta={time_delta/1000:.1f}us")
        
        return completed


class Statistics:
    """Track statistics across multiple executions."""
    
    def __init__(self):
        self.total_executions = 0
        self.total_events = 0
        self.total_sources = 0
        self.total_sinks = 0
        self.total_completed_flows = 0
        
        # Per-flow statistics
        self.completions_per_flow: Dict[int, int] = defaultdict(int)
        self.coverage_per_flow: Dict[int, Set[int]] = defaultdict(set)
        
        # Timing statistics
        self.min_time_delta_ns: Optional[int] = None
        self.max_time_delta_ns: Optional[int] = None
        self.total_time_delta_ns: int = 0
        
    def update(self, analysis: ExecutionAnalysis) -> None:
        """Update statistics with results from one execution."""
        self.total_executions += 1
        self.total_events += analysis.total_events
        self.total_sources += len(analysis.source_events)
        self.total_sinks += len(analysis.sink_events)
        self.total_completed_flows += len(analysis.completed_flows)
        
        # Per-flow stats
        for completion in analysis.completed_flows:
            self.completions_per_flow[completion.flow_id] += 1
            self.coverage_per_flow[completion.flow_id].update(completion.intermediate_coverage)
            
            # Timing stats
            delta = completion.time_delta_ns
            self.total_time_delta_ns += delta
            
            if self.min_time_delta_ns is None or delta < self.min_time_delta_ns:
                self.min_time_delta_ns = delta
            
            if self.max_time_delta_ns is None or delta > self.max_time_delta_ns:
                self.max_time_delta_ns = delta
    
    def get_summary(self) -> dict:
        """Get statistics summary as dictionary."""
        avg_time_delta_ns = (
            self.total_time_delta_ns / self.total_completed_flows
            if self.total_completed_flows > 0 else 0
        )
        
        return {
            'total_executions': self.total_executions,
            'total_events': self.total_events,
            'total_sources': self.total_sources,
            'total_sinks': self.total_sinks,
            'total_completed_flows': self.total_completed_flows,
            'completions_per_flow': dict(self.completions_per_flow),
            'unique_coverage_per_flow': {
                flow_id: len(locs) 
                for flow_id, locs in self.coverage_per_flow.items()
            },
            'timing': {
                'min_ns': self.min_time_delta_ns,
                'max_ns': self.max_time_delta_ns,
                'avg_ns': avg_time_delta_ns,
                'min_us': self.min_time_delta_ns / 1000 if self.min_time_delta_ns else None,
                'max_us': self.max_time_delta_ns / 1000 if self.max_time_delta_ns else None,
                'avg_us': avg_time_delta_ns / 1000,
            }
        }
    
    def __str__(self) -> str:
        """Get human-readable statistics summary."""
        summary = self.get_summary()
        lines = [
            "=== Execution Statistics ===",
            f"Total executions: {summary['total_executions']}",
            f"Total events: {summary['total_events']}",
            f"  Sources: {summary['total_sources']}",
            f"  Sinks: {summary['total_sinks']}",
            f"Completed flows: {summary['total_completed_flows']}",
        ]
        
        if summary['completions_per_flow']:
            lines.append("\nCompletions per flow:")
            for flow_id, count in sorted(summary['completions_per_flow'].items()):
                lines.append(f"  Flow {flow_id}: {count} completions")
        
        if summary['timing']['avg_ns']:
            lines.extend([
                "\nTiming:",
                f"  Min: {summary['timing']['min_us']:.2f} μs",
                f"  Max: {summary['timing']['max_us']:.2f} μs",
                f"  Avg: {summary['timing']['avg_us']:.2f} μs",
            ])
        
        return '\n'.join(lines)
