## Quadratic Discriminant Model

load("/Users/catherineli/Desktop/Final Project/RDA/Spotify-Model-Setup.rda")

# set seed
set.seed(3435)

# set up quadratic discriminant model 
spotify_qda_mod <- discrim_quad() %>% 
  set_mode("classification") %>% 
  set_engine("MASS")

# set up quadratic discriminant workflow
spotify_qda_wkflow <- workflow() %>% 
  add_model(spotify_qda_mod) %>% 
  add_recipe(spotify_recipe)

# fit model to the training data
spotify_qda_fit <- fit(spotify_qda_wkflow, spotify_train)
predict(spotify_qda_fit, new_data=spotify_train, type="prob")

# fit model to the folds
spotify_qda_kfold_fit <- fit_resamples(spotify_qda_wkflow, spotify_folds, control=control_grid(save_pred = TRUE))
collect_metrics(spotify_qda_kfold_fit)

# use `augment()` to create a roc curve using our QDA fitted model
spotify_roc_qda <- augment(spotify_qda_fit, spotify_train)

# save data to load into Rmd file
save(spotify_qda_fit, spotify_qda_kfold_fit, spotify_roc_qda, 
     file = "/Users/catherineli/Desktop/Final Project/RDA/Spotify-Quadratic-Discriminant.rda")