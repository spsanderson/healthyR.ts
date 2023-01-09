#' Geometric Brownian Motion
#'
#' @family Data Generator
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description Create a Geometric Brownian Motion.
#'
#' @details Geometric Brownian Motion (GBM) is a statistical method for modeling
#' the evolution of a given financial asset over time. It is a type of stochastic
#' process, which means that it is a system that undergoes random changes over
#' time.
#'
#' GBM is widely used in the field of finance to model the behavior of stock
#' prices, foreign exchange rates, and other financial assets. It is based on
#' the assumption that the asset's price follows a random walk, meaning that it
#' is influenced by a number of unpredictable factors such as market trends,
#' news events, and investor sentiment.
#'
#' The equation for GBM is:
#'
#'      dS/S = μdt + σdW
#'
#' where S is the price of the asset, t is time, μ is the expected return on the
#' asset, σ is the volatility of the asset, and dW is a small random change in
#' the asset's price.
#'
#' GBM can be used to estimate the likelihood of different outcomes for a given
#' asset, and it is often used in conjunction with other statistical methods to
#' make more accurate predictions about the future performance of an asset.
#'
#' This function provides the ability of simulating and estimating the parameters
#' of a GBM process. It can be used to analyze the behavior of financial
#' assets and to make informed investment decisions.
#'
#' @param .time Total time of the simulation.
#' @param .num_sims Total number of simulations.
#' @param .delta_time Time step size.
#' @param .initial_value Integer representing the initial value.
#' @param .mean Expected return
#' @param .sigma Volatility
#' @param .return_tibble The default is TRUE. If set to FALSE then an object
#' of class matrix will be returned.
#'
#' @examples
#' ts_geometric_brownian_motion()
#'
#' @return
#' A tibble/matrix
#'
#' @name ts_geometric_brownian_motion
NULL

#' @export
#' @rdname ts_geometric_brownian_motion

ts_geometric_brownian_motion <- function(.num_sims = 100, .time = 25,
                                         .mean = 0, .sigma = 0.1,
                                         .initial_value = 100,
                                         .delta_time = 1./365,
                                         .return_tibble = TRUE) {

    # Tidyeval ----
    # Thank you to https://robotwealth.com/efficiently-simulating-geometric-brownian-motion-in-r/
    num_sims <- as.numeric(.num_sims)
    t <- as.numeric(.time)
    mu <- as.numeric(.mean)
    sigma <- as.numeric(.sigma)
    initial_value <- as.numeric(.initial_value)
    delta_time <- as.numeric(.delta_time)
    return_tibble <- as.logical(.return_tibble)

    # Checks ----
    if (!is.logical(return_tibble)){
        rlang::abort(
            message = "The paramter `.return_tibble` must be either TRUE/FALSE",
            use_cli_format = TRUE
        )
    }

    if (!is.numeric(num_sims) | !is.numeric(t) | !is.numeric(mu) |
        !is.numeric(sigma) | !is.numeric(initial_value) | !is.numeric(delta_time)){
        rlang::abort(
            message = "The parameters of `.time', `.num_sims`, `.mean`, `.sigma`,
            `.initial_value`, and `.delta_time` must be numeric.",
            use_cli_format = TRUE
        )
    }

    # matrix of random draws - one for each day for each simulation
    rand_matrix <- matrix(rnorm(t * num_sims), ncol = num_sims, nrow = t)
    colnames(rand_matrix) <- paste0("sim_number ", 1:num_sims)

    # get GBM and convert to price paths
    ret <- exp((mu - sigma * sigma / 2) * delta_time + sigma * rand_matrix * sqrt(delta_time))
    ret <- apply(rbind(rep(initial_value, num_sims), ret), 2, cumprod)

    # Return
    if (return_tibble){
        ret <- ret %>%
            dplyr::as_tibble() %>%
            dplyr::mutate(t = 1:(t+1)) %>%
            dplyr::select(t, dplyr::everything()) %>%
            tidyr::pivot_longer(-t)
    }

    attr(ret, ".time") <- .time
    attr(ret, ".num_sims") <- .num_sims
    attr(ret, ".mean") <- .mean
    attr(ret, ".sigma") <- .sigma
    attr(ret, ".initial_value") <- .initial_value
    attr(ret, ".delta_time") <- .delta_time
    attr(ret, ".return_tibble") <- .return_tibble

    return(ret)
}
