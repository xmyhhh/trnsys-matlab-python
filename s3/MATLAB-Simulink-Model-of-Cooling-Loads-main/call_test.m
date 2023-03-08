function outputArg = call_test(exp_name, cfg_name, sample_time,VALVE_SIMULATION_MODEL, action_min, action_max)


    
%     exp_name = "default";
%     cfg_name = "h0";
%     VALVE_SIMULATION_MODEL = "sm_Experimental_Setup_h0";
%     sample_time = 3600;
%     action_min = 0.01;
%     action_max = 0.23;


%     agent_sample_time = 1;
%     SAVE_AGENT_THRESHOLD = 100000;
%     STOP_TRAINING = 100000;
%     maxsteps = 100;

    hyper_MODELS_PATH = strcat('./results/' , exp_name , '/' , cfg_name , '/' );
    hyper_VALVE_SIMULATION_MODEL = VALVE_SIMULATION_MODEL;
    hyper_action_min = action_min;
    hyper_action_max = action_max;
    hyper_sample_time = sample_time;

    code_Experimental_Setup;

    outputArg = 0;
end
