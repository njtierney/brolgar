#' Brolgar summaries (b_summaries)
#' 
#' Customised summaries of vectors with appropriate defaults for longitudinal
#'   data. This includes minimum, maximum, median, q25 and q75. The functions
#'   are prefixed with `b_` to assist with autocomplete. The defaults are to use
#'   `type = 8` for quantiles, and `na.rm = TRUE`.
#' 
#' @param x a vector
#' @param na.rm whether to remove NA values. Default is TRUE
#' @param ... other arguments to pass
#' @rdname b_summaries
#' @export
b_min <- function(x, na.rm = TRUE, ... ) min(x, na.rm = na.rm, ...)

#' @name b_summaries
#' @export
b_max <- function(x, na.rm = TRUE, ... ) max(x, na.rm = na.rm, ...)

#' @name b_summaries
#' @export
b_median <- function(x, na.rm = TRUE, ... ) median(x, na.rm = na.rm, ...)

#' @name b_summaries
#' @export
b_q25 <- function(x, na.rm = TRUE, ... ){
  quantile(x,
           type = 8,
           probs = 0.25,
           na.rm = na.rm,
           ...)
}

#' @name b_summaries
#' @export
b_q75 <- function(x, na.rm = TRUE, ... ){
  quantile(x,
           type = 8,
           probs = 0.75,
           na.rm = na.rm,
           ...)
}

#' @name b_summaries
#' @export
b_range <- function(x, na.rm = TRUE, ... ) range(x, na.rm = na.rm, ...)

#' @name b_summaries
#' @export
b_range_diff <- function(x, na.rm = TRUE, ... ) {
  diff(b_range(x, 
               na.rm = na.rm,
               ...))
}