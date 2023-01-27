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
#'      dS/S = mdt + sdW
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
#' @param .data The data you are going to pass to the function to augment.
#' @param .date_col The column that holds the date
#' @param .value_col The column that holds the value
#' @param .time Total time of the simulation.
#' @param .num_sims Total number of simulations.
#' @param .delta_time Time step size.
#' @param .mean Expected return
#' @param .sigma Volatility
#'
#' @examples
#' rn <- rnorm(31)
#' df <- data.frame(
#'  date_col = seq.Date(from = as.Date("2022-01-01"),
#'                       to = as.Date("2022-01-31"),
#'                       by = "day"),
#'  value = rn
#' )
#'
#' ts_geometric_brownian_motion_augment(
#'   .data = df,
#'   .date_col = date_col,
#'   .value_col = value
#' )
#'
#' @return
#' A tibble/matrix
#'
#' @name ts_geometric_brownian_motion_augment
NULL

#' @export
#' @rdname ts_geometric_brownian_motion_augment

ts_geometric_brownian_motion_augment <- function(.data, .date_col, .value_col,
                                                 .num_sims = 10, .time = 25,
                                                 .mean = 0, .sigma = 0.1,
                                                 .delta_time = 1./365
){

    # Tidyeval ----
    num_sims <- as.numeric(.num_sims)
    t <- as.numeric(.time)
    mu <- as.numeric(.mean)
    sigma <- as.numeric(.sigma)
    delta_time <- if (!is.null(.delta_time)) as.numeric(.delta_time)

    date_var_expr <- rlang::enquo(.date_col)
    value_var_expr <- rlang::enquo(.value_col)
    date_var_name <- rlang::quo_name(date_var_expr)
    value_var_name <- rlang::quo_name(value_var_expr)

    # Checks
    if (!is.data.frame(.data)){
        rlang::abort(
            message = "'.data' must be a data.frame/tibble.",
            use_cli_format = TRUE
        )
    }

    if (rlang::quo_is_missing(date_var_expr) | rlang::quo_is_missing(value_var_expr)){
        rlang::abort(
            message = "The parameters '.date_col' and '.value_col' must be supplied.",
            use_cli_format = TRUE
        )
    }

    if (!is.numeric(num_sims) | !is.numeric(t)){
        rlang::abort(
            message = "The parameters `.num_sims`, and `.time` must be numeric.",
            use_cli_format = TRUE
        )
    }

    if (!is.numeric(delta_time) & !is.null(delta_time)){
        rlang::abort(
            message = "'.delta_time' must be either numeric or NULL.",
            use_cli_format = TRUE
        )
    }

    if (!is.numeric(mu)){
        rlang::abort(
            message = "'.mean' must be numeric.",
            use_cli_format = TRUE
        )
    }

    if (!is.numeric(sigma)){
        rlang::abort(
            message = "'.sigma' must numeric.",
            use_cli_format = TRUE
        )
    }

    # Get data
    df <- dplyr::as_tibble(.data) %>%
        dplyr::select({{ date_var_expr }}, {{ value_var_expr }}) %>%
        dplyr::mutate(sim_number = forcats::as_factor("actual_data")) %>%
        dplyr::select(sim_number, dplyr::everything()) %>%
        purrr::set_names("sim_number", "t", "y")

    # Make sure .date_col is of class date
    date_col <- df %>%
        dplyr::pull(t)

    if (!ts_is_date_class(date_col)){
        rlang::abort(
            message = "'.date_col' must be a date class.",
            use_cli_format = TRUE
        )
    }

    # Get max date
    max_date <- df %>%
        dplyr::pull(t) %>%
        utils::tail(n = 1)

    # Get the frequency statistic
    time_freq <- ts_info_tbl(df, t)$frequency
    tk_time_freq <- timetk::tk_get_frequency(df %>% dplyr::pull(t),
                                             message = FALSE)

    # Get the future dates
    future_dates <- seq.Date(max_date, by = time_freq, length.out = t + 1)

    # Get initial value
    initial_value <- df %>%
        dplyr::select(y) %>%
        utils::tail(n = 1) %>%
        dplyr::pull()

    # Make sure the initial_value is numeric
    if (!is.numeric(initial_value)){
        rlang::abort(
            message = "'.value_col' must be a numeric class.",
            use_cli_format = TRUE
        )
    }

    # Get delta_time using the last period for tk_time_freq if it is null
    if (is.null(delta_time)){
        delta_time <- df %>%
            dplyr::select(y) %>%
            utils::tail(n = tk_time_freq) %>%
            dplyr::pull() %>%
            stats::sd(na.rm = TRUE)
    }

    # matrix of random draws - one for each day for each simulation
    rand_matrix <- matrix(rnorm(t * num_sims), ncol = num_sims, nrow = t)
    colnames(rand_matrix) <- paste0("sim_number ", 1:num_sims)

    # get GBM and convert to price paths
    ret <- exp((mu - sigma * sigma / 2) * delta_time + sigma * rand_matrix * sqrt(delta_time))
    ret <- apply(rbind(rep(initial_value, num_sims), ret), 2, cumprod)

    # Return
    ret <- ret %>%
        dplyr::as_tibble() %>%
        dplyr::mutate(t = future_dates) %>%
        tidyr::pivot_longer(-t) %>%
        dplyr::select(name, t, value) %>%
        purrr::set_names("sim_number", "t", "y") %>%
        dplyr::mutate(sim_number = forcats::as_factor(sim_number))

    ret <- rbind(df, ret) %>%
        dplyr::rename(!!date_var_name := t) %>%
        dplyr::rename(!!value_var_name := y)

    # Return ----
    attr(ret, ".time") <- t
    attr(ret, ".mu") <- mu
    attr(ret, ".sigma") <- sigma
    attr(ret, ".num_sims") <- .num_sims
    attr(ret, ".delta_time") <- delta_time
    attr(ret, ".initial_value") <- initial_value
    attr(ret, ".motion_type") <- "Geometric Brownian Motion"

    return(ret)

}
