# CHAP model: temp_r_model
#
# A simple linear regression model for disease prediction.

library(optparse)

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

# Parse command line arguments
args <- commandArgs(trailingOnly = TRUE)

if (length(args) < 1) {
  stop("Usage: Rscript main.R <train|predict> [options]")
}

command <- args[1]
command_args <- args[-1]

if (command == "train") {
  option_list <- list(
    make_option(c("-t", "--train_data"), type = "character", help = "Path to training data CSV"),
    make_option(c("-m", "--model"), type = "character", help = "Path to save trained model")
  )
  parser <- OptionParser(option_list = option_list, usage = "usage: %prog train [options]")
  opts <- parse_args(parser, args = command_args, positional_arguments = TRUE)

  if (is.null(opts$options$train_data) || is.null(opts$options$model)) {
    print_help(parser)
    stop("train requires --train_data and --model")
  }

  train(opts$options$train_data, opts$options$model)

} else if (command == "predict") {
  option_list <- list(
    make_option(c("-m", "--model"), type = "character", help = "Path to trained model"),
    make_option(c("-d", "--historic_data"), type = "character", help = "Path to historic data CSV"),
    make_option(c("-f", "--future_data"), type = "character", help = "Path to future climate data CSV"),
    make_option(c("-o", "--out_file"), type = "character", help = "Path to save predictions")
  )
  parser <- OptionParser(option_list = option_list, usage = "usage: %prog predict [options]")
  opts <- parse_args(parser, args = command_args, positional_arguments = TRUE)

  if (is.null(opts$options$model) || is.null(opts$options$historic_data) ||
      is.null(opts$options$future_data) || is.null(opts$options$out_file)) {
    print_help(parser)
    stop("predict requires --model, --historic_data, --future_data, and --out_file")
  }

  predict_model(opts$options$model, opts$options$historic_data,
                opts$options$future_data, opts$options$out_file)

} else {
  stop(paste("Unknown command:", command, "\nUsage: Rscript main.R <train|predict> [options]"))
}
