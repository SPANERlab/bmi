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
            Path(__file__).parent / "avg_tmp.sql",
            Path.cwd() / "avg.csv",
            Path.cwd() / "avg_tmp.csv",
        )
        yield (
            Path(__file__).parent / "diff_tmp.sql",
            Path.cwd() / "diff.csv",
            Path.cwd() / "diff_tmp.csv",
        )
        yield (
            Path(__file__).parent / "auroc" / "freq" / "stats.sql",
            Path.cwd() / "avg.csv",
            Path.cwd() / "auroc_freq_stats.csv",
        )
        yield (
            Path(__file__).parent / "auroc" / "bayes" / "stats.sql",
            Path.cwd() / "avg.csv",
            Path.cwd() / "auroc_bayes_stats.csv",
        )
        yield (
            Path(__file__).parent / "mcc" / "freq" / "stats.sql",
            Path.cwd() / "avg.csv",
            Path.cwd() / "mcc_freq_stats.csv",
        )
        yield (
            Path(__file__).parent / "mcc" / "bayes" / "stats.sql",
            Path.cwd() / "avg.csv",
            Path.cwd() / "mcc_bayes_stats.csv",
        )
        yield (
            Path(__file__).parent / "nll" / "freq" / "stats.sql",
            Path.cwd() / "avg.csv",
            Path.cwd() / "nll_freq_stats.csv",
        )
        yield (
            Path(__file__).parent / "nll" / "bayes" / "stats.sql",
            Path.cwd() / "avg.csv",
            Path.cwd() / "nll_bayes_stats.csv",
        )
        yield (
            Path(__file__).parent / "brier" / "freq" / "stats.sql",
            Path.cwd() / "avg.csv",
            Path.cwd() / "brier_freq_stats.csv",
        )
        yield (
            Path(__file__).parent / "brier" / "bayes" / "stats.sql",
            Path.cwd() / "avg.csv",
            Path.cwd() / "brier_bayes_stats.csv",
        )
        yield (
            Path(__file__).parent / "ece" / "freq" / "stats.sql",
            Path.cwd() / "avg.csv",
            Path.cwd() / "ece_freq_stats.csv",
        )
        yield (
            Path(__file__).parent / "ece" / "bayes" / "stats.sql",
            Path.cwd() / "avg.csv",
            Path.cwd() / "ece_bayes_stats.csv",
        )
        yield (
            Path(__file__).parent / "mce" / "freq" / "stats.sql",
            Path.cwd() / "avg.csv",
            Path.cwd() / "mce_freq_stats.csv",
        )
        yield (
            Path(__file__).parent / "mce" / "bayes" / "stats.sql",
            Path.cwd() / "avg.csv",
            Path.cwd() / "mce_bayes_stats.csv",
        )
        yield (
            Path(__file__).parent / "auroc" / "freq" / "bins.sql",
            Path.cwd() / "avg.csv",
            Path.cwd() / "auroc_freq_bins.csv",
        )
        yield (
            Path(__file__).parent / "auroc" / "bayes" / "bins.sql",
            Path.cwd() / "avg.csv",
            Path.cwd() / "auroc_bayes_bins.csv",
        )
        yield (
            Path(__file__).parent / "mcc" / "freq" / "bins.sql",
            Path.cwd() / "avg.csv",
            Path.cwd() / "mcc_freq_bins.csv",
        )
        yield (
            Path(__file__).parent / "mcc" / "bayes" / "bins.sql",
            Path.cwd() / "avg.csv",
            Path.cwd() / "mcc_bayes_bins.csv",
        )
        yield (
            Path(__file__).parent / "nll" / "freq" / "bins.sql",
            Path.cwd() / "avg.csv",
            Path.cwd() / "nll_freq_bins.csv",
        )
        yield (
            Path(__file__).parent / "nll" / "bayes" / "bins.sql",
            Path.cwd() / "avg.csv",
            Path.cwd() / "nll_bayes_bins.csv",
        )
        yield (
            Path(__file__).parent / "brier" / "freq" / "bins.sql",
            Path.cwd() / "avg.csv",
            Path.cwd() / "brier_freq_bins.csv",
        )
        yield (
            Path(__file__).parent / "brier" / "bayes" / "bins.sql",
            Path.cwd() / "avg.csv",
            Path.cwd() / "brier_bayes_bins.csv",
        )
        yield (
            Path(__file__).parent / "ece" / "freq" / "bins.sql",
            Path.cwd() / "avg.csv",
            Path.cwd() / "ece_freq_bins.csv",
        )
        yield (
            Path(__file__).parent / "ece" / "bayes" / "bins.sql",
            Path.cwd() / "avg.csv",
            Path.cwd() / "ece_bayes_bins.csv",
        )
        yield (
            Path(__file__).parent / "mce" / "freq" / "bins.sql",
            Path.cwd() / "avg.csv",
            Path.cwd() / "mce_freq_bins.csv",
        )
        yield (
            Path(__file__).parent / "mce" / "bayes" / "bins.sql",
            Path.cwd() / "avg.csv",
            Path.cwd() / "mce_bayes_bins.csv",
        )
