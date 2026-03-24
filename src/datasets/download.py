"""
Cache MOABB database.

References
----------
.. [1] https://moabb.neurotechx.com/docs/auto_examples/data_management_and_configuration/plot_changing_download_directory.html
.. [2] https://moabb.neurotechx.com/docs/auto_examples/data_management_and_configuration/plot_bids_conversion.html
.. [3] https://moabb.neurotechx.com/docs/paper_results.html#motor-imagery-left-vs-right-hand
.. [4] https://moabb.neurotechx.com/docs/dataset_summary.html#motor-imagery
"""

from os import getenv
from dotenv import load_dotenv
from moabb.utils import set_download_dir
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


class Download:
    def __init__(self):
        # Configure download
        load_dotenv()
        self.data_path = getenv("DATA_PATH")
        set_download_dir(self.data_path)

    def run(self):
        for datasetcls in self._datasets():
            dataset = datasetcls()
            dataset.download(accept=True)

    def _datasets(self):
        yield PhysionetMI
        yield Lee2019_MI
        yield Cho2017
        yield Schirrmeister2017
        yield Shin2017A
        yield BNCI2014_001
        yield BNCI2014_004
        yield Dreyer2023
        yield Weibo2014
        yield GrosseWentrup2009
        yield Stieger2021
        yield Liu2024
        yield Chang2025
        yield Zhou2020
        yield Brandl2020
        yield Forenzo2023
        yield GuttmannFlury2025_MI
        yield HefmiIch2025
        yield Kumar2024
        yield Yang2025
