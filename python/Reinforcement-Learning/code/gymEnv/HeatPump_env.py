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

        self.low = np.array([0, 0, 0, 0, 0, 0, 0, 0, 0], dtype=np.float32)
        self.one = np.array([1, 1, 1, 1, 1, 1, 1, 1, 1], dtype=np.float32)
        self.high = np.array([10000, 80, 500, 150, 50, 1000, 1000, 1, 500], dtype=np.float32)

        self.action_space = spaces.Box(
            low=-1, high=1, shape=(1,), dtype=np.float32
        )
        self.observation_space = spaces.Box(self.low, self.one, dtype=np.float32)

    def reset(self):
        print("call reset")
        self.episode_steps = 0

        self.state = self.heatPumpModel.Init() / self.high
        return self.state

    def step(self, action: np.ndarray):
        self.episode_steps += 1
        self.state = self.heatPumpModel.Step(action) / self.high
        #reward = -abs(40 - self.state[1]) + 10.0

        reward = -abs(action - 0.5).item()
        print("action is {}".format(action.item()))
        done = False
        if (self.episode_steps > 5):
            done = True
        return self.state, reward, bool(done), {}
