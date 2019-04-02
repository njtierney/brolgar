#' Calculate maximum/minimum and return NA if input is empty
#'
#' This is a helper function that returns NA if length(x) == 0 (e.g., is 
#' numeric(0)), otherwise calculates the maximum/minimum
#'
#' @param x numeric
#' @param ... additional arguments for min/max
#'
#' @return either NA or the maximum or minimum value
#' @examples
#' \dontrun{
#' max_if(numeric(0))
#' }
#' @name safe_minima
max_if <- function(x, ...){
  ifelse(test = length(x) == 0,
         yes = NA,
         no = max(x, ...))
}

#' @rdname safe_minima
min_if <- function(x, ...){
  ifelse(test = length(x) == 0,
         yes = NA,
         no = min(x, ...))
}