#' pivot_prism
#'
#' @description Converts bulk survival data (multiple observations per row) to
#'    individual survival data (one observation per row). Transforms this to a
#'    GraphPad PRISM compatible format, with one condition per column. Empty values
#'    are filled with NA.
#'
#' @param df A `data.frame` object with 4 columns. Column headers
#'    must be ("condition", "day", "dead", "censored").
#'
#' @details Status: 1 = dead, 0 = censored.
#'
#' @examples
#' df_prism <- pivot_prism(sample_data)
#'
#' @importFrom tidyr tibble
#' @importFrom plyr rbind.fill
#' @importFrom dplyr select filter mutate
#'
#' @export

pivot_prism <- function(df) {

  # Remove rows with no events (dead = 0, censored = 0)
  df <- df %>%
    dplyr::mutate(total_events = (dead + censored)) %>% # add dead + censored
    dplyr::filter(total_events > 0) %>% # keep rows with at least 1 event
    dplyr::select(-total_events) # remove counting column

  # Split dataframe by day
  ls_split <- split(df, f = df$day)

  # For each day, apply make_prism to convert it to 1s and 0s
  ls_prism <- lapply(ls_split, pivot_day)

  # Add day as a column
  ls_prism_day <- Map(cbind, ls_prism, day = names(ls_prism))

  # Rbind dataframes. Fill missing columns with NA
  df_prism <- plyr::rbind.fill(ls_prism_day)

  # Rearrange columns
  df_prism <- df_prism %>%
    dplyr::select(day, everything())

  return(tidyr::as_tibble(df_prism))

}
