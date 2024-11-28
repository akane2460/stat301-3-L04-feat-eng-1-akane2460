# L04 Feature Engineering I ----
# Model selection/comparison & analysis

# Load package(s) & set seed ----
library(tidymodels)
library(tidyverse)
library(here)

# Handle conflicts
tidymodels_prefer()

# load model results
load(here("results/tune_nn_simple.rda"))
load(here("results/tune_nn_complex.rda"))

runtimes_models <- bind_rows(tictoc_simple, tictoc_complex) |>
  select(runtime)

runtimes_models <- runtimes_models |>
  mutate(model = c("Simple Recipe", 
                   "Complex Recipe"))

runtimes_models |> 
  select(model, everything()) |> 
  knitr::kable()

model_results <- as_workflow_set(
  simple_nn = tune_neural_net_simple,
  complex_nn = tune_neural_net_complex
)

model_results_accuracy <- model_results |>
  collect_metrics() |>
  filter(.metric == "accuracy") |>
  slice_min(mean, by = wflow_id) |> 
  select(wflow_id, mean, std_err)

model_results_accuracy |> 
  knitr::kable()