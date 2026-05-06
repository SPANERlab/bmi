import duckdb
from os import getenv
from pathlib import Path
from dotenv import load_dotenv


class Query:
    def __init__(self):
        load_dotenv()
        self.data_path = Path(getenv("DATA_PATH")) / "metrics"

    def run(self):
        for sql_file, input_file, output_file in self._params():
            self._exec(sql_file, input_file, output_file)

    def _exec(self, sql_file, input_file, output_file):
        with duckdb.connect() as con:
            with open(sql_file, "r") as f:
                query = (
                    f.read()
                    .replace("{root_dir}", str(self.data_path))
                    .replace("{input_file}", str(input_file))
                )
            df = con.execute(query).df()
        df.to_csv(output_file, index=False)

    def _params(self):
        yield (
            Path(__file__).parent / "agg_worst.sql",
            Path.cwd() / "summary.csv",
            Path.cwd() / "agg_worst.csv",
        )
        yield (
            Path(__file__).parent / "agg_metrics_pipeline.sql",
            Path.cwd() / "agg_worst.csv",
            Path.cwd() / "agg_metrics_pipeline.csv",
        )
        yield (
            Path(__file__).parent / "agg_metrics_dataset.sql",
            Path.cwd() / "agg_worst.csv",
            Path.cwd() / "agg_metrics_dataset.csv",
        )
        yield (
            Path(__file__).parent / "carbon.sql",
            None,
            Path.cwd() / "carbon.csv",
        )
        yield (
            Path(__file__).parent / "avg_carbon.sql",
            None,
            Path.cwd() / "avg_carbon.csv",
        )
        yield (
            Path(__file__).parent / "avg_carbon_iqr.sql",
            None,
            Path.cwd() / "avg_carbon_iqr.csv",
        )
