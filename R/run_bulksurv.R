#' run_bulksurv
#'
#' This function performs a default survival analysis by running these steps:
#' \enumerate{
#'  \item{Calculate individual survival: \code{\link{get_indiv_surv}()}}
#'  \item{Fit survival curve by condition: \code{\link{fit_surv}()}}
#'  \item{Plot survival curve: \code{\link{plot_surv}()}}
#' }
#'
#'
#' @param sample_data `data.frame`, bulk survival data
#' @param sample_order character vector of conditions. Eg: c("WT", "Drug1", "Drug2")
#' @param type character, either "survival" (survival curve) or "mortality" (mortality curve)
#' @param print_stats logical, whether to print median survival, log-rank
#'  test and pairwise log-rank test with p-value corrections. Default: TRUE
#' @param print_plot logical, whether to print the plot. Also returns plot as a
#'    `ggplot` object for further modification. Default: TRUE
#' @param p_adjust_method either "holm", "hochberg", "hommel", "bonferroni",
#'   "BH", "BY", "fdr", "none". Default: "BH". For details, see `?stats::p.adjust`.
#' @param returnData logical, whether to return plot and statistics as a list? Default: FALSE
#' @param verbose logical, display messages on progress? Default: FALSE
#' @param ... additional plot parameters passed to `survminer::ggsurvplot`.
#'  Some useful parameters: `conf.int = TRUE`, `pval = TRUE`.
#'
#' @return A `ggplot2` object for the survival curve
#'
#' @examples
#' #p <- run_bulksurv(sample_data,
#' #                    sample_order = c("WT", "Drug1", "Drug2"),
#' #                    type = "survival")
#'
#'
#' @export
#'

run_bulksurv <- function(sample_data,
                         sample_order,
                         type = "survival",
                         print_stats = TRUE,
                         print_plot = TRUE,
                         returnData = FALSE,
                         verbose = FALSE,
                         p_adjust_method = "BH",
                         ...){

  # Convert bulk survival to individual survival
  if(verbose) message("1/4 Getting individual survivals")
  df_isurv <- get_indiv_surv(sample_data, sample_order)

  # Fit survival object
  if(verbose) message("2/4 Fitting survival object")
  surv_fit <- fit_surv(df_isurv)

  # Plot survival curve
  if(verbose) message("3/4 Plotting survival curve")
  p <- plot_surv(fit = surv_fit, type = type,
                 data = df_isurv,
                 legend.labs = sample_order,
                 p_adjust_method = p_adjust_method,
                 ...)

  if(verbose) message("4/4 Calculating summary statistics")

  # If print_stats = TRUE, prints summary stats
  if(print_stats){
    print(summary_stats(df_isurv,
                        type = "all",
                        p_adjust_method = p_adjust_method))
  }

  # If return_plot = TRUE, returns plot
  if(print_plot){
    print(p)
    return(p)
  }

  # else default to returnPlot and print the summary results

  # if returnData = TRUE, returns everything as a list
  if(returnData == TRUE) {

    sum_stats <- summary_stats(df_isurv,
                               type = "all",
                               p_adjust_method = p_adjust_method)
    ls <- c(list(plot = p),
            sum_stats)

    return(ls)

  }

}
