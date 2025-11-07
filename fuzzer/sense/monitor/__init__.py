"""
Flow Monitor Service - Phase 2 Implementation

This package provides monitoring and analysis of dataflow coverage and taint flow
completion during fuzzing. It reads shared memory regions created by instrumented
programs and correlates SOURCE/SINK events to detect completed flows.

Architecture:
    - shm_protocol: ctypes structures for shared memory parsing
    - flow_db: Flow database parser and manager
    - event_processor: Event correlation and analysis
    - monitor: Main monitoring service with polling loop
    - config: Configuration management

Usage:
    from monitor import FlowMonitor
    
    monitor = FlowMonitor(config_path="configs/default.yaml", 
                         flowdb_path="flows.flowdb")
    monitor.run()
"""

__version__ = "1.0.0"
__author__ = "Flow Monitor Team"

from .config import MonitorConfig
from .shm_protocol import FlowEvent, FlowEventBuffer, parse_flow_events, parse_coverage_map

__all__ = [
    "MonitorConfig",
    "FlowEvent", 
    "FlowEventBuffer",
    "parse_flow_events",
    "parse_coverage_map",
]
