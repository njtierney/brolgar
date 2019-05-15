#' brolgar
#'
#' brolgar is a package ...
#'
#' @name brolgar
#' @docType package
NULL

#' @importFrom rlang .data quo quos enquo enquos quo_name sym ensym syms :=

if(getRversion() >= "2.15.1")  utils::globalVariables(c("."))
globalVariables(c("intercept",
                  "slope",
                  "median",
                  "quantile",
                  "sd",
                  "term",
                  "estimate",
                  "stat", 
                  "stat_diff", 
                  "stat_value"
                  ))