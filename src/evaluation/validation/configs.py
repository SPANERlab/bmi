from enum import Enum


class VAR_NAMES(Enum):
    CSPBLDA = ["pi", "mu_0", "mu_1", "sigma"]
    CSPGP = ["ell", "eta", "f"]
    TSBLR = ["w", "b"]
    TSGP = ["eta", "f"]
    BSCNN = ["w", "b"]
    BDCNN = ["w", "b"]


class COORDS(Enum):
    CSPBLDA = {"mu_0_dim_0": [0], "mu_1_dim_0": [0], "sigma_dim_0": [0]}
    CSPGP = {"f_dim_0": [0]}
    TSBLR = {"w_dim_0": [0]}
    TSGP = {"f_dim_0": [0]}
    BSCNN = {"w_dim_0": [0]}
    BDCNN = {"w_dim_0": [0]}


class GRID(Enum):
    CSPBLDA = (2, 2)
    CSPGP = (2, 2)
    TSBLR = (1, 2)
    TSGP = (1, 2)
    BSCNN = (1, 2)
    BDCNN = (1, 2)
