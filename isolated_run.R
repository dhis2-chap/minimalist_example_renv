# Run the model in isolation without CHAP integration.
#
# This script demonstrates how to train and predict using the model directly,
# which is useful for development and debugging before integrating with CHAP.

# Train the model
system2("Rscript", c("main.R", "train", "input/trainData.csv", "output/model.rds"))

# Generate predictions
system2("Rscript", c("main.R", "predict", "output/model.rds",
                     "input/trainData.csv", "input/futureClimateData.csv",
                     "output/predictions.csv"))

message("\nPredictions saved to output/predictions.csv")
