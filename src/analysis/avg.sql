WITH subject_avg AS (
    SELECT
        dataset,
        pipeline,
        subject,
        AVG(samples) AS samples,
        AVG(samples_test) AS samples_test,
        AVG(time) AS duration,
        AVG(carbon_emission) AS carbon_emission,
        AVG(-score_nll) AS score_nll,
        AVG(-score_brier) AS score_brier,
        AVG(score_auroc) AS score_auroc,
        AVG(score_mcc) AS score_mcc,
        AVG(-score_ece) AS score_ece,
        AVG(-score_mce) AS score_mce
    FROM READ_CSV_AUTO('{root_dir}/*/*/scores.csv')
    GROUP BY dataset, pipeline, subject
)

SELECT
    dataset,
    pipeline,
    AVG(samples) AS samples,
    AVG(samples_test) AS samples_test,
    AVG(duration) AS duration,
    AVG(carbon_emission) AS carbon_emission,
    AVG(score_nll) AS score_nll,
    AVG(score_brier) AS score_brier,
    AVG(score_auroc) AS score_auroc,
    AVG(score_mcc) AS score_mcc,
    AVG(score_ece) AS score_ece,
    AVG(score_mce) AS score_mce
FROM subject_avg
GROUP BY dataset, pipeline
ORDER BY dataset, pipeline
