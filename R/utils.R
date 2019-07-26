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

test_if_tsibble <- function(x){
  if (!inherits(x, "tbl_ts")) {
    stop("Input must inherit from tsibble", call. = FALSE)
  }
}

test_if_null <- function(x, message = "Input must not be NULL"){
  if (is.null(x)) {
    stop(message, call. = FALSE)
  }
}
