## k-Nearest Neighbors Model

load("/Users/catherineli/Desktop/Final Project/RDA/Spotify-Model-Setup.rda")

# set seed
set.seed(3435)

# set up knn model 
spotify_knn_model <- nearest_neighbor() %>%
  set_engine("kknn") %>%
  set_mode("classification")

# set up knn workflow
spotify_knn_wkflow <- workflow() %>% 
  add_model(spotify_knn_model) %>%
  add_recipe(spotify_recipe)

# fit model to training data 
spotify_knn_fit <- fit(spotify_knn_wkflow, spotify_train)
predict(spotify_knn_fit, new_data=spotify_train, type="prob")

# fit model to the folds 
spotify_knn_kfold_fit <- fit_resamples(spotify_knn_wkflow, spotify_folds)
collect_metrics(spotify_knn_kfold_fit)

# use `augment()` to create a roc curve using our QDA fitted model
spotify_roc_knn <- augment(spotify_knn_fit, spotify_train)

# save data to load into Rmd file
save(spotify_knn_fit, spotify_knn_kfold_fit, spotify_roc_knn,
     file = "/Users/catherineli/Desktop/Final Project/RDA/Spotify-k-Nearest-Neighbors.rda")