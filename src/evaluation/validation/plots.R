library(ggplot2)

run <- function() {
  pipeline_ess_bulk()
  pipeline_ess_tail()
  pipeline_mcse_mean()
  pipeline_mcse_std()
  
  dataset_ess_bulk()
  dataset_ess_tail()
  dataset_mcse_mean()
  dataset_mcse_std()
}

pipeline_ess_bulk <- function() {
  df <- data.frame(
    pipeline = c("BDCNN", "BSCNN", "CSPBLDA", "CSPGP", "TSBLR", "TSGP"),
    median = c(4264, 4502, 1572, 635, 4727, 871.5),
    p05 = c(2908.25, 3590.85, 1100.55, 299.35, 3223.15, 351.85),
    p95 = c(5710.8, 6060.4, 3104.5, 1204.3, 6527.2, 1478.05)
  )

  p <- ggplot(df, aes(x = median, y = reorder(pipeline, median))) +
    geom_segment(aes(x = p05, xend = p95, yend = pipeline)) +
    geom_point() +
    geom_vline(xintercept = 400, linetype = "dashed") +
    labs(x = "Bulk ESS", y = "Pipeline", title = "Pipeline P05/P50/P95 Interval Plot: Bulk ESS") +
    theme_minimal() +
    theme(plot.title = element_text(hjust = 0.5))

  ggsave("pipeline_ess_bulk.png", plot = p, width = 6, height = 4, dpi = 300)
}

pipeline_ess_tail <- function() {
  df <- data.frame(
    pipeline = c("BDCNN", "BSCNN", "CSPBLDA", "CSPGP", "TSBLR", "TSGP"),
    median = c(1986.0, 1957.5, 2092.0, 1158.0, 2194.0, 1589.0),
    p05 = c(1509.15, 1743.0, 1420.35, 437.4, 2036.75, 653.3),
    p95 = c(2189.55, 2033.8, 2553.5, 1830.9, 2600.7, 2009.35)
  )

  p <- ggplot(df, aes(x = median, y = reorder(pipeline, median))) +
    geom_segment(aes(x = p05, xend = p95, yend = pipeline)) +
    geom_point() +
    geom_vline(xintercept = 400, linetype = "dashed") +
    labs(x = "Tail ESS", y = "Pipeline", title = "Pipeline P05/P50/P95 Interval Plot: Tail ESS") +
    theme_minimal() +
    theme(plot.title = element_text(hjust = 0.5))

  ggsave("pipeline_ess_tail.png", plot = p, width = 6, height = 4, dpi = 300)
}

pipeline_mcse_mean <- function() {
  df <- data.frame(
    pipeline = c("BDCNN", "BSCNN", "CSPBLDA", "CSPGP", "TSBLR", "TSGP"),
    median = c(0.001, 0.001, 0.001, 0.017, 0.001, 0.013),
    p05 = c(0.0, 0.0, 0.0, 0.012, 0.0, 0.011),
    p95 = c(0.002, 0.001, 0.002, 0.038, 0.002, 0.024)
  )

  p <- ggplot(df, aes(x = median, y = reorder(pipeline, median))) +
    geom_segment(aes(x = p05, xend = p95, yend = pipeline)) +
    geom_point() +
    labs(x = "Mean MCSE", y = "Pipeline", title = "Pipeline P05/P50/P95 Interval Plot: Mean MCSE") +
    theme_minimal() +
    theme(plot.title = element_text(hjust = 0.5))

  ggsave("pipeline_mcse_mean.png", plot = p, width = 6, height = 4, dpi = 300)
}

pipeline_mcse_std <- function() {
  df <- data.frame(
    pipeline = c("BDCNN", "BSCNN", "CSPBLDA", "CSPGP", "TSBLR", "TSGP"),
    median = c(0.001, 0.001, 0.001, 0.02, 0.001, 0.022),
    p05 = c(0.001, 0.001, 0.0, 0.016, 0.001, 0.019),
    p95 = c(0.002, 0.001, 0.001, 0.028, 0.002, 0.025)
  )

  p <- ggplot(df, aes(x = median, y = reorder(pipeline, median))) +
    geom_segment(aes(x = p05, xend = p95, yend = pipeline)) +
    geom_point() +
    labs(x = "Std. MCSE", y = "Pipeline", title = "Pipeline P05/P50/P95 Interval Plot: Std. MCSE") +
    theme_minimal() +
    theme(plot.title = element_text(hjust = 0.5))

  ggsave("pipeline_mcse_std.png", plot = p, width = 6, height = 4, dpi = 300)
}

dataset_ess_bulk <- function() {
  df <- data.frame(
    dataset = c("BNCI2014_001", "BNCI2014_004", "Brandl2020", "Chang2025", "Cho2017", "Dreyer2023", "Forenzo2023", "GrosseWentrup2009", "GuttmannFlury2025_MI", "HefmiIch2025", "Kumar2024", "Lee2019_MI", "Liu2024", "PhysionetMI", "Schirrmeister2017", "Shin2017A", "Stieger2021", "Weibo2014", "Yang2025", "Zhou2020"),
    median = c(2180.5, 2780.5, 2567.5, 3238.5, 2941.0, 2497.0, 2677.5, 2561.0, 3574.5, 3057.0, 3262.0, 2832.5, 2651.5, 2866.0, 3021.0, 2759.5, 2260.0, 2582.0, 2288.5, 3363.5),
    p05 = c(773.75, 658.25, 855.5, 770.0, 695.75, 405.75, 572.75, 1138.25, 1035.75, 588.0, 503.75, 568.5, 454.0, 562.0, 464.75, 730.25, 427.25, 770.25, 762.5, 429.5),
    p95 = c(3837.5, 4900.75, 6166.75, 5466.0, 5819.5, 4493.0, 4711.5, 5907.75, 6001.0, 5542.0, 4289.75, 5508.0, 4675.25, 5918.25, 5244.75, 5431.75, 4437.5, 6006.0, 4032.25, 6219.5)
  )

  p <- ggplot(df, aes(x = median, y = reorder(dataset, median))) +
    geom_segment(aes(x = p05, xend = p95, yend = dataset)) +
    geom_point() +
    geom_vline(xintercept = 400, linetype = "dashed") +
    labs(x = "Bulk ESS", y = "Dataset", title = "Dataset P05/P50/P95 Interval Plot: Bulk ESS") +
    theme_minimal() +
    theme(plot.title = element_text(hjust = 0.5))

  ggsave("dataset_ess_bulk.png", plot = p, width = 6, height = 4, dpi = 300)
}

dataset_ess_tail <- function() {
  df <- data.frame(
    dataset = c("BNCI2014_001", "BNCI2014_004", "Brandl2020", "Chang2025", "Cho2017", "Dreyer2023", "Forenzo2023", "GrosseWentrup2009", "GuttmannFlury2025_MI", "HefmiIch2025", "Kumar2024", "Lee2019_MI", "Liu2024", "PhysionetMI", "Schirrmeister2017", "Shin2017A", "Stieger2021", "Weibo2014", "Yang2025", "Zhou2020"),
    median = c(1988.0, 1944.0, 1869.0, 2134.5, 1893.5, 2015.0, 1926.0, 1877.0, 2010.5, 1840.5, 1921.0, 2065.5, 1859.5, 1716.5, 1892.5, 1717.5, 1862.5, 1807.0, 2020.0, 1862.0),
    p05 = c(1034.25, 903.5, 1615.75, 1518.0, 1240.5, 580.75, 567.5, 1550.5, 928.25, 744.0, 1102.25, 1096.5, 983.0, 914.5, 854.5, 1268.5, 798.75, 1286.5, 1349.0, 797.25),
    p95 = c(2165.0, 2308.75, 2101.0, 2521.25, 2266.5, 2179.25, 2216.25, 2066.0, 2378.5, 2125.0, 2560.5, 2310.0, 2493.75, 2013.75, 2260.0, 2523.75, 2323.5, 2174.25, 2342.0, 2109.5)
  )

  p <- ggplot(df, aes(x = median, y = reorder(dataset, median))) +
    geom_segment(aes(x = p05, xend = p95, yend = dataset)) +
    geom_point() +
    geom_vline(xintercept = 400, linetype = "dashed") +
    labs(x = "Tail ESS", y = "Dataset", title = "Dataset P05/P50/P95 Interval Plot: Tail ESS") +
    theme_minimal() +
    theme(plot.title = element_text(hjust = 0.5))

  ggsave("dataset_ess_tail.png", plot = p, width = 6, height = 4, dpi = 300)
}

dataset_mcse_mean <- function() {
  df <- data.frame(
    dataset = c("BNCI2014_001", "BNCI2014_004", "Brandl2020", "Chang2025", "Cho2017", "Dreyer2023", "Forenzo2023", "GrosseWentrup2009", "GuttmannFlury2025_MI", "HefmiIch2025", "Kumar2024", "Lee2019_MI", "Liu2024", "PhysionetMI", "Schirrmeister2017", "Shin2017A", "Stieger2021", "Weibo2014", "Yang2025", "Zhou2020"),
    median = c(0.003, 0.001, 0.001, 0.001, 0.001, 0.001, 0.002, 0.001, 0.001, 0.002, 0.001, 0.001, 0.002, 0.002, 0.002, 0.002, 0.0, 0.002, 0.001, 0.001),
    p05 = c(0.001, 0.0, 0.0, 0.001, 0.0, 0.0, 0.0, 0.0, 0.001, 0.0, 0.0, 0.0, 0.001, 0.0, 0.001, 0.001, 0.0, 0.001, 0.0, 0.0),
    p95 = c(0.016, 0.021, 0.012, 0.016, 0.017, 0.021, 0.03, 0.012, 0.03, 0.036, 0.025, 0.017, 0.032, 0.02, 0.017, 0.017, 0.017, 0.015, 0.014, 0.047)
  )

  p <- ggplot(df, aes(x = median, y = reorder(dataset, median))) +
    geom_segment(aes(x = p05, xend = p95, yend = dataset)) +
    geom_point() +
    labs(x = "Mean MCSE", y = "Dataset", title = "Dataset P05/P50/P95 Interval Plot: Mean MCSE") +
    theme_minimal() +
    theme(plot.title = element_text(hjust = 0.5))

  ggsave("dataset_mcse_mean.png", plot = p, width = 6, height = 4, dpi = 300)
}

dataset_mcse_std <- function() {
  df <- data.frame(
    dataset = c("BNCI2014_001", "BNCI2014_004", "Brandl2020", "Chang2025", "Cho2017", "Dreyer2023", "Forenzo2023", "GrosseWentrup2009", "GuttmannFlury2025_MI", "HefmiIch2025", "Kumar2024", "Lee2019_MI", "Liu2024", "PhysionetMI", "Schirrmeister2017", "Shin2017A", "Stieger2021", "Weibo2014", "Yang2025", "Zhou2020"),
    median = c(0.002, 0.001, 0.001, 0.002, 0.001, 0.001, 0.002, 0.001, 0.002, 0.002, 0.001, 0.001, 0.002, 0.001, 0.002, 0.002, 0.001, 0.002, 0.001, 0.001),
    p05 = c(0.001, 0.0, 0.001, 0.001, 0.0, 0.0, 0.001, 0.001, 0.001, 0.001, 0.0, 0.0, 0.001, 0.001, 0.001, 0.001, 0.0, 0.001, 0.0, 0.001),
    p95 = c(0.021, 0.026, 0.02, 0.018, 0.019, 0.023, 0.022, 0.022, 0.027, 0.024, 0.023, 0.021, 0.027, 0.024, 0.022, 0.02, 0.019, 0.021, 0.021, 0.021)
  )

  p <- ggplot(df, aes(x = median, y = reorder(dataset, median))) +
    geom_segment(aes(x = p05, xend = p95, yend = dataset)) +
    geom_point() +
    labs(x = "Std. MCSE", y = "Dataset", title = "Dataset P05/P50/P95 Interval Plot: Std. MCSE") +
    theme_minimal() +
    theme(plot.title = element_text(hjust = 0.5))

  ggsave("dataset_mcse_std.png", plot = p, width = 6, height = 4, dpi = 300)
}
