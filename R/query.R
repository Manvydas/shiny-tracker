updateUserInfo <- function(age = NA, weight = NA, uid, conn) {
  
  user_data <- tbl(conn, "user_info") %>% 
    filter(uid == uid) %>% 
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
  }
  
}