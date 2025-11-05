
<!-- README.md is generated from README.Rmd. Please edit that file -->

# neonNitrate

<!-- badges: start -->

[![License:
MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
<!-- badges: end -->

## Overview

The **neonNitrate** package provides an interactive dashboard and tools
for exploring **nitrate concentration** and related **water-quality
variables** in freshwater ecosystems.  
It uses open-access data from the **National Ecological Observatory
Network (NEON)**, focusing on nitrate dynamics across U.S. monitoring
sites.

Developed for **ETC5523 – Communicating With Data (Assignment 4)** at
**Monash University**.

**📊 Package Website:**
[neonNitrate](https://etc5523-2025.github.io/assignment-4-packages-and-shiny-apps-rimaln/)

------------------------------------------------------------------------

## Features

- 💧 **Cleaned NEON nitrate dataset**  
- 🌎 **Interactive Shiny dashboard** for visualization  
- 📈 **Time-series and correlation plots** for nitrate and temperature  
- 🧮 **Summary statistics** by site and time  
- 📝 **Vignettes and documentation** using `roxygen2`

------------------------------------------------------------------------

## Installation

Install the development version from GitHub:

``` r
install.packages("remotes")
remotes::install_github("ETC5523-2025/assignment-4-packages-and-shiny-apps-rimaln")
```

## Quick Start

``` r
library(neonNitrate)
```

## View the dataset

``` r
data(nitrate_clean)
head(nitrate_clean)
summary(nitrate_clean$nitrate_mgL)
```

### Launch interactive dashboard

``` r
run_app()
```

### Description

| Variable        | Description               | Units    |
|-----------------|---------------------------|----------|
| `datetime`      | Timestamp of measurement  | ISO 8601 |
| `siteID`        | NEON site code            | —        |
| `nitrate_mgL`   | Nitrate concentration     | mg/L     |
| `temperature_C` | Surface water temperature | °C       |
| `turbidity_NTU` | Turbidity (water clarity) | NTU      |

## Interactive Dashboard

Launch the Shiny dashboard to explore the data interactively:

``` r
run_app()
```

The Shiny dashboard includes three key sections: - **Overview** –
Explore nitrate levels by site and year - **Time-Series Trends** –
Visualize seasonal nitrate variation - **Variable Correlations** –
Compare nitrate with turbidity, temperature, and conductivity

## Example Analysis

``` r
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
library(ggplot2)

# Example dataset
nitrate_clean <- data.frame(
  siteID = rep("BARC", 12),
  datetime = seq(as.Date("2020-01-01"), by = "month", length.out = 12),
  nitrate_mgL = runif(12, 0.5, 3.5)
)

nitrate_clean |>
  mutate(month = format(datetime, "%b")) |>
  group_by(month) |>
  summarise(mean_nitrate = mean(nitrate_mgL, na.rm = TRUE)) |>
  ggplot(aes(x = month, y = mean_nitrate)) +
  geom_col(fill = "steelblue") +
  labs(
    title = "Average Monthly Nitrate Concentration – BARC Site",
    x = "Month",
    y = "Nitrate (mg/L)"
  ) +
  theme_minimal()
```

<img src="man/figures/README-unnamed-chunk-2-1.png" width="100%" />

## Available Datasets

- *nitrate_clean* – Cleaned NEON nitrate dataset
- *nitrate_summary* – Summarized nitrate data by site and month

## Functions

- **run_app()** - Launch the Shiny dashboard
- **summarize_nitrate()** - Compute nitrate statistics by time or site
- **plot_nitrate_trends()** - Generate time-series visualizations

## Documentation

- [**Package
  Website**](https://github.com/ETC5523-2025/assignment-4-packages-and-shiny-apps-rimaln.git)
