## Spotify Linear Discriminant Analysis

load("/Users/catherineli/Desktop/Final Project/RDA/Spotify-Model-Setup.rda")

# set seed
set.seed(3435)

# set up a decision tree model and tune the `cost_complexity` hyperparameter
spotify_spec <- decision_tree(cost_complexity = tune()) %>%
  set_engine("rpart") %>%
  set_mode("classification")

# set up decision tree workflow
spotify_wf <- workflow() %>%
  add_model(spotify_spec) %>%
  add_recipe(spotify_recipe)

# set up grid of range of values for the cost-complexity parameter
spotify_param_grid <- grid_regular(cost_complexity(range = c(-3, -1)), levels = 10)

# fit the models to our folded data
spotify_tune_tree <- tune_grid(
  spotify_wf,
  resamples = spotify_folds, 
  grid = spotify_param_grid, 
  metrics = metric_set(yardstick::roc_auc)
)

# find the `roc_auc` of best-performing pruned decision tree on the folds
spotify_best_pruned_tree <- dplyr::arrange(collect_metrics(spotify_tune_tree), desc(mean))
spotify_best_pruned_tree

# select decision tree with the best `roc_auc`
best_complexity <- select_best(spotify_tune_tree)

# fit model to the training set with 'finalize_workflow()' and 'fit()'
spotify_tree_final <- finalize_workflow(spotify_wf, best_complexity)
spotify_final_fit <- fit(spotify_tree_final, data = spotify_train)

# save data to load into Rmd file
save(spotify_tune_tree, spotify_final_fit,
     file = "/Users/catherineli/Desktop/Final Project/RDA/Spotify-Decision-Tree.rda")