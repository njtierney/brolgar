#' Brolgar summaries (b_summaries)
#' 
#' Customised summaries of vectors with appropriate defaults for longitudinal
#'   data. This includes minimum, maximum, median, q25 and q75. The functions
#'   are prefixed with `b_` to assist with autocomplete. The defaults are to use
#'   `type = 8` for quantiles, and `na.rm = TRUE`.
#' 
#' @param x a vector
#' @param ... other arguments to pass
#' @rdname b_summaries
#' @export
b_min <- function(x, ... ) min(x, na.rm = TRUE)

#' @name b_summaries
#' @export
b_max <- function(x, ... ) max(x, na.rm = TRUE)

#' @name b_summaries
#' @export
b_median <- function(x, ... ) median(x, na.rm = TRUE)

#' @name b_summaries
#' @export
b_q25 <- function(x, ... ) quantile(x, type = 8, probs = 0.25, na.rm = TRUE)

#' @name b_summaries
#' @export
b_q75 <- function(x, ... ) quantile(x, type = 8, probs = 0.75, na.rm = TRUE)