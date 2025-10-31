//===----------------------------------------------------------------------===//
// FlowManager.h - Track and deduplicate taint flows
//===----------------------------------------------------------------------===//
//
// This component manages the flow database and assigns unique IDs to sources
// and sinks based on their locations.
//
// Key responsibilities:
//   1. Store flows with source and sink locations
//   2. Assign unique SRC_ID to each unique source location
//   3. Assign unique SINK_ID to each unique sink location
//   4. Track flow mappings: (SRC_ID, SINK_ID) → Flow
//   5. Provide deduplication: same location = same ID
//
//===----------------------------------------------------------------------===//

#ifndef FLOWMANAGER_H
#define FLOWMANAGER_H

#include <map>
#include <string>
#include <vector>

namespace taint {

// Represents a source code location with file, line, and column range
struct SourceLocation {
  std::string filePath;
  unsigned line;
  unsigned colStart;
  unsigned colEnd;

  // Equality for map key comparison
  bool operator<(const SourceLocation &Other) const {
    if (filePath != Other.filePath)
      return filePath < Other.filePath;
    if (line != Other.line)
      return line < Other.line;
    if (colStart != Other.colStart)
      return colStart < Other.colStart;
    return colEnd < Other.colEnd;
  }

  bool operator==(const SourceLocation &Other) const {
    return filePath == Other.filePath && line == Other.line &&
           colStart == Other.colStart && colEnd == Other.colEnd;
  }

  std::string toString() const;
};

// Represents a complete taint flow from source to sink
struct Flow {
  int flowID;           // Unique flow identifier (sequential)
  SourceLocation source; // Where the taint originates
  SourceLocation sink;   // Where the taint leaks
  int srcID;            // Assigned source ID (shared across flows)
  int sinkID;           // Assigned sink ID (shared across flows)
  
  // Optional: dataflow path (ignored for now, can be extended)
  std::vector<SourceLocation> path;

  std::string description; // Human-readable description from SARIF
};

class FlowManager {
public:
  FlowManager() : nextFlowID(1), nextSrcID(1), nextSinkID(1) {}

  // Add a flow and assign IDs
  void addFlow(const Flow &F);

  // Get all flows
  const std::vector<Flow> &getFlows() const { return flows; }

  // Get unique source locations with their assigned IDs
  const std::map<SourceLocation, int> &getSourceLocations() const {
    return srcLocationToID;
  }

  // Get unique sink locations with their assigned IDs
  const std::map<SourceLocation, int> &getSinkLocations() const {
    return sinkLocationToID;
  }

  // Query: get all flows that use a specific source ID
  std::vector<const Flow *> getFlowsWithSrcID(int srcID) const;

  // Query: get all flows that use a specific sink ID
  std::vector<const Flow *> getFlowsWithSinkID(int sinkID) const;

  // Query: get flow by (SRC_ID, SINK_ID) pair
  const Flow *getFlow(int srcID, int sinkID) const;

  // Statistics
  size_t getNumFlows() const { return flows.size(); }
  size_t getNumUniqueSources() const { return srcLocationToID.size(); }
  size_t getNumUniqueSinks() const { return sinkLocationToID.size(); }

  void printSummary() const;

private:
  std::vector<Flow> flows;
  std::map<SourceLocation, int> srcLocationToID;
  std::map<SourceLocation, int> sinkLocationToID;
  
  // Reverse mappings for queries
  std::map<int, std::vector<const Flow *>> srcIDToFlows;
  std::map<int, std::vector<const Flow *>> sinkIDToFlows;
  std::map<std::pair<int, int>, const Flow *> srcSinkToFlow;

  int nextFlowID;
  int nextSrcID;
  int nextSinkID;
};

} // namespace taint

#endif // FLOWMANAGER_H
