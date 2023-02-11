import os

from simulink.HeatPump import HeatPump

heatPumpSimModel = HeatPump(os.getcwd() + "/../../../matlab")

heatPumpSimModel.Reset()
state = heatPumpSimModel.Init()
print(state)
state = heatPumpSimModel.Step(30)
print(state)
state = heatPumpSimModel.Step(30)
print(state)
state = heatPumpSimModel.Step(30)
print(state)
pass