#' summary_stats
#'
#' This function provides the following summary statistics:
#' \enumerate{
#'  \item{`median_survival`: Median survival with 95% confidence intervals}
#'  \item{`logrank`: Log-rank test - is there a difference between two (or more) survival curves?}
#'  \item{`pairwise`: Pairwise log-rank test with p-value correction between conditions.
#'         Default correction: "BH". }
#' }
#'
#' @param df_isurv a `data.frame` of survival data, with one individual per row.
#'   If starting with bulk survival data (multiple observations per row), run [get_indiv_surv()] first.
#' @param type character, either "median_survival", "logrank", "pairwise" or "all". Default: "all"
#' @return If `type == "all"`: a `list` object containing results from statistical tests.
#'  Otherwise, returns a `ggplot` object containing the survival/mortality curve
#'
#'
#' @details
#' * `logrank`: Calls [survival::survdiff()] to test if there is a difference
#'   between two or more survival curves using the G^rho family of tests
#' * `pairwise`: Calls [survminer::pairwise_survdiff()], which calculates pairwise comparisons
#'   between groups with corrections for multiple testing.
#'
#' @examples
#' df_isurv <- get_indiv_surv(sample_data,
#'                            sample_order = c("WT", "Drug1", "Drug2"))
#'
#' stats <- summary_stats(df_isurv)
#' stats
#'
#' @importFrom survival survdiff
#' @importFrom survminer pairwise_survdiff
#'
#' @export


summary_stats <- function(df_isurv, type = "all"){

  ## -- Error handling -- ##
  # Check that input is individual survival (check colnames/ values for censored and dead etc)

  median_survival <- fit_surv(df_isurv)

  logrank <- survival::survdiff(Surv(day, status) ~ condition, data = df_isurv)

  pairwise <- survminer::pairwise_survdiff(Surv(day, status) ~ condition,
                                           data = df_isurv,
                                           p.adjust.method = "BH")



  if(type == "median_survival"){
    return(median_survival)
  } else if (type == "logrank") {
    return(logrank)
  } else if (type == "pairwise") {
    return(pairwise)
  } else if (type == "all"){
    # return a list
    summary_list = list(median_survival = median_survival,
                        logrank = logrank,
                        pairwise = pairwise)
    return(summary_list)
  }


}
