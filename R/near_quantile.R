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
#' l_min(wages,id, lnw) %>% 
#'   mutate(min_near_median = near_quantile(l_min, 0.5, 0.01)) %>%
#'   filter(min_near_median)
#' l_min(wages,id, lnw) %>% 
#'   mutate(min_near_q3 = near_quantile(l_min, c(0.25, 0.5, 0.75), 0.01)) %>%
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
