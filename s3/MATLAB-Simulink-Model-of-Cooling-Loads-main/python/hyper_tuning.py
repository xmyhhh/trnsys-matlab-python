import os

import yaml
from concurrent.futures import ThreadPoolExecutor, as_completed
from threading import Lock
from collections import OrderedDict

try:
    from yaml import CLoader as Loader, CDumper as Dumper
except ImportError:
    from yaml import Loader, Dumper
import matlab.engine


def OrderedYaml():
    '''yaml orderedDict support'''
    _mapping_tag = yaml.resolver.BaseResolver.DEFAULT_MAPPING_TAG

    def dict_representer(dumper, data):
        return dumper.represent_dict(data.items())

    def dict_constructor(loader, node):
        return OrderedDict(loader.construct_pairs(node))

    Dumper.add_representer(OrderedDict, dict_representer)
    Loader.add_constructor(_mapping_tag, dict_constructor)
    return Loader, Dumper


def start_train(cfg, exp_name, cfg_name, hyper):
    # try:
    MATLAB_eng = matlab.engine.start_matlab()

    MATLAB_eng.addpath(MATLAB_eng.genpath(MATLAB_eng.fullfile("../")))
    if (cfg["task_type"]["train"]):
        MATLAB_eng.call_train(exp_name, cfg_name, hyper['max_eps'], hyper['VALVE_SIMULATION_MODEL_Train'],
                              hyper['batch'],
                              hyper['ACCEPTABLE_DELTA'], hyper['action_range'][0], hyper['action_range'][1],
                              hyper['criticLearningRate'],
                              hyper['actorLearningRate'], hyper['agent_sample_time'], hyper['SAVE_AGENT_THRESHOLD'],
                              hyper['STOP_TRAINING'], hyper['maxsteps'])
    if (cfg["task_type"]["test"]):
        MATLAB_eng.call_test(exp_name, cfg_name, cfg["task_type"]["test_sample_time"],
                             hyper['VALVE_SIMULATION_MODEL_Test'], hyper['action_range'][0], hyper['action_range'][1])
    # except:
    #     print("task error in", cfg)

    return hyper


def create_all_dirs(path):
    if "." in path.split("/")[-1]:
        dirs = os.path.dirname(path)
    else:
        dirs = path
    os.makedirs(dirs, exist_ok=True)


if __name__ == '__main__':
    config_path = "./hyper_config/default.yml"
    Loader, Dumper = OrderedYaml()
    with open(config_path, mode='r') as f:
        opt = yaml.load(f, Loader=Loader)
    executor = ThreadPoolExecutor(max_workers=opt["max_matlab_start"])
    #     # add task to ThreadPool
    all_task = []

    for hyper in opt["Hyper_array"]:
        print("+Task: Hyper_array " + hyper)
        task_save_path = os.path.join('results', opt["name"], hyper)
        create_all_dirs(task_save_path)
        all_task.append(
            executor.submit(lambda p: start_train(*p), [opt, opt["name"], hyper, opt["Hyper_array"][hyper]]))

    for future in as_completed(all_task):
        cfg = future.result()
        print(cfg)
