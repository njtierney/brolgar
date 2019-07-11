#' Brolgar summaries (b_summaries)
#' 
#' Customised summaries of vectors with appropriate defaults for longitudinal
#'   data. The functions are prefixed with `b_` to assist with autocomplete.
#'   The defaults are to use `na.rm = TRUE` for all, and for calculations 
#'   involving quantiles, `type = 8` and `names = FALSE`. Summaries include:
#'     * b_min: The minimum
#'     * b_max: The maximum
#'     * b_median: The median
#'     * b_mean: The mean
#'     * b_q25: The 25th quantile
#'     * b_q75: The 75th quantile
#'     * b_range: The range
#'     * b_range_diff: difference in range (max - min)
#'     * b_sd: The standard deviation
#'     * b_var: The variance
#'     * b_mad: The mean absolute deviation
#'     * b_iqr: The Inter-quartile range
#' 
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
b_mean <- function(x, na.rm = TRUE, ... ) mean(x, na.rm = na.rm, ...)

#' @name b_summaries
#' @export
b_q25 <- function(x, na.rm = TRUE, ... ){
  quantile(x,
           type = 8,
           probs = 0.25,
           na.rm = na.rm,
           names = FALSE,
           ...)
}

#' @name b_summaries
#' @export
b_q75 <- function(x, na.rm = TRUE, ... ){
  quantile(x,
           type = 8,
           probs = 0.75,
           na.rm = na.rm,
           names = FALSE,
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

#' @name b_summaries
#' @export
b_sd <- function(x, na.rm = TRUE, ... ) sd(x, na.rm = na.rm, ...)

#' @name b_summaries
#' @export
b_var <- function(x, na.rm = TRUE, ... ) var(x, na.rm = na.rm, ...)

#' @name b_summaries
#' @export
b_mad <- function(x, na.rm = TRUE, ... ) mad(x, na.rm = na.rm, ...)

#' @name b_summaries
#' @export
b_iqr <- function(x, na.rm = TRUE, ... ) IQR(x, na.rm = na.rm, type = 8, ...)

#  * `l_n_obs()` Number of observations
#  * `l_slope()` Slope and intercept (given some linear model formula)

#' @export
l_five_num <- list(
    min = b_min,
    q25 = b_q25,
    med = b_median,
    q_75 = b_q75,
    max = b_max
  )
