"""
Execution analysis database for storing and analyzing flow monitoring results.

This module provides:
- ExecutionAnalysisDatabase: Base class for storing execution analysis results
- SensitivityAnalysisDatabase: Extended database with sensitivity analysis capabilities
"""

import logging
import random
from typing import Dict, List, Set, Optional
from dataclasses import dataclass, field
from collections import defaultdict

from event_processor import ExecutionAnalysis, FlowCompletion
from flow_db import FlowDatabase


logger = logging.getLogger(__name__)


@dataclass
class FlowSensitivity:
    """Sensitivity metrics for a single flow."""
    flow_id: int
    total_executions: int  # Total number of executions monitored
    completions: int  # Number of times this flow completed
    sensitivity: float  # Probability of different sink hash from 2 random executions
    num_samples: int = 0  # Number of random samples used for sensitivity calculation
    
    # Detailed metrics
    unique_pids: Set[int] = field(default_factory=set)  # PIDs that completed this flow
    unique_sink_hashes: Set[int] = field(default_factory=set)  # Unique sink hashes observed
    total_time_ns: int = 0  # Sum of all completion times
    min_time_ns: Optional[int] = None
    max_time_ns: Optional[int] = None
    
    @property
    def avg_time_ns(self) -> float:
        """Average completion time in nanoseconds."""
        return self.total_time_ns / self.completions if self.completions > 0 else 0.0
    
    @property
    def avg_time_us(self) -> float:
        """Average completion time in microseconds."""
        return self.avg_time_ns / 1000
    
    def __str__(self) -> str:
        """Human-readable representation."""
        return (f"Flow {self.flow_id}: "
                f"{self.sensitivity:.1%} sensitive "
                f"({self.completions}/{self.total_executions} executions, "
                f"{len(self.unique_sink_hashes)} unique hashes, "
                f"avg {self.avg_time_us:.2f}μs)")


class ExecutionAnalysisDatabase:
    """
    Database for storing execution analysis results.
    
    This class maintains a collection of ExecutionAnalysis objects,
    indexed by PID, and provides methods for querying and analyzing
    the collected data.
    """
    
    def __init__(self, flow_db: Optional[FlowDatabase] = None):
        """
        Initialize the database.
        
        Args:
            flow_db: Optional flow database for flow metadata
        """
        self.flow_db = flow_db
        self.executions: Dict[int, ExecutionAnalysis] = {}
        self._total_stored = 0
        
        logger.info("ExecutionAnalysisDatabase initialized")
    
    def add(self, analysis: ExecutionAnalysis) -> None:
        """
        Add an execution analysis to the database.
        
        Args:
            analysis: ExecutionAnalysis to store
        """
        if analysis.pid in self.executions:
            logger.warning(f"Overwriting existing analysis for PID={analysis.pid}")
        
        self.executions[analysis.pid] = analysis
        self._total_stored += 1
        logger.debug(f"Stored analysis for PID={analysis.pid} "
                    f"(total stored: {self._total_stored})")
    
    def get(self, pid: int) -> Optional[ExecutionAnalysis]:
        """
        Get execution analysis by PID.
        
        Args:
            pid: Process ID
            
        Returns:
            ExecutionAnalysis if found, None otherwise
        """
        return self.executions.get(pid)
    
    def get_all(self) -> List[ExecutionAnalysis]:
        """
        Get all stored execution analyses.
        
        Returns:
            List of all ExecutionAnalysis objects
        """
        return list(self.executions.values())
    
    def get_by_flow(self, flow_id: int) -> List[ExecutionAnalysis]:
        """
        Get all executions that completed a specific flow.
        
        Args:
            flow_id: Flow ID to search for
            
        Returns:
            List of ExecutionAnalysis objects that completed the flow
        """
        results = []
        for analysis in self.executions.values():
            if any(fc.flow_id == flow_id for fc in analysis.completed_flows):
                results.append(analysis)
        return results
    
    def clear(self) -> None:
        """Clear all stored analyses."""
        count = len(self.executions)
        self.executions.clear()
        logger.info(f"Cleared {count} execution analyses from database")
    
    @property
    def total_executions(self) -> int:
        """Total number of executions in database."""
        return len(self.executions)
    
    @property
    def total_stored(self) -> int:
        """Total number of analyses ever stored (including overwrites)."""
        return self._total_stored


class SensitivityAnalysisDatabase(ExecutionAnalysisDatabase):
    """
    Extended database with sensitivity analysis capabilities.
    
    This class adds methods to compute and visualize flow sensitivity metrics,
    which measure how often each flow completes across all executions.
    """
    
    def __init__(self, flow_db: FlowDatabase):
        """
        Initialize sensitivity analysis database.
        
        Args:
            flow_db: Flow database (required for flow metadata)
        """
        super().__init__(flow_db)
        self._sensitivity_cache: Optional[Dict[int, FlowSensitivity]] = None
        logger.info("SensitivityAnalysisDatabase initialized")
    
    def add(self, analysis: ExecutionAnalysis) -> None:
        """
        Add execution and invalidate sensitivity cache.
        
        Args:
            analysis: ExecutionAnalysis to store
        """
        super().add(analysis)
        self._sensitivity_cache = None  # Invalidate cache
    
    def analysis(self, num_samples: int = 10000) -> Dict[int, FlowSensitivity]:
        """
        Compute sensitivity metrics for all flows using sampling.
        
        Sensitivity is defined as the probability that two randomly sampled
        executions produce different sink hashes for a given flow. This is
        estimated by randomly sampling pairs of executions and computing the
        fraction that have differing sink hashes.
        
        Args:
            num_samples: Number of random execution pairs to sample per flow
        
        Returns:
            Dictionary mapping flow_id -> FlowSensitivity
        """
        # Return cached results if available
        if self._sensitivity_cache is not None:
            return self._sensitivity_cache
        
        logger.info(f"Computing flow sensitivity analysis with {num_samples} samples...")
        
        total_execs = self.total_executions
        if total_execs == 0:
            logger.warning("No executions in database, returning empty sensitivity")
            return {}
        
        # First pass: collect all completions per flow
        flow_completions: Dict[int, List[FlowCompletion]] = defaultdict(list)
        flow_executions: Dict[int, List[ExecutionAnalysis]] = defaultdict(list)
        
        for analysis in self.executions.values():
            for completion in analysis.completed_flows:
                flow_id = completion.flow_id
                flow_completions[flow_id].append(completion)
                flow_executions[flow_id].append(analysis)
        
        # Second pass: compute sensitivity for each flow
        sensitivity_results = {}
        
        for flow_id, completions in flow_completions.items():
            num_completions = len(completions)
            
            if num_completions == 0:
                continue
            
            # Collect all sink hashes for this flow
            sink_hashes = [fc.sink_event.data_hash for fc in completions]
            unique_sink_hashes = set(sink_hashes)
            
            # Compute sensitivity via sampling
            # sensitivity = P(different sink hash | two random completions)
            if num_completions == 1:
                # Only one completion observed; assume deterministic (no evidence
                # of variability) so probability of different outputs is 1.0
                sensitivity_score = 1.0
                samples_used = 1
            else:
                # Sample pairs of completions and check if sink hashes differ
                matching_pairs = 0
                samples_used = min(num_samples, num_completions * (num_completions - 1) // 2)

                for _ in range(samples_used):
                    # Randomly sample two different completions
                    idx1, idx2 = random.sample(range(num_completions), 2)
                    hash1 = completions[idx1].sink_event.data_hash
                    hash2 = completions[idx2].sink_event.data_hash

                    if hash1 == hash2:
                        matching_pairs += 1

                # matching_pairs / samples_used estimates P(same). We want P(different)
                sensitivity_score = 1.0 - (matching_pairs / samples_used) if samples_used > 0 else 0.0
            
            # Collect timing metrics
            total_time_ns = sum(fc.time_delta_ns for fc in completions)
            min_time_ns = min(fc.time_delta_ns for fc in completions)
            max_time_ns = max(fc.time_delta_ns for fc in completions)
            unique_pids = set(analysis.pid for analysis in flow_executions[flow_id])
            
            sensitivity = FlowSensitivity(
                flow_id=flow_id,
                total_executions=total_execs,
                completions=num_completions,
                sensitivity=sensitivity_score,
                num_samples=samples_used,
                unique_pids=unique_pids,
                unique_sink_hashes=unique_sink_hashes,
                total_time_ns=total_time_ns,
                min_time_ns=min_time_ns,
                max_time_ns=max_time_ns
            )
            sensitivity_results[flow_id] = sensitivity
        
        logger.info(f"Computed sensitivity for {len(sensitivity_results)} flows "
                   f"across {total_execs} executions")
        
        # Cache results
        self._sensitivity_cache = sensitivity_results
        return sensitivity_results
    
    def statistic(self, top_n: Optional[int] = None) -> None:
        """
        Print sensitivity statistics visualization to stdout and log.
        
        Sensitivity is the probability that two randomly sampled executions
        produce different sink hashes. Higher sensitivity means the flow is
        more deterministic, while lower sensitivity means the
        flow is more variable across executions.
        
        This method displays:
        - Overview statistics
        - Per-flow sensitivity metrics (sorted by sensitivity)
        - Visual bar chart representation
        
        Args:
            top_n: If specified, only show top N most sensitive flows
        """
        sensitivity = self.analysis()
        
        if not sensitivity:
            msg = "=== FLOW SENSITIVITY ANALYSIS ===\nNo flows detected in monitored executions."
            print(msg)
            logger.info(msg)
            return
        
        # Sort flows by sensitivity (highest first)
        sorted_flows = sorted(
            sensitivity.values(),
            key=lambda fs: (fs.sensitivity, fs.completions),
            reverse=True
        )
        
        if top_n:
            sorted_flows = sorted_flows[:top_n]
        
        # Build output
        lines = []
        lines.append("=" * 90)
        lines.append("FLOW SENSITIVITY ANALYSIS")
        lines.append("Sensitivity = P(different sink hash | 2 random executions)")
        lines.append("=" * 90)
        lines.append(f"Total Executions: {self.total_executions}")
        lines.append(f"Unique Flows Detected: {len(sensitivity)}")
        lines.append(f"Total Flow Completions: {sum(fs.completions for fs in sensitivity.values())}")
        lines.append("")
        
        # Per-flow breakdown
        lines.append("-" * 90)
        lines.append(f"{'Flow':<8} {'Sens':<8} {'Compl':<10} {'Uniq':<8} {'Avg Time':<12} {'Samples':<8} {'Bar'}")
        lines.append("-" * 90)
        
        for fs in sorted_flows:
            # Create visual bar (40 chars max)
            bar_length = int(fs.sensitivity * 40)
            bar = "█" * bar_length
            
            # Get flow description if available
            flow_desc = ""
            if self.flow_db and fs.flow_id in self.flow_db.flows:
                flow_def = self.flow_db.flows[fs.flow_id]
                flow_desc = f" ({flow_def.description[:50]}...)" if len(flow_def.description) > 50 else f" ({flow_def.description})"
            
            lines.append(
                f"{fs.flow_id:<8} "
                f"{fs.sensitivity:>6.1%}  "
                f"{fs.completions:>4}/{fs.total_executions:<4} "
                f"{len(fs.unique_sink_hashes):>6}  "
                f"{fs.avg_time_us:>8.2f} μs  "
                f"{fs.num_samples:>6}  "
                f"{bar}"
            )
            
            if flow_desc:
                lines.append(f"         {flow_desc}")
        
        lines.append("-" * 90)
        
        # Summary statistics
        lines.append("")
        lines.append("SUMMARY:")
        lines.append(f"  Sens = Sensitivity (higher = more deterministic / less variable sink hash)")
        lines.append(f"  Compl = Completions (times flow completed / total executions)")
        lines.append(f"  Uniq = Unique sink hashes observed")
        lines.append("")
        
        avg_sensitivity = sum(fs.sensitivity for fs in sensitivity.values()) / len(sensitivity)
        lines.append(f"  Average Sensitivity: {avg_sensitivity:.1%}")
        
        highly_sensitive = sum(1 for fs in sensitivity.values() if fs.sensitivity > 0.8)
        lines.append(f"  Highly Sensitive Flows (>80%): {highly_sensitive}")
        
        low_sensitive = sum(1 for fs in sensitivity.values() if fs.sensitivity < 0.2)
        lines.append(f"  Low Sensitivity Flows (<20%): {low_sensitive}")
        
        # Hash diversity stats
        avg_unique_hashes = sum(len(fs.unique_sink_hashes) for fs in sensitivity.values()) / len(sensitivity)
        lines.append(f"  Average Unique Hashes per Flow: {avg_unique_hashes:.1f}")
        
        lines.append("=" * 90)
        
        # Output to both stdout and log
        output = "\n".join(lines)
        print(output)
        
        # Also log each line
        for line in lines:
            logger.info(line)
    
    def get_flow_sensitivity(self, flow_id: int) -> Optional[FlowSensitivity]:
        """
        Get sensitivity metrics for a specific flow.
        
        Args:
            flow_id: Flow ID to query
            
        Returns:
            FlowSensitivity if flow was detected, None otherwise
        """
        sensitivity = self.analysis()
        return sensitivity.get(flow_id)
    
    def get_high_sensitivity_flows(self, threshold: float = 0.5) -> List[FlowSensitivity]:
        """
        Get flows with sensitivity above threshold.
        
        Args:
            threshold: Minimum sensitivity (0.0 to 1.0)
            
        Returns:
            List of FlowSensitivity objects above threshold, sorted by sensitivity
        """
        sensitivity = self.analysis()
        high_sens = [
            fs for fs in sensitivity.values()
            if fs.sensitivity >= threshold
        ]
        return sorted(high_sens, key=lambda fs: fs.sensitivity, reverse=True)
    
    def get_low_sensitivity_flows(self, threshold: float = 0.1) -> List[FlowSensitivity]:
        """
        Get flows with sensitivity below threshold.
        
        Args:
            threshold: Maximum sensitivity (0.0 to 1.0)
            
        Returns:
            List of FlowSensitivity objects below threshold, sorted by sensitivity
        """
        sensitivity = self.analysis()
        low_sens = [
            fs for fs in sensitivity.values()
            if fs.sensitivity < threshold
        ]
        return sorted(low_sens, key=lambda fs: fs.sensitivity)
