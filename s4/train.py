import os
import yaml
import torch
from torch import nn
from tqdm import tqdm

from data import create_dataset, create_dataloader
from data.predictor_Dataset import predictor_Dataset
from utils.util import OrderedYaml
from net import MLP
import numpy as np
from torch.optim import lr_scheduler


def train(model, dataloader, loss_fn, optimizer, device):
    model.train()
    total_loss = 0
    index = 0
    for _, train_data in enumerate(dataloader):
        index += 1
        x = train_data["x"].to(device)
        y = train_data["y"].to(device)
        y_current = train_data["y_current"].to(device)

        out = model(x)
        Y_pred = out * torch.tensor([1.5, 0.1]).to(device) + y_current

        loss = loss_fn(Y_pred, y)
        total_loss += loss
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()

    print('Aver Loss: %.3f ' % (total_loss / index) )


if __name__ == '__main__':
    config_path = "config/default.yml"
    Loader, Dumper = OrderedYaml()
    with open(config_path, mode='r') as f:
        opt = yaml.load(f, Loader=Loader)

    dataset = create_dataset(opt["train"]["predictor"]["dataset"])
    dataloader = create_dataloader(dataset, opt["train"]["predictor"]["dataset"])

    # 如果显卡可用，则用显卡进行训练
    device = "cuda" if torch.cuda.is_available() else 'cpu'

    # 调用 net 里定义的模型，如果 GPU 可用则将模型转到 GPU
    model = MLP(in_dim=12, out_dim=2).to(device)
    # 定义损失函数
    loss_fn = nn.MSELoss(reduction='mean')
    # 定义优化器（SGD：随机梯度下降）
    optimizer = torch.optim.Adam(model.parameters(), lr=0.001)
    # 学习率每隔 10 个 epoch 变为原来的 0.1
    lr_scheduler = lr_scheduler.StepLR(optimizer, step_size=10, gamma=0.9)
    for t in tqdm(range(opt["train"]["predictor"]["max_epoch"])):
        lr_scheduler.step()
        print(f"Epoch {t + 1}\n----------------------")
        train(model, dataloader, loss_fn, optimizer, device)
        # test(test_dataloader, model, loss_fn)

    torch.save(model, 'save.pt')

    print("Done!")
