import torch.utils.data as data
import pandas
import torch
import torch.utils.data as data
import numpy as np

class predictor_Dataset(data.Dataset):
    def __init__(self, opt):
        super(predictor_Dataset, self).__init__()
        self.opt = opt
        self.excel_data = pandas.read_excel(opt["path"])


    def __len__(self):
        return len(self.excel_data) - 2

    def __getitem__(self, item):
        X = self.excel_data.loc[[item]]
        Y = self.excel_data.loc[[item + 1]]

        T_Wet_X = np.float32(X["T_Wet"])
        T_tower_out_X = np.float32(X["T_tower_out"])
        T_ch_X = np.float32(X["T_ch"])
        T_To_tower_X = np.float32(X["T_To_tower"])
        T_ch_r_X = np.float32(X["T_ch_r"])
        T_sf_X = np.float32(X["T_sf"])
        Td_X = np.float32(X["Td"])
        Q_IT_X = np.float32(X["Q_IT"])
        PUE_X = np.float32(X["PUE"])
        wind_r_X = np.float32(X["wind_r"])
        ch_control_X = np.float32(X["ch_control"])
        tower_control_X = np.float32(X["tower_control"])

        T_sf_Y = np.float32(Y["T_sf"])
        PUE_Y = np.float32(Y["PUE"])

        X_tensor = torch.tensor(np.array(
            [T_Wet_X, T_tower_out_X,
             T_ch_X, T_To_tower_X,
             T_ch_r_X, T_sf_X, Td_X,
             Q_IT_X, PUE_X, wind_r_X,
             ch_control_X, tower_control_X
             ])).squeeze()
        Y_current = torch.tensor(np.array([
            T_sf_X,
            PUE_X
        ])).squeeze()

        Y_tensor = torch.tensor(np.array([
            T_sf_Y,
            PUE_Y
        ])).squeeze()

        return {'x': X_tensor, 'y': Y_tensor, 'y_current': Y_current}
