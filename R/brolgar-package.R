#' @details
#' `brolgar` stands for: **BR**owse over **L**ongitudinal data **G**raphically
#' and **A**nalytically in **R**.
#'
#' @keywords internal
"_PACKAGE"

#' @importFrom rlang .data quo quos enquo enquos quo_name sym ensym syms :=

if(getRversion() >= "2.15.1")  utils::globalVariables(c("."))
globalVariables(c("intercept",
                  "is",
                  "slope",
                  "estimate",
                  "na.rm",
                  "stat", 
                  "stat_diff", 
                  "stat_value",
                  ".rows",
                  "quantile",
                  "coef_tbl",
                  "n_obs",
                  "colorRampPalette"
                  ))