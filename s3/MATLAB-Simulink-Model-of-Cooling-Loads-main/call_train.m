function outputArg = call_train(exp_name, cfg_name, max_eps, VALVE_SIMULATION_MODEL, BATCH_SIZE, ACCEPTABLE_DELTA, action_min, action_max)

% 
%     exp_name = "default";
%     cfg_name = "h0";
%     VALVE_SIMULATION_MODEL = "sm_DDPG_Training_Circuit_h0";
%     BATCH_SIZE = 64;
%     ACCEPTABLE_DELTA = 0.5;
%     max_eps = 2;
%     action_min = 0.00;
%     action_max = 0.16;


    hyper_MODELS_PATH = strcat('./results/' , exp_name , '/' , cfg_name , '/' );
    hyper_VALVE_SIMULATION_MODEL = VALVE_SIMULATION_MODEL;
    hyper_BATCH_SIZE = BATCH_SIZE;
    hyper_ACCEPTABLE_DELTA = ACCEPTABLE_DELTA;
    hyper_MAX_EPISODES = max_eps;
    hyper_action_min = action_min;
    hyper_action_max = action_max;




    code_DDPG_Training;
    outputArg = 0;
end
