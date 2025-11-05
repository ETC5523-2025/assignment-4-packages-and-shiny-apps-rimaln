library(shiny)
library(shinydashboard)
library(plotly)
library(DT)

ui <- dashboardPage(
  skin = "purple",
  dashboardHeader(
    title = "neonNitrate",
    titleWidth = 250
  ),
  dashboardSidebar(
    width = 250,
    selectInput("dataset_select", "Select Dataset:",
                choices = c(
                  "Combined (All Sites)" = "combined",
                  "Site/Dataset 1" = "file1",
                  "Site/Dataset 2" = "file2",
                  "Site/Dataset 3" = "file3",
                  "Site/Dataset 4" = "file4"
                ),
                selected = "combined"
    ),
    fileInput("csvfile", "Upload NEON Nitrate CSV", accept = ".csv"),
    sidebarMenu(
      id = "tabs",
      menuItem("Overview", tabName = "overview", icon = icon("info-circle")),
      menuItem("Population Estimates", tabName = "estimates", icon = icon("project-diagram")),
      menuItem("Stratified Analysis", tabName = "stratified", icon = icon("chart-bar"))
    )
  )
,
dashboardBody(
  tags$head(
    tags$style(HTML("
      /* Custom style for all box titles */
      .box .box-title {
        font-size: 1.3em !important;
        font-weight: 700 !important;
        letter-spacing: 0.1em;
        color: #4527a0 !important;
        font-family: 'Montserrat', 'Arial', sans-serif;
        border-left: 6px solid #7e57c2 !important;
        padding-left: 12px;
        margin-bottom: 0.2em;
      }
      .box-primary, .box-info {
        border-radius: 10px;
        border: none;
      }
      /* Add shadow for lifted look */
      .box {
        box-shadow: 0 2px 8px rgba(30,30,60,0.06) !important;
      }
      /* Optional: Light highlight on box background for extra clarity */
      .box.box-primary {
         background: #f6f3fc;
       }
      .box.box-info {
         background: #e3f2fd;
       }
    "))
  ),
    tabItems(
      # TAB 1: Overview
      tabItem(
        tabName = "overview",
        fluidRow(
          valueBoxOutput("value_box_total_obs", width = 4),
          valueBoxOutput("value_box_avg_nitrate", width = 4),
          valueBoxOutput("value_box_max_nitrate", width = 4)
        ),
        fluidRow(
          column(
            width = 3,
            box(
              title = "About NEON Nitrate Data",
              status = "primary",
              solidHeader = TRUE,
              collapsible = TRUE,
              width = 12,
              HTML("<p>This dataset contains surface water nitrate measurements from the NEON project.</p>
                    <p>Data collected at 15-minute intervals with associated quality flags and measurement statistics.</p>")
            )
          ),
          column(
            width = 9,
            box(
              title = "Sample Distribution",
              status = "primary",
              solidHeader = TRUE,
              width = 12,
              plotlyOutput("sample_distribution_plot", height = "600px")
            ),
            box(
              title = "Data Summary",
              status = "info",
              solidHeader = TRUE,
              width = 12,
              verbatimTextOutput("summary_text")
            )
          )
        )
      ),

      # TAB 2: Population Estimates
      tabItem(
        tabName = "estimates",
        fluidRow(
          column(12,
                 h2("Population Burden Estimates", style = "margin-top: 0;"),
                 p(style = "font-size: 15px; color: #666; margin-bottom: 20px;",
                   "Annual nitrate concentration statistics with confidence intervals and population impact estimates.")
          )
        ),
        fluidRow(
          valueBoxOutput("vbox_average", width = 3),
          valueBoxOutput("vbox_minimum", width = 3),
          valueBoxOutput("vbox_maximum", width = 3),
          valueBoxOutput("vbox_total_obs", width = 3)
        ),
        fluidRow(
          column(
            width = 3,
            box(
              title = "Filters",
              status = "primary",
              solidHeader = TRUE,
              width = NULL,
              selectInput("month_filter", "Select Month:", choices = NULL, selected = NULL),
              selectInput("year_filter", "Select Year:", choices = NULL, selected = NULL)
            )
          ),
          column(
            width = 9,
            box(
              title = "Population Estimates Table",
              status = "primary",
              solidHeader = TRUE,
              width = NULL,
              DTOutput("pop_est_table")
            )
          )
        )
      ),

      # TAB 3: Stratified Analysis
      tabItem(
        tabName = "stratified",
        fluidRow(
          column(12,
                 h2("Stratified Nitrate Analysis", style = "margin-top: 0;"),
                 p(style = "font-size: 15px; color: #666; margin-bottom: 20px;",
                   "Breakdown of nitrate levels by demographic groups, time, and locations.")
          )
        ),
        fluidRow(
          column(
            width = 3,
            box(
              title = "Analysis Controls",
              status = "primary",
              solidHeader = TRUE,
              width = NULL,
              selectInput("year_select", "Year", choices = NULL),
              selectInput("month_select", "Month", choices = NULL)
            )
          ),
          column(
            width = 9,
            box(
              title = "Stratified Analysis Plot",
              status = "primary",
              solidHeader = TRUE,
              width = NULL,
              plotlyOutput("stratified_boxplot", height = "500px")
            ),
            box(
              title = "Stratified Data Table",
              status = "info",
              solidHeader = TRUE,
              width = NULL,
              DTOutput("strata_table")
            )
          )
        )
      )
    )
  )
)
