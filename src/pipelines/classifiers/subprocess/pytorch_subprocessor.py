import torch
from os import path
from .subprocessor_base import SubprocessorBase


class PyTorchSubprocessor(SubprocessorBase):
    def save_fitted_state(self):
        self.estimator.model_.save_params(
            f_params=path.join(self._save_path, "params.pt"),
            f_optimizer=path.join(self._save_path, "optimizer.pt"),
            f_history=path.join(self._save_path, "history.json"),
        )

    def load_fitted_state(self):
        self.estimator.model_ = self.estimator.build_classifier()
        self.estimator.model_.initialize()
        self.estimator.model_.load_params(
            f_params=path.join(self._save_path, "params.pt"),
            f_optimizer=path.join(self._save_path, "optimizer.pt"),
            f_history=path.join(self._save_path, "history.json"),
        )
        self.estimator.classes_ = self.classes_

    def load_backbone(self):
        classifier = self.estimator.build_classifier()
        classifier.initialize()
        classifier.load_params(f_params=path.join(self._save_path, "params.pt"))
        classifier.module_.to("cpu")
        return classifier.module_
