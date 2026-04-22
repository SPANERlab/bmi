WITH pairs AS (
    SELECT 'CSPLDA' as freq, 'CSPBLDA' as bayes UNION ALL
    SELECT 'CSPSVM', 'CSPGP' UNION ALL
    SELECT 'TSLR', 'TSBLR' UNION ALL
    SELECT 'TSSVM', 'TSGP' UNION ALL
    SELECT 'SCNN', 'BSCNN' UNION ALL
    SELECT 'DCNN', 'BDCNN'
)
SELECT
    f.dataset,
    p.freq AS pipeline_freq,
    p.bayes AS pipeline_bayes,
    b.samples AS samples,
    b.samples_test AS samples_test,
    b.time - f.time AS time,
    b.carbon_emission - f.carbon_emission AS carbon_emission,
    b.score_nll - f.score_nll AS score_nll,
    b.score_brier - f.score_brier AS score_brier,
    b.score_auroc - f.score_auroc AS score_auroc,
    b.score_mcc - f.score_mcc AS score_mcc,
    b.score_ece - f.score_ece AS score_ece,
    b.score_mce - f.score_mce AS score_mce
FROM pairs p
JOIN read_csv_auto('{avg_file}') f ON f.pipeline = p.freq
JOIN read_csv_auto('{avg_file}') b ON b.pipeline = p.bayes AND b.dataset = f.dataset
ORDER BY dataset, pipeline_freq
