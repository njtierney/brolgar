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
#' wages_ts %>% features(ln_wages, min) %>%
#'   filter(near_middle(V1, 0.5, 0.1))
#'             
near_middle <- function(x,
                        middle,
                        within){
  
  within <- within / 2
  
  dplyr::between(dplyr::percent_rank(x),
                 left = middle - within,
                 right = middle + within)
  
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
#' wages_ts %>% features(ln_wages, list(min = min)) %>%
#'   filter(near_between(min, 0.1, 0.9))
near_between <- function(x,
                         from,
                         to){
  dplyr::between(dplyr::percent_rank(x),
                 left = from,
                 right = to)
}

#' Which values are nearest to any given quantiles
#'
#' @param x vector
#' @param probs quantiles to calculate
#' @param tol tolerance in terms of x that you will accept near to the 
#'   quantile
#'
#' @return logical vector of TRUE/FALSE if number is close to a quantile
#' @examples
#' x <- runif(20)
#' near_quantile(x, 0.5, 0.05)
#' near_quantile(x, c(0.25, 0.5, 0.75), 0.05)
#' 
#' library(dplyr)
#' wages_ts %>% 
#'   features(ln_wages, list(min = min)) %>% 
#'   mutate(min_near_median = near_quantile(min, 0.5, 0.01)) %>%
#'   filter(min_near_median)
#' wages_ts %>% 
#'   features(ln_wages, list(min = min)) %>% 
#'   mutate(min_near_q3 = near_quantile(min, c(0.25, 0.5, 0.75), 0.01)) %>%
#'   filter(min_near_q3)
#' @export

near_quantile <- function(x, probs, tol){
  
  quant <- qtl(x, probs = probs)
  upper <- purrr::map_dbl(quant, sum, tol)
  lower <- purrr::map_dbl(quant, sum, -tol)
  
  part_btn <- purrr::partial(dplyr::between, x = x)
  
  purrr::map2_dfr(.x = lower,
                  .y = upper,
                  .f = part_btn) %>%
    rowSums() == 1
  
}

nearest_lgl <- function(x, y){
  out <- logical(length(y))
  out[purrr::map_dbl(x, function(x) which.min(abs(y - x)))] <- TRUE
  out
}

nearest_qt_lgl <- function(y, ...){
  x <- stats::quantile(y, ...)
  out <- logical(length(y))
  out[purrr::map_dbl(x, function(x) which.min(abs(y - x)))] <- TRUE
  out
}

nearest_qt <- function(y, ...){
  x <- stats::quantile(y, ...)
  purrr::map(x, function(x) which.min(abs(y - x)))
  out <- logical(length(y))
  out[purrr::map_dbl(x, function(x) which.min(abs(y - x)))] <- TRUE
  out
}

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
