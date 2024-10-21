# Spotify Genre Classification Using Machine Learning

*Overview*\
This project builds a machine learning model to classify Spotify tracks into one of two musical genres: Hip-Hop/Rap or Electronic/Dance. Using Spotify audio features data from Kaggle, the goal is to create an accurate and dynamic model to enhance the music listening experience by enabling personalized and automated playlist creation.

*Inspiration and Motivation*\
Curating the perfect playlist can be overwhelming, given the 80 million+ tracks available on platforms like Spotify. This project aims to streamline that process by automatically classifying tracks based on their audio features, helping users discover and organize music more easily.

*Project Workflow*
1. Data Loading and Preparation\
Data was sourced from a Kaggle Spotify dataset.
The dataset contains 15 variables related to audio features of songs.
We reduced the data to two genres: Hip-Hop/Rap and Electronic/Dance.
Audio features include variables like duration, loudness, energy, etc.
2. Model Building\
We developed several machine learning models, including:
Logistic Regression
Linear Discriminant Analysis
k-Nearest Neighbors
Random Forest
Models were trained and evaluated using 10-fold cross-validation with the ROC AUC metric.
After tuning, we selected the best-performing model for genre classification.
3. Model Evaluation\
We used roc_auc to measure the models' effectiveness, focusing on their ability to distinguish between the two genres.
Random Forest emerged as the top-performing model based on accuracy and classification metrics.

*Results*\
The final model can accurately classify tracks into either Hip-Hop/Rap or Electronic/Dance based on audio features.\
Visualizations, including correlation plots and bar plots, highlight the relationships between the audio features and the predicted genre.

*Future Improvements*\
Extending the classification to additional genres beyond the current two.\
Improving feature engineering and experimenting with additional models.\
Expanding to include user preferences for more personalized playlist creation.\

*Technologies Used*\
R for data analysis and modeling.\
tidymodels framework for building and evaluating machine learning models.\
ggplot2 for data visualization.\
