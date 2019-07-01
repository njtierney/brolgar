n_obs <- function(data, ...){
  
  test_if_tsibble(data)
  nrow(tsibble::key_data(data))
  
}


