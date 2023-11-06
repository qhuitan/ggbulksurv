#' plot_surv
#'
#' Plots a survival curve from `survfit` object.
#'
#' @param fit a `survfit` object, created by [fit_surv()]
#' @param type character, either "survival" (a survival curve) or "mortality" (a mortality curve)
#' @param add.median.survival logical, whether to add the median survival line. Default: FALSE
#' @param add.conf.int logical, whether to add confidence intervals. Default: FALSE
#' @param add.pval logical, whether to add the p-value. Default: FALSE
#' @param legend.title character, the legend title. For no title, use
#'    legend.title = "". Default: "Condition"
#' @param legend.position character, one of type "right", "left", "bottom", or
#'    "top". For in-plot legends, can be coordinates. c(0,0): bottom left, c(1,1): top right.
#' @param xlab character, the x-axis label. Default: "Day"
#' @param p_adjust_method character, either "holm", "hochberg", "hommel", "bonferroni",
#'   "BH", "BY", "fdr", "none". Default: "BH". For details, see `?stats::p.adjust`.
#' @param ... additional arguments passed to `survminer::ggsurvplot()`.
#'   See full list of arguments at [survminer::ggsurvplot()].
#' @return A `ggplot2` object plotted by the `survminer` package
#'
#' @examples
#' # Convert bulk survival to individual survival
#' df_isurv <- get_indiv_surv(sample_data,
#'                            sample_order = c("WT", "Drug1", "Drug2"))
#'
#' # Fit survival object
#' surv_fit <- fit_surv(df_isurv)
#'
#' # Plot survival curve
#' plot_surv(fit = surv_fit, type = "survival")
#'
#' @importFrom ggplot2 theme element_text scale_x_continuous scale_y_continuous
#' @importFrom scales percent
#' @importFrom survminer ggsurvplot
#' @importFrom methods is
#'
#' @export

plot_surv <- function(fit,
                      type,
                      legend.title = "Condition",
                      legend.position = "right",
                      xlab = "Day",
                      add.median.survival = FALSE,
                      add.conf.int = FALSE,
                      add.pval = FALSE,
                      p_adjust_method = "BH",
                      ...){

  ## -- Error handling -- ##

  # Input checks
  if(!is(fit, "survfit")) {
    stop("`fit` must be a `survfit` object")
  }

  # Convert to survminer
  if(type == "survival"){
    ylab = "Percent survival"
    fun = "pct"
  } else if (type == "mortality") {
    fun = "event"
    ylab = "Percent mortality"
  } else {
    stop("`type` must be either `survival` or `mortality`")
  }

  # Add median survival line if true
  if (add.median.survival) {
    surv.median.line = "hv"
  } else {
    surv.median.line = "none"
  }

  # Plot with survminer, return ggplot object
  suppressMessages({ # suppress the replace scale messages
    p <- survminer::ggsurvplot(
    fit,
    fun = fun,
    legend.title = legend.title,
    legend = legend.position,
    xlab = xlab,
    ylab = ylab,
    surv.median.line = surv.median.line,
    conf.int = add.conf.int,
    pval = add.pval,
    p.adjust.method = p_adjust_method,
    ...)$plot

  # Styling - bold all axis text, legend title should be empty
  th <- ggplot2::theme(axis.title.x = ggplot2::element_text(face = "bold")) +
    ggplot2::theme(axis.title.y = ggplot2::element_text(face = "bold")) +
    ggplot2::theme(axis.text.x = ggplot2::element_text(face = "bold")) +
    ggplot2::theme(axis.text.y = ggplot2::element_text(face = "bold"))


  # Make sure y-axis is in percentage
  if (type == "mortality") {
    return(p +
             ggplot2::scale_x_continuous(expand = c(0, 0)) +
             ggplot2::scale_y_continuous(labels = scales::percent,
                                         expand = c(0, 0) # plot start (0, 0)
                                         ) +
             th)
  } else {
    return(p + th +
          # Plot start at 0, 0
          ggplot2::scale_x_continuous(expand = c(0, 0)) +
          ggplot2::scale_y_continuous(expand = c(0, 0))
           )
  }
  })
}
