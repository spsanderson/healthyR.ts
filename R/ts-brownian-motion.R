#' Brownian Motion
#'
#' @family Data Generator
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description Create a Brownian Motion Tibble
#'
#' @details Brownian Motion, also known as the Wiener process, is a
#' continuous-time random process that describes the random movement of particles
#' suspended in a fluid. It is named after the physicist Robert Brown,
#' who first described the phenomenon in 1827.
#'
#' The equation for Brownian Motion can be represented as:
#'
#'     W(t) = W(0) + sqrt(t) * Z
#'
#' Where W(t) is the Brownian motion at time t, W(0) is the initial value of the
#' Brownian motion, sqrt(t) is the square root of time, and Z is a standard
#' normal random variable.
#'
#' Brownian Motion has numerous applications, including modeling stock prices in
#' financial markets, modeling particle movement in fluids, and modeling random
#' walk processes in general. It is a useful tool in probability theory and
#' statistical analysis.
#'
#' @param .time Total time of the simulation.
#' @param .num_sims Total number of simulations.
#' @param .delta_time Time step size.
#' @param .initial_value Integer representing the initial value.
#' @param .return_tibble The default is TRUE. If set to FALSE then an object
#' of class matrix will be returned.
#'
#' @examples
#' ts_brownian_motion()
#'
#' @return
#' A tibble/matrix
#'
#' @name ts_brownian_motion
NULL

#' @export
#' @rdname ts_brownian_motion

ts_brownian_motion <- function(.time = 100, .num_sims = 10, .delta_time = 1,
                            .initial_value = 0, .return_tibble = TRUE) {

    # Tidyeval ----
    num_sims <- as.numeric(.num_sims)
    t <- as.numeric(.time)
    initial_value <- as.numeric(.initial_value)
    delta_time <- as.numeric(.delta_time)
    return_tibble <- as.logical(.return_tibble)

    # Checks
    if (!is.numeric(num_sims) | !is.numeric(t) | !is.numeric(initial_value) |
        !is.numeric(delta_time)){
        rlang::abort(
            message = "The parameters `.num_sims`, `.time`, `.delta_time`, and `.initial_value` must be numeric.",
            use_cli_format = TRUE
        )
    }

    if (!is.logical(return_tibble)){
        rlang::abort(
            message = "The parameter `.return_tibble` must be either TRUE/FALSE",
            use_cli_format = TRUE
        )
    }

    # Matrix of random draws - one for each simulation
    rand_matrix <- matrix(rnorm(t * num_sims, mean = 0, sd = sqrt(delta_time)),
                          ncol = num_sims, nrow = t)
    colnames(rand_matrix) <- paste0("sim_number ", 1:num_sims)

    # Get the Brownian Motion and convert to price paths
    ret <- apply(rbind(rep(initial_value, num_sims), rand_matrix), 2, cumsum)

    # Return
    if (return_tibble){
        ret <- ret %>%
            dplyr::as_tibble() %>%
            dplyr::mutate(t = 1:(t+1)) %>%
            #dplyr::select(t, dplyr::everything()) %>%
            tidyr::pivot_longer(-t) %>%
            dplyr::select(name, t, value) %>%
            purrr::set_names("sim_number", "t", "y") %>%
            dplyr::mutate(sim_number = forcats::as_factor(sim_number))
    }

    # Return ----
    attr(ret, ".time") <- .time
    attr(ret, ".num_sims") <- .num_sims
    attr(ret, ".delta_time") <- .delta_time
    attr(ret, ".initial_value") <- .initial_value
    attr(ret, ".return_tibble") <- .return_tibble

    return(ret)
}
