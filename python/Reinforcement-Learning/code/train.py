import argparse
import os.path
import random
import time
import os.path as osp
from copy import deepcopy
import gym
from stable_baselines3 import A2C, DDPG
from stable_baselines3.common.env_checker import check_env
from stable_baselines3.common.evaluation import evaluate_policy
from stable_baselines3.common.vec_env import SubprocVecEnv
from torch.utils.tensorboard import SummaryWriter
import matlab.engine
import logging
import numpy as np
import torch
from tqdm import tqdm

from gymEnv.HeatPump_env import HeatPump_env
from simulink.HeatPump import HeatPump
from tools.file import create_all_dirs
from util import get_output_folder, setup_logger

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='PyTorch on TORCS with Multi-modal')

    parser.add_argument('--mode', default='train', type=str, help='support option: train/test')
    parser.add_argument('--exp_name', default='default', type=str, help='exp name')
    parser.add_argument('--hidden1', default=400, type=int, help='hidden num of first fully connect layer')
    parser.add_argument('--hidden2', default=300, type=int, help='hidden num of second fully connect layer')
    parser.add_argument('--rate', default=0.001, type=float, help='learning rate')
    parser.add_argument('--prate', default=0.0001, type=float, help='policy net learning rate (only for DDPG)')
    parser.add_argument('--warmup', default=1, type=int,
                        help='time without training but only filling the replay memory')
    parser.add_argument('--discount', default=0.99, type=float, help='')

    parser.add_argument('--bsize', default=3000, type=int, help='minibatch size')
    parser.add_argument('--rmsize', default=6000000, type=int, help='memory size')
    parser.add_argument('--window_length', default=1, type=int, help='')
    parser.add_argument('--tau', default=0.001, type=float, help='moving average for target network')
    parser.add_argument('--ou_theta', default=0.15, type=float, help='noise theta')
    parser.add_argument('--ou_sigma', default=0.2, type=float, help='noise sigma')
    parser.add_argument('--ou_mu', default=0.0, type=float, help='noise mu')
    parser.add_argument('--validate_episodes', default=20, type=int,
                        help='how many episode to perform during validate experiment')
    parser.add_argument('--max_episode_length', default=500, type=int, help='')
    parser.add_argument('--validate_steps', default=2000, type=int,
                        help='how many steps to perform a validate experiment')
    parser.add_argument('--output', default='output', type=str, help='')
    parser.add_argument('--debug', dest='debug', action='store_true')
    parser.add_argument('--init_w', default=0.003, type=float, help='')

    parser.add_argument('--max_episode_steps', default=60, type=int, help='linear decay of exploration policy')
    parser.add_argument('--epsilon', default=50000, type=int, help='linear decay of exploration policy')
    parser.add_argument('--seed', default=-1, type=int, help='')
    parser.add_argument('--resume', default='default', type=str, help='Resuming model path for testing')
    # parser.add_argument('--l2norm', default=0.01, type=float, help='l2 weight decay') # TODO
    # parser.add_argument('--cuda', dest='cuda', action='store_true') # TODO
    args = parser.parse_args()

    # Step 1: Init logger and dir
    start = time.time()
    experiments_root = osp.join(osp.abspath(osp.join(__file__, osp.pardir)), '../experiments',
                                args.exp_name)
    create_all_dirs(experiments_root)
    setup_logger('base', experiments_root, 'train_{}_'.format(start) + args.exp_name, level=logging.INFO,
                 screen=False, tofile=True)
    logger = logging.getLogger('base')
    logger.info('exp {} start!'.format(start, args.exp_name))
    logger.info('config: {}'.format(args))


    def make_env():
        return HeatPump_env()


    # Step 2: Init simulink model and Rl model
    def PPO_test():
        # 检查环境是否合法
        # check_env(env, warn=True)
        # logger.info('init HeatPump simulink model xand RL env from stable_baselines3.common.env_checker import check_env!'.format(start, args.exp_name))

        from stable_baselines3 import PPO
        from stable_baselines3.common.env_util import make_vec_env
        # 包装环境
        train_env = make_vec_env(make_env, n_envs=1, vec_env_cls=SubprocVecEnv)
        env = HeatPump_env()
        # 定义模型
        print("model init")
        model = PPO('MlpPolicy', train_env, verbose=0)

        print("start evl")
        print(evaluate_policy(model, env, n_eval_episodes=1))

        model.learn(total_timesteps=5000, progress_bar=True)

        print("start evl 2")
        print(evaluate_policy(model, env, n_eval_episodes=1))

        # 保存模型
        model.save(experiments_root + '/models/ppo')


    def DDPG_test():
        env = HeatPump_env()
        # 检查环境是否合法
        # check_env(env, warn=True)
        # logger.info('init HeatPump simulink model xand RL env from stable_baselines3.common.env_checker import check_env!'.format(start, args.exp_name))

        from stable_baselines3 import PPO
        from stable_baselines3.common.env_util import make_vec_env
        # 包装环境
        train_env = make_vec_env(lambda: env, n_envs=1)

        # 定义模型
        print("model init")
        model = DDPG('MlpPolicy', train_env, verbose=0)
        print("start evl")
        print(evaluate_policy(model, env, n_eval_episodes=1))
        print("end evl")
        model.learn(total_timesteps=10000, progress_bar=True)
        print("start evl 2")
        print(evaluate_policy(model, env, n_eval_episodes=1))
        # 保存模型
        model.save(experiments_root + '/models/ddpg')


    PPO_test()
