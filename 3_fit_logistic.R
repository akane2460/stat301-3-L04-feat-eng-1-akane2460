# L04 Feature Engineering I ----
# Ex 1 Task 4: finalize logistic fit & check/analyze predictions on test set

# Load package(s) ----
library(tidyverse)
library(tidymodels)
library(here)

# Handle conflicts
tidymodels_prefer()

# load data ----

# training data
# load the version of the training data you created in Ex 1 Task 1
load(here("data/adult_train.rda"))

# testing data
adult_test <- read_csv(here("data/adult_test.csv"))

# load your recipe (recipe_basic from Ex 1 Task 3) ----
load(here("recipes/recipe_basic.rda"))

# model specification ----
log_spec <- logistic_reg() |>
  set_mode("classification") |>
  set_engine("glm")

# workflow ----
log_wflow <-
  workflow() |>
  add_model(log_spec) |>
  add_recipe(recipe_basic)

# we decided that a simple logistic regression was our best model
final_model_fit <-
  log_wflow |>
  fit(adult_train)

###############################################################################
# predict on testing dataset
adult_pred <-
  adult_test |>
  select(income) |>
  mutate(income = factor(income, levels = c(1, 0))) |>
  bind_cols(
    predict(final_model_fit, new_data = adult_test, type = "prob")
  )

adult_pred |>
  roc_auc(income, .pred_1)

