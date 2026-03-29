"""
Save preprocessed datasets meta information.

References
----------
.. [1] https://moabb.neurotechx.com/docs/auto_examples/data_management_and_configuration/plot_explore_paradigm.html
"""

import json
from collections import Counter
from moabb.datasets import (
    BNCI2014_001,
    BNCI2014_004,
    Brandl2020,
    Chang2025,
    Cho2017,
    Dreyer2023,
    Forenzo2023,
    GrosseWentrup2009,
    GuttmannFlury2025_MI,
    HefmiIch2025,
    Kumar2024,
    Lee2019_MI,
    Liu2024,
    PhysionetMI,
    Schirrmeister2017,
    Shin2017A,
    Stieger2021,
    Weibo2014,
    Yang2025,
    Zhou2020,
)
from ..paradigm import MultiScoreLeftRightImagery
from ...evaluation.configs import Subjects, Sessions, Channels


class Shape:
    def run(self):
        for datasetcls in self._datasets():
            dataset = datasetcls(
                subjects=Subjects[datasetcls.__name__].value,
                sessions=Sessions[datasetcls.__name__].value
            )
            paradigm = MultiScoreLeftRightImagery(
                resample=128,
                channels=Channels[datasetcls.__name__].value
            )

            X, y, metadata = paradigm.get_data(
                dataset,
                cache_config=dict(
                    use=True,
                    save_array=True,
                    overwrite_array=False
                )
            )
            info = {
                "X_shape": list(X.shape),
                "trial_len_s": round(X.shape[-1] / paradigm.resample, 3),
                "y_counts": dict(Counter(y)),
                "n_subjects": metadata["subject"].nunique(),
                "n_sessions": metadata["session"].nunique(),
                "n_runs": metadata["run"].nunique(),
            }

            with open(f"{datasetcls.__name__}_shape.json", "w") as f:
                json.dump(info, f, indent=2)

    def _datasets(self):
        yield BNCI2014_001
        yield BNCI2014_004
        yield Brandl2020
        yield Chang2025
        yield Cho2017
        yield Dreyer2023
        yield Forenzo2023
        yield GrosseWentrup2009
        yield GuttmannFlury2025_MI
        yield HefmiIch2025
        yield Kumar2024
        yield Lee2019_MI
        yield Liu2024
        yield PhysionetMI
        yield Schirrmeister2017
        yield Shin2017A
        yield Stieger2021
        yield Weibo2014
        yield Yang2025
        yield Zhou2020
