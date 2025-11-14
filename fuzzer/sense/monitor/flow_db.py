"""
Flow database parser and manager.

This module handles parsing .flowdb files and providing flow definitions
for correlation and analysis.

The .flowdb format (v1.1):
    SOURCE,<src_id>,<file>:<line>:<col>,<description>
    SINK,<sink_id>,<file>:<line>:<col>,<description>
    INTERMEDIATE,<loc_id>,<file>:<line>:<col>,<description>
    FLOW,<flow_id>,<src_id>,<sink_id>,[<intermediate_ids>],<description>
"""

from pathlib import Path
from typing import Dict, List, NamedTuple, Optional, Set
from dataclasses import dataclass


class SourceLocation(NamedTuple):
    """Source code location."""
    file: str
    line: int
    column: int
    column_end: Optional[int] = None
    
    @classmethod
    def from_string(cls, loc_str: str) -> "SourceLocation":
        """Parse location from 'file:line:col' format."""
        parts = loc_str.split(':')
        if len(parts) != 3:
            raise ValueError(f"Invalid location format: {loc_str}")
        return cls(file=parts[0], line=int(parts[1]), column=int(parts[2]))
    
    @classmethod
    def from_parts(cls, file: str, line: int, col_start: int, col_end: Optional[int] = None) -> "SourceLocation":
        """Create location from separate components."""
        return cls(file=file, line=line, column=col_start, column_end=col_end)
    
    def __str__(self) -> str:
        if self.column_end:
            return f"{self.file}:{self.line}:{self.column}-{self.column_end}"
        return f"{self.file}:{self.line}:{self.column}"


@dataclass
class SourceDef:
    """Source location definition."""
    id: int
    location: SourceLocation
    description: str


@dataclass
class SinkDef:
    """Sink location definition."""
    id: int
    location: SourceLocation
    description: str


@dataclass
class IntermediateDef:
    """Intermediate location definition."""
    id: int
    location: SourceLocation
    description: str


@dataclass
class FlowDef:
    """Flow definition."""
    id: int
    source_id: int
    sink_id: int
    intermediate_ids: List[int]
    description: str
    
    def all_location_ids(self) -> Set[int]:
        """Get all location IDs involved in this flow."""
        return set(self.intermediate_ids)


class FlowDatabase:
    """
    Flow database manager.
    
    Provides access to source, sink, intermediate, and flow definitions
    parsed from a .flowdb file.
    """
    
    def __init__(self):
        self.sources: Dict[int, SourceDef] = {}
        self.sinks: Dict[int, SinkDef] = {}
        self.intermediates: Dict[int, IntermediateDef] = {}
        self.flows: Dict[int, FlowDef] = {}
        self._version: Optional[str] = None
    
    @classmethod
    def from_file(cls, flowdb_path: Path) -> "FlowDatabase":
        """
        Load flow database from .flowdb file.
        
        Args:
            flowdb_path: Path to .flowdb file
            
        Returns:
            FlowDatabase instance
            
        Raises:
            FileNotFoundError: If file not found
            ValueError: If file format is invalid
        """
        if not flowdb_path.exists():
            raise FileNotFoundError(f"Flow database not found: {flowdb_path}")
        
        db = cls()
        
        with open(flowdb_path, 'r') as f:
            for line_num, line in enumerate(f, 1):
                line = line.strip()
                
                # Skip empty lines and comments
                if not line or line.startswith('#'):
                    continue
                
                # Parse version header
                if line.startswith('VERSION:'):
                    db._version = line.split(':', 1)[1].strip()
                    continue
                
                # Skip METADATA lines (informational only)
                if line.startswith('METADATA,'):
                    continue
                
                # Parse entry
                try:
                    db._parse_line(line)
                except Exception as e:
                    raise ValueError(f"Error parsing line {line_num}: {e}\n  Line: {line}")
        
        # Validate database
        db._validate()
        
        return db
    
    def _parse_line(self, line: str) -> None:
        """Parse a single line from the flowdb file."""
        parts = line.split(',', 1)
        if len(parts) < 2:
            raise ValueError(f"Invalid line format: {line}")
        
        entry_type = parts[0].strip()
        
        if entry_type == 'SOURCE':
            self._parse_source(line)
        elif entry_type == 'SINK':
            self._parse_sink(line)
        elif entry_type == 'INTERMEDIATE':
            self._parse_intermediate(line)
        elif entry_type == 'FLOW':
            self._parse_flow(line)
        else:
            raise ValueError(f"Unknown entry type: {entry_type}")
    
    def _parse_source(self, line: str) -> None:
        """Parse SOURCE entry: SOURCE,<id>,<file>,<line>,<colStart>,<colEnd>"""
        parts = line.split(',', 5)
        if len(parts) < 5:
            raise ValueError(f"Invalid SOURCE format: {line}")
        
        src_id = int(parts[1])
        file = parts[2]
        line_num = int(parts[3])
        col_start = int(parts[4])
        col_end = int(parts[5]) if len(parts) > 5 else None
        
        location = SourceLocation.from_parts(file, line_num, col_start, col_end)
        
        if src_id in self.sources:
            raise ValueError(f"Duplicate SOURCE id: {src_id}")
        
        # Description is inferred from location
        description = f"Source at {location}"
        
        self.sources[src_id] = SourceDef(id=src_id, location=location, description=description)
    
    def _parse_sink(self, line: str) -> None:
        """Parse SINK entry: SINK,<id>,<file>,<line>,<colStart>,<colEnd>"""
        parts = line.split(',', 5)
        if len(parts) < 5:
            raise ValueError(f"Invalid SINK format: {line}")
        
        sink_id = int(parts[1])
        file = parts[2]
        line_num = int(parts[3])
        col_start = int(parts[4])
        col_end = int(parts[5]) if len(parts) > 5 else None
        
        location = SourceLocation.from_parts(file, line_num, col_start, col_end)
        
        if sink_id in self.sinks:
            raise ValueError(f"Duplicate SINK id: {sink_id}")
        
        # Description is inferred from location
        description = f"Sink at {location}"
        
        self.sinks[sink_id] = SinkDef(id=sink_id, location=location, description=description)
    
    def _parse_intermediate(self, line: str) -> None:
        """Parse INTERMEDIATE entry: INTERMEDIATE,<id>,<file>,<line>,<colStart>,<colEnd>"""
        parts = line.split(',', 5)
        if len(parts) < 5:
            raise ValueError(f"Invalid INTERMEDIATE format: {line}")
        
        loc_id = int(parts[1])
        file = parts[2]
        line_num = int(parts[3])
        col_start = int(parts[4])
        col_end = int(parts[5]) if len(parts) > 5 else None
        
        location = SourceLocation.from_parts(file, line_num, col_start, col_end)
        
        if loc_id in self.intermediates:
            raise ValueError(f"Duplicate INTERMEDIATE id: {loc_id}")
        
        # Description is inferred from location
        description = f"Intermediate at {location}"
        
        self.intermediates[loc_id] = IntermediateDef(id=loc_id, location=location, description=description)
    
    def _parse_flow(self, line: str) -> None:
        """Parse FLOW entry: FLOW,<flow_id>,<src_id>,<sink_id>,[<intermediate_ids>],<description>"""
        # Format: FLOW,<flow_id>,<src_id>,<sink_id>,[<intermediate_ids>],<description>
        # The challenge: intermediate_ids contains commas inside the brackets
        
        # Find the bracket positions first
        bracket_start = line.find('[')
        bracket_end = line.find(']')
        
        if bracket_start == -1 or bracket_end == -1:
            raise ValueError(f"Invalid FLOW format: missing brackets for intermediate_ids in: {line}")
        
        if bracket_end <= bracket_start:
            raise ValueError(f"Invalid FLOW format: malformed brackets in: {line}")
        
        # Split the parts around the brackets
        # Before brackets: "FLOW,<flow_id>,<src_id>,<sink_id>,"
        before_bracket = line[:bracket_start]
        # The bracket content: "[...]"
        intermediate_str = line[bracket_start:bracket_end+1]
        # After brackets: ",<description>"
        after_bracket = line[bracket_end+1:]
        
        # Parse the parts before the bracket
        before_parts = before_bracket.rstrip(',').split(',')
        if len(before_parts) != 4:
            raise ValueError(f"Invalid FLOW format: expected FLOW,flow_id,src_id,sink_id before brackets, got: {before_parts}")
        
        if before_parts[0] != 'FLOW':
            raise ValueError(f"Invalid FLOW format: expected 'FLOW' prefix, got: {before_parts[0]}")
        
        flow_id = int(before_parts[1])
        src_id = int(before_parts[2])
        sink_id = int(before_parts[3])
        
        # Parse intermediate IDs: [1,2,3] or []
        intermediate_content = intermediate_str[1:-1].strip()
        if intermediate_content:
            intermediate_ids = [int(x.strip()) for x in intermediate_content.split(',')]
        else:
            intermediate_ids = []
        
        # Parse description (skip leading comma if present)
        description = after_bracket.lstrip(',').strip()
        
        if flow_id in self.flows:
            raise ValueError(f"Duplicate FLOW id: {flow_id}")
        
        self.flows[flow_id] = FlowDef(
            id=flow_id,
            source_id=src_id,
            sink_id=sink_id,
            intermediate_ids=intermediate_ids,
            description=description
        )
    
    def _validate(self) -> None:
        """Validate database integrity."""
        # Check that all flows reference valid sources and sinks
        for flow_id, flow in self.flows.items():
            if flow.source_id not in self.sources:
                raise ValueError(f"Flow {flow_id} references undefined source {flow.source_id}")
            
            if flow.sink_id not in self.sinks:
                raise ValueError(f"Flow {flow_id} references undefined sink {flow.sink_id}")
            
            # Check intermediate locations
            for loc_id in flow.intermediate_ids:
                if loc_id not in self.intermediates:
                    raise ValueError(f"Flow {flow_id} references undefined intermediate {loc_id}")
    
    def get_flow(self, flow_id: int) -> Optional[FlowDef]:
        """Get flow definition by ID."""
        return self.flows.get(flow_id)
    
    def get_source(self, src_id: int) -> Optional[SourceDef]:
        """Get source definition by ID."""
        return self.sources.get(src_id)
    
    def get_sink(self, sink_id: int) -> Optional[SinkDef]:
        """Get sink definition by ID."""
        return self.sinks.get(sink_id)
    
    def get_intermediate(self, loc_id: int) -> Optional[IntermediateDef]:
        """Get intermediate location definition by ID."""
        return self.intermediates.get(loc_id)
    
    def find_flows_by_source_sink(self, src_id: int, sink_id: int) -> List[FlowDef]:
        """Find all flows matching source and sink IDs."""
        return [f for f in self.flows.values() 
                if f.source_id == src_id and f.sink_id == sink_id]
    
    def get_stats(self) -> Dict[str, int]:
        """Get database statistics."""
        return {
            'version': self._version or 'unknown',
            'num_sources': len(self.sources),
            'num_sinks': len(self.sinks),
            'num_intermediates': len(self.intermediates),
            'num_flows': len(self.flows),
        }
    
    def __repr__(self) -> str:
        stats = self.get_stats()
        return (f"FlowDatabase(version={stats['version']}, "
                f"sources={stats['num_sources']}, "
                f"sinks={stats['num_sinks']}, "
                f"intermediates={stats['num_intermediates']}, "
                f"flows={stats['num_flows']})")
