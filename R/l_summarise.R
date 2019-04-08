
l_summarise <- function(data,
                        id,
                        .vars,
                        stat){
  
  quo_id <- rlang::enquo(id)
  quo_var <- rlang::enquo(.vars)
  
  # # rename the function names
  # if (is.null(names(stat))) {
  #   
  # } 
  funs_names <- names(stat)
  glued_names <- glue::glue("l_{funs_names}")
  l_stat <- rlang::set_names(stat,  glued_names)
  
  
  data %>%
    dplyr::group_by(!!quo_id) %>%
    dplyr::summarise_at(.vars = dplyr::vars(!!quo_var),
                        .funs = l_stat,
                        na.rm = TRUE)
}
