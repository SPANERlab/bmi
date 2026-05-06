WITH averages AS (
    SELECT
        s.pipeline,
        AVG(a.duration) AS duration,
        AVG(a.emissions) * 1000 AS emissions,
        AVG(a.emissions_rate) * 1000 AS emissions_rate,
        AVG(a.cpu_power) AS cpu_power,
        AVG(a.gpu_power) AS gpu_power,
        AVG(a.cpu_energy * 1000) AS cpu_energy,
        AVG(a.gpu_energy * 1000) AS gpu_energy,
        AVG(a.ram_energy * 1000) AS ram_energy,
        AVG(a.energy_consumed * 1000) AS energy_consumed
    FROM READ_CSV_AUTO('{root_dir}/*/*/scores.csv') AS s
    INNER JOIN
        READ_CSV_AUTO('{root_dir}/*/*/emissions/emissions_base_*.csv') AS a
        ON s.codecarbon_task_name = a.task_name
    GROUP BY s.dataset, s.pipeline
),

percentiles AS (
    SELECT
        a.pipeline,

        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY a.duration)
            AS duration_p25,
        PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY a.duration)
            AS duration_p50,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY a.duration)
            AS duration_p75,

        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY a.emissions)
            AS emissions_p25,
        PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY a.emissions)
            AS emissions_p50,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY a.emissions)
            AS emissions_p75,

        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY a.emissions_rate)
            AS emissions_rate_p25,
        PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY a.emissions_rate)
            AS emissions_rate_p50,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY a.emissions_rate)
            AS emissions_rate_p75,

        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY a.cpu_power)
            AS cpu_power_p25,
        PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY a.cpu_power)
            AS cpu_power_p50,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY a.cpu_power)
            AS cpu_power_p75,

        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY a.gpu_power)
            AS gpu_power_p25,
        PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY a.gpu_power)
            AS gpu_power_p50,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY a.gpu_power)
            AS gpu_power_p75,

        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY a.cpu_energy)
            AS cpu_energy_p25,
        PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY a.cpu_energy)
            AS cpu_energy_p50,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY a.cpu_energy)
            AS cpu_energy_p75,

        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY a.gpu_energy)
            AS gpu_energy_p25,
        PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY a.gpu_energy)
            AS gpu_energy_p50,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY a.gpu_energy)
            AS gpu_energy_p75,

        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY a.ram_energy)
            AS ram_energy_p25,
        PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY a.ram_energy)
            AS ram_energy_p50,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY a.ram_energy)
            AS ram_energy_p75,

        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY a.energy_consumed)
            AS energy_consumed_p25,
        PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY a.energy_consumed)
            AS energy_consumed_p50,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY a.energy_consumed)
            AS energy_consumed_p75
    FROM averages AS a
    GROUP BY a.pipeline
),

bounds AS (
    SELECT
        *,

        duration_p25 - 1.5 * (duration_p75 - duration_p25)
            AS duration_lower_fence,
        duration_p75 + 1.5 * (duration_p75 - duration_p25)
            AS duration_upper_fence,

        emissions_p25 - 1.5 * (emissions_p75 - emissions_p25)
            AS emissions_lower_fence,
        emissions_p75 + 1.5 * (emissions_p75 - emissions_p25)
            AS emissions_upper_fence,

        emissions_rate_p25 - 1.5 * (emissions_rate_p75 - emissions_rate_p25)
            AS emissions_rate_lower_fence,
        emissions_rate_p75 + 1.5 * (emissions_rate_p75 - emissions_rate_p25)
            AS emissions_rate_upper_fence,

        cpu_power_p25 - 1.5 * (cpu_power_p75 - cpu_power_p25)
            AS cpu_power_lower_fence,
        cpu_power_p75 + 1.5 * (cpu_power_p75 - cpu_power_p25)
            AS cpu_power_upper_fence,

        gpu_power_p25 - 1.5 * (gpu_power_p75 - gpu_power_p25)
            AS gpu_power_lower_fence,
        gpu_power_p75 + 1.5 * (gpu_power_p75 - gpu_power_p25)
            AS gpu_power_upper_fence,

        cpu_energy_p25 - 1.5 * (cpu_energy_p75 - cpu_energy_p25)
            AS cpu_energy_lower_fence,
        cpu_energy_p75 + 1.5 * (cpu_energy_p75 - cpu_energy_p25)
            AS cpu_energy_upper_fence,

        gpu_energy_p25 - 1.5 * (gpu_energy_p75 - gpu_energy_p25)
            AS gpu_energy_lower_fence,
        gpu_energy_p75 + 1.5 * (gpu_energy_p75 - gpu_energy_p25)
            AS gpu_energy_upper_fence,

        ram_energy_p25 - 1.5 * (ram_energy_p75 - ram_energy_p25)
            AS ram_energy_lower_fence,
        ram_energy_p75 + 1.5 * (ram_energy_p75 - ram_energy_p25)
            AS ram_energy_upper_fence,

        energy_consumed_p25 - 1.5 * (energy_consumed_p75 - energy_consumed_p25)
            AS energy_consumed_lower_fence,
        energy_consumed_p75 + 1.5 * (energy_consumed_p75 - energy_consumed_p25)
            AS energy_consumed_upper_fence
    FROM percentiles
)

SELECT
    b.pipeline,

    ROUND(b.duration_p25, 3) AS duration_p25,
    ROUND(b.duration_p50, 3) AS duration_p50,
    ROUND(b.duration_p75, 3) AS duration_p75,
    ROUND(b.duration_lower_fence, 3) AS duration_lower_fence,
    ROUND(b.duration_upper_fence, 3) AS duration_upper_fence,
    COUNT(CASE WHEN a.duration < b.duration_lower_fence THEN 1 END)
        AS duration_outliers_low,
    COUNT(CASE WHEN a.duration > b.duration_upper_fence THEN 1 END)
        AS duration_outliers_high,

    ROUND(b.emissions_p25, 3) AS emissions_p25,
    ROUND(b.emissions_p50, 3) AS emissions_p50,
    ROUND(b.emissions_p75, 3) AS emissions_p75,
    ROUND(b.emissions_lower_fence, 3) AS emissions_lower_fence,
    ROUND(b.emissions_upper_fence, 3) AS emissions_upper_fence,
    COUNT(CASE WHEN a.emissions < b.emissions_lower_fence THEN 1 END)
        AS emissions_outliers_low,
    COUNT(CASE WHEN a.emissions > b.emissions_upper_fence THEN 1 END)
        AS emissions_outliers_high,

    ROUND(b.emissions_rate_p25, 3) AS emissions_rate_p25,
    ROUND(b.emissions_rate_p50, 3) AS emissions_rate_p50,
    ROUND(b.emissions_rate_p75, 3) AS emissions_rate_p75,
    ROUND(b.emissions_rate_lower_fence, 3) AS emissions_rate_lower_fence,
    ROUND(b.emissions_rate_upper_fence, 3) AS emissions_rate_upper_fence,
    COUNT(CASE WHEN a.emissions_rate < b.emissions_rate_lower_fence THEN 1 END)
        AS emissions_rate_outliers_low,
    COUNT(CASE WHEN a.emissions_rate > b.emissions_rate_upper_fence THEN 1 END)
        AS emissions_rate_outliers_high,

    ROUND(b.cpu_power_p25, 3) AS cpu_power_p25,
    ROUND(b.cpu_power_p50, 3) AS cpu_power_p50,
    ROUND(b.cpu_power_p75, 3) AS cpu_power_p75,
    ROUND(b.cpu_power_lower_fence, 3) AS cpu_power_lower_fence,
    ROUND(b.cpu_power_upper_fence, 3) AS cpu_power_upper_fence,
    COUNT(CASE WHEN a.cpu_power < b.cpu_power_lower_fence THEN 1 END)
        AS cpu_power_outliers_low,
    COUNT(CASE WHEN a.cpu_power > b.cpu_power_upper_fence THEN 1 END)
        AS cpu_power_outliers_high,

    ROUND(b.gpu_power_p25, 3) AS gpu_power_p25,
    ROUND(b.gpu_power_p50, 3) AS gpu_power_p50,
    ROUND(b.gpu_power_p75, 3) AS gpu_power_p75,
    ROUND(b.gpu_power_lower_fence, 3) AS gpu_power_lower_fence,
    ROUND(b.gpu_power_upper_fence, 3) AS gpu_power_upper_fence,
    COUNT(CASE WHEN a.gpu_power < b.gpu_power_lower_fence THEN 1 END)
        AS gpu_power_outliers_low,
    COUNT(CASE WHEN a.gpu_power > b.gpu_power_upper_fence THEN 1 END)
        AS gpu_power_outliers_high,

    ROUND(b.cpu_energy_p25, 3) AS cpu_energy_p25,
    ROUND(b.cpu_energy_p50, 3) AS cpu_energy_p50,
    ROUND(b.cpu_energy_p75, 3) AS cpu_energy_p75,
    ROUND(b.cpu_energy_lower_fence, 3) AS cpu_energy_lower_fence,
    ROUND(b.cpu_energy_upper_fence, 3) AS cpu_energy_upper_fence,
    COUNT(CASE WHEN a.cpu_energy < b.cpu_energy_lower_fence THEN 1 END)
        AS cpu_energy_outliers_low,
    COUNT(CASE WHEN a.cpu_energy > b.cpu_energy_upper_fence THEN 1 END)
        AS cpu_energy_outliers_high,

    ROUND(b.gpu_energy_p25, 3) AS gpu_energy_p25,
    ROUND(b.gpu_energy_p50, 3) AS gpu_energy_p50,
    ROUND(b.gpu_energy_p75, 3) AS gpu_energy_p75,
    ROUND(b.gpu_energy_lower_fence, 3) AS gpu_energy_lower_fence,
    ROUND(b.gpu_energy_upper_fence, 3) AS gpu_energy_upper_fence,
    COUNT(CASE WHEN a.gpu_energy < b.gpu_energy_lower_fence THEN 1 END)
        AS gpu_energy_outliers_low,
    COUNT(CASE WHEN a.gpu_energy > b.gpu_energy_upper_fence THEN 1 END)
        AS gpu_energy_outliers_high,

    ROUND(b.ram_energy_p25, 3) AS ram_energy_p25,
    ROUND(b.ram_energy_p50, 3) AS ram_energy_p50,
    ROUND(b.ram_energy_p75, 3) AS ram_energy_p75,
    ROUND(b.ram_energy_lower_fence, 3) AS ram_energy_lower_fence,
    ROUND(b.ram_energy_upper_fence, 3) AS ram_energy_upper_fence,
    COUNT(CASE WHEN a.ram_energy < b.ram_energy_lower_fence THEN 1 END)
        AS ram_energy_outliers_low,
    COUNT(CASE WHEN a.ram_energy > b.ram_energy_upper_fence THEN 1 END)
        AS ram_energy_outliers_high,

    ROUND(b.energy_consumed_p25, 3) AS energy_consumed_p25,
    ROUND(b.energy_consumed_p50, 3) AS energy_consumed_p50,
    ROUND(b.energy_consumed_p75, 3) AS energy_consumed_p75,
    ROUND(b.energy_consumed_lower_fence, 3) AS energy_consumed_lower_fence,
    ROUND(b.energy_consumed_upper_fence, 3) AS energy_consumed_upper_fence,
    COUNT(
        CASE WHEN a.energy_consumed < b.energy_consumed_lower_fence THEN 1 END
    ) AS energy_consumed_outliers_low,
    COUNT(
        CASE WHEN a.energy_consumed > b.energy_consumed_upper_fence THEN 1 END
    ) AS energy_consumed_outliers_high
FROM bounds AS b
INNER JOIN averages AS a ON b.pipeline = a.pipeline
GROUP BY ALL
ORDER BY b.pipeline
