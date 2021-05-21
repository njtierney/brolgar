#' Student data from 2000-2018 PISA OECD data
#'
#' A subset of PISA data, containing scores and other information
#' from the triennial testing of 15 year olds around
#' the globe. Original data available from
#'  \url{https://www.oecd.org/pisa/data/}. Data derived from 
#'  \url{https://github.com/kevinwang09/learningtower}.
#'
#' @format A tibble of the following variables
#' \itemize{
#'     \item year the year of measurement
#'     \item country the three letter country code. This data contains Australia,
#'       New Zealand, and Indonesia. The full data from learningtower contains
#'       99 countries.
#'     \item school_id The unique school identification number
#'     \item student_id The student identification number
#'     \item gender recorded gender - 1 female or 2 male or missing
#'     \item math Simulated score in mathematics
#'     \item read Simulated score in reading
#'     \item science Simulated score in science
#'     \item stu_wgt The final survey weight score for the student score
#'     }
#' 
#' Understanding a bit more about the PISA data, the `school_id` and
#' `student_id` are not unique across time. This means the longitudinal element 
#' is the country within a given year.
#' 
#' We can cast `pisa` as a `tsibble`, but we need to aggregate the data to each 
#' year and country. In doing so, it is important that we provide some summary
#' statistics of each of the scores - we want to include the mean, and minimum 
#' and maximum of the math, reading, and science scores, so that we do not lose 
#' the information of the individuals.
#' 
#' The example code below does this, first grouping by year and country, then
#' calculating the weighted mean for math, reading, and science. This can be 
#' done using the student weight variable `stu_wgt`, to get the survey weighted 
#' mean. The minimum and maximum are then calculated.
#'
#' @docType data
#' @name pisa
#' @keywords datasets
#' @examples 
#' pisa
#' 
#' library(dplyr)
#' # Let's identify
#' 
#' #1.  The **key**, the individual, who would have repeated measurements. 
#' #2.  The **index**, the time component.
#' #3.  The **regularity** of the time interval (index). 
#' 
#' # Here it looks like the key is the student_id, which is nested within
#' # school_id #' and country,
#' 
#' # And the index is year, so we would write the following
#' 
#' as_tsibble(pisa, 
#'            key = country,
#'            index = year)
#' 
#' # We can assess the regularity of the year like so:
#' 
#' index_regular(pisa, year)
#' index_summary(pisa, year)
#' 
#' # We can now convert this into a `tsibble`:
#' 
#' pisa_ts <- as_tsibble(pisa,
#'            key = country,
#'            index = year,
#'            regular = TRUE)
#' 
#' pisa_ts
#' pisa_ts_au_nz <- pisa_ts %>% filter(country %in% c("AUS", "NZL", "QAT"))
#' 
#' library(ggplot2)
#' ggplot(pisa_ts_au_nz, 
#'        aes(x = year, 
#'            y = math_mean,
#'            group = country,
#'            colour = country)) +
#'   geom_ribbon(aes(ymin = math_min, 
#'                   ymax = math_max), 
#'               fill = "grey70") +
#'   geom_line(size = 1) +
#'   lims(y = c(0, 1000)) +
#'   labs(y = "math") +
#' facet_wrap(~country)
"pisa"