function outputArg = call_train(exp_name, cfg_name, VALVE_SIMULATION_MODEL)

    hyper_MODELS_PATH = strcat('./results/' , exp_name , '/' , cfg_name , '/' );
    hyper_VALVE_SIMULATION_MODEL = VALVE_SIMULATION_MODEL
    code_DDPG_Training;
    outputArg = 0;
end
