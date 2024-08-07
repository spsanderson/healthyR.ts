% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ts-random-walk.R
\name{ts_random_walk}
\alias{ts_random_walk}
\title{Random Walk Function}
\usage{
ts_random_walk(
  .mean = 0,
  .sd = 0.1,
  .num_walks = 100,
  .periods = 100,
  .initial_value = 1000
)
}
\arguments{
\item{.mean}{The desired mean of the random walks}

\item{.sd}{The standard deviation of the random walks}

\item{.num_walks}{The number of random walks you want generated}

\item{.periods}{The length of the random walk(s) you want generated}

\item{.initial_value}{The initial value where the random walks should start}
}
\value{
A tibble
}
\description{
This function takes in four arguments and returns a tibble of random walks.
}
\details{
Monte Carlo simulations were first formally designed in the 1940’s while
developing nuclear weapons, and since have been heavily used in various fields
to use randomness solve problems that are potentially deterministic in nature.
In finance, Monte Carlo simulations can be a useful tool to give a sense of
how assets with certain characteristics might behave in the future.
While there are more complex and sophisticated financial forecasting methods
such as ARIMA (Auto-Regressive Integrated Moving Average) and
GARCH (Generalized Auto-Regressive Conditional Heteroskedasticity)
which attempt to model not only the randomness but underlying macro factors
such as seasonality and volatility clustering, Monte Carlo random walks work
surprisingly well in illustrating market volatility as long as the results
are not taken too seriously.
}
\examples{
ts_random_walk(
.mean = 0,
.sd = 1,
.num_walks = 25,
.periods = 180,
.initial_value = 6
)

}
\seealso{
Other Data Generator: 
\code{\link{tidy_fft}()},
\code{\link{ts_brownian_motion}()},
\code{\link{ts_brownian_motion_augment}()},
\code{\link{ts_geometric_brownian_motion}()},
\code{\link{ts_geometric_brownian_motion_augment}()}
}
\concept{Data Generator}
