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
#'     $$ W(t) = \sqrt{t} Z $$
#'
#' Where W(t) represents the Brownian Motion process at time t, and Z is a
#' standard normal random variable.
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
#'
#' @examples
#' ts_brownian_motion()
#'
#' @return
#' A tibble
#'
#' @name ts_brownian_motion
NULL

#' @export
#' @rdname ts_brownian_motion

ts_brownian_motion <- function(.time = 100, .num_sims = 10, .delta_time = 1,
                            .initial_value = 0) {

    # TidyEval ----
    T <- as.numeric(.time)
    N <- as.numeric(.num_sims)
    delta_t <- as.numeric(.delta_time)
    initial_value <- as.numeric(.initial_value)

    # Checks ----
    if (!is.numeric(T) | !is.numeric(N) | !is.numeric(delta_t) | !is.numeric(initial_value)){
        rlang::abort(
            message = "All parameters must be numeric values.",
            use_cli_format = TRUE
        )
    }

    # Initialize empty data.frame to store the simulations
    sim_data <- data.frame()

    # Generate N simulations
    for (i in 1:N) {
        # Initialize the current simulation with a starting value of 0
        sim <- c(initial_value)

        # Generate the brownian motion values for each time step
        for (t in 1:(T / delta_t)) {
            sim <- c(sim, sim[t] + rnorm(1, mean = 0, sd = sqrt(delta_t)))
        }

        # Bind the time steps, simulation values, and simulation number together in a data.frame and add it to the result
        sim_data <- rbind(
            sim_data,
            data.frame(
                t = seq(0, T, delta_t),
                y = sim,
                sim_number = i
            )
        )
    }

    # Clean up
    sim_data <- sim_data %>%
        dplyr::as_tibble() %>%
        dplyr::mutate(sim_number = forcats::as_factor(sim_number)) %>%
        dplyr::select(sim_number, t, y)

    # Return ----
    attr(sim_data, ".time") <- .time
    attr(sim_data, ".num_sims") <- .num_sims
    attr(sim_data, ".delta_time") <- .delta_time
    attr(sim_data, ".initial_value") <- .initial_value

    return(sim_data)
}
