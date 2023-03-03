
import numpy as np
import torch
from torch import nn
import torch.nn.functional as F


class MLP(nn.Module):
    def __init__(self, in_dim = 1, out_dim = 2):
        super(MLP, self).__init__()
        self.layer = nn.Sequential(
            nn.Linear(in_dim, in_dim * 4),
            nn.ReLU(),
            nn.Linear(in_dim * 4, in_dim * 8),
            nn.ReLU(),
            nn.Linear(in_dim * 8, out_dim * 4),
            nn.ReLU(),
            nn.Linear(out_dim * 4, out_dim),
        )

    def forward(self, input):
        return self.layer(input)

