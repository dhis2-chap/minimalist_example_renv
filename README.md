# minimalist_example_renv

This is a CHAP-compatible forecasting model using [renv](https://rstudio.github.io/renv/) for dependency management.

The model learns a linear regression from rainfall and temperature to disease cases in the same month. It is meant as a starting point for developing your own model.

## Requirements

- R (>= 4.0)
- renv will be automatically restored on first run

## Running the model without CHAP integration

Before integrating with CHAP, you can test the model directly using the included sample data:

```bash
Rscript isolated_run.R
```

Or run the commands manually:

### Training the model

```bash
Rscript main.R train input/trainData.csv output/model.rds
```

### Generating predictions

```bash
Rscript main.R predict output/model.rds input/trainData.csv input/futureClimateData.csv output/predictions.csv
```

## Running the model with CHAP

After installing chap-core, run:

```bash
chap evaluate --model-name /path/to/minimalist_example_renv --dataset-csv your_data.csv --report-filename report.pdf
```

Or with a built-in dataset:

```bash
chap evaluate --model-name /path/to/minimalist_example_renv --dataset-name ISIMIP_dengue_harmonized --dataset-country brazil --report-filename report.pdf
```

## Project structure

- `MLproject` - Defines how CHAP interacts with your model
- `renv.lock` - Locks R package versions
- `main.R` - Contains your model's train and predict logic
- `isolated_run.R` - Script to test the model without CHAP
- `input/` - Sample training and future climate data
- `output/` - Where trained models and predictions are saved

## Customizing the model

Edit `main.R` to change:
- Which features are used for prediction
- The machine learning algorithm (currently lm)
- How predictions are formatted

Add dependencies using `renv::install("package_name")` and then `renv::snapshot()` to update renv.lock.
