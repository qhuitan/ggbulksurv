#' get_indiv_surv
#'
#' @description Converts bulk survival data (multiple observations per row) to
#'    individual survival data (one observation per row)
#'
#' @param sample_data A `data.frame` object with 4 columns. Column headers
#'    must be ("condition", "day", "dead", "censored").
#' @param sample_order `character`, conditions to plot, in order.
#'    Default: unique(sample_data$condition). To subset, use sample_order = c("WT", "Drug1")
#' @return A `tibble` for lifespan by individual.
#'    Contains 3 columns: `condition`, `day`, `status`.
#'
#' @details Status: 1 = dead, 0 = censored.
#'
#' @examples
#' # Default (alphabetical order)
#' df_isurv <- get_indiv_surv(sample_data)
#'
#' # Plot samples in a fixed order
#' df_isurv <- get_indiv_surv(sample_data,
#'                            sample_order = c("WT", "Drug1", "Drug2"))
#'
#' # Subset only 2 conditions
#' df_isurv <- get_indiv_surv(sample_data,
#'                            sample_order = c("WT", "Drug1"))
#'
#'
#' @importFrom dplyr group_by select mutate full_join arrange join_by summarize ungroup
#' @importFrom tidyr uncount
#' @importFrom janitor clean_names
#' @export

get_indiv_surv <- function(sample_data,
                           sample_order = unique(sample_data$condition)){


  ## ---- Error handling ---- ##
  # Check that sample_data is of type data.frame

  if(!is.data.frame(sample_data)) {
    stop(paste0("`sample_data` must have type `data.frame` instead of ",
                class(sample_data)))
  }

  # Convert all colnames to lowercase, remove trailing spaces
  sample_data <- sample_data %>% janitor::clean_names()

  # Check that all 5 columns are present
  input_colnames <- colnames(sample_data)
  expected_colnames <- c("condition", "day", "dead", "censored")

  if (sum(input_colnames %in% expected_colnames) < length(expected_colnames)) {
    stop("Missing column(s) in input. Expected colnames: `condition`, `day`, `dead`, `censored`.")

  }

  # Check sample_order is a complete subset of unique(sample_data$condition)

  a = unique(sample_order)
  b = unique(sample_data$condition)

  if (!setequal(intersect(a, b), a)) {
    # if a is NOT a complete subset of b, stop and show an error message.
    stop("`sample_order` must be a value in the `condition` column.")
  }

  # Check that sample_order and unique(sample_data$condition) are the same
  # if(
  #   length(intersect(
  #     unique(sample_data$condition), sample_order
  #                   )
  #          ) !=
  #   length(union(
  #     unique(sample_data$condition), sample_order
  #               )
  #         )
  # ) {
  #   stop("`sample_order` is not equal to unique(sample_data$condition). Did you miss a condition in `sample_order`?")
  # }


  ## -- Calculate dead -- ##
  df_dead <- sample_data %>%
    # Select only dead column
    dplyr::group_by(condition) %>%
    dplyr::select(-c(censored)) %>%
    # Uncount so that each row becomes an individual
    tidyr::uncount(dead) %>%
    # Add status = 1 (dead)
    dplyr::mutate(status = 1)

  ## -- Calculate censored -- ##
  df_censored <- sample_data %>%
    # Select only censored column
    dplyr::group_by(condition) %>%
    dplyr::select(-c(dead)) %>%
    # Uncount so that each row becomes an individual
    tidyr::uncount(censored) %>%
    # Add status = 0 (censored)
    dplyr::mutate(status = 0)

  ## -- Combine -- ##
  df_combined <- dplyr::full_join(df_censored, df_dead) %>%
      #                     join_by("condition", "day", "status"))
    dplyr::arrange(day) %>%
    dplyr::ungroup()

  df_combined$condition <- factor(df_combined$condition,
                                  levels = sample_order)

  # if it's a factor, keep as factor; if not, take it from sample_order.
  # if sample_order isn't given, make it a factor.

  rm(df_dead)
  rm(df_censored)


  return(df_combined)

}
