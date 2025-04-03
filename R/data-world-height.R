#' World Height Data
#'
#' Average male heights in 144 countries from 1810-1989, with a
#'   smaller number of countries from 1500-1800. Data has been filtered to
#'   only include countries with more than one observation.
#'
#' `heights` is stored as a time series `tsibble` object. It contains
#'   the variables:
#'
#'  * country: The Country. This forms the identifying `key`.
#'  * year: Year. This forms the time `index`.
#'  * height_cm: Average male height in centimeters.
#'  * continent: continent extracted from country name using `countrycode`
#'    package (https://joss.theoj.org/papers/10.21105/joss.00848).
#'
#' For more information, see the article: "Why are you tall while others are
#'   short? Agricultural production and other proximate determinants of global
#'   heights",  Joerg Baten and Matthias Blum, European Review of Economic
#'   History 18 (2014), 144–165. Data available from
#'   <https://datasets.iisg.amsterdam/dataset.xhtml?persistentId=hdl:10622/IAEKLA>, accessed via the Clio Infra website.
#'
#' @keywords datasets
#' @examples
#' # show the data
#' heights
#'
#' # show the spaghetti plot (ugh!)
#' library(ggplot2)
#' ggplot(heights,
#'        aes(x = year,
#'            y = height_cm,
#'            group = country)) +
#'     geom_line()
#'
#' # Explore all samples with `facet_strata()`
#' ggplot(heights,
#'        aes(x = year,
#'            y = height_cm,
#'            group = country)) +
#'   geom_line() +
#'   facet_strata()
#'
#' # Explore the heights over each continent
#' ggplot(heights,
#'        aes(x = year,
#'            y = height_cm,
#'            group = country)) +
#'   geom_line() +
#'   facet_wrap(~continent)
#'
#' # explore the five number summary of height_cm with `features`
#' heights %>%
#'   features(height_cm, feat_five_num)
"heights"
