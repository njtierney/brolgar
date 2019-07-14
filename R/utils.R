#' Calculate maximum and return NA if input is empty
#'
#' This is a helper function that returns NA if length(x) == 0 (e.g., is 
#' numeric(0)), otherwise calculates the maximum
#'
#' @param x numeric
#' @param ... additional arguments for max
#'
#' @return either NA or the maximum value
#' @examples
#' \dontrun{
#' max_if(numeric(0))
#' }
#' @name safe_minima
max_if <- function(x, ...){
  ifelse(test = length(x) == 0,
         yes = NA,
         no = max(x, ...))
}

pct <- function(x){
  glue::glue("q_{scales::percent(x, accuracy = 1, suffix = '')}")
}

qtl <- function(x, probs){
  
  prob_names <- pct(probs)
  
  stats::quantile(x = x,
           probs = probs,
           type = 7,
           names = FALSE) %>%
    purrr::set_names(prob_names)
}

# qtl(x = x, probs = qtl_val)

test_if_tsibble <- function(x){
  # test for tsibble
  if (!inherits(x, "tbl_ts")) {
    stop("Input must inherit from tsibble", call. = FALSE)
  }
  
}

#' Test if the input is NULL
#'
#' @param x object
#'
#' @return an error if input (x) is NULL
#'
#' @examples
#' \dontrun{
#' # success
#' test_if_null(airquality)
#' #fail
#' my_test <- NULL
#' test_if_null(my_test)
#' }
test_if_null <- function(x){
  
  # test for null
  if (is.null(x)) {
    stop("Input must not be NULL", call. = FALSE)
  }
}

extract_coef <- function(x){
  as.data.frame(t(stats::coef(x)))
}

extract_formula_vars <- function(x){
  all.vars(
    rlang::f_rhs(
      stats::as.formula(
        rlang::as_label(x)
      )
    )
  )  
}
