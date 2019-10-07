#' Sample a number or fraction of keys to explore
#'
#' @param .data data.frame to explore
#' @param size The number or fraction of observations, depending on the 
#'   function used. In `sample_n_keys`, it is a number > 0, and in 
#'   `sample_frac_keys` it is a fraction, between 0 and 1.
#'
#' @return data.frame with fewer observations of key
#' @name sample-n-frac-keys
#' @export
#' @examples
#' library(ggplot2)
#' sample_n_keys(wages,
#'              size = 10) %>%
#'   ggplot(aes(x = xp,
#'              y = unemploy_rate,
#'              group = id)) + 
#'   geom_line()
sample_n_keys <- function(.data, size){
  test_if_tsibble(.data)
  test_if_null(.data)

  key_indices <- tsibble::key_rows(.data)
  sample_unique_keys <- sample(key_indices, size)
  dplyr::slice(.data, vctrs::vec_c(!!!sample_unique_keys))
}
  
#' @name sample-n-frac-keys
#' @examples
#' library(ggplot2)
#' sample_frac_keys(wages,
#'                 0.1) %>%
#'   ggplot(aes(x = xp,
#'              y = unemploy_rate,
#'              group = id)) + 
#'   geom_line()
#' @export
sample_frac_keys <- function(.data, size){
  sample_n_keys(.data, size = round(size * tsibble::n_keys(.data)))
}
