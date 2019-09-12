#' reflective palettes
#'
#' @param palette character
#' @param pal_dir direction of palette reflection
#' @param n number of colours
#' @param alpha transparency
#' @param begin start point
#' @param end end point
#' @param direction direction
#' @param ... extra arguments
#'
#' @return palette
#' @export
#'
#' @examples
#'library(dplyr)
#'heights_near <- key_slope(heights,
#'          height_cm ~ year) %>%
#'  keys_near(key = country,
#'            var = .slope_year) %>%
#'  left_join(heights, by = "country")
#'
#'library(ggplot2)
#'ggplot(heights_near,
#'       aes(x = year,
#'           y = height_cm,
#'           group = country,
#'           colour = stat)) +
#'  geom_line() +
#'  scale_colour_reflective(palette = "batlow",
#'                          pal_dir = "left")
#' 
reflect_palette <- function(palette = "hawaii",
                            pal_dir = "left",
                            n = 5,
                            alpha = NULL,
                            begin = 0,
                            end = 1,
                            direction = 1,
                            ...){
  
  pal <- scico::scico(palette = palette,
                      n = n,
                      alpha = alpha,
                      begin = begin,
                      end = end,
                      direction = direction)

  if (pal_dir == "left") {
    pal <- reflect_left(pal)
  }

  if (pal_dir == "right") {
    pal <- reflect_right(pal)
  }

  colorRampPalette(pal, ...)

}


#' ggplot2 scale colour reflective
#'
#' @param palette character
#' @param pal_dir character
#' @param ... extra arguments
#'
#' @return ggplot
#' @export
#'
#' @examples
#'library(dplyr)
#'heights_near <- key_slope(heights,
#'          height_cm ~ year) %>%
#'  keys_near(key = country,
#'            var = .slope_year) %>%
#'  left_join(heights, by = "country")
#'
#'library(ggplot2)
#'ggplot(heights_near,
#'       aes(x = year,
#'           y = height_cm,
#'           group = country,
#'           colour = stat)) +
#'  geom_line() +
#'  scale_colour_reflective(palette = "batlow",
#'                          pal_dir = "left")
scale_colour_reflective <- function(palette = "hawaii",
                                    pal_dir = "left",
                                    ...){

  pal <- reflect_palette(palette = palette,
                         pal_dir = pal_dir)

  # if (discrete) {
    ggplot2::discrete_scale("colour",
                            paste0("reflect_",
                                   palette),
                            palette = pal,
                            ...)
  # } else {
    # scale_colour_gradientn(colours = pal(256), ...)
  # }
}


# examples
# 
# library(scico)
# pal <- scico(9, palette = 'bamako')
# 
# show_col(pal)
# 
# 
# scico_seq <- c("batlow",
#                "buda",
#                "hawaii",
#                "imola",
#                "lajolla",
#                "oslo")
# 
# scico_palette_show(scico_seq)
# 
# 


# library(dplyr)
# library(ggplot2)
# library(scico)
# library(brolgar)
# 
# heights_near <- key_slope(heights,
#                           height_cm ~ year) %>%
#   keys_near(key = country,
#             var = .slope_year) %>%
#   left_join(heights, by = "country")
# 
# ggplot(heights_near,
#        aes(x = year,
#            y = height_cm,
#            group = country,
#            colour = stat)) +
#   geom_line() +
#   scale_colour_reflective(palette = "batlow",
#                           pal_dir = "left")
# 
# scico_reflect <- function(n,
#                           alpha = NULL,
#                           direction = 1,
#                           palette = "bilbao"){
#   
#   # new_n <- 
#   
#   pal_lhs <- scico::scico(n = n,
#                           alpha = alpha,
#                           begin = 0,
#                           end = 1,
#                           direction = direction,
#                           palette = palette)
#   
#   pal_rhs <- scico::scico(n = n,
#                           alpha = alpha,
#                           begin = 1,
#                           end = 0,
#                           direction = direction,
#                           palette = palette)
#   
#   c(pal_lhs, pal_rhs)
#   
# }
# 
# 
# scico_discrete_reflect <- function(alpha, 
#                                    direction,
#                                    palette){
#   function(n) {
#     scico_reflect(n, 
#                   alpha, 
#                   direction, 
#                   palette)
#   }
# }
# 
# scale_colour_reflect_d <- function(...,
#                                    alpha = 1,
#                                    direction = 1,
#                                    palette = "bilbao",
#                                    aesthetics = "colour"){
#   
#   if (!requireNamespace("ggplot2", quietly = TRUE)) {
#     stop("ggplot2 is required for this functionality", call. = FALSE)
#   }
#   
#   if (alpha < 0 | alpha > 1) {
#     stop("alpha must be in [0,1]")
#   }
#   
#   if (!palette %in% scico_palette_names()) {
#     stop("Need to pick a scico palette. see `scico_palette_names() for options")
#   }
#   
#   ggplot2::discrete_scale(aesthetics, 
#                           "reflective_d", 
#                           scico_discrete_reflect(alpha, 
#                                                  direction, 
#                                                  palette), 
#                           ...)
# }
# 
# ggplot(heights_near,
#        aes(x = year,
#            y = height_cm,
#            group = country,
#            colour = stat)) +
#   geom_line() +
#   scale_colour_reflect_d(palette = "bilbao")
