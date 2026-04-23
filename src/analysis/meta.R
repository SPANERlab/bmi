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
    output_dir <- file.path("output", metric, "intercept")
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    output <- capture.output(fit(metric = metric, output_dir = output_dir))
    writeLines(output, file.path(output_dir, "results.txt"))

    # Fit 3-level meta-analysis with moderator
    output_dir <- file.path("output", metric, "moderator")
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    output <- capture.output(fit_mods(metric = metric, output_dir = output_dir))
    writeLines(output, file.path(output_dir, "results.txt"))
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
  avg_file = here("avg.csv"),
  sql_file = here("src/analysis/diff.sql"),
  output_file = here("diff.csv")
) {
  con <- dbConnect(duckdb())
  on.exit(dbDisconnect(con), add = TRUE)

  query <- glue(readLines(sql_file) |> paste(collapse = "\n"), avg_file = avg_file)
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

  query <- glue(readLines(sql_file) |> paste(collapse = "\n"), diff_file = diff_file)
  dbGetQuery(con, query) |> write_csv(output_file)

  output_file
}

fit <- function(
  meta_file = here("meta.csv"),
  metric,
  output_dir
) {
  # Fit 3-level meta-analysis
  df <- read.csv(meta_file)
  df$yi <- df[[paste0("yi_", metric)]]
  df$vi <- df[[paste0("vi_", metric)]]
  model <- rma.mv(
    yi = yi,
    V = vi,
    random = ~ 1 | dataset / family,
    data = df,
    test = "t",
    method = "REML"
  )
  print(summary(model))

  # Save forest plot
  plot_path <- file.path(output_dir, "forest.png")
  png(plot_path, width = 3000, height = 2400, res = 300)
  forest(
    model,
    slab = paste(df$dataset, df$family, sep = " / "),
    xlab = paste0("Effect Size: ", toupper(metric)),
    header = c("Study / Pipeline", "Estimate [95% CI]"),
    refline = 0,
    annotate = TRUE,
    order = "obs"
  )
  dev.off()

  # Compute variance across levels
  print(var.comp(model))

  # Run ANOVA against 2-level meta-analysis
  l2_model <- update(model, sigma2 = c(NA, 0))
  print(anova(model, l2_model))

  # Measure prediction interval
  print(predict(model))

  # Sensitivity analysis
  rhos <- c(0.2, 0.4, 0.6, 0.8)
  for (rho in rhos) {
    # Correlated and hierarchical effects modeling
    v <- with(df, impute_covariance_matrix(vi = vi, cluster = dataset, r = rho))
    che_model <- rma.mv(
      yi = yi,
      V = v,
      random = ~ 1 | dataset / family,
      data = df,
      test = "t",
      method = "REML",
      sparse = TRUE
    )

    # Robust variance estimation
    print(conf_int(che_model, vcov = "CR2"))
    print(coef_test(che_model, vcov = "CR2"))

    # Save forest plot
    plots_dir <- file.path(output_dir, "rve")
    dir.create(plots_dir, recursive = TRUE, showWarnings = FALSE)
    plot_path <- file.path(plots_dir, paste0("forest_rho_", rho, ".png"))
    png(plot_path, width = 3000, height = 2400, res = 300)
    forest(
      che_model,
      slab = paste(df$dataset, df$family, sep = " / "),
      xlab = paste0("Effect Size: ", toupper(metric), " (rho=", rho, ")"),
      header = c("Study / Pipeline", "Estimate [95% CI]"),
      refline = 0,
      annotate = TRUE,
      order = "obs"
    )
    dev.off()
  }
}

fit_mods <- function(
  meta_file = here("meta.csv"),
  metric,
  output_dir
) {
  # Fit 3-level meta-analysis
  df <- read.csv(meta_file)
  df$yi <- df[[paste0("yi_", metric)]]
  df$vi <- df[[paste0("vi_", metric)]]
  model <- rma.mv(
    yi = yi,
    V = vi,
    random = ~ 1 | dataset / family,
    mods = ~ scale(samples),
    data = df,
    test = "t",
    method = "REML"
  )
  print(summary(model))

  # Save forest plot
  plot_path <- file.path(output_dir, "forest.png")
  png(plot_path, width = 3000, height = 2400, res = 300)
  forest(
    model,
    slab = paste(df$dataset, df$family, sep = " / "),
    xlab = paste0("Effect Size: ", toupper(metric)),
    header = c("Study / Pipeline", "Estimate [95% CI]"),
    refline = 0,
    annotate = TRUE,
    order = "obs"
  )
  dev.off()

  # Compute variance across levels
  print(var.comp(model))

  # Run ANOVA against 2-level meta-analysis
  l2_model <- update(model, sigma2 = c(NA, 0))
  print(anova(model, l2_model))

  # Measure prediction interval
  print(predict(model, newmods = 0))

  # Sensitivity analysis
  rhos <- c(0.2, 0.4, 0.6, 0.8)
  for (rho in rhos) {
    # Correlated and hierarchical effects modeling
    v <- with(df, impute_covariance_matrix(vi = vi, cluster = dataset, r = rho))
    che_model <- rma.mv(
      yi = yi,
      V = v,
      random = ~ 1 | dataset / family,
      mods = ~ scale(samples),
      data = df,
      test = "t",
      method = "REML",
      sparse = TRUE
    )

    # Robust variance estimation
    print(conf_int(che_model, vcov = "CR2"))
    print(coef_test(che_model, vcov = "CR2"))

    # Save forest plot
    plots_dir <- file.path(output_dir, "rve")
    dir.create(plots_dir, recursive = TRUE, showWarnings = FALSE)
    plot_path <- file.path(plots_dir, paste0("forest_rho_", rho, ".png"))
    png(plot_path, width = 3000, height = 2400, res = 300)
    forest(
      che_model,
      slab = paste(df$dataset, df$family, sep = " / "),
      xlab = paste0("Effect Size: ", toupper(metric), " (rho=", rho, ")"),
      header = c("Study / Pipeline", "Estimate [95% CI]"),
      refline = 0,
      annotate = TRUE,
      order = "obs"
    )
    dev.off()

    # Bootstrap 3-level meta-analysis
    constraints <- constrain_zero(2, coefs = coef(che_model))
    cw_boot <- Wald_test_cwb(
      full_model = che_model,
      constraints = constraints,
      adjust = "CR2",
      R = 2000,
      seed = as.integer(Sys.getenv("RANDOM_STATE"))
    )
    print(cw_boot)

    # Save forest plot
    plots_dir <- file.path(output_dir, "cwb")
    dir.create(plots_dir, recursive = TRUE, showWarnings = FALSE)
    plot_path <- file.path(plots_dir, paste0("forest_rho_", rho, ".png"))
    png(plot_path, width = 3000, height = 2400, res = 300)
    forest(
      che_model,
      slab = paste(df$dataset, df$family, sep = " / "),
      xlab = paste0("Effect Size: ", toupper(metric), " (rho=", rho, ")"),
      header = c("Study / Pipeline", "Estimate [95% CI]"),
      refline = 0,
      annotate = TRUE,
      order = "obs"
    )
    dev.off()
  }
}
