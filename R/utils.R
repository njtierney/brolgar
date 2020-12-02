#' Format a number as a quantile string
#'
#' @param x numeric
#'
#' @return character string of a percent
#' @examples
#' pct(0.1)
#' @noRd
pct <- function(x){
  as.character(glue::glue("q_{scales::percent(x, accuracy = 1, suffix = '')}"))
}

#' Return nicely named quantiles
#' 
#' Wrapper around `stats::quantile` that provides quantiles prefaced with "q_".
#'   For example, specifying probs = c(0.25) will return the value named with
#'   "q_25" instead of `25%`. This is useful for naming quantiles, and is used 
#'   within `near_quantile`. This implementation also uses `type = 7` for the 
#'   quantile calculation. See `?stats::quantile` for more detail.
#'
#' @param x numeric vector
#' @param probs numeric vector of quantiles to calculate
#'
#' @return named numeric vector
#' @examples
#' qtl(c(0:10), probs = c(0.25))
#' qtl(c(0:10), probs = c(0.25, 0.5))
#' qtl(c(0:10), probs = c(0.25, 0.5, 0.75))
#' @noRd
qtl <- function(x, probs){
  prob_names <- pct(probs)
  stats::quantile(x = x,
           probs = probs,
           type = 7,
           names = FALSE) %>%
    purrr::set_names(prob_names)
}

#' Tests if input is `tsibble`
#'
#' @param x an R object
#'
#' @return Errors if input is not `tsibble`, otherwise returns nothing.
#' @examples
#' \dontrun{
#' # will work - input is `tsibble`
#' test_if_tsibble(wages)
#' # will not work - input is `data.frame`
#' test_if_tsibble(airquality)
#' }
#' @noRd
test_if_tsibble <- function(x){
  if (!inherits(x, "tbl_ts")) {
    stop("Input must inherit from tsibble", call. = FALSE)
  }
}

#' Tests if input is `NULL`
#'
#' @param x an R object
#'
#' @return Errors if input is `NULL`, otherwise returns nothing.
#' @examples
#' \dontrun{
#' # will not work: input is `NULL`
#' test_if_null(NULL)
#' # will work: input is `data.frame`
#' test_if_null(airquality)
#' }
#' @noRd
test_if_null <- function(x, message = "Input must not be NULL"){
  if (is.null(x)) {
    stop(message, call. = FALSE)
  }
}

#' Tests if input contains a `~`, tilde
#'
#' @param x character or formula string
#'
#' @return Errors if input does not contain a `~` tilde, otherwise returns nothing.
#' @examples
#' \dontrun{
#' # will work - input contains `~`
#' test_if_tilde("y ~ x")
#' # will not work - input contains no `~`
#' test_if_tilde("y + x")
#' }
#' @noRd
test_if_tilde <- function(x) {
  contains_tilde <- grepl("~", x)
  if (! any(contains_tilde)) {
    stop("Input x must be a formula with a tilde ,`~`, we see, '", 
         x, 
         "' of class ",
         class(x),
         ".",
         call. = FALSE)
  }
}

#' Tests if input is a valid formula
#'
#' @param x character or formula string
#'
#' @return Errors if input is not a formula
#' @examples
#' \dontrun{
#' # will work - valid formula
#' test_if_formula(y ~ x)
#' # will not work - not valid formula
#' test_if_formula("y ~ x")
#' # will not work - not valid
#' test_if_formula(y + x)
#' }
#' @noRd
test_if_formula <- function(x){
  if (!is(x, "formula")) {
    stop("Input x must be a formula, we see, '", 
         x, 
         "' of class ",
         class(x),
         ".",
         " Formula should be specified with something on the left hand side of ~ and the right hand side, with no quotes around the object.",
         " For more details on formula in R, see `?formula`.",
         call. = FALSE)
  }
}

#' Vectorised class function
#'
#' @param x vector/dataframe/list
#'
#' @return character vector of classes
#' @examples
#' classes(airquality)
#' @noRd 
classes <- function(x){
  purrr::map_chr(x, class)
}

#' Create possible from data
#' 
#' To create the potential strata for use in `stratify_keys()` and 
#'   `facet_strata()`, we need to create a vector of numbers that is the length
#'   of the number of keys in the data, containing 1 to the number of desired
#'   strata. These functions help with that. This is used internally within
#'   the `stratify_keys()` functions.
#'
#' @param .data data.frame
#' @param n_strata numeric vector of length 1
#'
#' @return numeric vector the length of the number of keys in the data.
#' @examples
#' possible_strata(wages, 3)
#' possible_strata(wages, 10)
#' possible_strata(airquality, 3)
#' @rdname possible-full-strata
#' @noRd
possible_strata <- function(.data, n_strata){
  sample(rep(seq_len(n_strata),
             length.out = tsibble::n_keys(.data)))
}

#' Create full strata from data
#' 
#' To create the full strata for use in `stratify_keys()` and 
#'   `facet_strata()`, we need to create a vector of numbers that is the length
#'   of the number of rows (not keys) of the data, containing 1 to the number 
#'   of desired strata. This functions helps with that. This is used 
#'   internally within the `stratify_keys()` functions.
#'
#' @param .data data.frame
#' @param n_strata numeric vector of length 1
#'
#' @return numeric vector the length of the number of rows in the data frame.
#' @examples
#' full_strata(wages, 3)
#' full_strata(wages, 10)
#' full_strata(airquality, 3)
#' @noRd
full_strata <- function(.data, n_strata){
  
  possible_strata(.data, n_strata) %>% 
  rep.int(times = lengths(my_key_rows(.data)))
  
}


#' Helpers to extract the keys of the data
#' 
#' To calculate the full strata we need the keys and the index locations of the
#'   corresponding rows for each key. This is a wrapper around 
#'   `tsibble::key_data()` and `tsibble::key_rows()`, which order the data, 
#'   instead of being in the order presented.
#'
#' @param .data tsibble object
#'
#' @return my_key_data returns a dataset with two columns, the id, and `.rows`,
#'   A nested list column of each of the rows in the data. my_key_rows returns 
#'   a list of the row location of each id.
#' @examples
#' my_key_data(wages)
#' my_key_rows(wages)
#' @noRd
my_key_data <- function(.data){
  .data %>% 
    dplyr::left_join(tsibble::key_data(.data),
                     by = tsibble::key_vars(.data)) %>% 
    tibble::as_tibble() %>% 
    dplyr::select(tsibble::key_vars(.data), .rows) %>% 
    dplyr::distinct()
}

#' @rdname my_key_data
#' @noRd
my_key_rows <- function(.data){
  my_key_data(.data)[[".rows"]]
}
