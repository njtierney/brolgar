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

#- Palette helper functions

middle <- function(x){
  floor(stats::median(seq_along(x)))
}


left <- function(x){
  1:middle(x)
}


right <- function(x){
  middle(x):length(x)
}


reflect_left <- function(x){
  middle <- middle(x)
  lhs <- left(x)[-middle]
  rhs <- rev(lhs)
  x[c(lhs, middle, rhs)]
}


reflect_right <- function(x){
  middle <- middle(x)
  rhs <- right(x)[-1]
  lhs <- rev(rhs)
  x[c(lhs, middle, rhs)]
}

vec <- 1:5
middle(vec)
left(vec)
right(vec)
reflect_left(vec)
reflect_right(vec)