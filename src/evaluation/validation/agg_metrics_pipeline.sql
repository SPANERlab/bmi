SELECT
    pipeline,
    ROUND(MIN(ess_bulk), 3) AS min_ess_bulk,
    ROUND(MAX(ess_bulk), 3) AS max_ess_bulk,
    ROUND(MEDIAN(ess_bulk), 3) AS median_ess_bulk,
    ROUND(PERCENTILE_CONT(0.05) within GROUP(ORDER BY ess_bulk), 3)
        AS p05_ess_bulk,
    ROUND(PERCENTILE_CONT(0.95) within GROUP(ORDER BY ess_bulk), 3)
        AS p95_ess_bulk,
    ROUND(MIN(ess_tail), 3) AS min_ess_tail,
    ROUND(MAX(ess_tail), 3) AS max_ess_tail,
    ROUND(MEDIAN(ess_tail), 3) AS median_ess_tail,
    ROUND(PERCENTILE_CONT(0.05) within GROUP(ORDER BY ess_tail), 3)
        AS p05_ess_tail,
    ROUND(PERCENTILE_CONT(0.95) within GROUP(ORDER BY ess_tail), 3)
        AS p95_ess_tail,
    ROUND(MIN(mcse_mean), 3) AS min_mcse_mean,
    ROUND(MAX(mcse_mean), 3) AS max_mcse_mean,
    ROUND(MEDIAN(mcse_mean), 3) AS median_mcse_mean,
    ROUND(PERCENTILE_CONT(0.05) within GROUP(ORDER BY mcse_mean), 3)
        AS p05_mcse_mean,
    ROUND(PERCENTILE_CONT(0.95) within GROUP(ORDER BY mcse_mean), 3)
        AS p95_mcse_mean,
    ROUND(MIN(mcse_sd), 3) AS min_mcse_sd,
    ROUND(MAX(mcse_sd), 3) AS max_mcse_sd,
    ROUND(MEDIAN(mcse_sd), 3) AS median_mcse_sd,
    ROUND(PERCENTILE_CONT(0.05) within GROUP(ORDER BY mcse_sd), 3)
        AS p05_mcse_sd,
    ROUND(PERCENTILE_CONT(0.95) within GROUP(ORDER BY mcse_sd), 3)
        AS p95_mcse_sd
FROM READ_CSV_AUTO('{input_file}')
GROUP BY pipeline
ORDER BY pipeline
