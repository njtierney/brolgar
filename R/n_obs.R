#' Find number of observations of individuals (keys) in a dataset
#' 
#' Here, we are not counting the number of rows in the dataset, but rather
#'   we are counting the number of individual, or keys, in the data
#'
#' @param .data data.frame
#' @param ... extra arguments
#'
#' @return number of observations - the number of individuals
#' @export
#' @name n_obs
n_obs <- function(.data, ...){
  UseMethod("n_obs")
}

#' @export
#' @inheritParams n_obs
n_obs.tbl_ts <- function(data, ...){
  tsibble::n_keys(data)
}

#' @export
#' @inheritParams n_obs
l_n_obs <- function(.data, ...) {
  UseMethod("l_n_obs")
}

#' @export
#' @inheritParams n_obs
l_n_obs.tbl_ts <- function(.data, ...){
  tsibble::key_data(.data) %>% 
    dplyr::mutate(n_obs = lengths(.rows)) %>%
    dplyr::select(-.rows)
}

#' @inheritParams n_obs
#' @export
add_l_n_obs <- function(.data, ...){
  UseMethod("add_l_n_obs")
}

#' @inheritParams n_obs
#' @export
add_l_n_obs.tbl_ts <- function(.data, ...){
  
  str_key <- purrr::map_chr(tsibble::key(.data), rlang::as_label)

  dplyr::right_join(x = .data,
                    y = l_n_obs(.data = .data),
                    by = str_key)
  
}