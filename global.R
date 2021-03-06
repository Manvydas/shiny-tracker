library(shiny)
library(shinyMobile)
library(DBI)
library(RPostgres)
library(DT)
library(dplyr)
library(purrr)
library(jsonlite)

# it would be better idea to use through the plumber
conn <- DBI::dbConnect(
  RPostgres::Postgres(),
  dbname = Sys.getenv("DB_NAME"),
  host = Sys.getenv("DB_HOST"),
  port = Sys.getenv("DB_PORT"),
  user = Sys.getenv("DB_USER"),
  password = Sys.getenv("DB_PW")
)