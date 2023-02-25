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


% Roof
pitRoof       = 40/180/pi;   % Roof pitch (40 deg)
thkRoof       = 0.2;         % Roof thickness [m]
roofDensity   = 32;          % Roof density (Glass fiber) [kg/m^3]
cRoof         = 835;         % Specific heat [J/kg/K]
kRoof         = 0.038;       % Thermal conductivity [W/m/K]

% Convective heat transfer coefficients [W/M^2/K]
hAirWall      = 24;   % Indoor air->walls
hWallAtm      = 34;   % Walls -> atmosphere
hAirWindow    = 25;   % Indoor air -> windows
hWindowAtm    = 32;   % Windows -> atmosphere
hAirRoof      = 12;   % Indoor air -> roof
hRoofAtm      = 38;   % Roof -> atmosphere

%Air
cAir  = 1005.4;       % cp of air at 273 K [J/(kg*K)]

% Leakage fraction
leakRoofPercent   = 0.1;   % Leakage through roof 
leakWallPercent   = 0.15;  % Leakage through walls
leakWinPercent    = 0.2;   % Leakage through windows

% Roof
roofArea =  2* (widHouse/(2*cos(pitRoof))*lenHouse);

% Room air temperature setpoint
tSetpoint = 23; % degC

% Room air initial temperature
tRoom  = 5;     % deg C

%Rooms
%% Room 1
areaWindowRoom1 = 3 * 1 *1;
areaWallRoom1 = (lenHouse*3/5 *htHouse+widHouse*2/3*htHouse) - areaWindowRoom1;
areaRoofRoom1 = roofArea/4;

%% Room 2
areaWindowRoom2 = 2 * 1 *1;
areaWallRoom2 = (lenHouse*3/5*htHouse+widHouse/3*htHouse) - areaWindowRoom2;
areaRoofRoom2 = roofArea/4;

%% Room 3
areaWindowRoom3 =2* 1 *1;
areaWallRoom3 = (lenHouse*2/5*htHouse+widHouse*2/3*htHouse) - areaWindowRoom3;
areaRoofRoom3 = roofArea/4;

%% Room 4
areaWindowRoom4 = 2 * 1 *1;
areaWallRoom4 = (lenHouse*2/5*htHouse+widHouse/3*htHouse) - areaWindowRoom4;
areaRoofRoom4 = roofArea/4;

%% Radiator parameters

% Radiator pipe geometry
lenRadiatorPipe = 4;      % [m]
diaRadiatorPipe = 0.0125; % [m]

% Exchange area with air
areaRadiator1 = 5;     % [m^2]
areaRadiator2 = 5;     % [m^2]
areaRadiator3 = 5;     % [m^2]
areaRadiator4 = 5;     % [m^2]

% Convective heat transfer coefficient radiator -> room
hRadiator1 = 100;  %  [W/(m^2 * K)]
hRadiator2 = 100;  %  [W/(m^2 * K)]
hRadiator3 = 100;  %  [W/(m^2 * K)]
hRadiator4 = 100;  %  [W/(m^2 * K)]

%% Heat pump parameters

% Condenser tube dimensions
diaCond            = 0.014;  % m
diaOuterCond       = 0.0158; % m
longPitchCond      = 0.021;  % m
transPitchCond     = 0.021;  % m
numTubeRowsCond    = 20;     % 1
numTubesPerRowCond = 10;     % 1

% Condenser air duct dimensions
wCondDuct   = 1.6;           % m
htCondDuct  = 0.3;           % m
lenCondDuct = 0.2;           % m

% Evaporator tube dimensions
diaEvap            = 0.126;  % m
diaOuterEvap       = 0.1344; % m
longPitchEvap      = 0.63;   % m
transPitchEvap     = 0.378;  % m
numTubeRowsEvap    = 400;    % 1
numTubesPerRowEvap = 20;     % 1
numFinsEvap        = 90;     % 1
areaFinEvap        = 0.05;   % m^2

% Evaporator air duct dimensions
wEvapDuct   = 0.96;          % m  
htEvapDuct  = 2.5;           % m 
lenEvapDuct = 0.4;           % m

% Thermostatic Expansion Valve parameters
nomQEvap         = 22;       % kW
maxQEvap         = 40;       % kW
tEvap            = -30;      % degC
tSuperheatStatic = 3;        % degC
tSuperheatNom    = 15;       % degC
tCond            = 6.85;     % degC
tSubcool         = 2;        % degC

% Copper tubes
kTube = 400;                 % W/(m*K)

%% Ground loop parameters

lenGroundPipeEach   = 45;    % m
diaGroundLoop       = 0.032; % m
lenHeaderPipe1      = 4;     % m
lenHeaderPipe2      = 8;     % m
spacingGroundPipes  = 2;     % m
qGroundLoopPump     = 18;    % lpm

%% Ground conditions
pGround  = 0.101325; % MPa 

% Ground initial temperature
tInitGround  = 10;   % degC

%% Refrigerant initial conditions
% To start the system near equilibrium
if (tSetpoint < 28)                
    pInitCond        = 3.1;        % MPa
    enthalpyInitCond = [514, 301]; % kJ/kg
else
    pInitCond        = 3.9;        % MPa
    enthalpyInitCond = [520, 314]; % kJ/kg
end
pInitEvap        = 0.37;           % MPa
enthalpyInitEvap = [304 439];      % kJ/kg

%% Heating water initial conditions
% To start the system near equilibrium
pInitHW = 0.11; % MPa
tInitHW = 50;   % degC