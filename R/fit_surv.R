#' fit_surv
#'
#' Creates a `survfit` object for `day` and `status`, then fits a survival curve by `condition`.
#'
#' @param df_isurv A `data.frame` object of survival data with one individual per
#'    row. If starting with bulk survival data (multiple observations per row), run [get_indiv_surv()] first.
#' @param formula A `character` string passed to a [survival::survfit.formula].
#'    Default: "Surv(day, status) ~ condition"
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
#' # Fit survival object with the default call (condition)
#' surv_fit <- fit_surv(df_isurv)
#' surv_fit
#'
#' # Fit survival object with custom call (condition + sex)
#' surv_fit <- fit_surv(df_isurv, formula = "Surv(day, status) ~ sex + condition")
#' surv_fit
#'
#' @importFrom survival Surv survfit
#' @importFrom stats as.formula
#'
#' @export

fit_surv <- function(df_isurv,
                     formula = "Surv(day, status) ~ condition",
                     as_data_frame = FALSE){

  ## -- Error handling -- ##

  df_isurv <- df_isurv %>%
    janitor::clean_names()

  # Stop if bulk survival object is input
  input_colnames <- colnames(df_isurv)
  bulk_colnames <- c("dead", "censored")

  if(sum(bulk_colnames %in% input_colnames) > 0) {
    stop("Data contains multiple individuals per row. Did you run `get_indiv_surv()` to convert it to one individual per row?")
  }

  # Check that formula is a character string

  if(!is.character(formula)) {
    stop("`formula` must have class `character`. Did you remember to add quotation marks?")
  }

#  input_colnames <- colnames(df_isurv)
#  expected_colnames <- c("condition", "day", "status")


#
#   if (sum(input_colnames %in% expected_colnames) != length(expected_colnames)) {
#     stop(
#       paste(c(
#         "Column names must have 1 individual per row.
#         Did you convert bulk survival data to individual survivals?
#          See `get_indiv_surv()`."
#               )
#             )
#           )
#   }

  # Check that status is either 1 or 0

  if(!(all(unique(df_isurv$status) %in% c(0, 1)))){
    stop("`status` must be either 0 or 1.")
  }

  # Convert character string into survfit formula

  surv_fit = survival::survfit(as.formula(formula), data = df_isurv)

  # Change the call
  full_call = str2lang(paste0("survfit(formula = ", formula, ", data = df_isurv)"))
  surv_fit$call = full_call

  message(paste0("\ncall: formula = ", formula))

  # Create and fit survival object
  #surv_fit <- survival::survfit(formula_combined,
  #                              data = df_isurv)

  return(surv_fit)

}
