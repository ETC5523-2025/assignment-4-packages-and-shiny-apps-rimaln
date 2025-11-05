#' Launch the NEON Nitrate Interactive Dashboard
#'
#' @description
#' Launches an interactive Shiny dashboard for exploring the NEON nitrate dataset.
#' The dashboard includes visualizations and summaries such as:
#' \itemize{
#'   \item Sample distributions with interactive plots
#'   \item Time series and monthly summaries
#'   \item Data filtering and quality control visualizations
#' }
#'
#' @param ... Additional arguments passed to \code{\link[shiny]{runApp}}.
#'   Common options include:
#'   \itemize{
#'     \item \code{port}: Port number (e.g., \code{port = 3838})
#'     \item \code{launch.browser}: Logical; open app in browser (default: \code{TRUE})
#'     \item \code{host}: Host IP address (default: \code{"127.0.0.1"})
#'   }
#'
#' @return Launches the Shiny application; no return value.
#' @export
#' @importFrom shiny runApp
run_app <- function(...) {
  required_pkgs <- c("shiny", "shinydashboard", "plotly", "DT", "ggplot2", "scales")
  missing_pkgs <- required_pkgs[!vapply(required_pkgs, requireNamespace, logical(1), quietly = TRUE)]
  if (length(missing_pkgs) > 0) {
    stop(
      "Please install required packages: ",
      paste(missing_pkgs, collapse = ", "),
      call. = FALSE
    )
  }

  app_dir <- system.file("shiny", package = "neonNitrate")
  if (app_dir == "") {
    stop(
      "Could not locate Shiny app directory in the neonNitrate package.",
      call. = FALSE
    )
  }

  shiny::runApp(app_dir, display.mode = "normal", ...)
}
