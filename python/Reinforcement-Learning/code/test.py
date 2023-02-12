import os

from simulink.HeatPump import HeatPump

heatPumpSimModel = HeatPump(os.getcwd() + "/../../../matlab")

heatPumpSimModel.Reset()
state = heatPumpSimModel.Init()
print(state)
state = heatPumpSimModel.Step(0)
print(state)
state = heatPumpSimModel.Step(0)
print(state)
state = heatPumpSimModel.Step(0)
print(state)
pass


# [3.52968280e+03 3.95000970e+01 2.95739179e+02 1.50735488e+02
#  1.04405869e+01 6.57221334e+02 4.10934888e+02 3.59650032e-02
#  9.14505590e+01]