# Data wrangling and meta-analysis.
#
# References
# ----------
# [1] https://duckdb.org/docs/current/guides/file_formats/csv_import
# [2] https://doing-meta.guide/multilevel-ma
# [3] https://www.rdocumentation.org/packages/metafor/versions/2.4-0/topics/rma.mv

library(tidyverse)
library(duckdb)
library(glue)
library(here)
library(metafor)
library(dotenv)
library(dmetar)
library(wildmeta)
library(clubSandwich)

load_dot_env()

run <- function() {
  avg() |>
    diff() |>
    meta()

  metrics <- c("score_auroc", "score_mcc", "score_nll", "score_brier", "score_ece", "score_mce")
  for (metric in metrics) {
    # Fit 3-level meta-analysis
    output <- capture.output(fit(metric = metric))
    writeLines(output, paste0("results_", metric, ".txt"))

    # Fit 3-level meta-analysis with moderator
    output <- capture.output(fit_mods(metric = metric))
    writeLines(output, paste0("results_mods_", metric, ".txt"))
  }
}

avg <- function(
  root_dir = file.path(Sys.getenv("DATA_PATH"), "metrics"),
  sql_file = here("src/analysis/avg.sql"),
  output_file = here("avg.csv")
) {
  con <- dbConnect(duckdb())
  on.exit(dbDisconnect(con), add = TRUE)

  query <- glue(readLines(sql_file) |> paste(collapse = "\n"), root_dir = root_dir)
  dbGetQuery(con, query) |> write_csv(output_file)

  output_file
}

diff <- function(
  agg_file = here("avg.csv"),
  sql_file = here("src/analysis/diff.sql"),
  output_file = here("diff.csv")
) {
  con <- dbConnect(duckdb())
  on.exit(dbDisconnect(con), add = TRUE)

  query <- glue(readLines(sql_file) |> paste(collapse = "\n"), agg_file = agg_file)
  dbGetQuery(con, query) |> write_csv(output_file)

  output_file
}

meta <- function(
  diff_file = here("diff.csv"),
  sql_file = here("src/analysis/meta.sql"),
  output_file = here("meta.csv")
) {
  con <- dbConnect(duckdb())
  on.exit(dbDisconnect(con), add = TRUE)

  query <- glue(readLines(sql_file) |> paste(collapse = "\n"), diff_file = diff_file, metric = metric)
  dbGetQuery(con, query) |> write_csv(output_file)

  output_file
}

fit <- function(
  meta_file = here("meta.csv"),
  metric = "score_auroc"
) {
  # Fit 3-level meta-analysis
  df <- read.csv(meta_file)
  df$yi <- df[[paste0("yi_", metric)]]
  df$vi <- df[[paste0("vi_", metric)]]
  model <- rma.mv(
    yi = yi,
    V = vi,
    random = ~ 1 | dataset / pipeline_family,
    data = df,
    test = "t",
    method = "REML"
  )
  print(summary(model))

  # Compute variance across levels
  print(var.comp(model))

  # Run ANOVA against 2-level meta-analysis
  l2_model <- update(model, sigma2 = c(NA, 0))
  print(anova(model, l2_model))

  # Measure prediction interval
  print(predict(model))

  # Robust variance estimation
  print(conf_int(model, vcov = "CR2"))
  print(coef_test(model, vcov = "CR2"))
}

fit_mods <- function(
  meta_file = here("meta.csv"),
  metric = "score_auroc"
) {
  # Fit 3-level meta-analysis
  df <- read.csv(meta_file)
  df$yi <- df[[paste0("yi_", metric)]]
  df$vi <- df[[paste0("vi_", metric)]]
  model <- rma.mv(
    yi = yi,
    V = vi,
    random = ~ 1 | dataset / pipeline_family,
    mods = ~ scale(samples),
    data = df,
    test = "t",
    method = "REML"
  )
  print(summary(model))

  # Compute variance across levels
  print(var.comp(model))

  # Run ANOVA against 2-level meta-analysis
  l2_model <- update(model, sigma2 = c(NA, 0))
  print(anova(model, l2_model))

  # Measure prediction interval
  print(predict(model, newmods = 0))

  # Robust variance estimation
  print(conf_int(model, vcov = "CR2"))
  print(coef_test(model, vcov = "CR2"))

  # Bootstrap 3-level meta-analysis
  constraints <- constrain_zero(2, coefs = coef(model))
  cw_boot <- Wald_test_cwb(
    full_model = model,
    constraints = constraints,
    adjust = "CR2",
    R = 2000,
    seed = as.integer(Sys.getenv("RANDOM_STATE"))
  )
  print(cw_boot)
}
