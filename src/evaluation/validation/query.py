import duckdb
from pathlib import Path


class Query:
    def run(self):
        for sql_file, input_file, output_file in self._params():
            self._exec(sql_file, input_file, output_file)

    def _exec(self, sql_file, input_file, output_file):
        with duckdb.connect() as con:
            with open(sql_file, "r") as f:
                query = f.read().format(input_file=input_file)
            df = con.execute(query).df()
        df.to_csv(output_file, index=False)

    def _params(self):
        yield (
            Path(__file__).parent / "agg_worst.sql",
            Path.cwd() / "summary.csv",
            Path.cwd() / "agg_worst.csv",
        )
        yield (
            Path(__file__).parent / "agg_metrics.sql",
            Path.cwd() / "agg_worst.csv",
            Path.cwd() / "agg_metrics.csv",
        )
