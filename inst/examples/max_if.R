#' Calculate maximum and return NA if input is empty
#'
#' This is a helper function that returns NA if length(x) == 0 (e.g., is
#' numeric(0)), otherwise calculates the maximum
#'
#' @param x numeric
#' @param ... additional arguments for max
#'
#' @return either NA or the maximum value
#' @noRd
#' @examples
#' \dontrun{
#' max_if(numeric(0))
#' }
#' @name safe_minima
max_if <- function(x, ...) {
  ifelse(test = length(x) == 0, yes = NA, no = max(x, ...))
}
