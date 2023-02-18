function outputArg = call_test(exp_name, cfg_name, max_episodes)
    hyper_MODELS_PATH = strcat(exp_name , '/' , cfg_name , '/results/');
    hyper_MAX_EPISODES = max_episodes;
    code_DDPG_Training;
    %test->img,txt
    outputArg = 0;
end
