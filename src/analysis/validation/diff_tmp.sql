SELECT
    dataset,
    pipeline_freq AS freq,
    pipeline_bayes AS bayes,
    ROUND(score_nll, 3) AS nll,
    ROUND(score_brier, 3) AS bs,
    ROUND(score_auroc, 3) AS auroc,
    ROUND(score_mcc, 3) AS mcc,
    ROUND(score_ece, 3) AS ece,
    ROUND(score_mce, 3) AS mce
FROM READ_CSV_AUTO('{input_file}')
ORDER BY
    dataset,
    CASE freq
        WHEN 'CSPLDA' THEN 1
        WHEN 'CSPSVM' THEN 2
        WHEN 'TSLR' THEN 3
        WHEN 'TSSVM' THEN 4
        WHEN 'SCNN' THEN 5
        WHEN 'DCNN' THEN 6
    END
