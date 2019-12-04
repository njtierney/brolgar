#' Feature: Three number summary
#' 
#' This feature returns the three number summary - min, median, and maximum
#' @param x A vector to extract features from.
#' @param ... Further arguments passed to other functions.
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
#' 
#' @inheritParams feat_three_num
#' @export
feat_five_num <- function(x, ...) {
  list(
    min = b_min(x, ...),
    q25 = b_q25(x, ...),
    med = b_median(x, ...),
    q75 = b_q75(x, ...),
    max = b_max(x, ...)
  )
}

#' Feature: Ranges
#' 
#' This feature returns the ranges - the minimum, maximum, range difference, 
#'   and interquartile range.
#'   
#' @inheritParams feat_three_num
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
#'   
#' @inheritParams feat_three_num
#'   
#' @export
feat_spread <- function(x, ...){
  c(
    var = b_var(x, ...),
    sd = b_sd(x, ...),
    mad = b_mad(x, ...),
    iqr = b_iqr(x, ...)
  )
}

#' Feature: Monotonics
#' 
#' This feature returns monotonic information - does it always increase,
#'   decrease, or is it unvarying?
#'   
#' @inheritParams feat_three_num
#'   
#' @export
feat_monotonic <- function(x, ...) {
  c(increase = increasing(x, ...),
    decrease = decreasing(x, ...), 
    unvary = unvarying(x, ...),
    monotonic = monotonic(x, ...))
}

#' Feature: All from brolgar
#' 
#' This feature returns all features in brolgar.
#' 
#' @inheritParams feat_three_num
#' @export
feat_brolgar <- function(x, ...){
  c(
    min = b_min(x, ...),
    max = b_max(x, ...),
    median = b_median(x, ...),
    mean = b_mean(x, ...),
    q25 = b_q25(x, ...),
    q75 = b_q75(x, ...),
    range = b_range(x, ...),
    range_diff = b_range_diff(x, ...),
    sd = b_sd(x, ...),
    var = b_var(x, ...),
    mad = b_mad(x, ...),
    iqr = b_iqr(x, ...),
    increase = increasing(x, ...),
    decrease = decreasing(x, ...), 
    unvary = unvarying(x, ...)
  )
}

