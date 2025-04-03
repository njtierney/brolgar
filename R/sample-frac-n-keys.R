#' Sample a number or fraction of keys to explore
#'
#' @param .data tsibble object
#' @param size The number or fraction of observations, depending on the
#'   function used. In `sample_n_keys`, it is a number > 0, and in
#'   `sample_frac_keys` it is a fraction, between 0 and 1.
#'
#' @return tsibble with fewer observations of key
#' @name sample-n-frac-keys
#' @export
#' @examples
#' library(ggplot2)
#' sample_n_keys(heights,
#'              size = 10) %>%
#'   ggplot(aes(x = year,
#'              y = height_cm,
#'              group = country)) +
#'   geom_line()
sample_n_keys <- function(.data, size) {
  test_if_tsibble(.data)
  test_if_null(.data)
  UseMethod("sample_n_keys")
}

#' @export
sample_n_keys.tbl_ts <- function(.data, size) {
  key_indices <- tsibble::key_rows(.data)
  sample_unique_keys <- sample(key_indices, size)
  dplyr::slice(.data, vctrs::vec_c(!!!sample_unique_keys))
}

#' @rdname sample-n-frac-keys
#' @examples
#' library(ggplot2)
#' sample_frac_keys(wages,
#'                 0.1) %>%
#'   ggplot(aes(x = xp,
#'              y = unemploy_rate,
#'              group = id)) +
#'   geom_line()
#' @export
sample_frac_keys <- function(.data, size) {
  test_if_tsibble(.data)
  test_if_null(.data)
  UseMethod("sample_frac_keys")
}

#' @inheritParams sample-n-frac-keys
#' @export
sample_frac_keys.tbl_ts <- function(.data, size) {
  if (size > 1 & size > 0) {
    stop(
      "sample size for `sample_frac_keys` must between 0 and 1, the size given was `",
      size,
      "`"
    )
  }

  sample_n_keys(.data, size = round(size * tsibble::n_keys(.data)))
}
