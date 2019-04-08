#' Add k groups to help explore ids
#'
#' @param data data.frame
#' @param id id
#' @param k number of random groups
#'
#' @return data.frame with additional column, `.rand_id` containing `k` groups
#' @export
#'
#' @examples
#' library(ggplot2)
#' library(brolgar)
#' 
#' wages %>%
#'   sample_frac_obs(id = id, size = 0.1) %>%
#'   add_k_groups(id = id, k = 10) %>%
#'  ggplot(aes(x = lnw,
#'             y = exper,
#'             group = id)) + 
#'  geom_line() + 
#'  facet_wrap(~.rand_id)
add_k_groups <- function(data, id, k){

  q_id <- rlang::enquo(id)
  
  data %>%
    dplyr::group_by(!!q_id) %>%
    tidyr::nest() %>%
    dplyr::mutate(.rand_id = sample(1:k, 
                                    nrow(.), 
                                    replace = TRUE)) %>%
    tidyr::unnest()
}