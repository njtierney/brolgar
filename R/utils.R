pct <- function(x) {
  as.character(glue::glue("q_{scales::percent(x, accuracy = 1, suffix = '')}"))
}

qtl <- function(x, probs) {
  prob_names <- pct(probs)
  stats::quantile(x = x, probs = probs, type = 7, names = FALSE) %>%
    purrr::set_names(prob_names)
}

test_if_tsibble <- function(x) {
  if (!inherits(x, "tbl_ts")) {
    stop("Input must inherit from tsibble", call. = FALSE)
  }
}

test_if_dataframe <- function(x) {
  if (!inherits(x, "data.frame")) {
    stop("Input must inherit from data.frame", call. = FALSE)
  }
}

test_if_null <- function(x, message = "Input must not be NULL") {
  if (is.null(x)) {
    stop(message, call. = FALSE)
  }
}

test_if_tilde <- function(x) {
  contains_tilde <- grepl("~", x)
  if (!any(contains_tilde)) {
    stop(
      "Input x must be a formula with a tilde ,`~`, we see, '",
      x,
      "' of class",
      class(x),
      ".",
      call. = FALSE
    )
  }
}

test_if_formula <- function(x) {
  if (!is(x, "formula")) {
    stop(
      "Input x must be a formula, we see, '",
      x,
      "' of class ",
      class(x),
      ".",
      " Formula should be specified with something on the left hand side of ~ and the right hand side.",
      " For more details on formula in R, see `?formula`.",
      call. = FALSE
    )
  }
}

classes <- function(x) purrr::map_chr(x, class)

possible_strata <- function(.data, n_strata) {
  n_keys_data <- tsibble::n_keys(.data)
  # Ensures the strata are evenly distributed amongst keys
  seq_len(n_strata) %>%
    rep(length.out = n_keys_data) %>%
    sample()
}

full_strata_df <- function(.data, n_strata) {
  possible_strata <- possible_strata(.data, n_strata)
  tsibble::key_data(.data) %>%
    dplyr::mutate(.strata = possible_strata) %>%
    tidyr::unnest_longer(col = c(.rows)) %>%
    dplyr::select(-.rows)
}

full_strata <- function(.data, n_strata) {
  possible_strata(.data, n_strata) %>%
    rep.int(times = lengths(my_key_rows(.data)))
}

my_key_data <- function(.data) {
  .data %>%
    dplyr::left_join(
      tsibble::key_data(.data),
      by = tsibble::key_vars(.data)
    ) %>%
    tibble::as_tibble() %>%
    dplyr::select(tsibble::key_vars(.data), .rows) %>%
    dplyr::distinct()
}

my_key_rows <- function(.data) {
  my_key_data(.data)[[".rows"]]
}

skip_on_gh_actions <- function() {
  if (!identical(Sys.getenv("GITHUB_ACTIONS"), "true")) {
    return(invisible(TRUE))
  }
  testthat::skip("On GitHub Actions")
}
