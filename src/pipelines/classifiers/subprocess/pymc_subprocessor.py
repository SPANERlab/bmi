import joblib
import numpy as np
from os import path
from arviz import InferenceData
from .subprocessor_base import SubprocessorBase


class PyMCSubprocessor(SubprocessorBase):
    def save_fitted_state(self):
        if hasattr(self.estimator, "scaler"):
            joblib.dump(self.estimator.scaler, path.join(self.save_dir, "scaler.pkl"))
        if hasattr(self.estimator, "network"):
            np.save(
                path.join(self.save_dir, "network_save_dir.npy"),
                np.array([self.estimator.network.save_dir])
            )
        np.save(path.join(self.save_dir, "X.npy"), self.estimator.X)
        np.save(path.join(self.save_dir, "y.npy"), self.estimator.y)
        self.estimator.idata.to_netcdf(path.join(self.save_dir, "idata.nc"))

    def load_fitted_state(self):
        if hasattr(self.estimator, "scaler"):
            self.estimator.scaler = joblib.load(path.join(self.save_dir, "scaler.pkl"))
        if hasattr(self.estimator, "network"):
            self.estimator.network.save_dir = np.load(path.join(self.save_dir, "network_save_dir.npy"))[0]
        X = np.load(path.join(self.save_dir, "X.npy"))
        y = np.load(path.join(self.save_dir, "y.npy"))
        self.estimator.build_model(X, y)
        self.estimator.idata = InferenceData.from_netcdf(path.join(self.save_dir, "idata.nc"))
        self.estimator.classes_ = self.classes_
