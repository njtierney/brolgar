# 
# l_summarise(wages,
#             id = id,
#             .vars = lnw,
#             funs = list(min = min, 
#                         max = max, 
#                         mean = mean))

l_summarise <- function(data,
                        id,
                        .vars,
                        funs){
  
  quo_id <- rlang::enquo(id)
  quo_var <- rlang::enquo(.vars)
  
  # rename the function names
  if (is.null(names(funs))) {
    
  } 
  
  funs_names <- names(funs)
  glued_names <- glue::glue("l_{funs_names}")
  l_funs <- rlang::set_names(funs,  glued_names)
  
  data %>%
    dplyr::group_by(id) %>%
    dplyr::summarise_at(.vars = !!quo_var,
                        .funs = l_funs)
}