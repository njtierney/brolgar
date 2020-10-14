#' Brolgar summaries (b_summaries)
#' 
#' Customised summaries of vectors with appropriate defaults for longitudinal
#'   data. The functions are prefixed with `b_` to assist with autocomplete.
#'   It uses `na.rm = TRUE` for all, and for calculations 
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
#'     * b_diff_var: The variance diff()
#'     * b_diff_sd: The standard deviation of diff()
#'     * b_diff_mean: The mean of diff()
#'     * b_diff_median: The median of diff()
#'     * b_diff_q25: The q25 of diff()
#'     * b_diff_q75: The q75 of diff()
#' 
#' @param x a vector
#' @param ... other arguments to pass
#' @rdname b_summaries
#' @examples 
#' 
#' x <- c(1:5, NA, 5:1)
#' min(x)
#' b_min(x)
#' max(x)
#' b_max(x)
#' median(x)
#' b_median(x)
#' mean(x)
#' b_mean(x)
#' range(x)
#' b_range(x)
#' var(x)
#' b_var(x)
#' sd(x)
#' b_sd(x)
#' 
#' @export
b_min <- function(x, ... ){
  min(x, na.rm = TRUE, ...)
}

#' @name b_summaries
#' @export
b_max <- function(x, ... ){
  max(x, na.rm = TRUE, ...)
}

#' @name b_summaries
#' @export
b_median <- function(x, ... ){
  stats::median(x, na.rm = TRUE, ...)
}

#' @name b_summaries
#' @export
b_mean <- function(x, ... ){
  mean(x, na.rm = TRUE, ...)
}

#' @name b_summaries
#' @export
b_q25 <- function(x, ... ){
  stats::quantile(x,
                  type = 8,
                  probs = 0.25,
                  na.rm = TRUE,
                  names = FALSE,
                  ...)
}

#' @name b_summaries
#' @export
b_q75 <- function(x, ... ){
  stats::quantile(x,
                  type = 8,
                  probs = 0.75,
                  na.rm = TRUE,
                  names = FALSE,
                  ...)
}

#' @name b_summaries
#' @export
b_range <- function(x, ... ){
  range(x, na.rm = TRUE, ...)
}

#' @name b_summaries
#' @export
b_range_diff <- function(x, ... ) {
  diff(b_range(x, 
               na.rm = TRUE,
               ...))
}

#' @name b_summaries
#' @export
b_sd <- function(x, ... ){
  stats::sd(x, na.rm = TRUE, ...)
}

#' @name b_summaries
#' @export
b_var <- function(x, ... ){
  stats::var(x, na.rm = TRUE, ...)
}

#' @name b_summaries
#' @export
b_mad <- function(x, ... ){
  stats::mad(x, na.rm = TRUE, ...)
}

#' @name b_summaries
#' @export
b_iqr <- function(x, ... ){
  stats::IQR(x, na.rm = TRUE, type = 8, ...)
}

#' @name b_summaries
#' @export
b_diff_var <- function(x, ...){
  x <- stats::na.omit(x)
  stats::var(diff(x, na.rm = TRUE, ...))
}

#' @name b_summaries
#' @export
b_diff_sd <- function(x, ...){
  x <- stats::na.omit(x)
  b_sd(diff(x, ...))
}

#' @name b_summaries
#' @export
b_diff_mean <- function(x, ...){
  x <- stats::na.omit(x)
  b_mean(diff(x, ...))
}

#' @name b_summaries
#' @export
b_diff_median <- function(x, ...){
  x <- stats::na.omit(x)
  b_median(diff(x, ...))
}

#' @name b_summaries
#' @export
b_diff_q25 <- function(x, ...){
  x <- stats::na.omit(x)
  b_q25(diff(x, ...))
}

#' @name b_summaries
#' @export
b_diff_q75 <- function(x, ...){
  x <- stats::na.omit(x)
  b_q75(diff(x, ...))
}

#' @name b_summaries
#' @export
b_diff_max <- function(x, ...){
  x <- stats::na.omit(x)
  b_max(diff(x, ...))
}

#' @name b_summaries
#' @export
b_diff_min <- function(x, ...){
  x <- stats::na.omit(x)
  b_min(diff(x, ...))
}

#' @name b_summaries
#' @export
b_diff_iqr <- function(x, ...){
  x <- stats::na.omit(x)
  b_iqr(diff(x, ...))
}

#  * `l_n_obs()` Number of observations
#  * `l_slope()` Slope and intercept (given some linear model formula)