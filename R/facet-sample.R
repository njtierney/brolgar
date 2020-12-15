#' Facet data into groups to facilitate exploration
#' 
#' This function requires a `tbl_ts` object, which can be created with 
#'   `tsibble::as_tsibble()`. Under the hood, `facet_strata` is powered by 
#'   [stratify_keys()] and [sample_n_keys()].
#'   
#' @param n_per_facet Number of keys per facet you want to plot. Default is 3.
#' @param n_facets Number of facets to create. Default is 12
#' @inheritParams ggplot2::facet_wrap
#' @import ggplot2
#'
#' @return a ggplot object
#' @export
#'
#' @examples
#' library(ggplot2)
#' ggplot(heights,
#' aes(x = year,
#'     y = height_cm,
#'     group = country)) +
#'   geom_line() +
#'   facet_sample()
#' 
#' ggplot(heights,
#'        aes(x = year,
#'            y = height_cm,
#'            group = country)) +
#'   geom_line() +
#'   facet_sample(n_per_facet = 1,
#'                n_facets = 12)
facet_sample <- function(n_per_facet = 3,
                         n_facets = 12,
                         nrow = NULL, 
                         ncol = NULL, 
                         scales = "fixed", 
                         shrink = TRUE, 
                         strip.position = "top") {
  
  facet <- facet_wrap(~.strata, 
                      nrow = nrow, 
                      ncol = ncol, 
                      scales = scales, 
                      shrink = shrink, 
                      strip.position = strip.position)
  
  facet$params$n <- n_facets 
  facet$params$n_per_facet <- n_per_facet
  
  ggproto(NULL, 
          FacetSample,
          shrink = shrink,
          params = facet$params
  )
}

FacetSample <- ggproto(
  "FacetSample", 
  FacetWrap,
  compute_layout = function(data, 
                            params) {
    id <- seq_len(params$n)
    dims <- wrap_dims(n = params$n, 
                      nrow = params$nrow, 
                      ncol = params$ncol)
    
    layout <- data.frame(PANEL = factor(id))
    
    if (params$as.table) {
      layout$ROW <- as.integer((id - 1L) %/% dims[2] + 1L)
    } else {
      layout$ROW <- as.integer(dims[1] - (id - 1L) %/% dims[2])
    }
    
    layout$COL <- as.integer((id - 1L) %% dims[2] + 1L)
    
    layout <- layout[order(layout$PANEL), , drop = FALSE]
    
    rownames(layout) <- NULL
    
    # Add scale identification
    layout$SCALE_X <- if (params$free$x) id else 1L
    layout$SCALE_Y <- if (params$free$y) id else 1L
    
    cbind(layout, .strata = id)
  },
  
  map_data = function(data, 
                      layout, 
                      params) {
    
    if (is.null(data) || nrow(data) == 0) {
      return(cbind(data, PANEL = integer(0)))
    }
    
    new_data <- data %>%
      sample_n_keys(size = params$n * params$n_per_facet) %>%
      stratify_keys(n_strata = params$n)
    
    new_data$PANEL = new_data$.strata
    
    return(new_data)
  }
)