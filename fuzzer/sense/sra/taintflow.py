from __future__ import annotations
from dataclasses import dataclass, field
from typing import List, Optional, Any, Dict


@dataclass
class Location:
    """
    A single step in a threadFlow.

    Mirrors SARIF's:
    result.codeFlows[].threadFlows[].locations[].location.physicalLocation.{artifactLocation, region}
    and optional location.message.text
    """
    uri: str
    start_line: Optional[int] = None
    start_column: Optional[int] = None
    end_line: Optional[int] = None
    end_column: Optional[int] = None
    message: Optional[str] = None

    # Optional handy extras for traceability:
    rule_id: Optional[str] = None          # result.ruleId
    result_message: Optional[str] = None   # result.message.text

    def span(self) -> str:
        """Human-readable line/column range."""
        sl = f"{self.start_line}" if self.start_line is not None else "?"
        sc = f"{self.start_column}" if self.start_column is not None else "?"
        el = f"{self.end_line}" if self.end_line is not None else sl
        ec = f"{self.end_column}" if self.end_column is not None else sc
        return f"{sl}:{sc}-{el}:{ec}"


@dataclass
class FlowPath:
    """
    One codeFlow/threadFlow path composed of ordered Locations.
    """
    rule_id: Optional[str]
    result_message: Optional[str]
    locations: List[Location] = field(default_factory=list)

    def __len__(self) -> int:
        return len(self.locations)

    def files_touched(self) -> List[str]:
        """Unique URIs in order of first appearance."""
        seen, order = set(), []
        for loc in self.locations:
            if loc.uri not in seen:
                seen.add(loc.uri)
                order.append(loc.uri)
        return order


def _get(d: Dict[str, Any], path: List[str], default=None):
    """Safe nested getter."""
    cur = d
    for key in path:
        if not isinstance(cur, dict) or key not in cur:
            return default
        cur = cur[key]
    return cur


def parse_sarif_flows(sarif: Dict[str, Any]) -> List[FlowPath]:
    """
    Extract FlowPath objects from a SARIF v2.1.0 log dict.

    Looks at runs[].results[].codeFlows[].threadFlows[].locations[] as per SARIF.
    """
    flow_paths: List[FlowPath] = []

    for run in sarif.get("runs", []):
        for result in run.get("results", []):
            rule_id = result.get("ruleId")
            result_message = _get(result, ["message", "text"])
            code_flows = result.get("codeFlows", []) or []

            for code_flow in code_flows:
                thread_flows = code_flow.get("threadFlows", []) or []
                for thread in thread_flows:
                    locs = []
                    for tfl in thread.get("locations", []) or []:
                        loc = tfl.get("location", {}) or {}
                        phys = loc.get("physicalLocation", {}) or {}

                        uri = _get(phys, ["artifactLocation", "uri"], "")
                        region = phys.get("region", {}) or {}

                        l = Location(
                            uri=uri or "",
                            start_line=region.get("startLine"),
                            start_column=region.get("startColumn"),
                            end_line=region.get("endLine"),
                            end_column=region.get("endColumn"),
                            message=_get(loc, ["message", "text"])
                                    or _get(tfl, ["message", "text"]),
                            rule_id=rule_id,
                            result_message=result_message,
                        )
                        locs.append(l)

                    flow_paths.append(FlowPath(rule_id=rule_id,
                                               result_message=result_message,
                                               locations=locs))
    return flow_paths

if __name__ == "__main__":
    import json
    with open("/mnt/ssd3/ericzhou/sra/taint-reports/codeql/totinfo-iruntrusted.sarif") as f:
        sarif = json.loads(f.read())
    flows = parse_sarif_flows(sarif)

    print(len(flows), "paths")
    for i, fp in enumerate(flows, 1):
        print(f"\nPath {i} — rule {fp.rule_id!r}")
        for step, loc in enumerate(fp.locations, 1):
            print(f"  {step:02d}. {loc.uri}  {loc.span()}  {loc.message or ''}")
