library(utils)
# renv activation script
local({
  if (!requireNamespace("renv", quietly = TRUE)) {
    message("Installing renv...")
    install.packages("renv", repos = "https://cloud.r-project.org")
  }
  renv::activate()
})
