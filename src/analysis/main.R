library(here)
source(here("src/analysis/meta.R"))

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
