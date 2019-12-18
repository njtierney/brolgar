#' Student data from 2000-2018 PISA OECD data
#'
#' A subset of PISA data, containing scores and other information
#' from the triennial testing of 15 year olds around
#' the globe. Original data available from
#'  \url{https://www.oecd.org/pisa/data/}. Data derived from 
#'  \url{https://github.com/ropenscilabs/learningtower}.
#'
#' @format A tibble of the following variables
#' \itemize{
#'     \item year the year of measurement
#'     \item country the three letter country code
#'     \item school_id The unique school identification number
#'     \item student_id The student identification number
#'     \item gender recorded gender - 1 female or 2 male or missing
#'     \item math Simulated score in mathematics
#'     \item read Simulated score in reading
#'     \item science Simulated score in science
#'     \item stu_wgt The final survey weight score for the student score
#'     }
#' @docType data
#' @name pisa
#' @keywords datasets
#' @examples 
#' pisa
"pisa"