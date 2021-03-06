/**
 * @kind path-problem
 */

import cpp
import semmle.code.cpp.dataflow.TaintTracking
import DataFlow::PathGraph

class NetworkByteSwap extends Expr {
    NetworkByteSwap () {
        exists(
          MacroInvocation mi | mi.getMacroName().regexpMatch("ntoh(l|ll|s)") 
          and this=mi.getExpr()
      )
    }
}

class Config extends TaintTracking::Configuration {
  Config() { this = "NetworkToMemFuncLength" }

  override predicate isSource(DataFlow::Node source) {
    exists (NetworkByteSwap mi | source.asExpr()=mi)
  }
  override predicate isSink(DataFlow::Node sink) {
    exists (
        FunctionCall fc | fc.getTarget().toString()="memcpy" 
        and fc.getArgument(2).getLocation()=sink.getLocation()
    )
  }
}

from Config cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink, source, sink, "Network byte swap flows to memcpy"