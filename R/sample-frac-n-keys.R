#' Sample a number or fraction of keys to explore
#'
#' @param .data data.frame to explore
#' @param size The number or fraction of observations, depending on the 
#'   function used. In `sample_n_keys`, it is a number > 0, and in 
#'   `sample_frac_keys` it is a fraction, between 0 and 1.
#' @param ... extra arguments
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
sample_n_keys <- function(.data, size, ...){
  test_if_tsibble(.data)
  test_if_null(.data)
  UseMethod("sample_n_keys")
}

#' @export
sample_n_keys.tbl_ts <- function(.data, size, ...){
  
  key_chr <- tsibble::key_vars(.data)

  unique_keys <- unique(.data[[key_chr]])
  
  sample_unique_keys <- sample(unique_keys, size)

  the_matches <- .data[[key_chr]] %in% sample_unique_keys
  
  dplyr::slice(.data, which(the_matches))
  
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
sample_frac_keys <- function(.data, size, ...){
  test_if_tsibble(.data)
  test_if_null(.data)
  UseMethod("sample_frac_keys")
}

#' @inheritParams sample-n-frac-keys
#' @export
sample_frac_keys.tbl_ts <- function(.data, size, ...){
  
  key_chr <- tsibble::key_vars(.data)
  
  unique_keys <- unique(.data[[key_chr]])
  
  
  sample_unique_keys <- sample(unique_keys, 
                               round(size * tsibble::n_keys(.data)))
  
  the_matches <- .data[[key_chr]] %in% sample_unique_keys
  
  dplyr::slice(.data, which(the_matches))
  
}