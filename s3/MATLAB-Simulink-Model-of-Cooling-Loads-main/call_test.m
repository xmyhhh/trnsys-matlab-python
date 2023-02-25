function outputArg = call_test(exp_name, cfg_name, sample_time,VALVE_SIMULATION_MODEL, action_min, action_max)
    % hyper_MODELS_PATH = strcat('python/results/' , exp_name , '/' , cfg_name , '/' );

    
    exp_name = "default";
    cfg_name = "h0";
    VALVE_SIMULATION_MODEL = "sm_Experimental_Setup_h0";
    sample_time = 3600;
    action_min = 0.01;
    action_max = 0.23;

    hyper_MODELS_PATH = strcat('./results/' , exp_name , '/' , cfg_name , '/' );
    hyper_VALVE_SIMULATION_MODEL = VALVE_SIMULATION_MODEL;
    hyper_action_min = action_min;
    hyper_action_max = action_max;
    hyper_sample_time = sample_time;
    code_Experimental_Setup;




    



    outputArg = 0;
end
