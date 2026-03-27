"""
Convert MOABB datasets to BIDS format.
"""

from os import getenv
from dotenv import load_dotenv
from moabb.utils import set_download_dir
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


class NoDigMixin:
    """Workaround datasets with incomplete digitization."""
    def get_data(self, subjects=None):
        data = super().get_data(subjects=subjects)
        for subject in data:
            for session in data[subject]:
                for _, raw in data[subject][session].items():
                    raw.set_montage(None)
        return data
    

class Chang2025NoDig(NoDigMixin, Chang2025):
    pass


class GuttmannFlury2025_MINoDig(NoDigMixin, GuttmannFlury2025_MI):
    pass


class BIDS:
    def __init__(self):
        # Configure download
        load_dotenv()
        self.data_path = getenv("DATA_PATH")
        set_download_dir(self.data_path)
        self.subjects = None

    def run(self):
        for datasetcls in self._datasets():
            dataset = datasetcls()
            dataset.convert_to_bids(subjects=self.subjects)

    def _datasets(self):
        yield BNCI2014_001
        yield BNCI2014_004
        yield Brandl2020
        yield Chang2025NoDig
        yield Cho2017
        yield Dreyer2023
        yield Forenzo2023
        yield GrosseWentrup2009
        yield GuttmannFlury2025_MINoDig
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
