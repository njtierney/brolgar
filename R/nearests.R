nearest_lgl <- function(x, y){
  out <- logical(length(y))
  out[purrr::map_dbl(x, function(x) which.min(abs(y-x)))] <- TRUE
  out
}

nearest_qt_lgl <- function(y, ...){
  x <- quantile(y, ...)
  out <- logical(length(y))
  out[purrr::map_dbl(x, function(x) which.min(abs(y-x)))] <- TRUE
  out
}

nearest_qt <- function(y, ...){
  x <- quantile(y, ...)
  map(x, function(x) which.min(abs(y-x)))
  out[purrr::map_dbl(x, function(x) which.min(abs(y-x)))] <- TRUE
  out
}