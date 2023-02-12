import os
from typing import Optional

import gym
import numpy as np
from gym import spaces


from simulink.HeatPump import HeatPump


class HeatPump_env(gym.Env):

    def __init__(self):
        super().__init__()
        self.episode_steps = 0
        self.heatPumpModel  = HeatPump(os.getcwd() + "/../../../matlab")

        self.low = np.array([0, 0, 0, 0, 0, 0, 0, 0, 0], dtype=np.float32)
        self.high = np.array([10, 1, 1, 1, 1, 1, 1, 1, 1], dtype=np.float32) * 1000

        self.action_space = spaces.Box(
            low=-1, high=1, shape=(1,), dtype=np.float32
        )
        self.observation_space = spaces.Box(self.low, self.high, dtype=np.float32)

    def reset(self):
        print("call reset")
        self.episode_steps = 0
        self.heatPumpModel.Reset()
        self.state = self.heatPumpModel.Init()
        return self.state

    def step(self, action: np.ndarray):
        self.episode_steps += 1
        state = self.heatPumpModel.Step(action)
        reward = -abs(40 - state[1]) + 10.0
        done = False
        if(self.episode_steps>60):
            done = True
        return self.state, reward, bool(done), {}


