function outputArg = call_train(exp_name, cfg_name, max_eps, VALVE_SIMULATION_MODEL, BATCH_SIZE, ACCEPTABLE_DELTA, action_min, action_max, criticLearningRate, actorLearningRate, agent_sample_time, SAVE_AGENT_THRESHOLD, STOP_TRAINING, maxsteps)

% 
%     exp_name = "default";
%     cfg_name = "h0";
%     VALVE_SIMULATION_MODEL = "sm_DDPG_Training_Circuit_h0";
%     BATCH_SIZE = 64;
%     ACCEPTABLE_DELTA = 0.5;
%     max_eps = 2;
%     action_min = 0.00;
%     action_max = 0.16;
%     criticLearningRate = 0.001;
%     actorLearningRate = 0.0001;
%     agent_sample_time = 1;
%     SAVE_AGENT_THRESHOLD = 100000;
%     STOP_TRAINING = 100000;
%     maxsteps = 100;

    hyper_MODELS_PATH = strcat('./results/' , exp_name , '/' , cfg_name , '/' );
    hyper_VALVE_SIMULATION_MODEL = VALVE_SIMULATION_MODEL;
    hyper_BATCH_SIZE = BATCH_SIZE;
    hyper_ACCEPTABLE_DELTA = ACCEPTABLE_DELTA;
    hyper_MAX_EPISODES = max_eps;
    hyper_action_min = action_min;
    hyper_action_max = action_max;


    hyper_criticLearningRate = criticLearningRate;
    hyper_actorLearningRate = actorLearningRate;
    hyper_agent_sample_time = agent_sample_time;
    hyper_SAVE_AGENT_THRESHOLD = SAVE_AGENT_THRESHOLD;
    hyper_STOP_TRAINING = STOP_TRAINING;
    hyper_maxsteps = maxsteps;

    code_DDPG_Training;
    outputArg = 0;
end
