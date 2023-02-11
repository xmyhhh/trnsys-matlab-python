% SolarCollector.m
% ----------------------------------------------------------------------------------------------------------------------
%
% Simple first-order solar collector model (M-file called by TRNSYS type 155)
%
% Data passed from / to TRNSYS 
% ---------------------------- 
%
% trnTime (1x1)        : simulation time 
% trnInfo (15x1)       : TRNSYS info array
% trnInputs (nIx1)     : TRNSYS inputs 
% trnStartTime (1x1)   : TRNSYS Simulation Start time
% trnStopTime (1x1)    : TRNSYS Simulation Stop time
% trnTimeStep (1x1)    : TRNSYS Simulation time step
% mFileErrorCode (1x1) : Error code for this m-file. It is set to 1 by TRNSYS and the m-file should set it to 0 at the
%                        end to indicate that the call was successful. Any non-zero value will stop the simulation
% trnOutputs (nOx1)    : TRNSYS outputs  
%
% 
% Notes: 
% ------
% 
% You can use the values of trnInfo(7), trnInfo(8) and trnInfo(13) to identify the call (e.g. first iteration, etc.)
% Real-time controllers (callingMode = 10) will only be called once per time step with trnInfo(13) = 1 (after convergence)
% 
% The number of inputs is given by trnInfo(3)
% The number of expected outputs is given by trnInfo(6)
% WARNING: if multiple units of Type 155 are used, the variables passed from/to TRNSYS will be sized according to  
%          the maximum required by all units. You should cope with that by only using the part of the arrays that is 
%          really used by the current m-File. Example: use "nI = trnInfo(3); myInputs = trnInputs(1:nI);" 
%                                                      rather than "MyInputs = trnInputs;" 
%          Please also note that all m-files share the same workspace in Matlab (they are "scripts", not "functions") so
%          variables like trnInfo, trnTime, etc. will be overwritten at each call. 
%
% ----------------------------------------------------------------------------------------------------------------------
% This example implements a very simple solar collector model. The component is iterative (should be called at each
% TRNSYS call)
%
% trnInputs
% ---------
%
% trnInputs(1) : Ti, collector inlet temperature
% trnInputs(2) : mdot, collector flowrate
% trnInputs(3) : Tamb , ambient temperature
% trnInputs(4) : Gt, solar radiation in the collector plane
%
% trnOutputs
% ----------
%
% trnOutputs(1) : To, collector outlet temperature
% trnOutputs(2) : mdot, collector flowrate
% trnOutputs(3) : Quseful, useful energy gain
%
% MKu, October 2004
% ----------------------------------------------------------------------------------------------------------------------


% TRNSYS sets mFileErrorCode = 1 at the beginning of the M-File for error detection
% This file increments mFileErrorCode at different places. If an error occurs in the m-file the last succesful step will
% be indicated by mFileErrorCode, which is displayed in the TRNSYS error message
% At the very end, the m-file sets mFileErrorCode to 0 to indicate that everything was OK

mFileErrorCode = 100;    % Beginning of the m-file 


% --- First call of the simulation: initial time step (no iterations) --------------------------------------------------
% ----------------------------------------------------------------------------------------------------------------------
% (note that Matlab is initialized before this at the info(7) = -1 call, but the m-file is not called)

if ( (trnInfo(7) == 0) & (trnTime-trnStartTime < 1e-6) )   
    
    tcw12 = 70;
    tc = 50;
    h3 = 260;
    tew12 = 20;
    te = 5;
    h1 =  410;  

    Te_in=12;
    Ge_in=14;
    Tc_in=35;
    Gc_in=8;

    mFileErrorCode = 130;  
    
end



options = simset('SrcWorkspace','current','Solver','ode45');
out = sim('H_P.slx',[0, (trnTimeStep)*3600], options);

tcw12 = getdatasamples(out.tcw12, [get(out.tcw12).Length]);
tc = getdatasamples(out.tc, [get(out.tcw12).Length]);
h3 = getdatasamples(out.h3, [get(out.tcw12).Length]);
tew12 = getdatasamples(out.tew12, [get(out.tcw12).Length]);
te = getdatasamples(out.te, [get(out.tcw12).Length]);
h1 = getdatasamples(out.h1, [get(out.tcw12).Length]);


trnOutputs(1) = getdatasamples(out.pc, [get(out.tcw12).Length]);
trnOutputs(2) = getdatasamples(out.tcw2, [get(out.tcw12).Length]);
trnOutputs(3) = getdatasamples(out.h3, [get(out.tcw12).Length]);
trnOutputs(4) = getdatasamples(out.Qc, [get(out.tcw12).Length]);
trnOutputs(5) = getdatasamples(out.tew2, [get(out.tcw12).Length]);
trnOutputs(6) = getdatasamples(out.pe, [get(out.tcw12).Length]);
trnOutputs(7) = getdatasamples(out.h1, [get(out.tcw12).Length]);
trnOutputs(8) = getdatasamples(out.vd, [get(out.tcw12).Length]);
trnOutputs(9) = getdatasamples(out.Qe, [get(out.tcw12).Length]);




mFileErrorCode = 0; % Tell TRNSYS that we reached the end of the m-file without errors
return