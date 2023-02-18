function outputArg = call_train(exp_name, cfg_name, max_eps, VALVE_SIMULATION_MODEL, BATCH_SIZE, ACCEPTABLE_DELTA)

    hyper_MODELS_PATH = strcat('./results/' , exp_name , '/' , cfg_name , '/' );
    hyper_VALVE_SIMULATION_MODEL = VALVE_SIMULATION_MODEL;
    hyper_BATCH_SIZE = BATCH_SIZE;
    hyper_ACCEPTABLE_DELTA = ACCEPTABLE_DELTA;
    hyper_MAX_EPISODES = max_eps;

    code_DDPG_Training;
    outputArg = 0;
end
