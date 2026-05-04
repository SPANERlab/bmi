SELECT
    dataset,
    pipeline,
    MIN(ess_bulk_min) AS ess_bulk,
    MIN(ess_tail_min) AS ess_tail,
    MAX(r_hat_max) AS r_hat,
    MAX(mcse_mean_max) AS mcse_mean,
    MAX(mcse_sd_max) AS mcse_sd,
    SUM(divergences) AS divergences
FROM READ_CSV_AUTO('{input_file}')
GROUP BY dataset, pipeline
ORDER BY dataset, pipeline
