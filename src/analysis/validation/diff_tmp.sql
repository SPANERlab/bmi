SELECT
    dataset, pipeline_freq AS freq, pipeline_bayes AS bayes,
    ROUND(score_nll, 3) AS NLL,
    ROUND(score_brier, 3) AS BS,
    ROUND(score_auroc, 3) AS AUROC,
    ROUND(score_mcc, 3) AS MCC,
    ROUND(score_ece, 3) AS ECE,
    ROUND(score_mce, 3) AS MCE
FROM read_csv_auto('{input_file}')
ORDER BY dataset,
    CASE freq
        WHEN 'CSPLDA' THEN 1
        WHEN 'CSPSVM' THEN 2
        WHEN 'TSLR' THEN 3
        WHEN 'TSSVM' THEN 4
        WHEN 'SCNN' THEN 5
        WHEN 'DCNN' THEN 6
    END