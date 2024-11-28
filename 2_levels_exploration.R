# L04 Feature Engineering I ----
# Exploring levels

# Load package(s)
library(tidymodels)
library(tidyverse)
library(here)
library(naniar)
library(patchwork)

# handle common conflicts
tidymodels_prefer()

# load train data
load(here("data/adult_train.rda"))

# inspect factor variables----
factor_variables <- names(adult_train)[sapply(adult_train, is.factor)]

p1 <- adult_train |> 
  select(factor_variables) |> 
  ggplot(aes(x = workclass)) +
  geom_bar()
# some levels

p2 <- adult_train |> 
  select(factor_variables) |> 
  ggplot(aes(x = education)) +
  geom_bar() +
  theme(axis.text.x = element_text(angle = 60, hjust = 1)) +
  labs(title = "Education")
# lots of levels
ggsave(here("results/education_factor.png"), p2, width = 10)

p3 <- adult_train |> 
  select(factor_variables) |> 
  ggplot(aes(x = marital_status)) +
  geom_bar()
# some levels

p4 <- adult_train |> 
  select(factor_variables) |> 
  ggplot(aes(x = occupation)) +
  geom_bar() +
  theme(axis.text.x = element_text(angle = 60, hjust = 1)) +
  labs(title = "Occupation")
# lots of levels
ggsave(here("results/occupation_factor.png"), p4, width = 10)

p5 <- adult_train |> 
  select(factor_variables) |> 
  ggplot(aes(x = relationship)) +
  geom_bar()
# some levels

p6 <- adult_train |> 
  select(factor_variables) |> 
  ggplot(aes(x = race)) +
  geom_bar()
# some levels

p7 <- adult_train |> 
  select(factor_variables) |> 
  ggplot(aes(x = sex)) +
  geom_bar()
# very few levels

p8 <- adult_train |> 
  select(factor_variables) |> 
  ggplot(aes(x = native_country)) +
  geom_bar() + 
  theme(axis.text.x = element_text(angle = 60, hjust = 1)) +
  labs(title = "Native Country")
# LOTs of levels
ggsave(here("results/native_country_factor.png"), p8, width = 10)

p9 <- adult_train |> 
  select(factor_variables) |> 
  ggplot(aes(x = income)) +
  geom_bar()
# few levels

# education, occupation and native_country all have LOTS of levels----

# education
education_levels <- na.omit(adult_train$education)

education_counts <- table(education_levels)

education_proportions <- education_counts / sum(education_counts)

education_proportions |> 
  knitr::kable()

# occupation
occupation_levels <- na.omit(adult_train$occupation)

occupation_counts <- table(occupation_levels)

occupation_proportions <- occupation_counts / sum(occupation_counts)

occupation_proportions |> 
  knitr::kable() 

# native_country
native_country_levels <- na.omit(adult_train$native_country)

native_table_counts <- table(native_country_levels)

native_table_proportions <- native_table_counts / sum(native_table_counts)

native_table_proportions |> 
  knitr::kable()
