#' Fit linear model for each key
#'
#' Using `key_slope` you can fit a linear model to each key in the `tsibble`.
#' `add_key_slope` adds this slope information back to the data, and returns
#' the full dimension `tsibble`.
#'
#' @param .data tsibble
#' @param formula formula
#' @param ... extra arguments
#'
#' @return tibble with coefficient information
#'
#' @name key_slope
#'
#' @examples
#' key_slope(heights, height_cm ~ year)
#'
#' @export
key_slope <- function(.data, formula, ...) {
  test_if_tilde(formula)
  test_if_formula(formula)
  UseMethod("key_slope")
}

#' @export
key_slope.tbl_ts <- function(.data, formula, ...) {
  quo_formula <- rlang::enquo(formula)
  f_rhs_vars <- all.vars(
    rlang::f_rhs(
      stats::as.formula(
        rlang::as_label(quo_formula)
      )
    )
  )
  coef_tbl_vars <- c(
    tsibble::key_vars(.data),
    ".intercept",
    paste0(".slope_", f_rhs_vars)
  )
  .data %>%
    tibble::as_tibble() %>%
    dplyr::group_by(!!!tsibble::key(.data)) %>%
    dplyr::summarise(
      coef_tbl = list(
        as.data.frame(
          t(stats::coef(stats::lm(
            stats::as.formula(
              rlang::as_label(quo_formula)
            )
          )))
        )
      )
    ) %>%
    tidyr::unnest(cols = c(coef_tbl)) %>%
    rlang::set_names(coef_tbl_vars)
}

#' @rdname key_slope
#' @export
add_key_slope <- function(.data, formula) {
  test_if_null(.data)
  test_if_null(formula)
  test_if_tsibble(.data)

  str_key <- purrr::map_chr(tsibble::key(.data), rlang::as_label)

  key_slope(.data = .data, formula = {{ formula }}) %>%
    dplyr::left_join(.data, ., by = str_key) %>%
    dplyr::select(
      !!!tsibble::key(.data),
      !!tsibble::index(.data),
      dplyr::starts_with("."),
      dplyr::everything()
    )
}

#' @rdname key_slope
#' @export
add_key_slope.default <- function(.data, formula) {
  stop(
    "Currently there is no method to deal with .data, which is of class ",
    class(.data),
    "."
  )
}
