--		Copyright 2008, 2009 by Daniel R. Grayson

-- this file contains top level routines that call the C++ code in the engine

use engine;
use common;
use hashtables;
use util;
use struct;
header "#include <engine.h>";

-- straight line programs

export rawSLP(e:Expr):Expr := (
     when e is s:Sequence do
     if length(s) != 2 then WrongNumArgs(2)
     else when s.0 is M:RawMatrixCell do (
	  if !isSequenceOfSmallIntegers(s.1) then WrongArg(2,"a sequence of small integers") else
	  toExpr(Ccode(RawStraightLineProgramOrNull,
		    "rawSLP(",
		    M.p, ",",
		    getSequenceOfSmallIntegers(s.1),
		    ")"
		    )))
     else WrongArgMatrix(1)
     else WrongNumArgs(2));
setupfun("rawSLP",rawSLP);

export rawEvaluateSLP(e:Expr):Expr := (
     when e is s:Sequence do
     if length(s) != 2 then WrongNumArgs(2)
     else when s.0 is slp:RawStraightLineProgramCell do (
	  when s.1 is M:RawMatrixCell do (
	       toExpr(Ccode(RawMatrixOrNull,
		    	 "rawEvaluateSLP(",
		    	 slp.p, ",",
		    	 M.p,
		    	 ")"
		    	 )))
	  else WrongArgMatrix(1))
     else WrongArg(2,"a raw straight line program")
     else WrongNumArgs(2)
     );
setupfun("rawEvaluateSLP",rawEvaluateSLP);

export rawPathTrackerPrecookedSLPs(e:Expr):Expr := (
     when e is s:Sequence do
     if length(s) != 2 then WrongNumArgs(2)
     else when s.0 is slp1:RawStraightLineProgramCell do 
     	  when s.1 is slp2:RawStraightLineProgramCell do
	       toExpr(Ccode(RawPathTrackerOrNull,
			"rawPathTrackerPrecookedSLPs(",
	       	   	slp1.p, ",",
		   	slp2.p, 
		   	")"
		    ))
     	  else WrongArg(2,"a raw straight line program")
     	  else WrongArg(1,"a raw straight line program")
     else WrongNumArgs(2)
     );
setupfun("rawPathTrackerPrecookedSLPs",rawPathTrackerPrecookedSLPs);

export rawPathTracker(e:Expr):Expr := (
     when e is HH:RawMatrixCell do 
		toExpr(Ccode(RawPathTrackerOrNull,
		    "rawPathTracker(",
		    HH.p, 
		    ")"
		    ))
     else WrongArgMatrix()
     );
setupfun("rawPathTracker",rawPathTracker);

export rawPathTrackerProjective(e:Expr):Expr := (
     when e is s:Sequence do
     if length(s) != 3 then WrongNumArgs(3)
     else when s.0 is S:RawMatrixCell do 
     	  when s.1 is T:RawMatrixCell do 
	  when s.2 is productST:RRcell do
	       toExpr(Ccode(RawPathTrackerOrNull,
			"rawPathTrackerProjective(",
	       	   	S.p, ",",
		   	T.p, ",",
			productST.v,
		   	")"
		    ))
          else WrongArgRR(3)
     	  else WrongArgMatrix(2)
     	  else WrongArgMatrix(1)
     else WrongNumArgs(3)
     );
setupfun("rawPathTrackerProjective",rawPathTrackerProjective);

export rawSetParametersPT(e:Expr):Expr := (
     when e is s:Sequence do
     if length(s) != 12 then WrongNumArgs(11)
     else when s.0 is PT:RawPathTrackerCell do 
	  when s.1 is isProj:Boolean do
	  when s.2 is initDt:RRcell do
	  when s.3 is minDt:RRcell do
	  when s.4 is dtIncreaseFactor:RRcell do 
	  when s.5 is dtDecreaseFactor:RRcell do
	  when s.6 is numSuccessesBeforeIncrease:ZZcell do
	  when s.7 is epsilon:RRcell do 
	  when s.8 is maxCorrSteps:ZZcell do
	  when s.9 is endZoneFactor:RRcell do 
	  when s.10 is infinityThreshold:RRcell do 
	  when s.11 is predType:ZZcell do 
	  (
	       Ccode(void,
		    	 "rawSetParametersPT(",
		    	 PT.p, ",",
			 toBoolean(s.1),",",
			 initDt.v,",",
			 minDt.v,",",
			 dtIncreaseFactor.v,",",
			 dtDecreaseFactor.v,",",
			 toInt(s.6),",",
			 epsilon.v,",",
			 toInt(s.8),",",
			 endZoneFactor.v,",",
			 infinityThreshold.v,",",
			 toInt(s.11),
		    	 ")"
		    	 );
	       nullE)
	  else WrongArgZZ(12)
	  else WrongArgRR(11)
	  else WrongArgRR(10)
	  else WrongArgZZ(9)
	  else WrongArgRR(8)
	  else WrongArgZZ(7)
	  else WrongArgRR(6)
	  else WrongArgRR(5)
	  else WrongArgRR(4)
	  else WrongArgRR(3)
	  else WrongArgBoolean(2)
     	  else WrongArg(1,"a path tracker")
     else WrongNumArgs(12)
     );
setupfun("rawSetParametersPT",rawSetParametersPT);

export rawLaunchPT(e:Expr):Expr := (
     when e is s:Sequence do
     if length(s) != 2 then WrongNumArgs(2)
     else when s.0 is PT:RawPathTrackerCell do 
	  when s.1 is startSols:RawMatrixCell do (
	       Ccode(void,
		    	 "rawLaunchPT(",
		    	 PT.p, ",",
	                 startSols.p, 
		    	 ")"
	       );
	       nullE)
	  else WrongArgMatrix(2)
     	  else WrongArg(1,"a path tracker")
     else WrongNumArgs(2)
     );
setupfun("rawLaunchPT",rawLaunchPT);

export rawGetSolutionPT(e:Expr):Expr := (
     when e is s:Sequence do
     if length(s) != 2 then WrongNumArgs(2)
     else when s.0 is PT:RawPathTrackerCell do 
          when s.1 is solN:ZZcell do 
		toExpr(Ccode(RawMatrixOrNull,
		    "rawGetSolutionPT(",
		    PT.p, ",",
		    toInt(s.1), 		    
		    ")"
		    ))
          else WrongArgZZ(2) 
          else WrongArg(1,"a path tracker")
     else WrongNumArgs(2)
     );
setupfun("rawGetSolutionPT",rawGetSolutionPT);

export rawGetAllSolutionsPT(e:Expr):Expr := (
     when e is PT:RawPathTrackerCell  do 
		toExpr(Ccode(RawMatrixOrNull,
		    "rawGetAllSolutionsPT(",
		    PT.p, 
		    ")"
		    ))
     else WrongArg("a path tracker")
     );
setupfun("rawGetAllSolutionsPT",rawGetAllSolutionsPT);

export rawGetSolutionStatusPT(e:Expr):Expr := (
     when e is s:Sequence do
     if length(s) != 2 then WrongNumArgs(2)
     else when s.0 is PT:RawPathTrackerCell do 
          when s.1 is solN:ZZcell do 
		toExpr(Ccode(int,
		    "rawGetSolutionStatusPT(",
		    PT.p, ",",
		    toInt(s.1), 		    
		    ")"
		    ))
          else WrongArgZZ(2) 
          else WrongArg(1,"a path tracker")
     else WrongNumArgs(2)
     );
setupfun("rawGetSolutionStatusPT",rawGetSolutionStatusPT);

export rawGetSolutionLastTvaluePT(e:Expr):Expr := (
     when e is s:Sequence do
     if length(s) != 2 then WrongNumArgs(2)
     else when s.0 is PT:RawPathTrackerCell do 
          when s.1 is solN:ZZcell do 
		toExpr(Ccode(RRorNull, "rawGetSolutionLastTvaluePT(",
		    PT.p, ",",
		    toInt(s.1), 		    
		    ")"
		    ))
          else WrongArgZZ(2) 
          else WrongArg(1,"a path tracker")
     else WrongNumArgs(2)
     );
setupfun("rawGetSolutionLastTvaluePT",rawGetSolutionLastTvaluePT);

export rawGetSolutionStepsPT(e:Expr):Expr := (
     when e is s:Sequence do
     if length(s) != 2 then WrongNumArgs(2)
     else when s.0 is PT:RawPathTrackerCell do 
          when s.1 is solN:ZZcell do 
		toExpr(Ccode(int,
		    "rawGetSolutionStepsPT(",
		    PT.p, ",",
		    toInt(s.1), 		    
		    ")"
		    ))
          else WrongArgZZ(2) 
          else WrongArg(1,"a path tracker")
     else WrongNumArgs(2)
     );
setupfun("rawGetSolutionStepsPT",rawGetSolutionStepsPT);

export rawGetSolutionRcondPT(e:Expr):Expr := (
     when e is s:Sequence do
     if length(s) != 2 then WrongNumArgs(2)
     else when s.0 is PT:RawPathTrackerCell do 
          when s.1 is solN:ZZcell do 
		toExpr(Ccode(RRorNull, "rawGetSolutionRcondPT(",
		    PT.p, ",",
		    toInt(s.1), 		    
		    ")"
		    ))
          else WrongArgZZ(2) 
          else WrongArg(1,"a path tracker")
     else WrongNumArgs(2)
     );
setupfun("rawGetSolutionRcondPT",rawGetSolutionRcondPT);

export rawRefinePT(e:Expr):Expr := (
     when e is s:Sequence do
     if length(s) != 4 then WrongNumArgs(4)
     else when s.0 is PT:RawPathTrackerCell do 
	  when s.1 is sols:RawMatrixCell do 
	  when s.2 is tolerance:RRcell do
          when s.3 is maxSteps:ZZcell do 
	       toExpr(Ccode(RawMatrixOrNull,
		    "rawRefinePT(",
		    	 PT.p, ",",
	                 sols.p, ",",
			 tolerance.v,",",
                         toInt(s.3),
		    	 ")"
	       ))
          else WrongArgZZ(4)
          else WrongArgRR(3)
	  else WrongArgMatrix(2)
     	  else WrongArg(1,"a path tracker")
     else WrongNumArgs(4)
     );
setupfun("rawRefinePT",rawRefinePT);

export rawGbBoolean(e:Expr):Expr := (
  when e is m:RawMatrixCell do 
		toExpr(Ccode(RawMatrixOrNull,
		    "rawGbBoolean(",
		    m.p, 		    
		    ")"
		    ))
    else WrongArg(1, "a raw matrix") 
     );
setupfun("rawGbBoolean",rawGbBoolean);

export rawBIBasis(e:Expr):Expr := (
    when e is s:Sequence do
        if length(s) != 2 then WrongNumArgs(2)
        else when s.0 is m:RawMatrixCell do
             when s.1 is isProj:Boolean do
                toExpr(Ccode(RawMatrixOrNull,
                             "rawBIBasis(",
                             m.p, ",",
                             toBoolean(s.1),
                             ")"
                             )
                       )
             else WrongArgBoolean(2)
             else WrongArgMatrix(1)
    else WrongNumArgs(2)
    );
setupfun("rawBIBasis",rawBIBasis);


-- Local Variables:
-- compile-command: "echo \"make: Entering directory \\`$M2BUILDDIR/Macaulay2/d'\" && make -C $M2BUILDDIR/Macaulay2/d interface2.o "
-- End:
