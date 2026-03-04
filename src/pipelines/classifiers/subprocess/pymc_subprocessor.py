import joblib
import numpy as np
from os import path
from arviz import InferenceData
from .subprocessor_base import SubprocessorBase


class PyMCSubprocessor(SubprocessorBase):
    def save_fitted_state(self):
        if hasattr(self.estimator, "scaler"):
            joblib.dump(self.estimator.scaler, path.join(self._save_path, "scaler.pkl"))
        np.save(path.join(self._save_path, "X.npy"), self.estimator.X)
        np.save(path.join(self._save_path, "y.npy"), self.estimator.y)
        self.estimator.idata.to_netcdf(path.join(self._save_path, "idata.nc"))

    def load_fitted_state(self):
        if hasattr(self.estimator, "scaler"):
            self.estimator.scaler = joblib.load(path.join(self._save_path, "scaler.pkl"))
        X = np.load(path.join(self._save_path, "X.npy"))
        y = np.load(path.join(self._save_path, "y.npy"))
        self.estimator.build_model(X, y)
        self.estimator.idata = InferenceData.from_netcdf(path.join(self._save_path, "idata.nc"))
        self.estimator.classes_ = self.classes_
