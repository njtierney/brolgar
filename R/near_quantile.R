#' Which values are nearest to a (single) quantile
#'
#' @param x vector
#' @param probs single quantile to calculate
#' @param tol the tolerance in terms of x that you will accept near to the 
#'   quantile
#'
#' @return logical vector of TRUE/FALSE
#' @examples
#' x <- runif(20)
#' near_quantile(x, 0.5, 0.05)
#' 
#' library(dplyr)
#' l_min(wages,id, lnw) %>% 
#'   mutate(min_near_median = near_quantile(l_min, 0.5, 0.01)) %>%
#'   filter(min_near_median)
#' l_min(wages,id, lnw) %>% 
#'   mutate(min_near_median = near_quantile(l_min, 0.5, 0.01)) %>%
#'   filter(min_near_median)
#' @export

near_quantile <- function(x, probs, tol){
  
  qtl <- quantile(x, probs = probs, type = 7)
  
  tol_q <- c(qtl - tol, qtl + tol)
  
  dplyr::between(x = x, left = tol_q[1], right = tol_q[2])
  
}
# trying to generalise to many quantiles
# 
# x <- runif(20)
# probs <- c(0.1, 0.5, 0.9)
# tol <- 0.01
# qtl <- quantile(x, probs = probs, type = 7)
# names(qtl) <- glue::glue("q_{readr::parse_number(names(qtl))}")
# upper <- map_dbl(qtl, sum, tol)
# lower <- map_dbl(qtl, sum, -tol)
# qtl_bound <- data.frame(upper = upper,
#                         lower = lower) %>%
#   tibble::rownames_to_column(var = "qtl")
# 
# tibble(x = list(x),
#        qtl = list(qtl_bound))
# 
# between(x[1],
#         left = lower[1],
#         right = upper[1])
# between(x[1],
#         left = lower[2],
#         right = upper[2])
# between(x[1],
#         left = lower[3],
#         right = upper[3])
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
