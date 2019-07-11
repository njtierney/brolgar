#' Fit linear model for each key
#' 
#' Using `l_slope` you can fit a linear model to each key in the `tsibble`.
#' `add_l_slope` adds this slope information back to the data, and returns
#' the full dimension `tsibble`.
#' 
#' @param .data data.frame
#' @param formula formula
#' @param ... extra arguments
#' 
#' @return data.frame with coefficient information
#' 
#' @name l_slope
#' @export
l_slope <- function(.data, formula, ...) {
  UseMethod("l_slope")
}

#' @export
l_slope.tbl_ts <- function(.data, formula, ...){

  quo_formula <- rlang::enquo(formula)
  f_rhs_vars <- all.vars(
    rlang::f_rhs(
      stats::as.formula(
        rlang::as_label(quo_formula)
      )
    )
  )
  coef_tbl_vars <- c(tsibble::key_vars(.data), "l_intercept", 
                     paste0("l_slope_", f_rhs_vars))

  .data %>%
    tibble::as_tibble() %>%
    dplyr::group_by(!!!tsibble::key(.data)) %>% 
    dplyr::summarise(
      coef_tbl = list(
        as.data.frame(
          # t(stats::coef(stats::lm(!!quo_formula)))
          t(stats::coef(stats::lm({{formula}})))
          )
        )
    ) %>%
    tidyr::unnest() %>%
    rlang::set_names(coef_tbl_vars)
  
    
  
}

#' @rdname l_slope
#' @export
add_l_slope <- function(.data,
                        formula){
  
  test_if_tsibble(.data)
  test_if_null(formula)
  test_if_null(.data)
  quo_formula <- rlang::enquo(formula)
  
  str_key <- purrr::map_chr(tsibble::key(.data), rlang::as_label)
  
  l_slope(.data = .data,
          formula = !!quo_formula) %>%
    dplyr::left_join(.data,
                     by = str_key)
  
}
