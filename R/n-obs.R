#' Return the number of observations
#' 
#' Returns the number of observations of a vector or data.frame. It uses 
#'   `vctrs::vec_size()` under the hood.
#'
#' @param x vector or dataframe
#' @param names logical; If TRUE the result is a named vector named "n_obs", else
#'   it is just the number of observations. 
#'
#' @return number of observations
#' @export
#'
#' @examples
#' n_obs(iris)
#' n_obs(1:10)
#' # return the number of observations
#' wages %>% 
#'   features(id, n_obs)
n_obs <- function(x, names = TRUE){
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
#' @param .data data.frame
#' @param ... extra arguments
#'
#' @return dataframe with `n_obs`, the number of observations per key added.
#' @export
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

