import  matlab.engine
import numpy as np


class SimulinkModelBase:


    def __init__(self, path):
        self.MATLAB_eng = matlab.engine.start_matlab()
        self.MATLAB_eng.addpath(self.MATLAB_eng.genpath(self.MATLAB_eng.fullfile(path)))
        pass
    def Init(self):
        pass

    def Reset(self):
        pass

    def Step(self, action):
        pass

    def MATLAB_return_to_ndarray(self, value):
        return np.array(value, dtype=np.float64).squeeze()