"""
Visualize MOABB bubble plots.

References
----------
.. [1] https://moabb.neurotechx.com/docs/auto_examples/advanced_examples/plot_dataset_bubbles.html
"""

import matplotlib.pyplot as plt
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
from moabb.datasets.utils import plot_datasets_cluster


class BubblePlot:
    KEYS = ("dataset_name", "paradigm", "n_subjects", "n_sessions", "n_trials", "trial_len")

    def run(self):
        fig = plot_datasets_cluster(
            datasets=[
                dict(zip(self.KEYS, row))
                for row in [
                    (BNCI2014_001.__name__, "imagery", 9, 2, 2592, 4.0),
                    (BNCI2014_004.__name__, "imagery", 9, 5, 6520, 4.5),
                    (Brandl2020.__name__, "imagery", 16, 1, 8058, 4.5),
                    (Chang2025.__name__, "imagery", 28, 4, 2260, 6.0),
                    (Cho2017.__name__, "imagery", 52, 1, 10520, 3.0),
                    (Dreyer2023.__name__, "imagery", 87, 1, 20792, 5.0),
                    (Forenzo2023.__name__, "imagery", 25, 5, 3661, 4.0),
                    (GrosseWentrup2009.__name__, "imagery", 10, 1, 3000, 7.0),
                    (GuttmannFlury2025_MI.__name__, "imagery", 31, 3, 2520, 4.0),
                    (HefmiIch2025.__name__, "imagery", 37, 6, 2940, 10.0),
                    (Kumar2024.__name__, "imagery", 18, 6, 7156, 5.0),
                    (Lee2019_MI.__name__, "imagery", 54, 2, 10800, 4.0),
                    (Liu2024.__name__, "imagery", 50, 1, 2000, 4.0),
                    (PhysionetMI.__name__, "imagery", 109, 1, 4918, 3.0),
                    (Schirrmeister2017.__name__, "imagery", 14, 1, 6742, 4.0),
                    (Shin2017A.__name__, "imagery", 29, 3, 1740, 10.0),
                    (Stieger2021.__name__, "imagery", 62, 6, 43422, 3.0),
                    (Weibo2014.__name__, "imagery", 10, 1, 1580, 4.0),
                    (Yang2025.__name__, "imagery", 51, 3, 30591, 4.0),
                    (Zhou2020.__name__, "imagery", 8, 7, 6666, 5.0),
                ]
            ],
            meta_gap=15,
            color_map=dict(imagery="tab:blue"),
            fontsize=12,
        )

        fig.suptitle("Scale Comparison", fontweight="bold", fontsize=16)
        plt.savefig("bubble-plot")
