"""
Perform cross-subject evaluation with left-/right-hand binary classification.

References
----------
.. [1] https://moabb.neurotechx.com/docs/generated/moabb.evaluations.CrossSubjectEvaluation.html
.. [2] https://moabb.neurotechx.com/docs/auto_examples/advanced_examples/plot_select_electrodes_resample.html
"""

import numpy as np
from os import path, getenv, makedirs
from itertools import product
from dotenv import load_dotenv
from moabb.utils import set_download_dir
from moabb.evaluations import CrossSubjectEvaluation
from moabb.datasets import (
    PhysionetMI,
    Lee2019_MI,
    Cho2017,
    Schirrmeister2017,
    Shin2017A,
    BNCI2014_001,
    BNCI2014_004,
    Dreyer2023,
    Weibo2014,
    GrosseWentrup2009,
    Stieger2021,
    Liu2024,
    Brandl2020,
    Chang2025,
    Forenzo2023,
    GuttmannFlury2025_MI,
    HefmiIch2025,
    Kumar2024,
    Yang2025,
    Zhou2020,
)
from .configs import Splits, Sessions, Channels, Subjects
from ..paradigm import MultiScoreLeftRightImagery
from ..pipelines import CSPLDA, CSPSVM, TSLR, TSSVM, SCNN, DCNN, CSPBLDA, CSPGP, TSBLR, TSGP, BSCNN, BDCNN


class Evaluation:
    def __init__(self):
        # Configure environment
        load_dotenv()
        self.random_state = int(getenv("RANDOM_STATE"))
        self.data_path = getenv("DATA_PATH")
        set_download_dir(self.data_path)

    def run(self):
        for datasetcls, pipelinecls in product(self._datasets(), self._pipelines()):
            # Make directories
            metrics_path = path.join(
                self.data_path,
                "metrics",
                datasetcls.__name__,
                pipelinecls.__name__,
            )
            emissions_path = path.join(metrics_path, "emissions")
            makedirs(metrics_path, exist_ok=True)
            makedirs(emissions_path, exist_ok=True)

            # Configure evaluation
            dataset = datasetcls(
                subjects=Subjects[datasetcls.__name__].value, sessions=Sessions[datasetcls.__name__].value
            )
            paradigm = MultiScoreLeftRightImagery(resample=128, channels=Channels[datasetcls.__name__].value)
            evaluation = CrossSubjectEvaluation(
                datasets=[dataset],
                paradigm=paradigm,
                hdf5_path=self.data_path,
                overwrite=True,
                n_splits=Splits[datasetcls.__name__].value,
                codecarbon_config=dict(
                    save_to_file=True,
                    output_dir=emissions_path,
                    log_level="critical",
                    country_iso_code="USA",
                    region="washington",
                ),
            )

            # Configure pipelines
            X, y, _ = paradigm.get_data(dataset, subjects=[1])
            pipeline = pipelinecls(
                data_path=metrics_path,
                random_state=self.random_state,
                n_features=X.shape[1],
                n_classes=len(np.unique(y)),
                n_timepoints=X.shape[2],
            )
            pipelines = pipeline.build()

            # Execute pipelines evaluation
            result = evaluation.process(pipelines)
            result.to_csv(path.join(metrics_path, "scores.csv"), index=False)

    def _datasets(self):
        yield BNCI2014_001
        yield Stieger2021
        yield Schirrmeister2017
        yield Liu2024
        yield GrosseWentrup2009
        yield PhysionetMI
        yield Lee2019_MI
        yield Cho2017
        yield Shin2017A
        yield BNCI2014_004
        yield Dreyer2023
        yield Weibo2014
        yield Chang2025
        yield Zhou2020
        yield Brandl2020
        yield Forenzo2023
        yield GuttmannFlury2025_MI
        yield HefmiIch2025
        yield Kumar2024
        yield Yang2025

    def _pipelines(self):
        yield CSPLDA
        yield CSPBLDA
        yield CSPSVM
        yield CSPGP
        yield TSLR
        yield TSBLR
        yield TSSVM
        yield TSGP
        yield SCNN
        yield BSCNN
        yield DCNN
        yield BDCNN
