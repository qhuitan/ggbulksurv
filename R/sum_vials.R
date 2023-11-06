#' sum_vials
#'
#' Sums the total dead and censored across vials for each (day, condition) pair
#'
#' @param df A `data.frame` with 4 columns: day | condition | dead | censored.
#' `vial` column is optional.
#' @return A `data.frame`. All dead and censored values are summed across vials
#' for each (day, condition) pair.
#'
#' @examples
#'
#' df <- tibble::tribble(
#'   ~day, ~condition, ~dead, ~censored, ~ vial,
#'   10,   "WT",       1,     0,         1,
#'   10,   "WT",       2,     0,         2,
#'   10,   "Drug1",    1,     0,         1,
#'   10,   "Drug1",    2,     0,         2,
#'   10,   "Drug2",    5,     0,         1,
#'   10,   "Drug1",    5,     0,         2,
#'   12,   "WT",       5,     0,         1,
#'   12,   "WT",       1,     0,         2,
#'   )
#'
#'
#'
#' @importFrom dplyr group_by reframe ungroup
#'
#' @export

sum_vials <- function(df) {

  df_collapsed <- df %>%
    group_by(day, condition) %>%
    reframe(
      dead = sum(dead), censored = sum(censored)) %>%
    ungroup()

  return(df_collapsed)
}


