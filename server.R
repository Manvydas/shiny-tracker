function(input, output, session) {
  
  users <- reactiveValues(
    auth = FALSE,
    excers = list(
      bech = list(
        name = "Bench Press",
        descr = "Flat bench barbell press",
        image_url = "https://upload.wikimedia.org/wikipedia/commons/a/a8/Bench-press-1.png"
      ),
      squat = list(
        name = "Squat",
        descr = "Barbell squat",
        image_url = "https://upload.wikimedia.org/wikipedia/commons/6/6f/Squats-2.png"
      )
    )
  )
  
  observe({
    users$auth <- TRUE
    users$uid <- 1
  }) %>% 
    bindEvent(input$auth)
  
  observe({
    if (users$auth) {
      uid <- users$uid
      users$info_table <- tbl(conn, "users") %>% 
        filter(uid == uid) %>% 
        collect()
      print(users$info_table)
      if (nrow(users$info_table) == 0) {
        users$info_table <- data.frame(
          uid = uid,
          username = "default",
          unit = "kg"
        )
        dbWriteTable(
          conn = conn,
          name = "users",
          users$info_table,
          append = TRUE
        )
      }
    }
  }) %>% 
    bindEvent(users$auth)
  
  
  output$list_excers <- renderUI({
    if (users$auth) {
      purrr::map(
        .x = users$excers,
        .f = function(excer) {
          tags$div(
            style = "
            background-color: white;
            padding: 5px 5px 5px 5px;
            max-width: 95%;
            color: black;
            margin: 5px 5px 5px 5px;
            ",
            tags$img(
              style = "width: 100%;",
              src = excer$image_url
            ),
            tags$h2(excer$name),
            tags$p(excer$descr)
            
          )
        }
      )
    }
  }) %>% 
    bindEvent(users$excers, users$auth)
  
  observe({
    if (users$auth) {
      new_excer <- list(
        name = list(
          name = input$new_excer_name,
          descr = input$new_excer_descr,
          image_url = input$new_excer_url
        )
      )
      names(new_excer) <- input$new_excer_name
      users$excers <- users$excers %>% append(new_excer)
    }
  }) %>% 
    bindEvent(input$new_excer_save)
}