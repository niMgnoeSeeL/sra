//===----------------------------------------------------------------------===//
// FlowManager.cpp - Implementation of flow tracking and deduplication
//===----------------------------------------------------------------------===//

#include "FlowManager.h"
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
            << ")\n";
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

} // namespace taint
