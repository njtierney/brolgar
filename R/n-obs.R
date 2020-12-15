#' Return the number of observations
#' 
#' Returns the number of observations of a vector or data.frame. It uses 
#'   `vctrs::vec_size()` under the hood.
#'
#' @param x vector or data.frame
#' @param names logical; If TRUE the result is a named vector named "n_obs", else
#'   it is just the number of observations. 
#'
#' @note You cannot use `n_obs` with `features` counting the key variable like
#'   so - `features(heights, country, n_obs)`. Instead, use any other variable.
#'
#' @return number of observations
#' @export
#'
#' @examples
#' n_obs(iris)
#' n_obs(1:10)
#' add_n_obs(heights)
#' heights %>%
#'   features(height_cm, n_obs) # can be any variable except id, the key.
n_obs <- function(x, names = TRUE){
  
  # assert if thing is either a vector
  vctrs::vec_assert(names, logical())
  # not sure how to check if x is a data.frame is a safe way.
  
  if (names) {
    size <- c(n_obs = vctrs::vec_size(x))
  }
  
  if (!names) {
    size <- vctrs::vec_size(x)
  }
  
  return(size)
}

#' Add the number of observations for each key in a `tsibble`
#' 
#' Here, we are not counting the number of rows in the dataset, but rather
#'   we are counting the number observations for each keys in the data.
#'
#' @param .data tsibble
#' @param ... extra arguments
#'
#' @return tsibble with `n_obs`, the number of observations per key added.
#' @export
#' 
#' @examples
#' library(dplyr)
#' # you can explore the data to see those cases that have exactly two 
#'  # observations:
#' heights %>% 
#'   add_n_obs() %>% 
#'   filter(n_obs == 2)
add_n_obs <- function(.data, ...){
  test_if_null(.data)
  test_if_tsibble(.data)
  
  .data %>%
    tsibble::group_by_key() %>%
    dplyr::mutate(n_obs = dplyr::n()) %>%
    dplyr::ungroup() %>%
    dplyr::select(!!!tsibble::key(.data),
                  !!tsibble::index(.data),
                  n_obs,
                  dplyr::everything())
  
}

