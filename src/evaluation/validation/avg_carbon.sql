SELECT
    s.dataset,
    s.pipeline,
    ROUND(AVG(s.samples), 3) AS samples,
    ROUND(AVG(s.samples_test), 3) AS samples_test,
    ROUND(AVG(e.duration), 3) AS duration,
    ROUND(AVG(e.emissions) * 1000, 3) AS emissions,
    ROUND(AVG(e.emissions_rate) * 1000, 3) AS emissions_rate,
    ROUND(AVG(e.cpu_power), 3) AS cpu_power,
    ROUND(AVG(e.gpu_power), 3) AS gpu_power,
    ROUND(AVG(e.ram_power), 3) AS ram_power,
    ROUND(AVG(e.cpu_energy * 1000), 3) AS cpu_energy,
    ROUND(AVG(e.gpu_energy * 1000), 3) AS gpu_energy,
    ROUND(AVG(e.ram_energy * 1000), 3) AS ram_energy,
    ROUND(AVG(e.energy_consumed * 1000), 3) AS energy_consumed
FROM READ_CSV_AUTO('{root_dir}/*/*/scores.csv') AS s
INNER JOIN READ_CSV_AUTO('{root_dir}/*/*/emissions/emissions_base_*.csv') AS e
    ON s.codecarbon_task_name = e.task_name
GROUP BY s.dataset, s.pipeline
ORDER BY s.dataset, s.pipeline
