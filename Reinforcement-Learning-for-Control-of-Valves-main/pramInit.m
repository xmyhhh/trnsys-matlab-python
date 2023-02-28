% Parameter file for sscfluids_residential_ground_source_heat_pump
%
% This script loads the parameters for the residential ground source heat 
% pump model.
%

% Copyright 2022 The MathWorks, Inc.

%% House parameters

% Walls

lenHouse    = 30;       % House length [m]
widHouse    = 10;       % House width [m]
htHouse     = 4;        % House height [m]
thkWall     = 0.2;      % Wall thickness [m]
wallDensity = 1920;     % Density [kg/m^3]
cWall       = 835;      % Specific heat [J/kg/K]
kWall       = 0.1;      % Thermal conductivity [W/m/K]


assignin('base','lenHouse',lenHouse);
assignin('base','widHouse',widHouse);
assignin('base','htHouse',htHouse);
assignin('base','thkWall',thkWall);
assignin('base','wallDensity',wallDensity);
assignin('base','cWall',cWall);
assignin('base','kWall',kWall);

% Windows
n1Window      = 3;      % Number of windows in room 1
n2Window      = 2;      % Number of windows in room 2
n3Window      = 2;      % Number of windows in room 3
n4Window      = 2;      % Number of windows in room 4
htWindows     = 1;      % Height of windows [m]
widWindows    = 1;      % Width of windows  [m]
thkWindow     = 0.01;   % Thickness of windows [m]
windowDensity = 2700;   % Density [kg/m^3]
cWindow       = 840;    % Specific heat [J/kg/K]
kWindow       = 0.78;   % Thermal conductivity [W/m/K]

assignin('base','n1Window',n1Window);
assignin('base','n2Window',n2Window);
assignin('base','n3Window',n3Window);
assignin('base','n4Window',n4Window);
assignin('base','htWindows',htWindows);
assignin('base','widWindows',widWindows);
assignin('base','thkWindow',thkWindow);
assignin('base','windowDensity',windowDensity);
assignin('base','cWindow',cWindow);
assignin('base','kWindow',kWindow);



% Roof
pitRoof       = 40/180/pi;   % Roof pitch (40 deg)
thkRoof       = 0.2;         % Roof thickness [m]
roofDensity   = 32;          % Roof density (Glass fiber) [kg/m^3]
cRoof         = 835;         % Specific heat [J/kg/K]
kRoof         = 0.038;       % Thermal conductivity [W/m/K]

assignin('base','pitRoof',pitRoof);
assignin('base','thkRoof',thkRoof);
assignin('base','roofDensity',roofDensity);
assignin('base','cRoof',cRoof);
assignin('base','kRoof',kRoof);


% Convective heat transfer coefficients [W/M^2/K]
hAirWall      = 24;   % Indoor air->walls
hWallAtm      = 34;   % Walls -> atmosphere
hAirWindow    = 25;   % Indoor air -> windows
hWindowAtm    = 32;   % Windows -> atmosphere
hAirRoof      = 12;   % Indoor air -> roof
hRoofAtm      = 38;   % Roof -> atmosphere

assignin('base','hAirWall',hAirWall);
assignin('base','hWallAtm',hWallAtm);
assignin('base','hAirWindow',hAirWindow);
assignin('base','hAirRoof',hAirRoof);
assignin('base','hRoofAtm',hRoofAtm);
assignin('base','hWindowAtm',hWindowAtm);

%Air
cAir  = 1005.4;       % cp of air at 273 K [J/(kg*K)]
assignin('base','cAir',cAir);

% Leakage fraction
leakRoofPercent   = 0.1;   % Leakage through roof 
leakWallPercent   = 0.15;  % Leakage through walls
leakWinPercent    = 0.2;   % Leakage through windows

assignin('base','leakRoofPercent',leakRoofPercent);
assignin('base','leakWallPercent',leakWallPercent);
assignin('base','leakWinPercent',leakWinPercent);

% Roof
roofArea =  2* (widHouse/(2*cos(pitRoof))*lenHouse);

assignin('base','roofArea',roofArea);

% Room air temperature setpoint
tSetpoint = 15; % degC

assignin('base','tSetpoint',tSetpoint);

% Room air initial temperature
tRoom  = 15;     % deg C

assignin('base','tRoom',tRoom);

%Rooms
%% Room 1
areaWindowRoom1 = 3 * 1 *1;
areaWallRoom1 = (lenHouse*3/5 *htHouse+widHouse*2/3*htHouse) - areaWindowRoom1;
areaRoofRoom1 = roofArea/4;

assignin('base','areaWindowRoom1',areaWindowRoom1);
assignin('base','areaWallRoom1',areaWallRoom1);
assignin('base','areaRoofRoom1',areaRoofRoom1);


%% Room 2
areaWindowRoom2 = 2 * 1 *1;
areaWallRoom2 = (lenHouse*3/5*htHouse+widHouse/3*htHouse) - areaWindowRoom2;
areaRoofRoom2 = roofArea/4;

assignin('base','areaWindowRoom2',areaWindowRoom2);
assignin('base','areaWallRoom2',areaWallRoom2);
assignin('base','areaRoofRoom2',areaRoofRoom2);

%% Room 3
areaWindowRoom3 =2* 1 *1;
areaWallRoom3 = (lenHouse*2/5*htHouse+widHouse*2/3*htHouse) - areaWindowRoom3;
areaRoofRoom3 = roofArea/4;

assignin('base','areaWindowRoom3',areaWindowRoom3);
assignin('base','areaWallRoom3',areaWallRoom3);
assignin('base','areaRoofRoom3',areaRoofRoom3);

%% Room 4
areaWindowRoom4 = 2 * 1 *1;
areaWallRoom4 = (lenHouse*2/5*htHouse+widHouse/3*htHouse) - areaWindowRoom4;
areaRoofRoom4 = roofArea/4;

assignin('base','areaWindowRoom4',areaWindowRoom4);
assignin('base','areaWallRoom4',areaWallRoom4);
assignin('base','areaRoofRoom4',areaRoofRoom4);

%% Radiator parameters

% Radiator pipe geometry
lenRadiatorPipe = 4;      % [m]
diaRadiatorPipe = 0.0125; % [m]

assignin('base','lenRadiatorPipe',lenRadiatorPipe);
assignin('base','diaRadiatorPipe',diaRadiatorPipe);

% Exchange area with air
areaRadiator1 = 5;     % [m^2]
areaRadiator2 = 5;     % [m^2]
areaRadiator3 = 5;     % [m^2]
areaRadiator4 = 5;     % [m^2]


assignin('base','areaRadiator1',areaRadiator1);
assignin('base','areaRadiator2',areaRadiator2);
assignin('base','areaRadiator3',areaRadiator3);
assignin('base','areaRadiator4',areaRadiator4);


% Convective heat transfer coefficient radiator -> room
hRadiator1 = 100;  %  [W/(m^2 * K)]
hRadiator2 = 100;  %  [W/(m^2 * K)]
hRadiator3 = 100;  %  [W/(m^2 * K)]
hRadiator4 = 100;  %  [W/(m^2 * K)]

assignin('base','hRadiator1',hRadiator1);
assignin('base','hRadiator2',hRadiator2);
assignin('base','hRadiator3',hRadiator3);
assignin('base','hRadiator4',hRadiator4);

%% Heat pump parameters

% Condenser tube dimensions
diaCond            = 0.014;  % m
diaOuterCond       = 0.0158; % m
longPitchCond      = 0.021;  % m
transPitchCond     = 0.021;  % m
numTubeRowsCond    = 20;     % 1
numTubesPerRowCond = 10;     % 1

assignin('base','diaCond',diaCond);
assignin('base','diaOuterCond',diaOuterCond);
assignin('base','longPitchCond',longPitchCond);
assignin('base','transPitchCond',transPitchCond);
assignin('base','numTubeRowsCond',numTubeRowsCond);
assignin('base','numTubesPerRowCond',numTubesPerRowCond);

% Condenser air duct dimensions
wCondDuct   = 1.6;           % m
htCondDuct  = 0.3;           % m
lenCondDuct = 0.2;           % m

assignin('base','wCondDuct',wCondDuct);
assignin('base','htCondDuct',htCondDuct);
assignin('base','lenCondDuct',lenCondDuct);


% Evaporator tube dimensions
diaEvap            = 0.126;  % m
diaOuterEvap       = 0.1344; % m
longPitchEvap      = 0.63;   % m
transPitchEvap     = 0.378;  % m
numTubeRowsEvap    = 400;    % 1
numTubesPerRowEvap = 20;     % 1
numFinsEvap        = 90;     % 1
areaFinEvap        = 0.05;   % m^2

assignin('base','diaEvap',diaEvap);
assignin('base','diaOuterEvap',diaOuterEvap);
assignin('base','longPitchEvap',longPitchEvap);
assignin('base','transPitchEvap',transPitchEvap);
assignin('base','numTubeRowsEvap',numTubeRowsEvap);
assignin('base','numTubesPerRowEvap',numTubesPerRowEvap);
assignin('base','numFinsEvap',numFinsEvap);
assignin('base','areaFinEvap',areaFinEvap);



% Evaporator air duct dimensions
wEvapDuct   = 0.96;          % m  
htEvapDuct  = 2.5;           % m 
lenEvapDuct = 0.4;           % m

assignin('base','wEvapDuct',wEvapDuct);
assignin('base','htEvapDuct',htEvapDuct);
assignin('base','lenEvapDuct',lenEvapDuct);

% Thermostatic Expansion Valve parameters
nomQEvap         = 22;       % kW
maxQEvap         = 40;       % kW
tEvap            = -30;      % degC
tSuperheatStatic = 3;        % degC
tSuperheatNom    = 15;       % degC
tCond            = 6.85;     % degC
tSubcool         = 2;        % degC


assignin('base','nomQEvap',nomQEvap);
assignin('base','maxQEvap',maxQEvap);
assignin('base','tEvap',tEvap);
assignin('base','tSuperheatStatic',tSuperheatStatic);
assignin('base','tSuperheatNom',tSuperheatNom);
assignin('base','tCond',tCond);
assignin('base','tSubcool',tSubcool);

% Copper tubes
kTube = 400;                 % W/(m*K)

assignin('base','kTube',kTube);

%% Ground loop parameters

lenGroundPipeEach   = 45;    % m
diaGroundLoop       = 0.032; % m
lenHeaderPipe1      = 4;     % m
lenHeaderPipe2      = 8;     % m
spacingGroundPipes  = 2;     % m
qGroundLoopPump     = 18;    % lpm

assignin('base','lenGroundPipeEach',lenGroundPipeEach);
assignin('base','diaGroundLoop',diaGroundLoop);
assignin('base','lenHeaderPipe1',lenHeaderPipe1);
assignin('base','lenHeaderPipe2',lenHeaderPipe2);
assignin('base','spacingGroundPipes',spacingGroundPipes);
assignin('base','qGroundLoopPump',qGroundLoopPump);

%% Ground conditions
pGround  = 0.101325; % MPa 

assignin('base','pGround',pGround);

% Ground initial temperature
tInitGround  = 10;   % degC

assignin('base','tInitGround',tInitGround);

%% Refrigerant initial conditions
% To start the system near equilibrium
if (tSetpoint < 28)                
    pInitCond        = 3.1;        % MPa
    enthalpyInitCond = [514, 301]; % kJ/kg
else
    pInitCond        = 3.9;        % MPa
    enthalpyInitCond = [520, 314]; % kJ/kg
end

assignin('base','pInitCond',pInitCond);
assignin('base','enthalpyInitCond',enthalpyInitCond);

pInitEvap        = 0.37;           % MPa
enthalpyInitEvap = [304 439];      % kJ/kg

assignin('base','pInitEvap',pInitEvap);
assignin('base','enthalpyInitEvap',enthalpyInitEvap);

%% Heating water initial conditions
% To start the system near equilibrium
pInitHW = 0.11; % MPa
tInitHW = 50;   % degC

assignin('base','pInitHW',pInitHW);
assignin('base','tInitHW',tInitHW);