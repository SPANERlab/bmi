SELECT
    ROUND(MIN(score_nll), 3) AS min_score,
    ROUND(MAX(score_nll), 3) AS max_score,
    ROUND(MEDIAN(score_nll), 3) AS median_score,
    ROUND(PERCENTILE_CONT(0.05) within GROUP(ORDER BY score_nll), 3) AS p05_score,
    ROUND(PERCENTILE_CONT(0.95) within GROUP(ORDER BY score_nll), 3) AS p95_score
FROM READ_CSV_AUTO('{input_file}')
WHERE pipeline IN ('CSPLDA', 'CSPSVM', 'TSLR', 'TSSVM', 'SCNN', 'DCNN')
