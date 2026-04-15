"""
Inspect traces from MCMC posterior sampling.

References
----------
.. [1] https://python.arviz.org/projects/plots/en/stable/api/generated/arviz_plots.plot_trace.html
.. [2] https://python.arviz.org/projects/plots/en/stable/api/generated/arviz_plots.plot_autocorr.html
.. [3] https://python.arviz.org/projects/plots/en/stable/api/generated/arviz_plots.plot_rank.html
"""

import re
import pandas as pd
import matplotlib.pyplot as plt
import arviz as az
from itertools import product, islice
from os import getenv
from pathlib import Path
from dotenv import load_dotenv
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
from .configs import VAR_NAMES, COORDS, GRID
from ...pipelines import CSPBLDA, CSPGP, TSBLR, TSGP, BSCNN, BDCNN


class Trace:
    def __init__(self):
        load_dotenv()
        self.data_path = getenv("DATA_PATH")
        az.style.use("arviz-docgrid")

    def run(self):
        self._plots()
        self._summary()

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

    def _pipelines(self):
        yield CSPBLDA
        yield CSPGP
        yield TSBLR
        yield TSGP
        yield BSCNN
        yield BDCNN

    def _plots(self, n_datasets=None, n_pipelines=None, n_traces=1):
        pattern = re.compile(r"\d{8}-\d{6}")
        for i, datasetcls in enumerate(islice(self._datasets(), n_datasets)):
            for j, pipelinecls in enumerate(islice(self._pipelines(), n_pipelines)):
                dirname = Path(self.data_path) / "metrics" / datasetcls.__name__ / pipelinecls.__name__
                for k, filepath in enumerate(islice(dirname.rglob("*.nc"), n_traces)):
                    match = pattern.search(str(filepath))
                    timestamp = match.group() if match else None
                    idata = az.from_netcdf(filepath)

                    self._plot_trace(idata, datasetcls, pipelinecls, timestamp)
                    self._plot_autocorr(idata, datasetcls, pipelinecls, timestamp)
                    self._plot_rank(idata, datasetcls, pipelinecls, timestamp)

    def _plot_trace(self, idata, datasetcls, pipelinecls, timestamp):
        az.plot_trace(idata, var_names=VAR_NAMES[pipelinecls.__name__].value)
        plt.suptitle(f"{datasetcls.__name__} {pipelinecls.__name__} Trace Plot", fontsize=12, weight="bold")
        plt.tight_layout()

        dirname = Path("plots") / datasetcls.__name__ / pipelinecls.__name__
        dirname.mkdir(parents=True, exist_ok=True)
        plt.savefig(dirname / f"{timestamp}_trace")

    def _plot_autocorr(self, idata, datasetcls, pipelinecls, timestamp):
        az.plot_autocorr(
            idata,
            var_names=VAR_NAMES[pipelinecls.__name__].value,
            coords=COORDS[pipelinecls.__name__].value,
            grid=GRID[pipelinecls.__name__].value,
            combined=True,
        )
        plt.suptitle(
            f"{datasetcls.__name__} {pipelinecls.__name__} Autocorrelation Plot", fontsize=18, weight="bold"
        )
        plt.tight_layout()

        dirname = Path("plots") / datasetcls.__name__ / pipelinecls.__name__
        dirname.mkdir(parents=True, exist_ok=True)
        plt.savefig(dirname / f"{timestamp}_autocorr")

    def _plot_rank(self, idata, datasetcls, pipelinecls, timestamp):
        az.plot_rank(
            idata,
            var_names=VAR_NAMES[pipelinecls.__name__].value,
            coords=COORDS[pipelinecls.__name__].value,
            grid=GRID[pipelinecls.__name__].value,
        )
        plt.suptitle(f"{datasetcls.__name__} {pipelinecls.__name__} Rank Plot", fontsize=18, weight="bold")
        plt.tight_layout()

        dirname = Path("plots") / datasetcls.__name__ / pipelinecls.__name__
        dirname.mkdir(parents=True, exist_ok=True)
        plt.savefig(dirname / f"{timestamp}_rank")

    def _summary(self):
        rows = []
        pattern = re.compile(r"\d{8}-\d{6}")

        for datasetcls, pipelinecls in product(self._datasets(), self._pipelines()):
            dirname = Path(self.data_path) / "metrics" / datasetcls.__name__ / pipelinecls.__name__
            for path in dirname.rglob("*.nc"):
                match = pattern.search(str(path))
                timestamp = match.group() if match else None

                idata = az.from_netcdf(path)
                summary = az.summary(idata, var_names=VAR_NAMES[pipelinecls.__name__].value)

                rows.append(
                    {
                        "dataset": datasetcls.__name__,
                        "pipeline": pipelinecls.__name__,
                        "timestamp": timestamp,
                        "ess_bulk_min": summary["ess_bulk"].min(),
                        "ess_bulk_mean": summary["ess_bulk"].mean(),
                        "ess_tail_min": summary["ess_tail"].min(),
                        "ess_tail_mean": summary["ess_tail"].mean(),
                        "r_hat_max": summary["r_hat"].max(),
                        "r_hat_mean": summary["r_hat"].mean(),
                        "mcse_mean_max": summary["mcse_mean"].max(),
                        "mcse_mean_mean": summary["mcse_mean"].mean(),
                        "mcse_sd_max": summary["mcse_sd"].max(),
                        "mcse_sd_mean": summary["mcse_sd"].mean(),
                        "divergences": int(idata.sample_stats["diverging"].values.sum()),
                    }
                )

        df = pd.DataFrame(rows)
        df.to_csv("summary.csv", index=False)
