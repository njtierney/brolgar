#' Feature: Three number summary
#' 
#' This feature returns the three number summary - min, median, and maximum
#' @export
feat_three_num <- function(x, ...) {
  c(min = b_min(x, ...),
    med = b_median(x, ...), 
    max = b_max(x, ...))
}

#' Feature: Five number summary
#' 
#' This feature returns the five number summary: minimum, q25, median, q75,
#'   and maximum.
#' @export
feat_five_num <- function(x, ...) {
  list(
    min = b_min(x, ...),
    q25 = b_q25(x, ...),
    med = b_median(x, ...),
    q_75 = b_q75(x, ...),
    max = b_max(x, ...)
  )
}

#' Feature: Ranges
#' 
#' This feature returns the ranges - the minimum, maximum, range difference, 
#'   and interquartile range.
#' @export
feat_ranges <- function(x, ...){
  c(
    min = b_min(x, ...),
    max = b_max(x, ...),
    range_diff = b_range_diff(x, ...),
    iqr = b_iqr(x, ...)
  )
}

#' Feature: Spread
#' 
#' This feature returns measurements of spread: variance, standard deviation, 
#'   median absolute distance, and interquartile range
#' @export
feat_spread <- function(x, ...){
  c(
    var = b_var(x, ...),
    sd = b_sd(x, ...),
    mad = b_mad(x, ...),
    iqr = b_iqr(x, ...)
  )
}

#' Feature: All from brolgar
#' 
#' This feature returns measurements of spread: variance, standard deviation, 
#'   median absolute distance, and interquartile range
#' @export
feat_brolgar <- function(x, ...){
  c(
    b_min = b_min(x, ...),
    b_max = b_max(x, ...),
    b_median = b_median(x, ...),
    b_mean = b_mean(x, ...),
    b_q25 = b_q25(x, ...),
    b_q75 = b_q75(x, ...),
    b_range = b_range(x, ...),
    b_range_diff = b_range_diff(x, ...),
    b_sd = b_sd(x, ...),
    b_var = b_var(x, ...),
    b_mad = b_mad(x, ...),
    b_iqr = b_iqr(x, ...)
  )
}