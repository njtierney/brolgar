#' Calculating lognostics
#' 
#' Lognostics are Cognitive Diagnostics for longitudinal data
#' 
#' @param df data.frame to explore
#' @param var vector of values for individuals, needs to match the id vector
#' @param id vector of ids to define which values belong to which individual
#' @name lognostic
NULL

#' Index of interestingness: mean
#'
#' Compute the mean for all individuals in the data
#'
#' @inheritParams lognostic
#' @export
#' @examples
#' library(tidyverse)
#' data(wages)
#' m <- l_mean(wages, "id", "lnw")
#'
l_mean <- function(df, id, var) {
  sub <- df[, c(id, var)]
  l <- split(sub, sub[[id]])
  m <- purrr::map_dbl(l, ~ mean(.x[[var]], na.rm = TRUE))
  ng <- tibble::tibble(id = unique(sub[[id]]), m)
  return(ng)
}

#' Index of interestingness: sd
#'
#' Compute the standard deviation for all individuals in the data
#'
#' @inheritParams lognostic
#' @export
#' @examples
#' library(tidyverse)
#' data(wages)
#' s <- l_sd(wages, "id", "lnw")
#'
l_sd <- function(df, id, var) {
  sub <- df[, c(id, var)]
  l <- split(sub, sub[[id]])
  m <- purrr::map_dbl(l, ~ sd(.x[[var]], na.rm = TRUE))
  ng <- tibble::tibble(id = unique(sub[[id]]), m)
  return(ng)
}

#' Index of interestingness: max
#'
#' Compute the maximum value for all individuals in the data
#'
#' @inheritParams lognostic
#' @export
#' @examples
#' library(tidyverse)
#' data(wages)
#' m <- l_max(wages, "id", "lnw")
#'
l_max <- function(df, id, var) {
  sub <- df[, c(id, var)]
  l <- split(sub, sub[[id]])
  m <- purrr::map_dbl(l, ~ max(.x[[var]], na.rm = TRUE))
  ng <- tibble::tibble(id = unique(sub[[id]]), m)
  return(ng)
}

#' Index of interestingness: min
#'
#' Compute the minimum value for all individuals in the data

#' @inheritParams lognostic
#' @export
#' @examples
#' library(tidyverse)
#' data(wages)
#' m <- l_min(wages, "id", "lnw")
#'
l_min <- function(df, id, var) {
  sub <- df[, c(id, var)]
  l <- split(sub, sub[[id]])
  m <- purrr::map_dbl(l, ~ min_if(.x[[var]], na.rm = TRUE))
  ng <- tibble::tibble(id = unique(sub[[id]]), m)
  return(ng)
}

#' Index of interestingness: median
#'
#' Compute the median value for all individuals in the data

#' @inheritParams lognostic
#' @export
#' @examples
#' library(tidyverse)
#' data(wages)
#' m <- l_median(wages, "id", "lnw")
#'
l_median <- function(df, id, var) {
  sub <- df[, c(id, var)]
  l <- split(sub, sub[[id]])
  m <- purrr::map_dbl(l, ~ median(.x[[var]], na.rm = TRUE))
  ng <- tibble::tibble(id = unique(sub[[id]]), m)
  return(ng)
}

#' Index of interestingness: first quartile
#'
#' Compute the first quartile value for all individuals in the data

#' @inheritParams lognostic
#' @export
#' @examples
#' library(tidyverse)
#' data(wages)
#' m <- l_q1(wages, "id", "lnw")
#'
l_q1 <- function(df, id, var) {
  sub <- df[, c(id, var)]
  l <- split(sub, sub[[id]])
  m <- purrr::map_dbl(l, ~ quantile(.x[[var]], 0.25, type = 7, na.rm = TRUE))
  ng <- tibble::tibble(id = unique(sub[[id]]), m)
  return(ng)
}

#' Index of interestingness: third quartile
#'
#' Compute the third quartile value for all individuals in the data

#' @inheritParams lognostic
#' @export
#' @examples
#' library(tidyverse)
#' data(wages)
#' m <- l_q3(wages, "id", "lnw")
#'
l_q3 <- function(df, id, var) {
  sub <- df[, c(id, var)]
  l <- split(sub, sub[[id]])
  m <- purrr::map_dbl(l, ~ quantile(.x[[var]], 0.75, type = 7, na.rm = TRUE))
  ng <- tibble::tibble(id = unique(sub[[id]]), m)
  return(ng)
}

#' Index of interestingness: first order difference
#' Need to revisit for missing values
#'
#' Compute the maximum of the first order difference of consecutive values for all individuals in the data

#' @inheritParams lognostic
#' @export
#' @examples
#' library(tidyverse)
#' data(wages)
#' m <- l_d1(wages, "id", "lnw")
#'
l_d1 <- function(df, id, var) {
  
  sub <- df[, c(id, var)]
  l <- split(sub, sub[[id]])
  m <- purrr::map_dbl(l, ~ max_if(diff(.x[[var]], lag = 1)))
  ng <- tibble::tibble(id = unique(sub[[id]]), m)
  return(ng)
}


#' Index of interestingness: n subjects
#'
#' Compute the number of observations for each individuals in the data

#' @inheritParams lognostic
#' @export
#' @examples
#' library(tidyverse)
#' data(wages)
#' ns <- l_length(wages, "id", "lnw")
#'
l_length <- function(df, id, var) {
  sub <- df[, c(id, var)]
  l <- split(sub, sub[[id]])
  n <- purrr::map_dbl(l, ~ length(.x[[var]]))
  lg <- tibble::tibble(id = unique(sub[[id]]), n)
  return(lg)
}

#' Index of interestingness: slope
#'
#' Compute the maximum value for all individuals in the data

#' @inheritParams lognostic
#' @param formula character, a formula representing the slope of interest
# @param var vector of values to compute statistic on
# @param time variable for model
#' @export
#' @examples
#' library(tidyverse)
#' data(wages)
#' m <- l_slope(wages, "id", "lnw~exper")
#'
l_slope <- function(df, id, formula) {
  l <- split(df, df[[id]])
  sl <- purrr::map(l, ~ eval(substitute(lm(formula, data = .)))) %>%
    purrr::map_dfr( ~ as.data.frame(t(as.matrix(coef(
      .
    ))))) %>%
    dplyr::mutate(id = as.integer(names(l))) %>%
    dplyr::rename_all( ~ c("intercept", "slope", "id")) %>%
    dplyr::select(id, intercept, slope) %>%
    tibble::as_tibble()
  return(sl)
}
