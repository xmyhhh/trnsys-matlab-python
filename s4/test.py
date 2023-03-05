import os
import yaml
import torch
from torch import nn
from tqdm import tqdm
import matplotlib.pyplot as plt
from data import create_dataset, create_dataloader
from data.predictor_Dataset import predictor_Dataset
from optimizer import SphericalOptimizer
from utils.util import OrderedYaml
from net import MLP
import numpy as np
import matplotlib as mpl

from torch.optim import lr_scheduler


def evala(model, data, kernel_code, loss_fn, optimizer, device, iter_num=1000):
    out = None
    for iteration in range(iter_num):
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
        input = torch.cat([data["x"], torch.sigmoid(kernel_code)], dim=0).unsqueeze(0)
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

    return out


if __name__ == '__main__':
    mpl.use('TkAgg')  # !IMPORTANT
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
    kernel_code = torch.ones(2).to(device) * 0.5
    kernel_code.requires_grad = True

    optimizer = torch.optim.Adam([{'params': kernel_code}], lr=0.0001)

    # 定义损失函数
    loss_fn = nn.MSELoss(reduction='mean')
    start = 20000
    y_lable = []
    res_Tsf = []
    res_PUE = []
    res_kernel = []
    for t in tqdm(range(opt["test"]["test_step"])):
        y_lable.append(t)
        print(f"Step {t + 1}\n----------------------")
        # 给定设定值、当前时刻的扰动、当前时刻的pue和送风温度
        data = dataset.getitem(start + t)
        data["T_sf_set"] = torch.tensor(20)
        data["PUE_set"] = torch.tensor(1.08)
        if (t > 20):
            data["T_sf_set"] = torch.tensor(18)
        final = evala(predictor_model, data, kernel_code, loss_fn, optimizer, device,
                      iter_num=opt["test"]["controller"]["max_step"])
        pass
        res_Tsf.append(final.squeeze(0)[0].cpu().detach().numpy())
        res_PUE.append(final.squeeze(0)[1].cpu().detach().numpy())
        res_kernel.append(torch.sigmoid(kernel_code).cpu().detach().numpy())

    # plot
    res_Tsf_np = np.array(res_Tsf)
    res_PUE_np = np.array(res_PUE)
    y_lable_np = np.array(y_lable)
    res_kernel_np = np.array(res_kernel)

    import matplotlib.pyplot as plt

    fig = plt.figure()
    plt.plot(y_lable, res_Tsf)

    plt.savefig("Figure_sf.png")
    fig = plt.figure()
    plt.plot(y_lable, res_kernel_np[:, 0])

    plt.savefig("kernel_0.png")
    fig = plt.figure()
    plt.plot(y_lable, res_kernel_np[:, 1])

    plt.savefig("kernel_1.png")
    print("Done!")
