stop0 <- function(...) {
  stop(..., call. = FALSE)
}

`%if_empty_string%` <- function(x, y) {
  stopifnot(length(x) == 1)
  
  if (identical(x, "")) y else x
}