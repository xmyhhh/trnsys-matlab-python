import argparse
import os.path
import random
import time
import os.path as osp
from copy import deepcopy
import gym
from stable_baselines3 import A2C, PPO, DDPG
from stable_baselines3.common.env_checker import check_env
from stable_baselines3.common.evaluation import evaluate_policy
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
    parser.add_argument('--exp_name', default='default', type=str, help='exp name')
    parser.add_argument('--output', default='output', type=str, help='')
    args = parser.parse_args()

    # Step 1: Init logger and dir
    start = time.time()
    experiments_root = osp.join(osp.abspath(osp.join(__file__, osp.pardir)), '../experiments',
                                args.exp_name)

    model = PPO.load(experiments_root + '/models/ppo')
    env = HeatPump_env()

    obs = env.reset()
    for i in range(1000):
        action, _state = model.predict(obs, deterministic=True)
        obs, reward, done, info = env.step(action)
        print("obs: {}, action:{}, reward: {}".format(obs * env.high, action, reward))
