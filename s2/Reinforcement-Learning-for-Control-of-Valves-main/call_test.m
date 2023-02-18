function outputArg = call_test(exp_name, cfg_name, VALVE_SIMULATION_MODEL, action_min, action_max)
    %hyper_MODELS_PATH = strcat('python/results/' , exp_name , '/' , cfg_name , '/' );
    hyper_MODELS_PATH = strcat('./results/' , exp_name , '/' , cfg_name , '/' );
    hyper_VALVE_SIMULATION_MODEL = VALVE_SIMULATION_MODEL;
    hyper_action_min = action_min;
    hyper_action_max = action_max;

    code_Experimental_Setup;

    outputArg = 0;
end
