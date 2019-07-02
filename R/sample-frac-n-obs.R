#' Sample a number or fraction of keys to explore
#'
#' @param .data data.frame to explore
#' @param ... extra arguments
#' @param key vector of keys to define which values belong to which individual
#' @param size The number or fraction of observations, depending on the 
#'   function used. In `sample_n_key`, it is a number > 0, and in 
#'   `sample_frac_key` it is a fraction, between 0 and 1.
#'
#' @return data.frame with fewer observations of key
#' @name sample-n-frac-key
#' @export
#' @examples
#' library(ggplot2)
#' sample_n_key(ts_wages,
#'              size = 10) %>%
#'   ggplot(aes(x = exper,
#'              y = uerate,
#'              group = id)) + 
#'   geom_line()
sample_n_key <- function(.data, size, ...){
  UseMethod("sample_n_key")
}

#' @export
sample_n_key.tbl_ts <- function(.data, size, ...){
  
  key_chr <- tsibble::key_vars(.data)

  unique_keys <- unique(.data[[key_chr]])
  
  sample_unique_keys <- sample(unique_keys, size)

  the_matches <- .data[[key_chr]] %in% sample_unique_keys
  
  dplyr::slice(.data, which(the_matches))
  
}
  
#' @export
sample_n_key.data.frame <- function(.data, key, size, ...){
  
  .data %>%
    dplyr::group_by({{key}}) %>%
    tidyr::nest() %>%
    dplyr::sample_n(size = size) %>%
    tidyr::unnest()
  
}


#' @name sample-n-frac-key
#' @examples
#' library(ggplot2)
#' sample_frac_key(ts_wages,
#'                 0.1) %>%
#'   ggplot(aes(x = exper,
#'              y = uerate,
#'              group = id)) + 
#'   geom_line()
#' @export
sample_frac_key <- function(.data, size, ...){
  UseMethod("sample_frac_key")
}

#' @inheritParams sample-n-frac-key
#' @export
sample_frac_key.tbl_ts <- function(.data, size, ...){
  
  key_chr <- tsibble::key_vars(.data)
  
  unique_keys <- unique(.data[[key_chr]])
  
  
  sample_unique_keys <- sample(unique_keys, 
                               round(size * tsibble::n_keys(.data)))
  
  the_matches <- .data[[key_chr]] %in% sample_unique_keys
  
  dplyr::slice(.data, which(the_matches))
  
}
  
#' @inheritParams sample-n-frac-key
#' @param key vector of the unique identifier
#' @name sample-n-frac-key
#' @export
sample_frac_key.data.frame <- function(.data, key, size, ...){
  
  q_key <- rlang::enquo(key)
  
  .data %>%
    dplyr::group_by(!!q_key) %>%
    tidyr::nest() %>%
    dplyr::sample_frac(size = size) %>%
    tidyr::unnest()
  
}
