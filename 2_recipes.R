# L04 Feature Engineering I ----
# Setup preprocessing/recipes/feature engineering

# Load package(s) ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load training data ----
load(here("data/adult_train.rda"))

###############################################################################
# Recipe for Exercise 1: recipe_basic
###############################################################################
recipe_basic <- recipe(income ~., data = adult_train) |>
  step_rm(name) |>
  step_impute_mode(occupation, workclass, native_country) |>
  step_impute_mean(education_num, hours_per_week) |>
  step_dummy(all_nominal_predictors()) |>
  step_zv(all_predictors()) |>
  step_normalize(all_numeric_predictors())

# prep(recipe_basic) |>
#   bake(new_data = NULL)

save(
  recipe_basic,
  file = here("recipes/recipe_basic.rda")
)

###############################################################################
# Recipes for Exercise 3: recipe_simple & recipe_complex
###############################################################################
#### Task 1

# recipe_simple
  recipe_simple <- recipe(income ~., data = adult_train) |>
  step_rm(name) |>
  step_impute_median(education_num, hours_per_week) |>
  step_impute_median(all_numeric_predictors()) |>
  step_impute_mode(all_nominal_predictors()) |>
  step_other(threshold = .05) |> 
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |>
  step_nzv(all_predictors()) |>
  step_normalize(all_numeric_predictors())

# prep(recipe_simple) |>
#   bake(new_data = NULL)

save(
  recipe_simple,
  file = here("recipes/recipe_simple.rda")
)

###############################################################################
# recipe_complex

recipe_complex <- recipe(income ~., data = adult_train) |>
  step_rm(name) |>
  step_impute_linear(education_num, hours_per_week, 
                     impute_with = c("age", "capital_gain", "capital_loss", 
                                     "fnlwgt", "marital_status", "relationship", 
                                     "race", "sex")) |>
  step_impute_knn(occupation, workclass, native_country, 
                  impute_with = c("age", "capital_gain", "capital_loss", 
                                  "fnlwgt", "marital_status", "relationship", 
                                  "race", "sex")) |>
  step_impute_median(all_numeric_predictors()) |>
  step_impute_mode(all_nominal_predictors()) |>
  step_other(threshold = .05) |> 
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |>
  step_nzv(all_predictors()) |>
  step_normalize(all_numeric_predictors())

# prep(recipe_complex) |>
#   bake(new_data = NULL)

save(
  recipe_complex,
  file = here("recipes/recipe_complex.rda")
)
