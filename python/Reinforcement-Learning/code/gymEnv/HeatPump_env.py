import math
import os
from typing import Optional

import gym
import numpy as np
from gym import spaces
from gym.utils import seeding

from simulink.HeatPump import HeatPump


class HeatPump_env(gym.Env):

    def __init__(self):
        self.episode_steps = 0
        self.heatPumpModel = HeatPump(os.getcwd() + "/../../../matlab")
        # 1940.47559,35.00086,259.99402,54.20593,8.00061,584.63422,410.00662,0.04032,188.64571
        self.episode_steps_max = 0
        self.low = np.array([0, 0], dtype=np.float32)
        self.one = np.array([1, 1], dtype=np.float32)
        self.high = np.array([130, 45], dtype=np.float32)

        self.action_space = spaces.Box(
            low=-1, high=1, shape=(1,), dtype=np.float32
        )
        self.observation_space = spaces.Box(self.low, self.one, dtype=np.float32)
        self.success_step = 0
        self.success_step_ter = 10

    def reset(self):
        # print("call reset")
        self.episode_steps = 0
        self.success_step = 0
        self.state = self.heatPumpModel.Init() / self.high
        return self.state

    def step(self, action: np.ndarray):
        self.episode_steps += 1
        self.state = self.heatPumpModel.Step(action) / self.high
        reward = 0
        done = False

        # version 0
        # reward = (100 - pow(40 - self.state[1], 2)) * (self.episode_steps_max - self.episode_steps + 10)

        # version 1
        # reward = -1
        # print("action is {}".format(action.item()))
        # done = False
        # if (abs(self.state[1] - 40) < 0.5):
        #     self.success_step += 1
        #     if (self.success_step >= self.success_step_ter):
        #         done = True
        #         reward += 1000 - 200 * abs(self.state[1] - 40)
        #         print("success")
        # else:
        #     self.success_step = 0
        #
        # if (self.episode_steps > self.episode_steps_max):
        #     done = True
        #     reward -= 1000 * abs(self.state[1] - 40)
        #     self.success_step = 0

        # version 2
        reward = -abs(self.state[1] - 40)
        if (self.episode_steps >= self.episode_steps_max):
            done = True


        return self.state, reward, bool(done), {}
