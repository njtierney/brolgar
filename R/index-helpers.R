#' Index summaries
#'
#' These functions check if the index is regular (`index_regular()`), and
#'     summarise the index variable (`index_summary()`). This can be useful
#'     to check your index variables.
#'
#' @param .data data.frame or tsibble
#' @param index the proposed index variable
#' @param ... extra arguments
#' @name index_summary
#'
#' @return logical  TRUE means it is regular, FALSE means not
#'
#' @examples
#' # a tsibble
#' index_regular(heights)
#'
#' # some data frames
#' index_regular(pisa, year)
#' index_regular(airquality, Month)
#'
#' # a tsibble
#' index_summary(heights)
#' # some data frames
#' index_summary(pisa, year)
#' index_summary(airquality, Month)
#' index_summary(airquality, Day)
#' @export
index_regular <- function(.data, ...) {
  UseMethod("index_regular")
}


#' @rdname index_summary
#' @export
index_regular.tbl_ts <- function(.data, ...) {
  .data %>%
    dplyr::pull(tsibble::index(.)) %>%
    unique() %>%
    sort() %>%
    diff() %>%
    unvarying()
}

#' @rdname index_summary
#' @export
index_regular.data.frame <- function(.data, index, ...) {
  .data %>%
    dplyr::pull({{ index }}) %>%
    unique() %>%
    sort() %>%
    diff() %>%
    unvarying()
}

#' @rdname index_summary
#' @export
index_summary <- function(.data, ...) {
  UseMethod("index_summary")
}


#' @rdname index_summary
#' @export
index_summary.tbl_ts <- function(.data, ...) {
  .data %>%
    dplyr::pull(tsibble::index(.)) %>%
    unique() %>%
    summary()
}

#' @rdname index_summary
#' @export
index_summary.data.frame <- function(.data, index, ...) {
  .data %>%
    dplyr::pull({{ index }}) %>%
    unique() %>%
    summary()
}
