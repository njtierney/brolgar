#' @rdname l_longnostic
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
          t(stats::coef(stats::lm(!!quo_formula)))
          )
        )
    ) %>%
    tidyr::unnest() %>%
    rlang::set_names(coef_tbl_vars)
  
    
  
}

#' @export
l_slope.data.frame <- function(.data, key, formula) {
  
  
  quo_key <- rlang::enquo(key)
  quo_formula <- rlang::enquo(formula)
  f_rhs_vars <- all.vars(
    rlang::f_rhs(
      stats::as.formula(
        rlang::as_label(quo_formula)
      )
    )
  )
  coef_tbl_vars <- c(rlang::as_label(quo_key), "l_intercept", 
                     paste0("l_slope_", f_rhs_vars))
  
  
  .data %>%
    dplyr::group_by({{key}}) %>%
    dplyr::summarise(
      coef_tbl = list(as.data.frame(t(stats::coef(stats::lm(!!quo_formula)))))
    ) %>%
    tidyr::unnest() %>%
    rlang::set_names(coef_tbl_vars)
  
}

#' @rdname add_longnostic
#' @export
add_l_slope <- function(data,
                        id,
                        formula){
  
  quo_id <- rlang::enquo(id)
  quo_formula <- rlang::enquo(formula)
  
  str_id <- rlang::as_label(quo_id)
  
  l_slope(data = data,
          id = !!quo_id,
          formula = !!quo_formula) %>%
    dplyr::left_join(data,
                     by = str_id)
  
}
