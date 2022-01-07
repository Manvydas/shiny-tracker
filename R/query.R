updateUserInfo <- function(conn, uid, age = NA, weight = NA) {
  
  uid_input <- as.character(uid)
  user_data <- tbl(conn, "user_info") %>% 
    filter(uid == uid_input) %>% 
    collect()
  
  if (nrow(user_data) == 0) {
    user_data <- data.frame(
      uid = uid,
      age = age,
      weight = weight
    )
    dbWriteTable(
      conn = conn,
      name = "user_info",
      user_data,
      append = TRUE
    )
    return(0)
  }
  
  if (is.na(age)) age <- user_data$age
  if (is.na(weight)) weight <- user_data$weight
  
  query <- "UPDATE user_info SET age = ?age, weight = ?weight WHERE uid = ?uid"
  age <- as.integer(age)
  weight <- as.integer(weight)

  query_interp <- sqlInterpolate(
    conn = conn,
    sql = query,
    uid = uid_input,
    age = age,
    weight = weight
  )
  
  dbExecute(conn = conn, query_interp)
  
  return(0)
  
}


fetchUserInfo <- function(conn, uid) {
  
  uid_input <- as.character(uid)
  user_data <- tbl(conn, "user_info") %>% 
    filter(uid == uid_input) %>% 
    collect()
  
  if (nrow(user_data) == 0) return(data.frame(uid = uid, age = 0, weight = 0))

  return(user_data)
  
}

updateExercises <- function(conn, uid, new_exer) {
  
  uid_input <- as.character(uid)
  user_data <- tbl(conn, "exercises") %>% 
    filter(uid == uid_input) %>% 
    collect()
  exers <- fromJSON(user_data$exercises)
  if (names(new_exer) %in% names(exers)) stop("Exercise already exist")
  if (nchar(names(new_exer)) < 1) stop("No name provided")
  exers <- exers %>% 
    append(new_exer)
  
  exers_json <- toJSON(exers)
  query <- "UPDATE exercises SET exercises = ?exers WHERE uid = ?uid"

  query_interp <- sqlInterpolate(
    conn = conn,
    sql = query,
    uid = uid_input,
    exers = exers_json
  )
  
  dbExecute(conn = conn, query_interp)
  
  return(exers)
  
}