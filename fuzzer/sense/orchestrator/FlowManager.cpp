//===----------------------------------------------------------------------===//
// FlowManager.cpp - Implementation of flow tracking and deduplication
//===----------------------------------------------------------------------===//

#include "FlowManager.h"
#include <algorithm>
#include <fstream>
#include <iostream>
#include <sstream>

namespace taint {

std::string SourceLocation::toString() const {
  std::ostringstream oss;
  oss << filePath << ":" << line << ":" << colStart << "-" << colEnd;
  return oss.str();
}

void FlowManager::addFlow(const Flow &F) {
  Flow newFlow = F;
  newFlow.flowID = nextFlowID++;

  // Assign or reuse SRC_ID
  auto srcIt = srcLocationToID.find(F.source);
  if (srcIt == srcLocationToID.end()) {
    newFlow.srcID = nextSrcID++;
    srcLocationToID[F.source] = newFlow.srcID;
  } else {
    newFlow.srcID = srcIt->second;
  }

  // Assign or reuse SINK_ID
  auto sinkIt = sinkLocationToID.find(F.sink);
  if (sinkIt == sinkLocationToID.end()) {
    newFlow.sinkID = nextSinkID++;
    sinkLocationToID[F.sink] = newFlow.sinkID;
  } else {
    newFlow.sinkID = sinkIt->second;
  }

  // Assign or reuse INTERMEDIATE_IDs for path locations
  for (const auto &intermediateLoc : F.path) {
    auto it = intermediateLocationToID.find(intermediateLoc);
    if (it == intermediateLocationToID.end()) {
      int newID = nextIntermediateID++;
      intermediateLocationToID[intermediateLoc] = newID;
      std::cout << "[FlowManager] Added intermediate location: ID=" << newID
                << " at " << intermediateLoc.toString() << "\n";
    }
  }

  // Store flow
  flows.push_back(newFlow);
  const Flow *flowPtr = &flows.back();

  // Build reverse mappings
  srcIDToFlows[newFlow.srcID].push_back(flowPtr);
  sinkIDToFlows[newFlow.sinkID].push_back(flowPtr);
  srcSinkToFlow[{newFlow.srcID, newFlow.sinkID}] = flowPtr;

  std::cout << "[FlowManager] Added flow #" << newFlow.flowID
            << ": SRC_ID=" << newFlow.srcID << " (" << F.source.toString()
            << ") → SINK_ID=" << newFlow.sinkID << " (" << F.sink.toString()
            << ")";
  if (!F.path.empty()) {
    std::cout << " with " << F.path.size() << " intermediate locations";
  }
  std::cout << "\n";
}

int FlowManager::addIntermediateLocation(const SourceLocation &Loc) {
  auto it = intermediateLocationToID.find(Loc);
  if (it != intermediateLocationToID.end()) {
    // Already exists, return existing ID
    return it->second;
  }

  // Assign new ID
  int newID = nextIntermediateID++;
  intermediateLocationToID[Loc] = newID;

  std::cout << "[FlowManager] Added intermediate location: ID=" << newID
            << " at " << Loc.toString() << "\n";

  return newID;
}

std::vector<const Flow *> FlowManager::getFlowsWithSrcID(int srcID) const {
  auto it = srcIDToFlows.find(srcID);
  if (it != srcIDToFlows.end()) {
    return it->second;
  }
  return {};
}

std::vector<const Flow *> FlowManager::getFlowsWithSinkID(int sinkID) const {
  auto it = sinkIDToFlows.find(sinkID);
  if (it != sinkIDToFlows.end()) {
    return it->second;
  }
  return {};
}

const Flow *FlowManager::getFlow(int srcID, int sinkID) const {
  auto it = srcSinkToFlow.find({srcID, sinkID});
  if (it != srcSinkToFlow.end()) {
    return it->second;
  }
  return nullptr;
}

void FlowManager::printSummary() const {
  std::cout << "\n=== Flow Manager Summary ===\n";
  std::cout << "Total flows: " << getNumFlows() << "\n";
  std::cout << "Unique sources: " << getNumUniqueSources() << "\n";
  std::cout << "Unique sinks: " << getNumUniqueSinks() << "\n";

  std::cout << "\nSource locations:\n";
  for (const auto &[loc, id] : srcLocationToID) {
    std::cout << "  SRC_ID=" << id << ": " << loc.toString() << "\n";
  }

  std::cout << "\nSink locations:\n";
  for (const auto &[loc, id] : sinkLocationToID) {
    std::cout << "  SINK_ID=" << id << ": " << loc.toString() << "\n";
  }

  std::cout << "\nIntermediate locations:\n";
  for (const auto &[loc, id] : intermediateLocationToID) {
    std::cout << "  INTERMEDIATE_ID=" << id << ": " << loc.toString() << "\n";
  }

  std::cout << "\nFlow mappings:\n";
  for (const auto &flow : flows) {
    std::cout << "  Flow #" << flow.flowID << ": (SRC_ID=" << flow.srcID
              << ", SINK_ID=" << flow.sinkID << ")";
    if (!flow.description.empty()) {
      std::cout << " - " << flow.description;
    }
    std::cout << "\n";
  }
  std::cout << "============================\n\n";
}

bool FlowManager::serializeToFile(const std::string &FilePath) const {
  std::ofstream File(FilePath);
  if (!File.is_open()) {
    std::cerr << "[FlowManager] ERROR: Could not open file for writing: "
              << FilePath << "\n";
    return false;
  }

  // Write header with version and counts
  File << "# FlowManager Serialized Database v1.0\n";
  File << "# Format: TYPE,ID,file,line,colStart,colEnd[,flowID,srcID,sinkID,"
          "description]\n";
  File << "METADATA,flows=" << getNumFlows()
       << ",sources=" << getNumUniqueSources()
       << ",sinks=" << getNumUniqueSinks()
       << ",intermediates=" << getNumUniqueIntermediates() << "\n";

  // Write source locations
  for (const auto &[loc, id] : srcLocationToID) {
    File << "SOURCE," << id << "," << loc.filePath << "," << loc.line << ","
         << loc.colStart << "," << loc.colEnd << "\n";
  }

  // Write sink locations
  for (const auto &[loc, id] : sinkLocationToID) {
    File << "SINK," << id << "," << loc.filePath << "," << loc.line << ","
         << loc.colStart << "," << loc.colEnd << "\n";
  }

  // Write intermediate locations
  for (const auto &[loc, id] : intermediateLocationToID) {
    File << "INTERMEDIATE," << id << "," << loc.filePath << "," << loc.line
         << "," << loc.colStart << "," << loc.colEnd << "\n";
  }

  // Write flow mappings
  for (const auto &flow : flows) {
    // Escape description (replace commas with semicolons)
    std::string escapedDesc = flow.description;
    std::replace(escapedDesc.begin(), escapedDesc.end(), ',', ';');

    File << "FLOW," << flow.flowID << "," << flow.srcID << "," << flow.sinkID
         << "," << escapedDesc << "\n";
  }

  File.close();

  std::cout << "[FlowManager] Serialized to: " << FilePath << "\n";
  std::cout << "  Sources: " << getNumUniqueSources() << "\n";
  std::cout << "  Sinks: " << getNumUniqueSinks() << "\n";
  std::cout << "  Intermediates: " << getNumUniqueIntermediates() << "\n";
  std::cout << "  Flows: " << getNumFlows() << "\n";

  return true;
}

bool FlowManager::deserializeFromFile(const std::string &FilePath) {
  std::ifstream File(FilePath);
  if (!File.is_open()) {
    std::cerr << "[FlowManager] ERROR: Could not open file for reading: "
              << FilePath << "\n";
    return false;
  }

  // Clear existing data
  flows.clear();
  srcLocationToID.clear();
  sinkLocationToID.clear();
  intermediateLocationToID.clear();
  srcIDToFlows.clear();
  sinkIDToFlows.clear();
  srcSinkToFlow.clear();

  std::string line;
  int lineNum = 0;

  while (std::getline(File, line)) {
    lineNum++;

    // Skip comments and empty lines
    if (line.empty() || line[0] == '#')
      continue;

    std::istringstream iss(line);
    std::string type;
    std::getline(iss, type, ',');

    if (type == "METADATA") {
      // Parse metadata (optional, for validation)
      continue;
    } else if (type == "SOURCE" || type == "SINK" || type == "INTERMEDIATE") {
      // Parse: TYPE,ID,file,line,colStart,colEnd
      std::string idStr, filePath, lineStr, colStartStr, colEndStr;

      if (!std::getline(iss, idStr, ',') || !std::getline(iss, filePath, ',') ||
          !std::getline(iss, lineStr, ',') ||
          !std::getline(iss, colStartStr, ',') ||
          !std::getline(iss, colEndStr, ',')) {
        std::cerr << "[FlowManager] WARNING: Malformed line " << lineNum << ": "
                  << line << "\n";
        continue;
      }

      int id = std::stoi(idStr);
      SourceLocation loc;
      loc.filePath = filePath;
      loc.line = std::stoul(lineStr);
      loc.colStart = std::stoul(colStartStr);
      loc.colEnd = std::stoul(colEndStr);

      if (type == "SOURCE") {
        srcLocationToID[loc] = id;
        if (id >= nextSrcID)
          nextSrcID = id + 1;
      } else if (type == "SINK") {
        sinkLocationToID[loc] = id;
        if (id >= nextSinkID)
          nextSinkID = id + 1;
      } else if (type == "INTERMEDIATE") {
        intermediateLocationToID[loc] = id;
        if (id >= nextIntermediateID)
          nextIntermediateID = id + 1;
      }
    } else if (type == "FLOW") {
      // Parse: FLOW,flowID,srcID,sinkID,description
      std::string flowIDStr, srcIDStr, sinkIDStr, description;

      if (!std::getline(iss, flowIDStr, ',') ||
          !std::getline(iss, srcIDStr, ',') ||
          !std::getline(iss, sinkIDStr, ',')) {
        std::cerr << "[FlowManager] WARNING: Malformed flow line " << lineNum
                  << ": " << line << "\n";
        continue;
      }

      // Rest of line is description (may contain commas-turned-semicolons)
      std::getline(iss, description);

      Flow flow;
      flow.flowID = std::stoi(flowIDStr);
      flow.srcID = std::stoi(srcIDStr);
      flow.sinkID = std::stoi(sinkIDStr);
      flow.description = description;

      // Find source and sink locations by ID
      for (const auto &[loc, id] : srcLocationToID) {
        if (id == flow.srcID) {
          flow.source = loc;
          break;
        }
      }
      for (const auto &[loc, id] : sinkLocationToID) {
        if (id == flow.sinkID) {
          flow.sink = loc;
          break;
        }
      }

      flows.push_back(flow);
      const Flow *flowPtr = &flows.back();

      // Rebuild reverse mappings
      srcIDToFlows[flow.srcID].push_back(flowPtr);
      sinkIDToFlows[flow.sinkID].push_back(flowPtr);
      srcSinkToFlow[{flow.srcID, flow.sinkID}] = flowPtr;

      if (flow.flowID >= nextFlowID)
        nextFlowID = flow.flowID + 1;
    }
  }

  File.close();

  std::cout << "[FlowManager] Deserialized from: " << FilePath << "\n";
  std::cout << "  Sources: " << getNumUniqueSources() << "\n";
  std::cout << "  Sinks: " << getNumUniqueSinks() << "\n";
  std::cout << "  Intermediates: " << getNumUniqueIntermediates() << "\n";
  std::cout << "  Flows: " << getNumFlows() << "\n";

  return true;
}

} // namespace taint
