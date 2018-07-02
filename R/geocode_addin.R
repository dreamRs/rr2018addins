
#' Géocode un point placé sur une carte
#'
#' @export
#'
#' @importFrom ggmap revgeocode
#' @importFrom leaflet leafletOutput renderLeaflet leaflet addTiles setView leafletProxy removeMarker addMarkers %>%
#' @importFrom miniUI miniPage gadgetTitleBar miniContentPanel
#' @importFrom shiny absolutePanel uiOutput reactiveValues observeEvent renderUI tags paneViewer runGadget stopApp
#'
#' @examples
#' \dontrun{
#'
#' if (interactive()) {
#'
#' geocode_addin()
#'
#' }
#'
#' }
geocode_addin <- function() {

  ui <- miniPage(
    gadgetTitleBar("Géolocalisation"),
    miniContentPanel(
      padding = 0,
      leafletOutput(outputId = "carte", height = "100%"),
      absolutePanel(
        bottom = 5, left = 5,
        uiOutput(outputId = "res")
      )
    )
  )


  server <- function(input, output, session) {

    output$carte <- renderLeaflet({
      leaflet() %>%
        addTiles() %>%
        setView(lng = -1.66, lat = 48.1, zoom = 11)
    })

    localisation <- reactiveValues(lng = NULL, lat = NULL, adresse = NULL)

    observeEvent(input$carte_click, {
      leafletProxy(mapId = "carte") %>%
        removeMarker(layerId = "points") %>%
        addMarkers(lng = input$carte_click$lng, lat = input$carte_click$lat, layerId = "points")
      localisation$lng <- input$carte_click$lng
      localisation$lat <- input$carte_click$lat
      geoloc <- revgeocode(location = c(input$carte_click$lng, input$carte_click$lat))
      localisation$adresse <- geoloc
    })

    output$res <- renderUI({
      if (!is.null(localisation$lng)) {
        tags$div(
          style = "background-color: white; padding: 10px; border-style: solid; border-color: steelblue; border-radius: 10px;",
          "Latitude : ", localisation$lat, tags$br(),
          "Longitude : ", localisation$lng, tags$br(),
          "Adresse : ", tags$b(localisation$adresse), tags$br(),
          "Code :", tags$br(), tags$div(tags$pre(tags$code(
            sprintf("\rrevgeocode(c(%s,\n %s))", localisation$lng, localisation$lat)
          )))
        )
      }
    })

    observeEvent(input$done, stopApp())

  }

  viewer <- paneViewer(300)
  runGadget(ui, server, viewer = viewer)

}



