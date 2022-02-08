function(input, output, session) {
  
  users <- reactiveValues(
    auth = FALSE,
    exers = list()
  )
  
  observe({
    users$auth <- TRUE
    users$uid <- 1
  }) %>% 
    bindEvent(input$auth)
  
  observe({
    if (users$auth) {
      uid <- users$uid
      users$data <- tbl(conn, "users") %>% 
        filter(uid == uid) %>% 
        collect()
      if (nrow(users$data) == 0) {
        users$data <- data.frame(
          uid = uid,
          username = "default",
          unit = "kg"
        )
        dbWriteTable(
          conn = conn,
          name = "users",
          users$data,
          append = TRUE
        )
      }
      users$info <- fetchUserInfo(conn = conn, uid = users$uid)
    }
  }) %>% 
    bindEvent(users$auth)
  
  observe({
    if (users$auth) {
      uid <- users$uid
      exers_df <- tbl(conn, "exercises") %>% 
        filter(uid == uid) %>% 
        collect()
      if (nrow(exers_df) == 0) {
        exers_df <- data.frame(
          uid = uid,
          exercises = "{}"
        )
        dbWriteTable(
          conn = conn,
          name = "exercises",
          exers_df,
          append = TRUE
        )
      }
      users$exers <- exers_df$exercises %>% 
        fromJSON()
    }
  }) %>% 
    bindEvent(users$auth)
  
  observe({
    if (users$auth) {
      updateF7Select(
        inputId = "age",
        selected = users$info$age
      )
      updateF7Select(
        inputId = "weight",
        selected = users$info$weight
      )
    }
  }) %>% 
    bindEvent(users$info)
  
  output$list_exers <- renderUI({
    if (users$auth) {
      purrr::map2(
        .x = users$exers,
        .y = seq_len(length(users$exers)),
        .f = function(exer, index) {
          tagList(
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
              src = exer$image_url
            ),
            tags$h2(exer$name),
            tags$p(exer$descr),
            actionButton(
              inputId = paste0("del_exer_", index),
              label = "Delete"
            )
            )
          )
        }
      )
    }
  }) %>% 
    bindEvent(users$exers, users$auth)
  
  purrr::map(
    .x = 1:100,
    function(x) {
      observe({
        if (users$auth) {
          uid <- users$uid
          del_exer <- users$exers[[x]]$name
          users$exers <- deleteExercises(
            conn = conn,
            uid = uid,
            del_exer = del_exer
          )
        }
      }) %>% 
        bindEvent(input[[paste0("del_exer_", x)]])
    }
  )
  
  observe({
    if (users$auth) {
      uid <- users$uid
      new_exer <- list(
        name = list(
          name = input$new_exer_name,
          descr = input$new_exer_descr,
          image_url = input$new_exer_url
        )
      )
      names(new_exer) <- input$new_exer_name
      users$exers <- updateExercises(
        conn = conn,
        uid = uid,
        new_exer = new_exer
      )
    }
  }) %>% 
    bindEvent(input$new_exer_save)
  
  observe({
    if (users$auth){
      updateUserInfo(
        conn = conn,
        age = input$age,
        weight = input$weight,
        uid = users$uid
      )
    }
  }) %>% 
    bindEvent(input$update_metrics)
}