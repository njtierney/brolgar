#' reflective palettes
#'
#' @param palette character
#' @param direction direction
#' @param n number of colours
#' @param alpha transparency
#' @param begin start point
#' @param end end point
#' @param direction direction?
#' @param ... extra args
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
#' @param ... extra args
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
