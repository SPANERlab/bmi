SELECT
    ROUND(MIN(score_mce), 3) AS min,
    ROUND(MAX(score_mce), 3) AS max,
    ROUND(MEDIAN(score_mce), 3) AS median,
    ROUND(PERCENTILE_CONT(0.05) WITHIN GROUP (ORDER BY score_mce), 3) AS p05,
    ROUND(PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY score_mce), 3) AS p95
FROM read_csv_auto('{input_file}')
WHERE pipeline IN ('CSPLDA', 'CSPSVM', 'TSLR', 'TSSVM', 'SCNN', 'DCNN')
