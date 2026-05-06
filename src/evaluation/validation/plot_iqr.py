"""
Plot computational costs from averaged k-fold CV measurements.

References
----------
.. [1] https://seaborn.pydata.org/examples/grouped_barplot.html
"""

import pandas as pd
import seaborn as sns


class Catplot:
    def __init__(self):
        self.df = pd.read_csv("avg_carbon.csv")
        frequentist = ["CSPLDA", "CSPSVM", "TSLR", "TSSVM", "SCNN", "DCNN"]
        self.df["type"] = self.df["pipeline"].apply(
            lambda x: "Frequentist" if x in frequentist else "Bayesian"
        )
        pair_map = {
            "CSPLDA": "CSPLDA/CSPBLDA",
            "CSPBLDA": "CSPLDA/CSPBLDA",
            "CSPSVM": "CSPSVM/CSPGP",
            "CSPGP": "CSPSVM/CSPGP",
            "TSLR": "TSLR/TSBLR",
            "TSBLR": "TSLR/TSBLR",
            "TSSVM": "TSSVM/TSGP",
            "TSGP": "TSSVM/TSGP",
            "SCNN": "SCNN/BSCNN",
            "BSCNN": "SCNN/BSCNN",
            "DCNN": "DCNN/BDCNN",
            "BDCNN": "DCNN/BDCNN",
        }
        self.df["pair"] = self.df["pipeline"].map(pair_map)

    def run(self):
        for metric, title, ylabel in self._params():
            self._plot(metric, title, ylabel)

    def _plot(self, metric, title, ylabel):
        plot = sns.catplot(
            data=self.df,
            kind="bar",
            x="pair",
            y=metric,
            hue="type",
            order=["CSPLDA/CSPBLDA", "CSPSVM/CSPGP", "TSLR/TSBLR", "TSSVM/TSGP", "SCNN/BSCNN", "DCNN/BDCNN"],
            hue_order=["Frequentist", "Bayesian"],
            estimator="median",
            errorbar=("pi", 50),
            height=5,
            aspect=2,
        )

        plot.set(yscale="log")
        plot.figure.suptitle(title, y=1.05, fontsize=14, fontweight="bold")
        plot.set_axis_labels("Pairwise Pipelines", ylabel, fontsize=12)
        plot.set_xticklabels(fontsize=12)
        plot.set_yticklabels(fontsize=12)
        plot.legend.set_title("Type", prop={"size": 12})
        for text in plot.legend.get_texts():
            text.set_fontsize(12)

        plot.savefig(f"catplot_{metric}.png", dpi=150, bbox_inches="tight")

    def _params(self):
        yield ("duration", "Training Duration: Median + IQR", "Duration (s)")
        yield ("emissions", "Training Emissions: Median + IQR", "Emissions (g CO$_2$eq)")
        yield ("cpu_power", "Training CPU Power: Median + IQR", "CPU Power (W)")
        yield ("gpu_power", "Training GPU Power: Median + IQR", "GPU Power (W)")
        yield ("cpu_energy", "Training CPU Energy: Median + IQR", "CPU Energy (Wh)")
        yield ("gpu_energy", "Training GPU Energy: Median + IQR", "GPU Energy (Wh)")
        yield ("ram_energy", "Training RAM Energy: Median + IQR", "RAM Energy (Wh)")
        yield ("energy_consumed", "Training Energy Consumed: Median + IQR", "Energy Consumed (Wh)")
