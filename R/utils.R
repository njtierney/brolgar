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

classes <- function(x) purrr::map_chr(x, class)

possible_strata <- function(.data, n_strata){
  sample(rep(seq_len(n_strata),
             length.out = tsibble::n_keys(.data)))
}

full_strata <- function(.data, n_strata){
  
  possible_strata(.data, n_strata) %>% 
  rep.int(times = lengths(tsibble::key_rows(.data)))
  
}

skip_on_gh_actions <- function() {
  if (!identical(Sys.getenv("GITHUB_ACTIONS"), "true")) {
    return(invisible(TRUE))
  }
  testthat::skip("On GitHub Actions")
}
