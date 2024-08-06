## Logistic Regression Model

load("/Users/catherineli/Desktop/Final Project/RDA/Spotify-Model-Setup.rda")

# set seed
set.seed(3435)

# set up logistical model 
spotify_log_reg <- logistic_reg() %>%
  set_mode("classification") %>%
  set_engine("glm") 

# set up logistical workflow
spotify_log_wkflow <- workflow() %>% 
  add_recipe(spotify_recipe) %>%
  add_model(spotify_log_reg) 

# fit model to training data
spotify_log_fit <- fit(spotify_log_wkflow, spotify_train)
predict(spotify_log_fit, new_data=spotify_train, type="prob")

# fit model to the folds 
spotify_log_kfold_fit <- fit_resamples(spotify_log_wkflow, spotify_folds)
collect_metrics(spotify_log_kfold_fit)

# save data to load into Rmd file
save(spotify_log_fit, spotify_log_kfold_fit, 
     file = "/Users/catherineli/Desktop/Final Project/RDA/Spotify-Logistic-Regression.rda")