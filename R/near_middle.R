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
#' l_min(wages, id, lnw) %>%
#'   filter(near_middle(l_min, 0.5, 0.1))
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
#' l_min(wages, id, lnw) %>%
#'   filter(near_between(l_min, 0.1, 0.9))
near_between <- function(x,
                         from,
                         to){
  dplyr::between(dplyr::percent_rank(x),
                 left = from,
                 right = to)
}

