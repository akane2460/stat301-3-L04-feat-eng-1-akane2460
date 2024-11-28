# L04 Feature Engineering I ----
# Processing training, creating resamples, missingness & factor EDA

# Load package(s)
library(tidymodels)
library(tidyverse)
library(here)
library(naniar)
library(patchwork)

# handle common conflicts
tidymodels_prefer()

# load train data
adult_train <- read_csv(here("data/adult_train.csv"))

# convert character to factor
# set the reference level of the outcome variable, `income`, to be `1`.

# adult_train |> skimr::skim_without_charts()

adult_train <- adult_train |> 
  mutate(
    workclass = as.factor(workclass),
    education = as.factor(education),
    name = as.factor(name),
    marital_status = as.factor(marital_status),
    occupation = as.factor(occupation),
    relationship = as.factor(relationship),
    race = as.factor(race),
    sex = as.factor(sex),
    native_country = as.factor(native_country),
    income = as.factor(income),
    income = relevel(income, ref = "1")
  )
 
# resamples: v-fold
adult_folds <- adult_train |>
  vfold_cv(v = 10, repeats = 3, strata = income)

# Using the `naniar` package, explore the nature of missingness in the training data. 
# Use both graphics and summary tables. Display this work.

miss_var_summary(adult_train) |> 
  knitr::kable()

missing_variables_adult_train_plot <- gg_miss_var(adult_train) +
  labs(title = "Missing variables in adult_train")

ggsave(here("results/missing_variables_adult_train_plot.png"), missing_variables_adult_train_plot)

# saving train and resamples
save(
  adult_train,
  file = here("data/adult_train.rda")
)

save(
  adult_folds,
  file = here("data/adult_folds.rda")
)
