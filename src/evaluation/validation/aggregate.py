import duckdb
from pathlib import Path


class Aggregate:
    def run(self):
        sql_file = Path(__file__).parent / "aggregate.sql"
        summary_file = Path.cwd() / "summary.csv"
        with open(sql_file) as f:
            query = f.read().format(summary_file=summary_file.as_posix())
        con = duckdb.connect()
        result = con.execute(query).df()
        result.to_csv("aggregate.csv", index=False)
