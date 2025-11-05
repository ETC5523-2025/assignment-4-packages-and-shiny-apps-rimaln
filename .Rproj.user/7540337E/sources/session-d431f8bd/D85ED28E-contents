library(shiny)
library(dplyr)
library(tidyr)
library(plotly)
library(DT)
library(scales)
library(ggplot2)
library(janitor)
library(readr)
library(lubridate)

function(input, output, session) {

  # === UPLOAD CSV and process as main dataset ===
  user_data <- reactive({
    req(input$csvfile)
    read_csv(input$csvfile$datapath) |> janitor::clean_names()
  })

  neon_nitrate <- reactive({
    user_data() |>
      filter(!is.na(surf_water_nitrate_mean), !is.na(start_date_time)) |>
      mutate(
        month = lubridate::month(start_date_time),
        year = lubridate::year(start_date_time)
      )
  })

  nitrate_sample_distribution <- reactive({
    neon_nitrate() |>
      count(surf_water_nitrate_mean) |>
      arrange(desc(n))
  })

  pop_est <- reactive({
    neon_nitrate() |> summarise(total_obs = n())
  })

  strata_summary <- reactive({
    neon_nitrate() |>
      group_by(year, month) |>
      summarise(
        mean_nitrate = mean(surf_water_nitrate_mean, na.rm = TRUE),
        min_nitrate = min(surf_water_nitrate_mean, na.rm = TRUE),
        max_nitrate = max(surf_water_nitrate_mean, na.rm = TRUE),
        n = n(),
        .groups = "drop"
      )
  })

  # ========= TAB 1: Overview =========
  output$value_box_total_obs <- renderValueBox({
    total_obs <- pop_est() |> pull(total_obs)
    valueBox(
      value = formatC(total_obs, format = "d", big.mark = ","),
      subtitle = "💧 Total Nitrate Observations",
      color = "blue"
    )
  })

  output$value_box_avg_nitrate <- renderValueBox({
    avg_nitrate <- neon_nitrate() |> summarise(avg = mean(surf_water_nitrate_mean, na.rm = TRUE)) |> pull(avg)
    valueBox(
      value = round(avg_nitrate, 2),
      subtitle = "⏱️ Average Nitrate (mean)",
      color = "green"
    )
  })

  output$value_box_max_nitrate <- renderValueBox({
    max_nitrate <- neon_nitrate() |> summarise(max = max(surf_water_nitrate_mean, na.rm = TRUE)) |> pull(max)
    valueBox(
      value = round(max_nitrate, 2),
      subtitle = "🚨 Maximum Nitrate",
      color = "red"
    )
  })


  output$sample_distribution_plot <- renderPlotly({
    dist <- nitrate_sample_distribution()
    p <- ggplot(dist,
                aes(x = surf_water_nitrate_mean, y = n,
                    color = surf_water_nitrate_mean,
                    text = paste("Mean Nitrate:", round(surf_water_nitrate_mean,2), "<br>Count:", n))) +
      geom_point(size = 4, alpha = 0.85) +
      scale_color_gradient(low = "#00c3ff", high = "#ff53a1") +
      labs(
        title = "Nitrate Sample Distribution",
        x = "Surface Water Nitrate Mean",
        y = "Sample Count",
        color = "Nitrate Level"
      ) +
      theme_minimal(base_family = "Arial") +
      theme(
        plot.background = element_rect(fill = "#f5f7fa"),
        panel.grid.minor.x = element_blank(),
        axis.title.x = element_text(size = 13, color = "#1859a1"),
        axis.title.y = element_text(size = 13, color = "#1859a1"),
        plot.title = element_text(size = 15, face = "bold", color = "#5e3370")
      )
    ggplotly(p, tooltip = "text")
  })

  output$summary_text <- renderPrint({
    summary(neon_nitrate())
  })

  # ========= TAB 2: Population Estimates =========
  # ===== TAB 2: Population Estimates =====

  # Update month/year filter options every time the underlying data changes
  observe({
    updateSelectInput(session, "month_filter",
                      choices = sort(unique(neon_nitrate()$month)),
                      selected = isolate(input$month_filter)
    )
    updateSelectInput(session, "year_filter",
                      choices = sort(unique(neon_nitrate()$year)),
                      selected = isolate(input$year_filter)
    )
  })

  # Show summary table—no CSV/Copy/search bar
  output$pop_est_table <- DT::renderDataTable({
    data <- neon_nitrate()
    if (!is.null(input$month_filter) && input$month_filter != "") {
      data <- data %>% filter(month == input$month_filter)
    }
    if (!is.null(input$year_filter) && input$year_filter != "") {
      data <- data %>% filter(year == input$year_filter)
    }
    data %>%
      summarise(
        total_obs = n(),
        mean_nitrate = round(mean(surf_water_nitrate_mean, na.rm = TRUE), 2),
        min_nitrate = round(min(surf_water_nitrate_mean, na.rm = TRUE), 2),
        max_nitrate = round(max(surf_water_nitrate_mean, na.rm = TRUE), 2)
      ) %>%
      datatable(
        options = list(dom = 't', pageLength = 10), # 't' = only table, no controls/search/buttons
        rownames = FALSE
      )
  })


  # ========= TAB 3: Stratified Analysis =========
  observeEvent(strata_summary(), {
    updateSelectInput(
      session, "year_select",
      choices = sort(unique(strata_summary()$year)),
      selected = sort(unique(strata_summary()$year))[1]
    )
    updateSelectInput(
      session, "month_select",
      choices = sort(unique(strata_summary()$month)),
      selected = sort(unique(strata_summary()$month))[1]
    )
  })

  selected_strata <- reactive({
    req(input$year_select, input$month_select)
    filter(strata_summary(), year == input$year_select, month == input$month_select)
  })

  output$stratified_boxplot <- renderPlotly({
    req(input$year_select)
    nn <- neon_nitrate()
    filtered <- nn |> filter(year == input$year_select)

    validate(need(nrow(filtered) > 0, "No data for this year"))

    p <- ggplot(filtered, aes(x = factor(month), y = surf_water_nitrate_mean)) +
      geom_boxplot(fill = "#1859a1", alpha = 0.7) +
      labs(
        title = paste("Nitrate Distribution in Year", input$year_select),
        x = "Month",
        y = "Surface Water Nitrate Mean (mg/L)"
      ) +
      theme_minimal()

    ggplotly(p)
  })

}
