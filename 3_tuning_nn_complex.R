# L04 Feature Engineering I ----
# Single layer neural net tuning, complex imputation ----

# Load package(s) ----
library(tidyverse)
library(tidymodels)
library(tictoc)
library(here)
library(nnet)
library(doMC)

# Handle conflicts
tidymodels_prefer()

# parallel processing ----
num_cores <- parallel::detectCores(logical = TRUE)
registerDoMC(cores = num_cores - 1)

# load resamples ----
load(here("data/adult_folds.rda"))

# load preprocessing/recipe ----
load(here("recipes/recipe_complex.rda"))

# model specifications ----
neural_net_spec <- 
  mlp(hidden_units = tune(), penalty = tune()) |> 
  set_mode("classification") |> 
  set_engine("nnet")

# define workflow ----
neural_net_model <- workflow() |> 
  add_model(neural_net_spec) |> 
  add_recipe(recipe_complex)

# hyperparameter tuning values ----
neural_net_params <- hardhat::extract_parameter_set_dials(neural_net_model)

neural_net_grid <- grid_latin_hypercube(neural_net_params, size = 50)

# tune/fit workflow/model ----
tic.clearlog() # clear log
tic("Neural Network: Complex Recipe") # start clock

# tuning code in here
tune_neural_net_complex <- neural_net_model |> 
  tune_grid(
    resamples = adult_folds,
    grid = neural_net_grid,
    control = control_grid(save_workflow = TRUE),
    metrics = metric_set(accuracy)
  )

toc(log = TRUE)

# Extract runtime info
time_log <- tic.log(format = FALSE)

tictoc_complex <- tibble(
  model = time_log[[1]]$msg,
  start_time = time_log[[1]]$tic,
  end_time = time_log[[1]]$toc,
  runtime = end_time - start_time
)

# write out results (fitted/trained workflows & runtime info) ----
save(tune_neural_net_complex, tictoc_complex,
     file = here("results/tune_nn_complex.rda"))
