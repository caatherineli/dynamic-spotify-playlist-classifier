## Spotify Random Forest Model

load("/Users/catherineli/Desktop/Final Project/RDA/Spotify-Model-Setup.rda")

# set seed
set.seed(3435)

#`create hyperparamters for tuning
spotify_rf_spec <- rand_forest(mtry = tune(), 
                               trees = tune(), 
                               min_n = tune()) %>%
  set_engine("ranger", importance = "impurity") %>%
  set_mode("classification")

# set up a random forest workflow
spotify_rf_wf <- workflow() %>%
  add_model(spotify_rf_spec) %>% 
  add_recipe(spotify_recipe)

# set up and define the grid of hyperparameters to be tuned 
spotify_grid <- grid_regular(mtry(range = c(3, 8)), 
                             trees(range = c(100, 500)), 
                             min_n(range = c(5, 20)), 
                             levels = 6)
spotify_grid

# for ROC AUC:
# fit models to our folded data
spotify_tune <- tune_grid(
  spotify_rf_wf, 
  resamples = spotify_folds, 
  grid = spotify_grid, 
  metrics = metric_set(yardstick::roc_auc)
)

# find the `roc_auc` of best performing random forest tree on the folds
spotify_best_rft <- dplyr::arrange(collect_metrics(spotify_tune), desc(mean))
head(spotify_best_rft)

# select random forest with the best `roc_auc`
spotify_best_rf_roc <- select_best(spotify_tune)

# fit the model to the training set with 'finalize_workflow()' and 'fit()'
spotify_rf_final_wkflow <- finalize_workflow(spotify_rf_wf, spotify_best_rf_roc)
spotify_rf_fit <- fit(spotify_rf_final_wkflow, data = spotify_train)

# save data to load into rmd file
save(spotify_tune, spotify_rf_fit, spotify_best_rft,
     file = "/Users/catherineli/Desktop/Final Project/RDA/Spotify-Random-Forest.rda")