from simulink.SimulinkModelBase import SimulinkModelBase


class HeatPump(SimulinkModelBase):
    def __init__(self, path):
        super(HeatPump, self).__init__(path)

    def Init(self):
        res = self.MATLAB_eng.pythonInterface(0, 'init')
        return self.MATLAB_return_to_ndarray(res)

    def Reset(self):
        res = self.MATLAB_eng.pythonInterface(0, 'reset')
        return self.MATLAB_return_to_ndarray(res)

    def Step(self, action):
        res =  self.MATLAB_eng.pythonInterface(action, 'step')
        return self.MATLAB_return_to_ndarray(res)
