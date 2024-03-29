% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_indiv_surv.R
\name{get_indiv_surv}
\alias{get_indiv_surv}
\title{get_indiv_surv}
\usage{
get_indiv_surv(sample_data, sample_order = unique(sample_data$condition))
}
\arguments{
\item{sample_data}{A \code{data.frame} object with 4 columns. Column headers
must be ("condition", "day", "dead", "censored").}

\item{sample_order}{\code{character}, conditions to plot, in order.
Default: unique(sample_data$condition). To subset, use sample_order = c("WT", "Drug1")}
}
\value{
A \code{tibble} for lifespan by individual.
Contains 3 columns: \code{condition}, \code{day}, \code{status}.
}
\description{
Converts bulk survival data (multiple observations per row) to
individual survival data (one observation per row)
}
\details{
Status: 1 = dead, 0 = censored.
}
\examples{
# Default (alphabetical order)
df_isurv <- get_indiv_surv(sample_data)

# Plot samples in a fixed order
df_isurv <- get_indiv_surv(sample_data,
                           sample_order = c("WT", "Drug1", "Drug2"))

# Subset only 2 conditions
df_isurv <- get_indiv_surv(sample_data,
                           sample_order = c("WT", "Drug1"))


}
