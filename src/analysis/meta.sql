SELECT
    dataset,
    CASE
        WHEN pipeline_freq IN ('CSPLDA', 'CSPSVM') THEN 'CSP'
        WHEN pipeline_freq IN ('TSLR', 'TSSVM') THEN 'TS'
        WHEN pipeline_freq IN ('SCNN', 'DCNN') THEN 'CNN'
    END AS pipeline_family,
    ANY_VALUE(samples) AS samples,
    ANY_VALUE(samples_test) AS samples_test,
    AVG(time) AS time,
    AVG(carbon_emission) AS carbon_emission,
    AVG(score_auroc) AS yi_score_auroc,
    VAR_SAMP(score_auroc) / COUNT(*) AS vi_score_auroc,
    AVG(score_mcc) AS yi_score_mcc,
    VAR_SAMP(score_mcc) / COUNT(*) AS vi_score_mcc,
    AVG(score_nll) AS yi_score_nll,
    VAR_SAMP(score_nll) / COUNT(*) AS vi_score_nll,
    AVG(score_brier) AS yi_score_brier,
    VAR_SAMP(score_brier) / COUNT(*) AS vi_score_brier,
    AVG(score_ece) AS yi_score_ece,
    VAR_SAMP(score_ece) / COUNT(*) AS vi_score_ece,
    AVG(score_mce) AS yi_score_mce,
    VAR_SAMP(score_mce) / COUNT(*) AS vi_score_mce
FROM read_csv_auto('{diff_file}')
GROUP BY dataset, pipeline_family
ORDER BY dataset, pipeline_family
