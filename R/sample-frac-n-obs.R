#' Sample a fraction of keys to explore
#'
#' @param .data data.frame to explore
#' @param ... extra arguments
#' @param key vector of keys to define which values belong to which individual
#' @param size The number or fraction of observations, depending on the 
#'   function used. In `sample_n_obs`, it is a number > 0, and in 
#'   `sample_frac_obs` it is a fraction, between 0 and 1.
#'
#' @return data.frame with fewer observations of id
#' @rdname sample-n-key
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
  
  .data[the_matches, ]
  
}
  
#' @export
sample_n_key.data.frame <- function(.data, key, size, ...){
  
  .data %>%
    dplyr::group_by({{key}}) %>%
    tidyr::nest() %>%
    dplyr::sample_n(size = size) %>%
    tidyr::unnest()
  
}

#' @name sample-frac-key
#' @examples
#' library(ggplot2)
#' sample_frac_key(ts_wages,
#'                 0.1) %>%
#'   ggplot(aes(x = exper,
#'              y = uerate,
#'              group = id)) + 
#'   geom_line()
#' @export
sample_frac_key <- function(.data, id, size){
  
  q_id <- rlang::enquo(id)
  
  .data %>%
    dplyr::group_by(!!q_id) %>%
    tidyr::nest() %>%
    dplyr::sample_frac(size = size) %>%
    tidyr::unnest()
  
}

sample_frac_key <- function(.data, id, size){
  
  q_id <- rlang::enquo(id)
  
  .data %>%
    dplyr::group_by(!!q_id) %>%
    tidyr::nest() %>%
    dplyr::sample_frac(size = size) %>%
    tidyr::unnest()
  
}

#' @inheritParams inherit-key
#' @param key vector of ids to define which values belong to which individual
#' @param size The number or fraction of observations, depending on the 
#'   function used. In `sample_n_obs`, it is a number > 0, and in 
#'   `sample_frac_obs` it is a fraction, between 0 and 1.
#'
#' @return data.frame with fewer observations of id
#' @rdname sample-key
#' @export
#' @examples
#' library(ggplot2)
#' sample_key(wages,
#'            key = id,
#'            size = 10) %>%
#'   ggplot(aes(x = exper,
#'              y = uerate,
#'              group = id)) + 
#'   geom_line()