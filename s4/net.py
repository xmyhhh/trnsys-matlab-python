
import numpy as np
import torch
from torch import nn
import torch.nn.functional as F


class MLP(nn.Module):
    def __init__(self, in_dim = 1, out_dim = 2):
        super(MLP, self).__init__()
        self.layer = nn.Sequential(

            nn.Linear(in_dim, in_dim * 32),

            nn.BatchNorm1d(in_dim * 32),
            nn.ReLU(),

            nn.Linear(in_dim * 32, out_dim),
            nn.Tanh()
        )

    def forward(self, input):

        return self.layer(input)

