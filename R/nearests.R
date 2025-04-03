#' Return the middle x percent of values
#'
#' @param x numeric vector
#' @param middle percentage you want to center around
#' @param within percentage around center
#' @return logical vector
#' @export
#'
#' @examples
#' x <- runif(20)
#' near_middle(x = x,
#'             middle = 0.5,
#'             within = 0.2)
#'
#' library(dplyr)
#' heights %>% features(height_cm, list(min = min)) %>%
#'   filter(near_middle(min, 0.5, 0.1))
#'
near_middle <- function(x, middle, within) {
  within <- within / 2

  dplyr::between(
    dplyr::percent_rank(x),
    left = middle - within,
    right = middle + within
  )
}

#' Return x percent to y percent of values
#'
#' @param x numeric vector
#' @param from the lower bound of percentage
#' @param to the upper bound of percentage
#'
#' @return logical vector
#' @export
#'
#' @examples
#' x <- runif(20)
#'
#' near_middle(x = x,
#'             middle = 0.5,
#'             within = 0.2)
#'
#' library(dplyr)
#' heights %>% features(height_cm, list(min = min)) %>%
#'   filter(near_between(min, 0.1, 0.9))
#'
#' near_quantile(x = x,
#'               probs = 0.5,
#'               tol = 0.01)
#'
#' near_quantile(x, c(0.25, 0.5, 0.75), 0.05)
#'
#' heights %>%
#'   features(height_cm, l_five_num) %>%
#'   mutate_at(vars(min:max),
#'             .funs = near_quantile,
#'             0.5,
#'             0.01) %>%
#'   filter(min)
#'
#' heights %>%
#'   features(height_cm, list(min = min)) %>%
#'   mutate(min_near_q3 = near_quantile(min, c(0.25, 0.5, 0.75), 0.01)) %>%
#'   filter(min_near_q3)
#'
#' heights %>%
#'   features(height_cm, list(min = min)) %>%
#'   filter(near_between(min, 0.1, 0.9))
#'
#' heights %>%
#'   features(height_cm, list(min = min)) %>%
#'   filter(near_middle(min, 0.5, 0.1))
near_between <- function(x, from, to) {
  dplyr::between(dplyr::percent_rank(x), left = from, right = to)
}

#' Which values are nearest to any given quantiles
#'
#' @param x vector
#' @param probs quantiles to calculate
#' @param tol tolerance in terms of x that you will accept near to the
#'   quantile. Default is 0.01.
#'
#' @return logical vector of TRUE/FALSE if number is close to a quantile
#' @examples
#' x <- runif(20)
#' near_quantile(x, 0.5, 0.05)
#' near_quantile(x, c(0.25, 0.5, 0.75), 0.05)
#'
#' library(dplyr)
#' heights %>%
#'   features(height_cm, list(min = min)) %>%
#'   mutate(min_near_median = near_quantile(min, 0.5, 0.01)) %>%
#'   filter(min_near_median)
#' heights %>%
#'   features(height_cm, list(min = min)) %>%
#'   mutate(min_near_q3 = near_quantile(min, c(0.25, 0.5, 0.75), 0.01)) %>%
#'   filter(min_near_q3)
#' @export

near_quantile <- function(x, probs, tol = 0.01) {
  x <- as.numeric(x)

  quant <- qtl(x, probs = probs)
  upper <- purrr::map_dbl(quant, sum, tol)
  lower <- purrr::map_dbl(quant, sum, -tol)

  part_btn <- purrr::partial(dplyr::between, x = x)

  purrr::map2_dfr(.x = lower, .y = upper, .f = part_btn) %>%
    rowSums() ==
    1
}


#' Is x nearest to y?
#'
#' @description  Returns TRUE if x is nearest to y.
#'     There are two implementations. `nearest_lgl()` returns a logical vector
#'     when an element of the first argument is nearest to an element of the
#'     second argument. `nearest_qt_lgl()` is similar to `nearest_lgl()`, but
#'     instead determines if an element of the first argument is nearest to
#'     some value of the given quantile probabilities. See example for more
#'     detail.
#'
#' @param x a numeric vector
#' @param y a numeric vector
#' @param ... (if used) arguments to pass to `quantile()`.
#'
#' @return logical vector of `length(y)`
#' @name nearests
#' @export
#'
#' @examples
#'
#' x <- 1:10
#' y <- 5:14
#' z <- 16:25
#' a <- -1:-5
#' b <- -1
#'
#' nearest_lgl(x, y)
#' nearest_lgl(y, x)
#'
#' nearest_lgl(x, z)
#' nearest_lgl(z, x)
#'
#' nearest_lgl(x, a)
#' nearest_lgl(a, x)
#'
#' nearest_lgl(x, b)
#' nearest_lgl(b, x)
#'
#' library(dplyr)
#' heights_near_min <- heights %>%
#'   filter(nearest_lgl(min(height_cm), height_cm))
#'
#' heights_near_fivenum <- heights %>%
#'   filter(nearest_lgl(fivenum(height_cm), height_cm))
#'
#' heights_near_qt_1 <- heights %>%
#'   filter(nearest_qt_lgl(height_cm, c(0.5)))
#'
#' heights_near_qt_3 <- heights %>%
#'   filter(nearest_qt_lgl(height_cm, c(0.1, 0.5, 0.9)))
#'
nearest_lgl <- function(x, y) {
  x <- vctrs::vec_cast(x, to = double())
  y <- vctrs::vec_cast(y, to = double())
  out <- logical(length(y))
  out[purrr::map_dbl(x, function(x) which.min(abs(y - x)))] <- TRUE
  out
}

#' @export
#' @rdname nearests
nearest_qt_lgl <- function(y, ...) {
  x <- stats::quantile(y, ...)
  out <- logical(length(y))
  out[purrr::map_dbl(x, function(x) which.min(abs(y - x)))] <- TRUE
  out
}

# it is not clear to me how this is significantly different to nearest_qt_lgl
# nearest_qt <- function(y, ...){
#   x <- stats::quantile(y, ...)
#   purrr::map(x, function(x) which.min(abs(y - x)))
#   out <- logical(length(y))
#   out[purrr::map_dbl(x, function(x) which.min(abs(y - x)))] <- TRUE
#   out
# }
#
#
# # Mitch's notes
# stat_near_quant(min, 0.5, 0.1)(map(seq_len(100), rnorm))
#
#
# min_near_quant <- stat_near_quant(min, 0.5, 0.1)
#
# min_near_quant(rnorm(1000))
#
# stat_near_quant <- function(fn, qt, tol){
#   function(lst, ...){
#     # ??? magic quantile stuff ???
#     fn_out <- map_dbl(lst, fn, ...)
#
#     quantile(fn_out, probs = qt)
#     #
#     # x_near <- map(qt_out, ~ x[dplyr::near(x, .x, tol)])
#     #
#     # map(x_near, fn, ...)
#   }
# }
#
# ?dplyr::ntile()
#
# # does it return a lgl (is it near to a quantile? TRUE/FALSE)
# # or a character? (q25, or q50, say - or NA if not near)
