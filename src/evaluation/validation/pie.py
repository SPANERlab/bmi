"""
Create pie charts for energy consumed.

References
----------
.. [1] https://matplotlib.org/stable/gallery/pie_and_polar_charts/pie_features.html
"""

import matplotlib.pyplot as plt


class PieCharts:
    def run(self):
        for sizes, title, filepath in self._params():
            labels = "CPU", "GPU", "RAM"
            colors = ["tab:gray", "tab:olive", "tab:cyan"]
            fig, ax = plt.subplots()
            ax.pie(sizes, labels=labels, autopct="%1.2f%%", textprops=dict(fontsize=12), colors=colors)
            ax.set_title(title, fontsize=14, fontweight="bold")
            fig.savefig(filepath, bbox_inches="tight", pad_inches=0.1)

    def _params(self):
        """Average of median energy consumed by CPU/GPU/RAM."""
        yield ([6.46, 2.69, 0.67], "Energy Consumed: Frequentist Pipelines (Wh)", "pie_chart_freq.png")
        yield ([9.73, 13.61, 3.86], "Energy Consumed: Bayesian Pipelines (Wh)", "pie_chart_bayes.png")
