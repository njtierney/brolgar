#' Obtain IDs closest to each quantile for a given stat
#'
#' @param data data.frame
#' @param id id
#' @param var variable to calculate stat on
#' @param stat statistic to calculate
#' @param l_name name of the statistic
#' @param ... extra arguments to pass to the statistic
#' @param probs vector of quantile probabilites
#' @param tolerance select stats within this this amount (default is 
#'   `.Machine$double.eps^0.5`)
#'
#' @return dataframe with the columns: `id`, `quant`, `l_name`, and 
#'   `q_stat_diff`, which is the difference between the stat and the quantile
#'   calculated. This can be useful to understand the impact of `tolerance`
#' @export
#'
#' @examples
#' stat_near_quant(wages,
#'                 id,
#'                 lnw,
#'                 stat = min,
#'                 l_name = l_min,
#'                 na.rm = TRUE,
#'                 tolerance = 0.01)
stat_near_quant <- function(data,
                            id,
                            var,
                            stat,
                            l_name,
                            ...,
                            probs = c(0.25, 0.5, 0.75),
                            tolderance = .Machine$double.eps^0.5){
  
  q_id <- rlang::enquo(id)
  q_var <- rlang::enquo(var)
  sym_l_name <- rlang::ensym(l_name)
  sym_stat <- rlang::ensym(stat)
  str_id <- rlang::as_label(q_id)
  
  l_stat_data <-  longnostic(data,
                             id = !!q_id,
                             var = !!q_var,
                             statistic = !!sym_stat,
                             l_name = !!sym_l_name,
                             ...)
  
  l_stat_quants <- quantile(x = dplyr::pull(l_stat_data, !!sym_l_name),
                            probs = probs,
                            type = 7)
  
  part_near <- purrr::partial(dplyr::near,
                              y = dplyr::pull(l_stat_data, !!sym_l_name),
                              tol = tolerance)
  
  summarise_l_stat_data <- l_stat_data %>%
    dplyr::summarise(id = list(!!q_id), 
                     qs = list(as.list(quantile(x = l_stat_quants,
                                                probs = probs,
                                                type = 7)))
    )
  
  near_quant_id <- summarise_l_stat_data %>%
    dplyr::mutate(is_near = list(
      purrr::map_dfr(purrr::flatten(qs), part_near))
    ) %>% 
    dplyr::select(!!q_id, is_near) %>%
    tidyr::unnest() %>%
    tidyr::gather(key = "near_q",
                  value = "value",
                  -!!q_id) %>%
    dplyr::left_join(l_stat_data, by = str_id) %>%
    dplyr::filter(value) %>%
    dplyr::mutate(nearest_quant = 
      dplyr::case_when(value ~ glue::glue("q_{readr::parse_number(near_q)}"))
        # glue::glue("q_{readr::parse_number(near_q)}")
    ) %>%
    dplyr::select(!!q_id,
                  nearest_quant,
                  !!sym_l_name)
    
  # show us how different the stat is to the quantile
  new_quant_lab <- glue::glue("q_{readr::parse_number(names(l_stat_quants))}")
  
  tibble::enframe(l_stat_quants, name = "quant", value = "l_stat_quants") %>%
    dplyr::mutate(quant = new_quant_lab) %>%
    dplyr::left_join(y = near_quant_id,
                     by = c("quant" = "nearest_quant")) %>%
    dplyr::mutate(q_stat_diff = l_stat_quants - !!sym_l_name) %>%
    dplyr::select(!!q_id, 
                  quant,
                  !!sym_l_name,
                  q_stat_diff)
  
}

#' @rdname stat-near-quant
#' @export
#' @examples
#' filter_stat_near_quant(wages,
#'                        id,
#'                        lnw,
#'                        stat = min,
#'                        l_name = l_min,
#'                        na.rm = TRUE,
#'                        tolerance = 0.01)

filter_stat_near_quant <- function(data,
                                   id,
                                   var,
                                   stat,
                                   l_name,
                                   ...,
                                   probs = c(0.25, 0.5, 0.75),
                                   tolerance = .Machine$double.eps^0.5){
  
  q_id <- rlang::enquo(id)
  q_var <- rlang::enquo(var)
  sym_stat <- rlang::ensym(stat)
  sym_l_name <- rlang::ensym(l_name)
    str_id <- rlang::as_label(q_id)
  
  data_near_quant <- stat_near_quant(data = data,
                                     id = !!q_id,
                                     var = !!q_var,
                                     stat = !!sym_stat,
                                     l_name = !!sym_l_name,
                                     ...,
                                     probs = probs,
                                     tolerance = tolerance)
  
  dplyr::left_join(x = data_near_quant,
                   y = data,
                   by = str_id)
}

debugonce(longnostic)
#
filter_stat_near_quant(wages,
                       id,
                       lnw,
                       stat = min,
                       l_name = l_min,
                       na.rm = TRUE,
                       tolerance = 0.01)
