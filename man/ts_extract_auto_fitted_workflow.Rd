% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils-get-boilerplate-fit-wflw.R
\name{ts_extract_auto_fitted_workflow}
\alias{ts_extract_auto_fitted_workflow}
\title{Extract Boilerplate Items}
\usage{
ts_extract_auto_fitted_workflow(.input)
}
\arguments{
\item{.input}{This is the output list object of a \code{ts_auto_} function.}
}
\value{
A fitted \code{workflow} object.
}
\description{
Extract the fitted workflow from a \code{ts_auto_} function.
}
\details{
Extract the fitted workflow from a \code{ts_auto_} function. This will
only work on those functions that are designated as \emph{Boilerplate}.
}
\examples{
\dontrun{
library(dplyr)

data <- AirPassengers \%>\%
  ts_to_tbl() \%>\%
  select(-index)

splits <- time_series_split(
  data
  , date_col
  , assess = 12
  , skip = 3
  , cumulative = TRUE
)

ts_lm <- ts_auto_lm(
  .data = data,
  .date_col = date_col,
  .value_col = value,
  .rsamp_obj = splits,
  .formula = value ~ .,
)

ts_extract_auto_fitted_workflow(ts_lm)
}

}
\author{
Steven P. Sanderson II, MPH
}
\concept{Boilerplate Utility}
