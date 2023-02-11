function outputArg = pythonInterface(inputArg, callType)
   %addpath("pythonInterface/")
   %addpath("simulinkModel/")

   switch callType
    case 'init'   %call init
        %disp('call matlab init')
        outputArg = HeatPump_Init(inputArg);
    case 'step'   %call step
        %disp('call matlab step')
        outputArg = HeatPump_Step(inputArg);
    case 'reset'   %call reset
        %disp('call matlab reset')
        clc;
        clear all;
        outputArg = 0;
    otherwise
        outputArg = 0;
    end

end

