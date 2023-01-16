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
#' @param .data The data.frame/tibble being augmented.
#' @param .date_col The column that holds the date.
#' @param .value_col The value that is going to get augmented. The last value of
#' this column becomes the initial value internally.
#' @param .time How many time steps ahead.
#' @param .num_sims How many simulations should be run.
#' @param .delta_time Time step size.
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
#' ts_brownian_motion_augment(
#'   .data = df,
#'   .date_col = date_col,
#'   .value_col = value
#' )
#'
#' @return
#' A tibble/matrix
#'
#' @name ts_brownian_motion_augment
NULL

#' @export
#' @rdname ts_brownian_motion_augment

ts_brownian_motion_augment <- function(.data, .date_col, .value_col, .time = 100,
                                       .num_sims = 10, .delta_time = NULL) {

    # Tidyeval ----
    num_sims <- as.numeric(.num_sims)
    t <- as.numeric(.time)
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

    # Get delta_time using the last period for tk_time_freq
    if (is.null(delta_time)){
        delta_time <- df %>%
            dplyr::select(y) %>%
            utils::tail(n = tk_time_freq) %>%
            dplyr::pull() %>%
            stats::sd(na.rm = TRUE)
    }

    # Make sure the initial_value is numeric
    if (!is.numeric(initial_value)){
        rlang::abort(
            message = "'.value_col' must be a numeric class.",
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
    attr(ret, ".time") <- .time
    attr(ret, ".num_sims") <- .num_sims
    attr(ret, ".delta_time") <- delta_time
    attr(ret, ".initial_value") <- initial_value

    return(ret)
}

