function outputArg = call_train(exp_name, cfg_name, max_episodes)
    hyper_MODELS_PATH = strcat('python/results/' , exp_name , '/' , cfg_name );
    hyper_MAX_EPISODES = max_episodes;
    code_DDPG_Training;
    %test->img,txt
    outputArg = 0;
end
