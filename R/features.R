#' Calculate features of a `tsibble` object in conjunction with [features()]
#'
#' You can calculate a series of summary statistics (features) of a given
#'   variable for a dataset. For example, a three number summary, the minimum,
#'   median, and maximum, can be calculated for a given variable. This is
#'   designed to work with the [features()] function shown in the examples.
#'   Other available features in `brolgar` include:
#'
#'   - [feat_three_num()] - minimum, median, maximum
#'   - [feat_five_num()] - minimum, q25, median, q75, maximum.
#'   - [feat_ranges()] - min, max, range difference, interquartile range.
#'   - [feat_spread()]  - variance, standard deviation, median absolute distance,
#'    and interquartile range
#'   - [feat_monotonic()] - is it always increasing, decreasing, or unvarying?
#'   - [feat_diff_summary()] - the summary statistics of the differences
#'  amongst a value, including the five number summary, as well as the
#'  standard deviation and variance. Returns NA if there is only one
#'  observation, as we can't take the difference of one observation, and a
#'  difference of 0 in these cases would be misleading.
#'
#'   - [feat_brolgar()]  all features in brolgar.
#'
#' @param x A vector to extract features from.
#' @param ... Further arguments passed to other functions.
#' @name brolgar-features
#' @examples
#'
#' # You can use any of the features `feat_*` in conjunction with `features`
#' # like so:
#' heights %>%
#'   features(height_cm, # variable you want to explore
#'            feat_three_num) # the feature summarisation you want to perform

#' @rdname brolgar-features
#' @export
feat_three_num <- function(x, ...) {
  c(min = b_min(x, ...), med = b_median(x, ...), max = b_max(x, ...))
}

#' @rdname brolgar-features
#' @export
feat_five_num <- function(x, ...) {
  c(
    min = b_min(x, ...),
    q25 = b_q25(x, ...),
    med = b_median(x, ...),
    q75 = b_q75(x, ...),
    max = b_max(x, ...)
  )
}

#' @rdname brolgar-features
#' @export
feat_ranges <- function(x, ...) {
  c(
    min = b_min(x, ...),
    max = b_max(x, ...),
    range_diff = b_range_diff(x, ...),
    iqr = b_iqr(x, ...)
  )
}

#' @rdname brolgar-features
#' @export
feat_spread <- function(x, ...) {
  c(
    var = b_var(x, ...),
    sd = b_sd(x, ...),
    mad = b_mad(x, ...),
    iqr = b_iqr(x, ...)
  )
}

#' @rdname brolgar-features
#' @export
feat_monotonic <- function(x, ...) {
  c(
    increase = increasing(x, ...),
    decrease = decreasing(x, ...),
    unvary = unvarying(x, ...),
    monotonic = monotonic(x, ...)
  )
}

#' @rdname brolgar-features
#' @export
feat_brolgar <- function(x, ...) {
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
    unvary = unvarying(x, ...),
    feat_diff_summary(x, ...)
  )
}

#' @rdname brolgar-features
#' @export
feat_diff_summary <- function(x, ...) {
  c(
    diff_min = b_diff_min(x, ...),
    diff_q25 = b_diff_q25(x, ...),
    diff_median = b_diff_median(x, ...),
    diff_mean = b_diff_mean(x, ...),
    diff_q75 = b_diff_q75(x, ...),
    diff_max = b_diff_max(x, ...),
    diff_var = b_diff_var(x, ...),
    diff_sd = b_diff_sd(x, ...),
    diff_iqr = b_diff_iqr(x, ...)
  )
}
