#' fit_surv
#'
#' Creates a `survfit` object for `day` and `status`, then fits a survival curve by `condition`.
#'
#' @param df_isurv A `data.frame` object of survival data with one individual per
#'    row. Column names must be `condition`, `day`, `status`. If starting with
#'    bulk survival data (multiple observations per row), run [get_indiv_surv()] first.
#' @param as_data_frame If FALSE, returns a `survfit` object from the `survival`
#'      package. If TRUE, returns it in a `data.frame` format. Default: FALSE
#' @return A [survival::survfit()] object. If `as_data_frame = TRUE`,
#'      returns it in a \code{data.frame} format. Default: FALSE
#'
#' @details Call: `survival::survfit(Surv(day, status) ~ condition, data = df_isurv)}`
#'
#' @examples
#' # Convert bulk survival to individual survival
#' df_isurv <- get_indiv_surv(sample_data, sample_order = c("WT", "Drug1", "Drug2"))
#'
#' # Fit survival object
#' surv_fit <- fit_surv(df_isurv)
#'
#' @importFrom survival Surv survfit
#'
#' @export

fit_surv <- function(df_isurv,
                     as_data_frame = FALSE){

  ## -- Error handling -- ##

  df_isurv <- df_isurv %>%
    janitor::clean_names()

  # Stop if bulk survival object is input
  input_colnames <- colnames(df_isurv)
  expected_colnames <- c("condition", "day", "status")

  if (sum(input_colnames %in% expected_colnames) != length(expected_colnames)) {
    stop(
      paste(c(
        "Column names must be `condition`, `day` and `status`.
        Did you convert bulk survival data to individual survivals?
         See `get_indiv_surv()`."
              )
            )
          )
  }

  # Check that status is either 1 or 0

  if(!(all(unique(df_isurv$status) %in% c(0, 1)))){
    stop("`status` must be either 0 or 1.")
  }

  # Create and fit survival object
  surv_fit <- survival::survfit(Surv(day, status) ~ condition,
                                data = df_isurv)

  return(surv_fit)

}
