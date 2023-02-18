function outputArg = pythonInterface(inputArg, callType)
   %addpath("pythonInterface/")
   %addpath("simulinkModel/")

   switch callType
    case 'init'   %call init
        outputArg = HeatPump_Init(inputArg);
    case 'step'   %call step
        outputArg = HeatPump_Step(inputArg);
    otherwise
        outputArg = 0;
    end

end

