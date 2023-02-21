% Type155_CallingMatlab.m
% ----------------------------------------------------------------------------------------------------------------------
%
% Example M-file called by TRNSYS Type 155
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
%          "Local" variables like iCall, iStep in this example will also be shared by all units 
%          (i.e. they should be given a different name in each m-File if required)
%
% ----------------------------------------------------------------------------------------------------------------------
% This example implements a very simple component. The component is iterative (should be called at each TRNSYS call)
%
%
% MKu, October 2004
% ----------------------------------------------------------------------------------------------------------------------


% TRNSYS sets mFileErrorCode = 1 at the beginning of the M-File for error detection
% This file increments mFileErrorCode at different places. If an error occurs in the m-file the last succesful step will
% be indicated by mFileErrorCode, which is displayed in the TRNSYS error message
% At the very end, the m-file sets mFileErrorCode to 0 to indicate that everything was OK

mFileErrorCode = 100;    % Beginning of the m-file 


% --- Process Inputs and global parameters -----------------------------------------------------------------------------
% ----------------------------------------------------------------------------------------------------------------------

nI = trnInfo(3);
nO = trnInfo(6);

MyInput = trnInputs(1);

mFileErrorCode = 110;    % After processing inputs


% --- First call of the simulation: initial time step (no iterations) --------------------------------------------------
% ----------------------------------------------------------------------------------------------------------------------
% (note that Matlab is initialized before this at the info(7) = -1 call, but the m-file is not called)

if ( (trnInfo(7) == 0) & (trnTime-trnStartTime < 1e-6) )  
    
    % This is the first call (Counter will be incremented later for this very first call)
    iCall = 0;

    % This is the first time step
    iStep = 1;
    
    % Do some initialization stuff, e.g. initialize history of the variables for plotting at the end of the simulation
    % (uncomment lines if you wish to store variables) 
    nTimeSteps = (trnStopTime-trnStartTime)/trnTimeStep + 1;
    history.inputs = zeros(nTimeSteps,nI);

    % No return, normal calculations are also performed during this call
    mFileErrorCode = 120    % After initialization call
    
end


% --- Very last call of the simulation (after the user clicks "OK") ----------------------------------------------------
% ----------------------------------------------------------------------------------------------------------------------

if ( trnInfo(8) == -1 )

    mFileErrorCode = 1000;
    
    % Do stuff at the end of the simulation, e.g. calculate stats, draw plots, etc... 
        
    mFileErrorCode = 0; % Tell TRNSYS that we reached the end of the m-file without errors
    return

end


% --- Post convergence calls: store values -----------------------------------------------------------------------------
% ----------------------------------------------------------------------------------------------------------------------

if (trnInfo(13) == 1)
    
    mFileErrorCode = 200;   % Beginning of a post-convergence call 

    % This is the extra call that indicates that all Units have converged. You should do things like: 
    % - calculate control signal that should be applied at next time step
    % - Store history of variables

    history.inputs(iStep) = MyInput; 

    % Note: If Calling Mode is set to 10, Matlab will not be called during iterative calls.
    % In that case only this loop will be executed and things like incrementing the "iStep" counter should be done here
    
    mFileErrorCode = 0; % Tell TRNSYS that we reached the end of the m-file without errors
    return  % Do not update outputs at this call

end


% --- All iterative calls ----------------------------------------------------------------------------------------------
% ----------------------------------------------------------------------------------------------------------------------

% --- If this is a first call in the time step, increment counter ---

if ( trnInfo(7) == 0 )
    iStep = iStep+1;
end

% --- Process Inputs ---

mFileErrorCode = 130;   % Beginning of iterative call

% Do calculations here
MyResult = MyInput*2;

% --- Set outputs ---

trnOutputs(1) = MyResult;

mFileErrorCode = 0; % Tell TRNSYS that we reached the end of the m-file without errors
return