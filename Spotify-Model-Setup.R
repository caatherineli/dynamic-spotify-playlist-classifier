## Spotify Model Setup 

# setting the seed
set.seed(3435)

# splitting the data 
spotify_split <- initial_split(spotify, prop = 0.7, strata = "music_category")

# training & testing split 
spotify_train <- training(spotify_split)
spotify_test <- testing(spotify_split)

# building our recipe
spotify_recipe <- 
  recipe(music_category ~ acousticness + danceability + duration_ms + energy + instrumentalness + key + liveness + loudness + mode + song_name + speechiness + tempo + time_signature + valence, data = spotify_train) %>% 
  # convert mode to a factor
  step_mutate(mode = as.factor(mode)) %>%
  # dummy coding our categorical variables
  step_dummy(mode) %>%
  # standardizing our numerical and integer predictors 
  step_center(acousticness, danceability, duration_ms, energy, instrumentalness,
              key, liveness, loudness, speechiness, tempo, time_signature, valence) %>%
  step_scale(acousticness, danceability, duration_ms, energy, instrumentalness,
             key, liveness, loudness, speechiness, tempo, time_signature, valence) %>%
  # remove the 'song_name' variable because does not affect `music_category`
  step_rm(song_name)

# 10-fold CV 
spotify_folds <- vfold_cv(spotify_train, v=10, strata="music_category")