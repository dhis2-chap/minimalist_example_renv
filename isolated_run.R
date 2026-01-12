# Run the model in isolation without CHAP integration.
#
# This script demonstrates how to train and predict using the model directly,
# which is useful for development and debugging before integrating with CHAP.

# Train the model
system2("Rscript", c("main.R", "train",
                     "--train_data", "input/trainData.csv",
                     "--model", "output/model.rds"))

# Generate predictions
system2("Rscript", c("main.R", "predict",
                     "--model", "output/model.rds",
                     "--historic_data", "input/trainData.csv",
                     "--future_data", "input/futureClimateData.csv",
                     "--out_file", "output/predictions.csv"))

message("\nPredictions saved to output/predictions.csv")
