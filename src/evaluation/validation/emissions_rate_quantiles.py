"""
Compute quantiles of average emissions rate.

References
----------
.. [1] https://github.com/mlco2/codecarbon/blob/master/codecarbon/data/private_infra/2016/usa_emissions.json
"""

import pandas as pd


class EmissionsRateQuantiles:
    def run(self):
        df = pd.read_csv("avg_carbon.csv")
        result = df.groupby("pipeline")["emissions_rate"].quantile([0.25, 0.5, 0.75]).unstack()
        result.columns = ["Q1_WA", "Q2_WA", "Q3_WA"]

        # USA to WA grid intensity conversion ratio
        scale_usa = 0.452886 / 0.084751
        result["Q1_USA"] = result["Q1_WA"] * scale_usa
        result["Q2_USA"] = result["Q2_WA"] * scale_usa
        result["Q3_USA"] = result["Q3_WA"] * scale_usa

        # WY to WA grid intensity conversion ratio
        scale_wy = 0.9191 / 0.084751
        result["Q1_WY"] = result["Q1_WA"] * scale_wy
        result["Q2_WY"] = result["Q2_WA"] * scale_wy
        result["Q3_WY"] = result["Q3_WA"] * scale_wy

        order = [
            "CSPLDA",
            "CSPBLDA",
            "CSPSVM",
            "CSPGP",
            "TSLR",
            "TSBLR",
            "TSSVM",
            "TSGP",
            "SCNN",
            "BSCNN",
            "DCNN",
            "BDCNN",
        ]
        result = (
            result.loc[order]
            .reset_index()
            .rename(columns={"index": "pipeline"})[
                [
                    "pipeline",
                    "Q2_WA",
                    "Q2_USA",
                    "Q2_WY",
                    "Q1_WA",
                    "Q1_USA",
                    "Q1_WY",
                    "Q3_WA",
                    "Q3_USA",
                    "Q3_WY",
                ]
            ]
            .round(3)
            .to_csv("emissions_rate_quantiles.csv", index=False)
        )
