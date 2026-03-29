"""
Plot EEG channel montages.

References
----------
.. [1] https://mne.tools/mne-bids/stable/auto_examples/read_bids_datasets.html
.. [2] https://mne.tools/stable/auto_tutorials/intro/40_sensor_locations.html
.. [3] https://matplotlib.org/stable/gallery/subplots_axes_and_figures/align_labels_demo.html
"""

import mne
import numpy as np
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
from ...evaluation import Channels


class Montage:
    def __init__(self):
        self.datasets = self._datasets()

    def run(self):
        nrows, ncols = 5, 4
        fig, axes = plt.subplots(nrows, ncols, figsize=(8, 8))

        for row in range(nrows):
            for col in range(ncols):
                self._plot_montage(axes[row][col], next(self.datasets))

        fig.suptitle("Channel Montages", fontweight="bold", fontsize=16)
        fig.tight_layout()
        fig.savefig("montages")

    def _plot_montage(self, ax, datasetcls):
        ch_names = Channels[datasetcls.__name__].value
        if datasetcls.__name__ == GrosseWentrup2009.__name__:
            ch_names = Channels[f"{datasetcls.__name__}_1005"].value

        info = mne.create_info(ch_names=ch_names, sfreq=128, ch_types="eeg")
        data = np.zeros((len(ch_names), 1))
        raw = mne.io.RawArray(data, info, verbose=False)

        raw.set_montage("standard_1005")
        try:
            raw.plot_sensors(show_names=False, sphere="auto", show=False, axes=ax)
        except ValueError:
            raw.plot_sensors(show_names=False, sphere=(0, 0, 0, 0.095), show=False, axes=ax)
        ax.set_title(datasetcls.__name__, fontsize=14)

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
