"""
Make pipeline for CSP+SVM.

References
----------
.. [1] https://github.com/NeuroTechX/moabb/blob/develop/pipelines/CSP_SVM_grid.yml
.. [2] https://scikit-learn.org/stable/modules/generated/sklearn.svm.SVC.html
"""

from pyriemann.estimation import Covariances
from pyriemann.spatialfilters import CSP
from sklearn.pipeline import make_pipeline
from sklearn.svm import SVC
from sklearn.preprocessing import StandardScaler
from ..pipeline_base import PipelineBase
from ..classifiers import SklearnSubprocessor


class CSPSVM(PipelineBase):
    def build(self):
        return {
            self.__class__.__name__: make_pipeline(
                Covariances(estimator="oas"),
                CSP(nfilter=6),
                StandardScaler(),
                SklearnSubprocessor(
                    estimator=SVC(C=1.0, kernel="rbf", probability=True, random_state=self.random_state),
                    root_dir=self.data_path,
                ),
            )
        }
