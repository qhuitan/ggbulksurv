#' pivot_prism
#'
#' @description Converts bulk survival data (multiple observations per row) to
#'    individual survival data (one observation per row). Transforms this to a
#'    GraphPad PRISM compatible format, with one condition per column. Empty values
#'    are filled with NA.
#'
#' @param sample_data A `data.frame` object with 4 columns. Column headers
#'    must be ("condition", "day", "dead", "censored").
#' @param sample_order `character`, order of conditions. Eg: c("WT", "Drug1", "Drug2")
#' @return A `tibble` arranged by `day`, with one condition per column. For
#'   `sample_data` this is `day`, `WT`, `Drug1` and `Drug2`
#'
#' @details Status: 1 = dead, 0 = censored.
#'
#' @examples
#' df_prism <- pivot_prism(sample_data,
#'             sample_order = c("WT", "Drug1", "Drug2"))
#'
#' @importFrom dplyr group_by select mutate
#' @importFrom tidyr pivot_wider fill
#' @export


pivot_prism <- function(sample_data, sample_order){

  # Transform to individual survival
  df_isurv <- get_indiv_surv(sample_data, sample_order)

  # Transform to PRISM format
  df_prism <- df_isurv %>%
    dplyr::group_by(day) %>%
    dplyr::mutate(id = 1:dplyr::n()) %>%
    tidyr::pivot_wider(names_from = condition, values_from = status) %>%
    tidyr::fill(everything()) %>%
    dplyr::select(-id)


  return(df_prism)
}

