# CHAP model: minimalist_example_renv
#
# A simple linear regression model for disease prediction.

args <- commandArgs(trailingOnly = TRUE)

train <- function(train_data_path, model_path) {
  df <- read.csv(train_data_path)

  df$rainfall[is.na(df$rainfall)] <- 0
  df$mean_temperature[is.na(df$mean_temperature)] <- 0
  df$disease_cases[is.na(df$disease_cases)] <- 0

  model <- lm(disease_cases ~ rainfall + mean_temperature, data = df)
  saveRDS(model, model_path)
  message(paste("Model saved to", model_path))
}

predict_model <- function(model_path, historic_data_path, future_data_path, out_path) {
  model <- readRDS(model_path)
  future_df <- read.csv(future_data_path)

  future_df$rainfall[is.na(future_df$rainfall)] <- 0
  future_df$mean_temperature[is.na(future_df$mean_temperature)] <- 0

  predictions <- predict(model, newdata = future_df)

  output_df <- data.frame(
    time_period = future_df$time_period,
    location = future_df$location,
    sample_0 = predictions
  )
  write.csv(output_df, out_path, row.names = FALSE)
  message(paste("Predictions saved to", out_path))
}

if (length(args) < 1) {
  stop("Usage: Rscript main.R <command> [args...]")
}

command <- args[1]

if (command == "train") {
  if (length(args) != 3) {
    stop("train requires: train_data model")
  }
  train(args[2], args[3])
} else if (command == "predict") {
  if (length(args) != 5) {
    stop("predict requires: model historic_data future_data out_file")
  }
  predict_model(args[2], args[3], args[4], args[5])
} else {
  stop(paste("Unknown command:", command))
}
