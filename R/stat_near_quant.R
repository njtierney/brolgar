#' Obtain IDs closest to each quantile for a given stat
#'
#' @param data data.frame
#' @param id id
#' @param var variable to calculate stat on
#' @param probs vector of quantiles
#' @param nearest_within select stats within this this amount (default is 
#'   `.Machine$double.eps^0.5`)
#' @return dataframe with columns `id` and `nearest_quant`
#' @name stat-near-quant
#' @export
#'
#' @examples
#'  l_max_near_quant(data = wages,
#'                   id = id,
#'                   var = lnw,
#'                   nearest_within = 0.01)

#'  l_max_near_quant(data = wages,
#'                   id = id,
#'                   var = lnw,
#'                   probs = seq(0.1, 0.9, by = 0.1),
#'                   nearest_within = 0.01)
#' # dplyr::inner_join(data, l_max_data_near, by = "id")

l_max_near_quant <- function(data,
                             id,
                             var,
                             probs = c(0.25, 0.5, 0.75),
                             nearest_within = .Machine$double.eps^0.5){

  q_id <- rlang::enquo(id)
  q_var <- rlang::enquo(var)
  
l_max_data <- l_max(data, !!q_id, !!q_var)

l_max_quants <- quantile(x = dplyr::pull(l_max_data, l_max),
                         probs = probs,
                         type = 7)

part_near <- purrr::partial(dplyr::near,
                     y = dplyr::pull(l_max_data, l_max),
                     tol = nearest_within)

summarise_l_max_data <- l_max_data %>%
  dplyr::summarise(id = list(!!q_id), 
                   qs = list(as.list(quantile(x = l_max,
                                              probs = probs,
                                              type = 7)))
  )

near_quant_id <- summarise_l_max_data %>%
  dplyr::mutate(is_near = list(
    purrr::map_dfr(purrr::flatten(qs), part_near))
    ) %>% 
  dplyr::select(!!q_id, is_near) %>%
  tidyr::unnest() %>%
  tidyr::gather(key = "near_q",
                value = "value",
                -!!q_id) %>%
  dplyr::mutate(nearest_quant = dplyr::case_when(
    value ~ glue::glue("q_{readr::parse_number(near_q)}")
  )) %>%
  dplyr::filter(!is.na(nearest_quant)) %>%
  dplyr::select(!!q_id,
                nearest_quant) %>%
  dplyr::left_join(l_max_data)

# show us how different the stat is to the quantile

new_quant_lab <- glue::glue("q_{readr::parse_number(names(l_max_quants))}")

tibble::enframe(l_max_quants, name = "quant", value = "l_max_quants") %>%
  dplyr::mutate(quant = new_quant_lab) %>%
  dplyr::left_join(y = near_quant_id,
                   by = c("quant" = "nearest_quant")) %>%
  dplyr::mutate(q_stat_diff = l_max_quants - l_max) %>%
  dplyr::select(id, 
                quant,
                l_max,
                q_stat_diff)

}


#' @rdname stat-near-quant
#' @export
#' @examples
#' add_stat_near_quant(wages,
#'                     id,
#'                     lnw)
add_stat_near_quant <- function(data,
                                id,
                                var,
                                probs = c(0.25, 0.5, 0.75),
                                nearest_within = .Machine$double.eps^0.5){
  
  q_id <- rlang::enquo(id)
  q_var <- rlang::enquo(var)
  str_id <- rlang::as_label(q_id)
  
  data_near_quant <- 
  l_max_near_quant(data = data,
                   id = !!q_id,
                   var = !!q_var,
                   probs = probs,
                   nearest_within = nearest_within)
  
  dplyr::left_join(x = data_near_quant,
                   y = data,
                   by = str_id)
}