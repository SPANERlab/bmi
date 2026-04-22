SELECT
    dataset, pipeline,
    ROUND(score_nll, 3) AS NLL,
    ROUND(score_brier, 3) AS BS,
    ROUND(score_auroc, 3) AS AUROC,
    ROUND(score_mcc, 3) AS MCC,
    ROUND(score_ece, 3) AS ECE,
    ROUND(score_mce, 3) AS MCE
FROM read_csv_auto('{input_file}')
ORDER BY dataset,
    CASE pipeline
        WHEN 'CSPLDA' THEN 1
        WHEN 'CSPBLDA' THEN 2
        WHEN 'CSPSVM' THEN 3
        WHEN 'CSPGP' THEN 4
        WHEN 'TSLR' THEN 5
        WHEN 'TSBLR' THEN 6
        WHEN 'TSSVM' THEN 7
        WHEN 'TSGP' THEN 8
        WHEN 'SCNN' THEN 9
        WHEN 'BSCNN' THEN 10
        WHEN 'DCNN' THEN 11
        WHEN 'BDCNN' THEN 12
    END