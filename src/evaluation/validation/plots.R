library(ggplot2)

run <- function() {
  ess_bulk()
  ess_tail()
  mean_mcse()
  std_mcse()
}

ess_bulk <- function() {
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
    labs(x = "Bulk ESS", y = "Pipeline", title = "P05/P50/P95 Interval Plot: Bulk ESS") +
    theme_minimal() +
    theme(plot.title = element_text(hjust = 0.5))

  ggsave("ess_bulk.png", plot = p, width = 6, height = 4, dpi = 300)
}

ess_tail <- function() {
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
    labs(x = "Bulk ESS", y = "Pipeline", title = "P05/P50/P95 Interval Plot: Tail ESS") +
    theme_minimal() +
    theme(plot.title = element_text(hjust = 0.5))

  ggsave("ess_tail.png", plot = p, width = 6, height = 4, dpi = 300)
}

mean_mcse <- function() {
  df <- data.frame(
    pipeline = c("BDCNN", "BSCNN", "CSPBLDA", "CSPGP", "TSBLR", "TSGP"),
    median = c(0.001, 0.001, 0.001, 0.017, 0.001, 0.013),
    p05 = c(0.0, 0.0, 0.0, 0.012, 0.0, 0.011),
    p95 = c(0.002, 0.001, 0.002, 0.038, 0.002, 0.024)
  )

  p <- ggplot(df, aes(x = median, y = reorder(pipeline, median))) +
    geom_segment(aes(x = p05, xend = p95, yend = pipeline)) +
    geom_point() +
    labs(x = "Bulk ESS", y = "Pipeline", title = "P05/P50/P95 Interval Plot: Mean MCSE") +
    theme_minimal() +
    theme(plot.title = element_text(hjust = 0.5))

  ggsave("mean_mcse.png", plot = p, width = 6, height = 4, dpi = 300)
}

std_mcse <- function() {
  df <- data.frame(
    pipeline = c("BDCNN", "BSCNN", "CSPBLDA", "CSPGP", "TSBLR", "TSGP"),
    median = c(0.001, 0.001, 0.001, 0.02, 0.001, 0.022),
    p05 = c(0.001, 0.001, 0.0, 0.016, 0.001, 0.019),
    p95 = c(0.002, 0.001, 0.001, 0.028, 0.002, 0.025)
  )

  p <- ggplot(df, aes(x = median, y = reorder(pipeline, median))) +
    geom_segment(aes(x = p05, xend = p95, yend = pipeline)) +
    geom_point() +
    labs(x = "Bulk ESS", y = "Pipeline", title = "P05/P50/P95 Interval Plot: Std. MCSE") +
    theme_minimal() +
    theme(plot.title = element_text(hjust = 0.5))

  ggsave("std_mcse.png", plot = p, width = 6, height = 4, dpi = 300)
}
