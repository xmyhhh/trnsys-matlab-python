import os
import yaml
import torch
from torch import nn
from tqdm import tqdm

from data import create_dataset, create_dataloader
from data.predictor_Dataset import predictor_Dataset
from optimizer import SphericalOptimizer
from utils.util import OrderedYaml
from net import MLP
import numpy as np
from torch.optim import lr_scheduler

def evala(model, data, kernel_code, loss_fn, optimizer, device, iter_num = 1000):
    for iteration in tqdm(range(iter_num), ncols=60):
        data["x"] = data["x"].to(device)
        data["T_sf_set"] = data["T_sf_set"].to(device)
        data["PUE_set"] = data["PUE_set"].to(device)
        optimizer.zero_grad()
        '''
        # ---------------------
        # (2.1) forward
        # ---------------------
         '''

        # generate sr image
        input = torch.cat([data["x"], kernel_code],dim = 0).unsqueeze(0)
        out = model(input)
        out = out + torch.tensor([data["x"][5], data["x"][8]]).unsqueeze(0).to(device)
        '''
        # ---------------------
        # (2.2) backward
        # ---------------------
         '''

        loss = loss_fn(out, torch.tensor([data["T_sf_set"], data["PUE_set"]]).unsqueeze(0).to(device))

        loss.backward()
        optimizer.step()

        if (iteration % 10 == 0 or iteration == 1) :
            print('\n Iter {}, loss: {}'.format(iteration, loss.data))

if __name__ == '__main__':
    config_path = "config/default.yml"
    Loader, Dumper = OrderedYaml()
    with open(config_path, mode='r') as f:
        opt = yaml.load(f, Loader=Loader)

    dataset = create_dataset(opt["train"]["predictor"]["dataset"])
    # 如果显卡可用，则用显卡进行训练
    device = "cuda" if torch.cuda.is_available() else 'cpu'

    # 调用 net 里定义的模型，如果 GPU 可用则将模型转到 GPU
    predictor_model = torch.load(opt["test"]["predictor"]["pretrain_model_path"])

    predictor_model.eval()
    for p in predictor_model.parameters(): p.requires_grad = False
    kernel_code = torch.zeros(2).to(device)
    kernel_code.requires_grad = True

    optimizer = torch.optim.Adam([{'params': kernel_code}], lr=0.001)

    # 定义损失函数
    loss_fn = nn.MSELoss(reduction='mean')

    for t in tqdm(range(opt["test"]["test_step"])):
        print(f"Step {t + 1}\n----------------------")
        #给定设定值、当前时刻的扰动、当前时刻的pue和送风温度
        data = dataset.getitem(20000)
        data["T_sf_set"] = torch.tensor(20)
        data["PUE_set"] = torch.tensor(1.112)

        evala(predictor_model, data, kernel_code, loss_fn, optimizer, device)




    print("Done!")
