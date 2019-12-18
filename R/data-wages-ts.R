#' Wages data from National Longitudinal Survey of Youth (NLSY)
#' 
#' This data contains measurements on hourly wages by years in
#' the workforce, with education and race as covariates. The population
#' measured was male high-school dropouts, aged between 14 and 17 years
#' when first measured. `wages` is a time series `tsibble`.
#' It comes from J. D. Singer and J. B. Willett. 
#' Applied Longitudinal Data Analysis. 
#' Oxford University Press, Oxford, UK, 2003.
#' http://gseacademic.harvard.edu/alda/
#' 
#' @format A `tsibble` data frame with 6402 rows and 8 variables:
#' \describe{
#'   \item{id}{1–888, for each subject. This forms the `key` of the data} 
#'   \item{ln_wages}{natural log of wages, adjusted for inflation, 
#'     to 1990 dollars.}
#'   \item{xp}{Experience - the length of time in the workforce (in years).
#'     This is treated as the time variable, with t0 for each subject starting
#'     on their first day at work. The number of time points and values of time
#'     points for each subject can differ. This forms the `index` of the data}
#'   \item{ged}{when/if a graduate equivalency diploma is obtained.}
#'   \item{xp_since_ged}{change in experience since getting a ged (if they get one)}
#'   \item{black}{categorical indicator of race = black.}
#'   \item{hispanic}{categorical indicator of race = hispanic.}
#'   \item{high_grade}{highest grade completed}
#'   \item{unemploy_rate}{unemployment rates in the local geographic region 
#'     at each measurement time}
#' }
#' 
#' @docType data
#' @name wages
#' @keywords datasets
#' @examples 
#' wages
#' set.seed(2019-7-15-1300)
#' library(ggplot2)
#' wages %>%
#'   sample_n_keys(size = 5) %>%
#'   ggplot(aes(x = xp,
#'              y = ln_wages,
#'              group = id)) + 
#'   geom_line()
#'   
#'   ggplot(wages, aes(x = xp,
#'              y = ln_wages,
#'              group = id)) + 
#'   geom_line() + 
#'   facet_sample()
"wages"

