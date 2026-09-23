WITH raw AS (
    SELECT
        dataset,
        pipeline,
        subject,
        session,
        brier,
        reliability,
        resolution,
        auroc,
        entropy
    FROM read_csv_auto('data/metrics.csv')
),

fold AS (
    SELECT
        dataset,
        pipeline,
        subject,
        avg(brier) AS f_brier,
        avg(reliability) AS f_reliability,
        avg(resolution) AS f_resolution,
        avg(auroc) AS f_auroc,
        avg(entropy) AS f_entropy
    FROM raw
    GROUP BY dataset, pipeline, subject
),

cv AS (
    SELECT
        dataset,
        pipeline,
        avg(f_brier) AS cv_brier,
        avg(f_reliability) AS cv_reliability,
        avg(f_resolution) AS cv_resolution,
        avg(f_auroc) AS cv_auroc,
        avg(f_entropy) AS cv_entropy
    FROM fold
    GROUP BY dataset, pipeline
),

pair AS (
    SELECT
        'CSPLDA' AS freq,
        'CSPBLDA' AS bayes
    UNION ALL
    SELECT
        'CSPSVM' AS freq,
        'CSPGP' AS bayes
    UNION ALL
    SELECT
        'TSLR' AS freq,
        'TSBLR' AS bayes
    UNION ALL
    SELECT
        'TSSVM' AS freq,
        'TSGP' AS bayes
    UNION ALL
    SELECT
        'SCNN' AS freq,
        'BSCNN' AS bayes
    UNION ALL
    SELECT
        'DCNN' AS freq,
        'BDCNN' AS bayes
),

diff AS (
    SELECT
        f.dataset,
        p.freq,
        p.bayes,
        f.cv_brier AS freq_brier,
        b.cv_brier AS bayes_brier,
        f.cv_reliability AS freq_reliability,
        b.cv_reliability AS bayes_reliability,
        f.cv_resolution AS freq_resolution,
        b.cv_resolution AS bayes_resolution,
        f.cv_auroc AS freq_auroc,
        b.cv_auroc AS bayes_auroc,
        f.cv_entropy AS freq_entropy,
        b.cv_entropy AS bayes_entropy,
        b.cv_brier - f.cv_brier AS diff_brier,
        b.cv_reliability - f.cv_reliability AS diff_reliability,
        b.cv_resolution - f.cv_resolution AS diff_resolution,
        b.cv_auroc - f.cv_auroc AS diff_auroc,
        b.cv_entropy - f.cv_entropy AS diff_entropy
    FROM pair AS p
    INNER JOIN cv AS f ON p.freq = f.pipeline
    INNER JOIN cv AS b ON p.bayes = b.pipeline AND f.dataset = b.dataset
),

stat AS (
    SELECT
        dataset,
        count(*) AS n,

        avg(diff_brier) AS mean_brier,
        var_samp(diff_brier) AS var_brier,
        corr(freq_brier, bayes_brier) AS r_brier,

        avg(diff_reliability) AS mean_reliability,
        var_samp(diff_reliability) AS var_reliability,
        corr(freq_reliability, bayes_reliability) AS r_reliability,

        avg(diff_resolution) AS mean_resolution,
        var_samp(diff_resolution) AS var_resolution,
        corr(freq_resolution, bayes_resolution) AS r_resolution,

        avg(diff_auroc) AS mean_auroc,
        var_samp(diff_auroc) AS var_auroc,
        corr(freq_auroc, bayes_auroc) AS r_auroc,

        avg(diff_entropy) AS mean_entropy,
        var_samp(diff_entropy) AS var_entropy,
        corr(freq_entropy, bayes_entropy) AS r_entropy
    FROM diff
    GROUP BY dataset
),

smd AS (
    SELECT
        dataset,
        n,

        r_brier,
        r_reliability,
        r_resolution,
        r_auroc,
        r_entropy,

        mean_brier * sqrt(2 * (1 - r_brier)) / sqrt(var_brier) AS d_brier,
        mean_reliability * sqrt(2 * (1 - r_reliability)) / sqrt(var_reliability) AS d_reliability,
        mean_resolution * sqrt(2 * (1 - r_resolution)) / sqrt(var_resolution) AS d_resolution,
        mean_auroc * sqrt(2 * (1 - r_auroc)) / sqrt(var_auroc) AS d_auroc,
        mean_entropy * sqrt(2 * (1 - r_entropy)) / sqrt(var_entropy) AS d_entropy
    FROM stat
)

SELECT
    dataset,

    d_brier AS yi_brier,
    d_reliability AS yi_reliability,
    d_resolution AS yi_resolution,
    d_auroc AS yi_auroc,
    d_entropy AS yi_entropy,
    (1.0 / n + power(d_brier, 2) / (2 * n)) * 2 * (1 - r_brier) AS vi_brier,
    (1.0 / n + power(d_reliability, 2) / (2 * n)) * 2 * (1 - r_reliability) AS vi_reliability,
    (1.0 / n + power(d_resolution, 2) / (2 * n)) * 2 * (1 - r_resolution) AS vi_resolution,
    (1.0 / n + power(d_auroc, 2) / (2 * n)) * 2 * (1 - r_auroc) AS vi_auroc,
    (1.0 / n + power(d_entropy, 2) / (2 * n)) * 2 * (1 - r_entropy) AS vi_entropy
FROM smd
ORDER BY dataset
