#' NEON Nitrate Survey Data
#'
#' @description
#' Surface water nitrate data collected by NEON at COM sites.
#'
#' @format A data frame with one row per 15-minute sample:
#' \describe{
#'   \item{start_date_time}{Start time of sample (POSIXct)}
#'   \item{end_date_time}{End time of sample (POSIXct)}
#'   \item{surf_water_nitrate_mean}{Mean water nitrate concentration (mg/L)}
#'   \item{surf_water_nitrate_minimum}{Minimum nitrate concentration (mg/L)}
#'   \item{surf_water_nitrate_maximum}{Maximum nitrate concentration (mg/L)}
#'   \item{surf_water_nitrate_variance}{Variance of nitrate values}
#'   \item{surf_water_nitrate_num_pts}{Number of measurements in interval}
#'   \item{surf_water_nitrate_exp_uncert}{Experimental uncertainty}
#'   \item{surf_water_nitrate_std_er_mean}{Standard error of mean}
#'   \item{final_qf}{Quality flag}
#' }
#'
#' @details
#' Data are derived from high-frequency COM site sensors, cleaned to remove missing values in mean nitrate and timestamps.
#'
#' @source NEON project: COMO site nitrate data, https://data.neonscience.org/
#'
#' @seealso [nitrate_sample_distribution], [strata_summary], [pop_est]
#'
#' @examples
#' data(neon_nitrate)
#' summary(neon_nitrate$surf_water_nitrate_mean)
#' head(neon_nitrate)
"neon_nitrate"

#' NEON Nitrate Sample Distribution
#'
#' @description
#' Frequency of observed surface water nitrate mean concentrations.
#'
#' @format A data frame:
#' \describe{
#'   \item{surf_water_nitrate_mean}{Mean nitrate value (mg/L)}
#'   \item{n}{Number of samples with that mean value}
#' }
#'
#' @examples
#' data(nitrate_sample_distribution)
#' plot(nitrate_sample_distribution)
"nitrate_sample_distribution"

#' NEON Monthly Nitrate Summary
#'
#' @description
#' Monthly summary statistics for nitrate values by year and month.
#'
#' @format A data frame:
#' \describe{
#'   \item{year}{Year}
#'   \item{month}{Month}
#'   \item{mean_nitrate}{Mean concentration}
#'   \item{min_nitrate}{Minimum concentration}
#'   \item{max_nitrate}{Maximum concentration}
#'   \item{n}{Sample count}
#' }
#'
#' @examples
#' data(strata_summary)
#' plot(strata_summary$mean_nitrate ~ interaction(strata_summary$year, strata_summary$month))
"strata_summary"
