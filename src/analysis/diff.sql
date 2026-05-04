WITH pairs AS (
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
)

SELECT
    f.dataset,
    p.freq,
    p.bayes,
    b.samples,
    b.samples_test,
    b.duration - f.duration AS duration,
    b.carbon_emission - f.carbon_emission AS carbon_emission,
    b.score_nll - f.score_nll AS score_nll,
    b.score_brier - f.score_brier AS score_brier,
    b.score_auroc - f.score_auroc AS score_auroc,
    b.score_mcc - f.score_mcc AS score_mcc,
    b.score_ece - f.score_ece AS score_ece,
    b.score_mce - f.score_mce AS score_mce
FROM pairs AS p
INNER JOIN read_csv_auto('{avg_file}') AS f ON p.freq = f.pipeline
INNER JOIN
    read_csv_auto('{avg_file}') AS b
    ON p.bayes = b.pipeline AND f.dataset = b.dataset
ORDER BY f.dataset, p.freq
