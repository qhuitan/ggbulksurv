#' pivot_day
#'
#' Converts a "one day, multiple observations" dataframe to a PRISM-compatible
#' format. However, this function does not filter for days - input must all be
#' __the same day__.
#'
#' @param df A `data.frame` with 4 columns: day | condition | dead | censored.
#' `vial` column is optional.
#' @return A `data.frame` in a PRISM-compatible format. First column is day,
#' subsequent columns are the other conditions. Each column has a series of 1(dead) and 0 (censored)
#' corresponding to the number of dead and censored per day.
#'
#'
#'
#' @importFrom tibble as_tibble


pivot_day <- function(df) {

  # Sum all vials
  df = sum_vials(df)

  # Takes a single row as input. Expands it into a single vector of 1s (dead) and 0s (censored)
  expand_vector <- function(condition) {

    n_dead <- df[df$condition == condition, ]$dead
    n_censored <- df[df$condition == condition, ]$censored

    n_vector <- c(rep(1, n_dead), rep(0, n_censored))

    return(n_vector)
  }


  # For every condition, create vector of 1s and 0s,
  # then wrap it in a list
  surv_list <- lapply(unique(df$condition), expand_vector)

  # Convert list to data frame
  df_prism <- do.call(cbind, lapply(surv_list, `length<-`,
                                    max(lengths(surv_list))))
  df_prism <- as_tibble(df_prism, rownames = NULL,
                        .name_repair = "minimal")

  colnames(df_prism) <- unique(df$condition)

  return(df_prism)

}
