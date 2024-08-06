## Lasso Regression Model

load("/Users/catherineli/Desktop/Final Project/RDA/Spotify-Model-Setup.rda")

# set seed
set.seed(3435)

# set up lasso model & tune penalty and mixture parameters
spotify_lasso_spec <- multinom_reg(penalty = tune(), 
                                   mixture = tune()) %>%
  set_engine("glmnet") %>% 
  set_mode("classification") 

# set up lasso workflow
spotify_lasso_wkflow <- workflow() %>% 
  add_model(spotify_lasso_spec) %>% 
  add_recipe(spotify_recipe) 

# create parameter grid to tune ranges of hyperparameters
lasso_grid <- grid_regular(penalty(range = c(-6, 6)), 
                           mixture(range = c(0, 1)), 
                           levels = 10)
lasso_grid

# fit models to our folded data
spotify_lasso_tune_res <- tune_grid(
  spotify_lasso_wkflow,
  resamples = spotify_folds, 
  grid = lasso_grid,
  metrics = metric_set(yardstick::roc_auc)
)

# collect metrics for the tuning results
collect_metrics(spotify_lasso_tune_res)

# select model with most optimal `roc_auc`
best_spotify_lasso_penalty <- tune::select_best(spotify_lasso_tune_res, metric = "roc_auc")
best_spotify_lasso_penalty

# finalize workflow 
spotify_lasso_final <- finalize_workflow(spotify_lasso_wkflow, best_spotify_lasso_penalty)

# fit model to the training set
spotify_lasso_final_fit <- fit(spotify_lasso_final, data = spotify_train)

# save data to load into Rmd file
save(spotify_lasso_tune_res, spotify_lasso_final_fit, 
     file = "/Users/catherineli/Desktop/Final Project/RDA/Spotify-Lasso-Regression.rda")
