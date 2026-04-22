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
            Path.cwd() / "src" / "analysis" / "validation" / "avg_tmp.sql",
            Path.cwd() / "avg.csv",
            Path.cwd() / "avg_tmp.csv",
        )
        yield (
            Path.cwd() / "src" / "analysis" / "validation" / "diff_tmp.sql",
            Path.cwd() / "diff.csv",
            Path.cwd() / "diff_tmp.csv",
        )
        yield (
            Path.cwd() / "src" / "analysis" / "validation" / "auroc" / "freq" / "stats.sql",
            Path.cwd() / "avg.csv",
            Path.cwd() / "auroc_freq_stats.csv",
        )
        yield (
            Path.cwd() / "src" / "analysis" / "validation" / "auroc" / "bayes" / "stats.sql",
            Path.cwd() / "avg.csv",
            Path.cwd() / "auroc_bayes_stats.csv",
        )
        yield (
            Path.cwd() / "src" / "analysis" / "validation" / "mcc" / "freq" / "stats.sql",
            Path.cwd() / "avg.csv",
            Path.cwd() / "mcc_freq_stats.csv",
        )
        yield (
            Path.cwd() / "src" / "analysis" / "validation" / "mcc" / "bayes" / "stats.sql",
            Path.cwd() / "avg.csv",
            Path.cwd() / "mcc_bayes_stats.csv",
        )
        yield (
            Path.cwd() / "src" / "analysis" / "validation" / "nll" / "freq" / "stats.sql",
            Path.cwd() / "avg.csv",
            Path.cwd() / "nll_freq_stats.csv",
        )
        yield (
            Path.cwd() / "src" / "analysis" / "validation" / "nll" / "bayes" / "stats.sql",
            Path.cwd() / "avg.csv",
            Path.cwd() / "nll_bayes_stats.csv",
        )
        yield (
            Path.cwd() / "src" / "analysis" / "validation" / "brier" / "freq" / "stats.sql",
            Path.cwd() / "avg.csv",
            Path.cwd() / "brier_freq_stats.csv",
        )
        yield (
            Path.cwd() / "src" / "analysis" / "validation" / "brier" / "bayes" / "stats.sql",
            Path.cwd() / "avg.csv",
            Path.cwd() / "brier_bayes_stats.csv",
        )
        yield (
            Path.cwd() / "src" / "analysis" / "validation" / "ece" / "freq" / "stats.sql",
            Path.cwd() / "avg.csv",
            Path.cwd() / "ece_freq_stats.csv",
        )
        yield (
            Path.cwd() / "src" / "analysis" / "validation" / "ece" / "bayes" / "stats.sql",
            Path.cwd() / "avg.csv",
            Path.cwd() / "ece_bayes_stats.csv",
        )
        yield (
            Path.cwd() / "src" / "analysis" / "validation" / "mce" / "freq" / "stats.sql",
            Path.cwd() / "avg.csv",
            Path.cwd() / "mce_freq_stats.csv",
        )
        yield (
            Path.cwd() / "src" / "analysis" / "validation" / "mce" / "bayes" / "stats.sql",
            Path.cwd() / "avg.csv",
            Path.cwd() / "mce_bayes_stats.csv",
        )
        yield (
            Path.cwd() / "src" / "analysis" / "validation" / "auroc" / "freq" / "bins.sql",
            Path.cwd() / "avg.csv",
            Path.cwd() / "auroc_freq_bins.csv",
        )
        yield (
            Path.cwd() / "src" / "analysis" / "validation" / "auroc" / "bayes" / "bins.sql",
            Path.cwd() / "avg.csv",
            Path.cwd() / "auroc_bayes_bins.csv",
        )
        yield (
            Path.cwd() / "src" / "analysis" / "validation" / "mcc" / "freq" / "bins.sql",
            Path.cwd() / "avg.csv",
            Path.cwd() / "mcc_freq_bins.csv",
        )
        yield (
            Path.cwd() / "src" / "analysis" / "validation" / "mcc" / "bayes" / "bins.sql",
            Path.cwd() / "avg.csv",
            Path.cwd() / "mcc_bayes_bins.csv",
        )
        yield (
            Path.cwd() / "src" / "analysis" / "validation" / "nll" / "freq" / "bins.sql",
            Path.cwd() / "avg.csv",
            Path.cwd() / "nll_freq_bins.csv",
        )
        yield (
            Path.cwd() / "src" / "analysis" / "validation" / "nll" / "bayes" / "bins.sql",
            Path.cwd() / "avg.csv",
            Path.cwd() / "nll_bayes_bins.csv",
        )
        yield (
            Path.cwd() / "src" / "analysis" / "validation" / "brier" / "freq" / "bins.sql",
            Path.cwd() / "avg.csv",
            Path.cwd() / "brier_freq_bins.csv",
        )
        yield (
            Path.cwd() / "src" / "analysis" / "validation" / "brier" / "bayes" / "bins.sql",
            Path.cwd() / "avg.csv",
            Path.cwd() / "brier_bayes_bins.csv",
        )
        yield (
            Path.cwd() / "src" / "analysis" / "validation" / "ece" / "freq" / "bins.sql",
            Path.cwd() / "avg.csv",
            Path.cwd() / "ece_freq_bins.csv",
        )
        yield (
            Path.cwd() / "src" / "analysis" / "validation" / "ece" / "bayes" / "bins.sql",
            Path.cwd() / "avg.csv",
            Path.cwd() / "ece_bayes_bins.csv",
        )
        yield (
            Path.cwd() / "src" / "analysis" / "validation" / "mce" / "freq" / "bins.sql",
            Path.cwd() / "avg.csv",
            Path.cwd() / "mce_freq_bins.csv",
        )
        yield (
            Path.cwd() / "src" / "analysis" / "validation" / "mce" / "bayes" / "bins.sql",
            Path.cwd() / "avg.csv",
            Path.cwd() / "mce_bayes_bins.csv",
        )
