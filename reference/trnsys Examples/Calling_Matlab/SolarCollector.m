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

mFileErrorCode = 100    % Beginning of the m-file 

% --- Solar collector parameters----------------------------------------------------------------------------------------
% ----------------------------------------------------------------------------------------------------------------------

% Efficiency: 
% eta = qUseful / (Gt A) = mdot Cp (To - Ti) / (Gt A) = eta0 - eta1 * Gt / (To-Tamb)
% can be rewritten as:
% To = (eta0*Gt+mdot*Cp/A*Ti+eta1*Tamb) / (mdot*Cp/Aa+eta1)

% Collector area [m^2]
A = 5;
% Intercept efficiency [-]
eta0 = 0.8;
% Negative First order loss coefficient [kJ/h-m^2-K]
eta1 = 15;
% Specific heat [kJ/kg-K]
Cp = 4.19;

mFileErrorCode = 110    % After setting parameters


% --- Process Inputs ---------------------------------------------------------------------------------------------------
% ----------------------------------------------------------------------------------------------------------------------

Ti   = trnInputs(1);
mdot = trnInputs(2);
Tamb = trnInputs(3);
Gt   = trnInputs(4);

mFileErrorCode = 120    % After processing inputs


% --- First call of the simulation: initial time step (no iterations) --------------------------------------------------
% ----------------------------------------------------------------------------------------------------------------------
% (note that Matlab is initialized before this at the info(7) = -1 call, but the m-file is not called)

if ( (trnInfo(7) == 0) & (trnTime-trnStartTime < 1e-6) )  
    
    % This is the first call (Counter will be incremented later for this very first call)
    nCall = 0;

    % This is the first time step
    nStep = 1;
    
    % Initialize history of the variables for plotting at the end of the simulation
    nTimeSteps = (trnStopTime-trnStartTime)/trnTimeStep + 1;
    history.Tamb    = zeros(nTimeSteps,1);
    history.Gt      = zeros(nTimeSteps,1);
    history.To      = zeros(nTimeSteps,1);
    history.Quseful = zeros(nTimeSteps,1);

    % No return, we will calculate the solar collector performance during this call
    mFileErrorCode = 130    % After initialization
    
end


% --- Very last call of the simulation (after the user clicks "OK"): Do nothing ----------------------------------------
% ----------------------------------------------------------------------------------------------------------------------

if ( trnInfo(8) == -1 )

    mFileErrorCode = 1000;
    
    % Draw a plot of efficiency versus (To-Ta)/Gt
    isOk = find(history.Gt > 10);
    plot( (history.To(isOk)-history.Tamb(isOk))./history.Gt(isOk) , history.Quseful(isOk)/A./history.Gt(isOk) , 'r.' );
    title('Collector Efficiency');
    ylabel('Efficiency [-]');
    xlabel('(To-Tamb)/Gt  [°C.m².h/kJ]');
        
    mFileErrorCode = 0; % Tell TRNSYS that we reached the end of the m-file without errors
    return

end


% --- Post convergence calls: store values -----------------------------------------------------------------------------
% ----------------------------------------------------------------------------------------------------------------------

if (trnInfo(13) == 1)
    
    mFileErrorCode = 140;   % Beginning of a post-convergence call 
    
    history.Tamb(nStep)    = Tamb;
    history.Gt(nStep)      = Gt;
    history.To(nStep)      = To;
    history.Quseful(nStep) = Quseful;
    
    mFileErrorCode = 0; % Tell TRNSYS that we reached the end of the m-file without errors
    return  % Do not update outputs at this call

end


% --- All iterative calls ----------------------------------------------------------------------------------------------
% ----------------------------------------------------------------------------------------------------------------------

% --- If this is a first call in the time step, increment counter ---

if ( trnInfo(7) == 0 )
    nStep = nStep+1;
end

% --- Get TRNSYS Inputs ---

nI = trnInfo(3);     % For bookkeeping
nO = trnInfo(6);   % For bookkeeping

Ti   = trnInputs(1);
mdot = trnInputs(2);
Tamb = trnInputs(3);
Gt   = trnInputs(4);

mFileErrorCode = 150;   % After reading inputs 

% --- Calculate solar collector performance ---

To = (eta0*Gt+mdot*Cp/A*Ti+eta1*Tamb) / (mdot*Cp/A+eta1);
Quseful = mdot*Cp*(To-Ti);

% --- Set outputs ---

trnOutputs(1) = To;
trnOutputs(2) = mdot;
trnOutputs(3) = Quseful;

mFileErrorCode = 0; % Tell TRNSYS that we reached the end of the m-file without errors
return