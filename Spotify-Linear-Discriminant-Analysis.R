## Spotify Linear Discriminant Analysis

load("/Users/catherineli/Desktop/Final Project/RDA/Spotify-Model-Setup.rda")

# set seed
set.seed(3435)

# set up linear discriminant model 
spotify_lda_mod <- discrim_linear() %>% 
  set_mode("classification") %>% 
  set_engine("MASS")

# set up linear discriminant workflow
spotify_lda_wkflow <- workflow() %>% 
  add_recipe(spotify_recipe) %>%
  add_model(spotify_lda_mod) 

# fit model to the training data
spotify_lda_fit <- fit(spotify_lda_wkflow, spotify_train)
predict(spotify_lda_fit, new_data = spotify_train, type="prob")

# fit model to the folds
spotify_lda_kfold_fit <- fit_resamples(spotify_lda_wkflow, spotify_folds)
collect_metrics(spotify_lda_kfold_fit)

# save data to load into Rmd file
save(spotify_lda_fit, spotify_lda_kfold_fit, 
     file = "/Users/catherineli/Desktop/Final Project/RDA/Spotify-Linear-Discriminant-Analysis.rda")
