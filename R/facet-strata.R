#' Facet data into groups to facilitate exploration
#' 
#' This function requires a `tbl_ts` object, which can be created with 
#'   `tsibble::as_tsibble()`. Under the hood, `facet_strata` is powered by 
#'   [stratify_keys()].
#'
#' @inheritParams stratify_keys
#' @inheritParams ggplot2::facet_wrap
#' @import ggplot2
#'
#' @return a ggplot object
#' @export
#'
#' @examples
#' library(ggplot2)
#' ggplot(heights,
#'        aes(x = year,
#'            y = height_cm,
#'            group = country)) +
#'   geom_line() +
#'   facet_strata()
#'   
#' 
#' ggplot(heights,
#'        aes(x = year,
#'            y = height_cm,
#'            group = country)) +
#'   geom_line() +
#'   facet_wrap(~continent)
#' 
#' ggplot(heights,
#'        aes(x = year,
#'            y = height_cm,
#'            group = country)) +
#'   geom_line() +
#'   facet_strata(along = year)
#' 
#' \donttest{
#' library(dplyr)
#' heights %>%
#'   key_slope(height_cm ~ year) %>%
#'   right_join(heights, ., by = "country") %>%
#'   ggplot(aes(x = year,
#'              y = height_cm)) +
#'   geom_line(aes(group = country)) +
#'   geom_smooth(method = "lm") + 
#'   facet_strata(along = .slope_year)
#' }

facet_strata <- function(n_strata = 12,
                         along = NULL,
                         fun = mean,
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
  
  facet$params$n <- n_strata
  facet$params$along <- rlang::enquo(along)
  facet$params$fun <- fun
  
  ggproto(NULL, 
          FacetStrata,
          shrink = shrink,
          params = facet$params
  )
}

FacetStrata <- ggproto(
  "FacetStrata", 
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
    
    new_data <- brolgar::stratify_keys(.data = data,
                                       n_strata = params$n,
                                       along = !!params$along,
                                       fun = params$fun)
    
    new_data$PANEL = new_data$.strata
    
    return(new_data)
  }
)