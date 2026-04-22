SELECT
    ROUND(MIN(score_ece), 3) AS min,
    ROUND(MAX(score_ece), 3) AS max,
    ROUND(MEDIAN(score_ece), 3) AS median,
    ROUND(PERCENTILE_CONT(0.05) WITHIN GROUP (ORDER BY score_ece), 3) AS p05,
    ROUND(PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY score_ece), 3) AS p95
FROM read_csv_auto('{input_file}')
WHERE pipeline IN ('CSPLDA', 'CSPSVM', 'TSLR', 'TSSVM', 'SCNN', 'DCNN')
