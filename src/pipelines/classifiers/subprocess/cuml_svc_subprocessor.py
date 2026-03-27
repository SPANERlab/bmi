from os import path
from cuml.svm import SVC
from .subprocessor_base import SubprocessorBase


class CuMLSVCSubprocessor(SubprocessorBase):
    def save_fitted_state(self):
        self.estimator.model_.save_model(path.join(self.save_dir, "model.cuml"))

    def load_fitted_state(self):
        params = self.estimator.classifier.get_params()
        model = SVC(**params)
        model.load_model(path.join(self.save_dir, "model.cuml"))
        self.estimator.model_ = model
