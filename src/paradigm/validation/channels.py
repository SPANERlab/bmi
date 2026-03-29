"""
Inspect montage sensors of datasets.

References
----------
.. [1] https://mne.tools/mne-bids/stable/auto_examples/read_bids_datasets.html
.. [2] https://mne.tools/stable/auto_tutorials/intro/40_sensor_locations.html
"""

import mne
import pandas as pd
from os import path, getenv
from dotenv import load_dotenv
from mne_bids import find_matching_paths, read_raw_bids
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


class Channels:
    # fmt: off
    CHANNELS = [
        "FC5", "FC3", "FC1", "FCz", "FC2", "FC4", "FC6",
        "FCC5h", "FCC3h", "FFC1h", "FCC2h", "FCC4h", "FCC6h",
        "C5", "C3", "C1", "Cz", "C2", "C4", "C6",
        "CCP5h", "CCP3h", "CCP1h", "CCP2h", "CCP4h", "CCP6h",
        "CP5", "CP3", "CP1", "CPz", "CP2", "CP4", "CP6",
    ]
    # fmt: on

    def __init__(self):
        load_dotenv()
        self.data_path = getenv("DATA_PATH")
        self.raw = False

    def run(self):
        for datasetcls, subdir, subject in self._params():
            root = path.join(self.data_path, subdir)
            bids_paths = find_matching_paths(root=root, subjects=subject, datatypes="eeg", extensions=".edf")
            bids_path = bids_paths[0]
            raw = read_raw_bids(bids_path=bids_path, verbose=False)

            ch_names = None
            if datasetcls.__name__ == GrosseWentrup2009.__name__:
                ch_names = self._rename_channels(raw)

            self._save_raw_montage(raw, datasetcls.__name__, ch_names)
            self._save_montage(raw, datasetcls.__name__, ch_names)

    def _params(self):
        yield (BNCI2014_001, "MNE-BIDS-bnci2014-001", "1")
        yield (BNCI2014_004, "MNE-BIDS-bnci2014-004", "1")
        yield (Brandl2020, "MNE-BIDS-brandl2020", "1")
        yield (Chang2025, "MNE-BIDS-chang2025", "1")
        yield (Cho2017, "MNE-BIDS-cho2017", "1")
        yield (Dreyer2023, "MNE-BIDS-dreyer2023", "1")
        yield (Forenzo2023, "MNE-BIDS-forenzo2023", "1")
        yield (GrosseWentrup2009, "MNE-BIDS-grosse-wentrup2009", "1")
        yield (GuttmannFlury2025_MI, "MNE-BIDS-guttmann-flury2025-mi", "1")
        yield (HefmiIch2025, "MNE-BIDS-hefmi-ich2025", "1")
        yield (Kumar2024, "MNE-BIDS-kumar2024", "1")
        yield (Lee2019_MI, "MNE-BIDS-lee2019-mi", "1")
        yield (Liu2024, "MNE-BIDS-liu2024", "1")
        yield (PhysionetMI, "MNE-BIDS-physionet-motor-imagery", "1")
        yield (Schirrmeister2017, "MNE-BIDS-schirrmeister2017", "1")
        yield (Shin2017A, "MNE-BIDS-shin2017-a", "1")
        yield (Stieger2021, "MNE-BIDS-stieger2021", "1")
        yield (Weibo2014, "MNE-BIDS-weibo2014", "1")
        yield (Yang2025, "MNE-BIDS-yang2025", "1")
        yield (Zhou2020, "MNE-BIDS-zhou2020", "13")

    def _rename_channels(self, raw):
        orig_ch_names = raw.ch_names
        montage_name = "brainproducts-RNP-BA-128"
        std = mne.channels.make_standard_montage(montage_name)
        rename_map = {str(i + 1): name for i, name in enumerate(std.ch_names) if str(i + 1) in orig_ch_names}
        raw.rename_channels(rename_map)
        raw.set_montage(montage_name)
        return orig_ch_names

    def _save_raw_montage(self, raw, classname, ch_names=None):
        df = pd.DataFrame(raw.ch_names, columns=["ch_names"])
        if ch_names is not None:
            df["orig_ch_names"] = ch_names
        df.to_csv(f"{classname}_raw_montage.csv", index=False)

    def _save_montage(self, raw, classname, ch_names=None):
        channels = set(self.CHANNELS) & set(raw.ch_names)
        df = pd.DataFrame(sorted(channels, key=lambda ch: self.CHANNELS.index(ch)), columns=["ch_names"])
        if ch_names is not None:
            df["orig_ch_names"] = [
                ch_names[raw.ch_names.index(ch)]
                for ch in sorted(channels, key=lambda ch: self.CHANNELS.index(ch))
            ]
        df.to_csv(f"{classname}_montage.csv", index=False)
