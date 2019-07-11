#' brolgar
#'
#' `brolgar` stands for: **BR**owse over **L**ongitudinal data **G**raphically
#'   and **A**nalytically in **R**.
#'
#' @name brolgar
#' @docType package
NULL

#' @importFrom rlang .data quo quos enquo enquos quo_name sym ensym syms :=

if(getRversion() >= "2.15.1")  utils::globalVariables(c("."))
globalVariables(c("intercept",
                  "slope",
                  "estimate",
                  "stat", 
                  "stat_diff", 
                  "stat_value"
                  ))