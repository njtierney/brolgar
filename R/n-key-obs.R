#' Find number of observations for each key in a dataset
#' 
#' Here, we are not counting the number of rows in the dataset, but rather
#'   we are counting the number of individual, or keys, in the data.
#'
#' @param .data data.frame
#' @param ... extra arguments
#'
#' @return number of observations - the number of individuals
#' @export
#' @name n_obs
#' @export
#' @inheritParams n_obs
n_key_obs <- function(.data, ...) {
  test_if_null(.data)
  test_if_tsibble(.data)
  UseMethod("n_key_obs")
}

#' @export
#' @inheritParams n_obs
#' @rdname n_obs
n_key_obs.tbl_ts <- function(.data, ...){
  tsibble::key_data(.data) %>% 
    dplyr::mutate(n_obs = lengths(.rows)) %>%
    dplyr::select(-.rows)
}

#' @inheritParams n_obs
#' @rdname n_obs
#' @export
add_n_key_obs <- function(.data, ...){
  test_if_null(.data)
  test_if_tsibble(.data)
  UseMethod("add_n_key_obs")
}

#' @inheritParams n_obs
#' @rdname n_obs
#' @export
add_n_key_obs.tbl_ts <- function(.data, ...){
  
  str_key <- purrr::map_chr(tsibble::key(.data), rlang::as_label)

  dplyr::right_join(x = .data,
                    y = n_key_obs(.data = .data),
                    by = str_key)
  
}