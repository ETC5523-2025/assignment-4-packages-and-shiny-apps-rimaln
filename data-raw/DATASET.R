library(readr)
library(dplyr)
library(janitor)
library(stringr)
library(lubridate)
library(usethis)
library(purrr)

# Get a vector of ALL CSVs you want to combine (change pattern if needed)
csv_files <- list.files("data-raw", pattern = "\\.csv$", full.names = TRUE)

# Bind all NEON nitrate CSVs into one dataframe
nitrate_raw <- purrr::map_dfr(csv_files, read_csv)

# Clean data and create main dataset
neon_nitrate <- nitrate_raw |>
  filter(!is.na(surfWaterNitrateMean), !is.na(startDateTime)) |>
  janitor::clean_names()


# Distribution of nitrate measurements
nitrate_sample_distribution <- neon_nitrate |>
  count(surf_water_nitrate_mean) |>
  arrange(desc(n))

usethis::use_data(nitrate_sample_distribution, overwrite = TRUE)

# Stratified summary: add month and year
neon_nitrate <- neon_nitrate |>
  mutate(
    month = lubridate::month(start_date_time),
    year = lubridate::year(start_date_time)
  )

strata_summary <- neon_nitrate |>
  group_by(year, month) |>
  summarise(
    mean_nitrate = mean(surf_water_nitrate_mean, na.rm = TRUE),
    min_nitrate = min(surf_water_nitrate_mean, na.rm = TRUE),
    max_nitrate = max(surf_water_nitrate_mean, na.rm = TRUE),
    n = n(),
    .groups = "drop"
  )

usethis::use_data(strata_summary, overwrite = TRUE)

# Population estimate (total observation count)
pop_est <- neon_nitrate |>
  summarise(total_obs = n())

usethis::use_data(pop_est, overwrite = TRUE)

# Write the combined dataset to a CSV file
write_csv(neon_nitrate, "data-raw/Neon_Nitrate_Combined.csv")
usethis::use_data(neon_nitrate, overwrite = TRUE)
