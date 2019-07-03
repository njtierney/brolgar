#' @rdname l_longnostic
#' @export
l_slope <- function(.data, formula, ...) {
  UseMethod("l_slope")
}

#' @export
l_slope.tbl_ts <- function(.data, formula, ...){

  key_sym <- tsibble::key(.data)
  quo_formula <- rlang::enquo(formula)
  f_rhs_vars <- extract_formula_vars(quo_formula)
  
  coef_tbl_vars <- c(tsibble::key_vars(.data), 
                     "l_intercept", 
                     paste0("l_slope_", f_rhs_vars))

  .data %>%
    tibble::as_tibble() %>%
    dplyr::group_by(!!!tsibble::key(.data)) %>%
    dplyr::summarise(
      lm_coef = list(extract_coef(lm(!!quo_formula, data = .)))
    ) %>%
    tidyr::unnest() %>%
    rlang::set_names(coef_tbl_vars)
  
}

#' @export
l_slope.data.frame <- function(.data, key, formula) {
  
  quo_key <- rlang::enquo(key)
  quo_formula <- rlang::enquo(formula)
  f_rhs_vars <- extract_formula_vars(quo_formula)

    coef_tbl_vars <- c(rlang::as_label(quo_key), 
                     "l_intercept", 
                     paste0("l_slope_", f_rhs_vars))
  
  .data %>%
    dplyr::group_by(!!quo_key) %>%
    dplyr::summarise(
      lm_coef = list(extract_coef(lm(!!quo_formula, data = .)))
    ) %>%
    tidyr::unnest() %>%
    rlang::set_names(coef_tbl_vars)
  
}