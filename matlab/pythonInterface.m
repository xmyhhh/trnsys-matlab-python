function outputArg = pythonInterface(inputArg, callType)
   %addpath("pythonInterface/")
   %addpath("simulinkModel/")

   switch callType
    case 'init'   %call init
        outputArg = 0;
        outputArg = HeatPump_Init(inputArg);
    case 'step'   %call step
        outputArg = HeatPump_Step(inputArg);
    case 'reset'   %call reset
        clc;
        clear all;
        outputArg = 0;
    otherwise
        outputArg = 0;
    end

end

