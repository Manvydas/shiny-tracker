shinyUI(
  f7Page(
    title = "Tab Layout",
    f7TabLayout(
      navbar = f7Navbar(
        title = "workout tracker",
        hairline = FALSE,
        shadow = TRUE
      ),
      f7Tabs(
        id = "tabdemo",
        swipeable = TRUE,
        animated = FALSE,
        style = c("toolbar", "segmented", "strong"),
        f7Tab(
          tabName = "main",
          active = TRUE,
          icon = f7Icon("bolt_fill"),
          f7Button(
            inputId = "auth",
            label = "Login"
          ),
          f7Select(
            inputId = "age",
            label = "Age",
            choices = 1:100
          ),
          f7Select(
            inputId = "weight",
            label = "Weight",
            choices = 1:150
          ),
          f7Button(
            inputId = "update_metrics",
            label = "Update metrics"
          ),
          f7Sheet(
            id = "sheet",
            label = "More",
            orientation = "bottom",
            swipeToClose = TRUE,
            swipeToStep = TRUE,
            backdrop = TRUE,
            "Issokantis langas"
          )
        ),
        f7Tab(
          tabName = "workouts",
          f7Select(
            inputId = "w_day_select",
            label = "Day",
            choices = 1:3
          ),
          uiOutput(
            outputId = "w_day_summary"
          )
        ),
        f7Tab(
          tabName = "exer",
          uiOutput(
            outputId = "list_exers"
          )
        ),
        f7Tab(
          tabName = "new_exer",
          f7Text(
            inputId = "new_exer_name",
            label = "Name of the new exercise"
          ),
          f7TextArea(
            inputId = "new_exer_descr",
            label = "exercise description"
          ),
          f7Text(
            inputId = "new_exer_url",
            label = "Link to the image of exercise"
          ),
          f7Button(
            inputId = "new_exer_save",
            label = "Save"
          )
        ),
        .items = f7TabLink(
          icon = f7Icon("bolt_fill"),
          label = "Toggle Sheet",
          `data-sheet` = "#sheet",
          class = "sheet-open"
        )
      )
    )
  )
)