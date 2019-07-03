#' Wages data from National Longitudinal Survey of Youth (NLSY)
#' 
#' This data contains measurements on hourly wages by years in
#' the workforce, with education and race as covariates. The population
#' measured was male high-school dropouts, aged between 14 and 17 years
#' when first measured. `wages_ts` is a time series tsibble of the `wages`
#' data.
#' It comes from J. D. Singer and J. B. Willett. 
#' Applied Longitudinal Data Analysis. 
#' Oxford University Press, Oxford, UK, 2003.
#' http://gseacademic.harvard.edu/alda/
#' 
#' @format A data frame with 6402 rows and 8 variables:
#' \describe{
#'   \item{id}{1–888, for each subject. This forms the `key` of the data} 
#'   \item{lnw}{natural log of wages, adjusted for inflation, to 1990 dollars.}
#'   \item{exper}{length of time in the workforce (in years). This is treated
#'     as the time variable, with t0 for each subject starting on their first
#'     day at work. The number of time points and values of time points for
#'    each subject can differ. This forms the `index` of the data}
#'   \item{ged}{when/if a graduate equivalency diploma is obtained.}
#'   \item{postexp}{change in experience since getting a ged (if they get one)}
#'   \item{black}{categorical indicator of race = black.}
#'   \item{hispanic}{categorical indicator of race = hispanic.}
#'   \item{hgc}{highest grade completed}
#'   \item{uerate}{unemployment rates in the local geographic region at each
#'     measurement time}
#' }
#' 
#' @docType data
#' @name wages_ts
#' @examples 
#' \dontrun{
#' # This data is created as follows:
#' library(tsibble)
#' wages_ts <- as_tsibble(x = wages,
#'                        key = id,
#'                        index = exper,
#'                        regular = FALSE)
#' }
NULL