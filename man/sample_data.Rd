\name{sample_data}
\docType{data}
\alias{sample_data}
\title{Sample Survival Analysis Dataset}
\description{
  A fictional dataset for survival analysis.
}
\usage{data("sample_data")}
\format{
  A `data.frame` with 64 rows and 4 columns:
  \itemize{
    \item{\code{ condition }}{character, either WT, Drug1 or Drug2}
    \item{\code{ day }}{numeric, the day that observations were made}
    \item{\code{ dead }}{numeric, number of organisms dead on this day}
    \item{\code{ censored }}{numeric, number of organisms censored/missing on this day.}
            }
      }
\examples{
data(sample_data)
}
\keyword{datasets}
