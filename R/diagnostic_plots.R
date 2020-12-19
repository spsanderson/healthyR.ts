#' Get Random Walk `ggplot2` layers
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description
#' Get layers to add to a `ggplot` graph from the [ts_random_walk()] function.
#'
#' @details
#' - Set the intercept of the initial value from the random walk
#' - Set the max and min of the cumulative sum of the random walks
#'
#' @param .data The data passed to the function.
#'
#' @examples
#' library(ggplot2)
#'
#' df <- ts_random_walk()
#'
#' df %>%
#'   ggplot(
#'     mapping = aes(
#'       x = x
#'       , y = cum_y
#'       , color = factor(run)
#'       , group = factor(run)
#'    )
#'  ) +
#'  geom_line(alpha = 0.8) +
#'  ts_random_walk_ggplot_layers(df)
#'
#' @return
#' A `ggplot2` layers object
#'
#' @export
#'

# Function for obtaining ggplot layers to commonly apply to subsequent plots
ts_random_walk_ggplot_layers <- function(.data) {

    # Check
    if(!is.data.frame(.data)){
        stop(call. = FALSE,"(.data) was not provided. Please supply.")
    }

    df <- dplyr::as_tibble(.data)

    gg_layers <- list(
        ggplot2::geom_hline(
            yintercept = attr(df, ".initial_value"),
            color = "black", linetype = "dotted"
        ),
        ggplot2::geom_hline(
            yintercept = max(subset(df, x == max(x))$cum_y),
            color = "steelblue", linetype = "dashed"
        ),
        ggplot2::geom_hline(
            yintercept = min(subset(df, x == max(x))$cum_y),
            color = "firebrick", linetype = "dashed"
        ),
        ggplot2::annotate(
            geom = "label",
            x = max(df$x), y = max(subset(df, x == max(x))$cum_y),
            label = prettyNum(round(max(subset(df, x == max(x))$cum_y), 0), big.mark = ","),
            size = 3, hjust = 1, color = "white", fill = "steelblue"
        ),
        ggplot2::annotate(
            geom = "label",
            x = max(df$x), y = min(subset(df, x == max(x))$cum_y),
            label = prettyNum(round(min(subset(df, x == max(x))$cum_y), 0), big.mark = ","),
            size = 3, hjust = 1, color = "white", fill = "firebrick"
        ),
        ggplot2::labs(
            title = "Random Walk Simulation",
            subtitle = paste(
                attr(df, ".num_walks"), "Random walks with",
                paste0("an initial value of: ", prettyNum(attr(df, ".initial_value"), big.mark = ",")),
                "and", paste0(round(attr(df, ".sd") * 100, 0), "%"),
                "volatility"
            ),
            x = "Days into future", y = "Value"
        ),
        tidyquant::scale_colour_tq(),
        tidyquant::scale_fill_tq(),
        tidyquant::theme_tq(),
        ggplot2::theme(legend.position = "none")
    )
    return(gg_layers)
}

#' Quality Control Run Chart
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description
#' A control chart is a specific type of graph that shows data points between
#' upper and lower limits over a period of time. You can use it to understand
#' if the process is in control or not. These charts commonly have three types
#' of lines such as upper and lower specification limits, upper and lower limits
#' and planned value. By the help of these lines, Control Charts show the
#' process behavior over time.
#'
#' @details
#' - Expects a time-series tibble/data.frame
#' - Expects a date column and a value column
#'
#' @param .data The data.frame/tibble to be passed.
#' @param .date_col The column holding the timestamp.
#' @param .value_col The column with the values to be analyzed.
#' @param .interactive Default is FALSE, TRUE for an interactive plotly plot.
#' @param .median Default is TRUE. This will show the median line of the data.
#' @param .cl This is the first upper control line
#' @param .mcl This is the second sigma control line positive
#' @param .ucl This is the third sigma control line positive
#' @param .lc This is the first negative control line
#' @param .lmcl This is the second sigma negative control line
#' @param .llcl This si the thrid sigma negative control line
#'
#' @examples
#' library(healthyR.data)
#' library(timetk)
#' library(dplyr)
#' library(stringr)
#'
#' df <- healthyR_data
#'
#' df_monthly_tbl <- df %>%
#'    mutate(ip_op_flag = str_squish(ip_op_flag)) %>%
#'    filter(ip_op_flag == "I") %>%
#'    select(visit_end_date_time, length_of_stay) %>%
#'    arrange(visit_end_date_time) %>%
#'    summarise_by_time(
#'        .date_var = visit_end_date_time
#'        , .by = "month"
#'        , alos = round(mean(length_of_stay, na.rm = TRUE), 2)
#'        , .type = "ceiling"
#'    ) %>%
#'    mutate(
#'      visit_end_date_time = visit_end_date_time %>%
#'        subtract_time("1 day")
#'    )
#'
#' df_monthly_tbl %>%
#'   ts_qc_run_chart(
#'     .date_col    = visit_end_date_time
#'     , .value_col = alos
#'     , .llcl      = TRUE
#'   )
#'
#' @return
#' A static ggplot2 graph or if .interactive is set to TRUE a plotly plot
#'
#' @export
#'

ts_qc_run_chart <- function(.data, .date_col, .value_col, .interactive = FALSE,
                            .median = TRUE, .cl = TRUE, .mcl = TRUE, .ucl = TRUE,
                            .lc = FALSE, .lmcl = FALSE, .llcl = FALSE) {

    # Tidyeval
    date_col_var_expr  <- rlang::enquo(.date_col)
    value_col_var_expr <- rlang::enquo(.value_col)

    # Checks
    if(!is.data.frame(.data)){
        stop(call. = FALSE, "(.data) is missing. Please supply.")
    }

    if(rlang::quo_is_missing(date_col_var_expr)){
        stop(call. = FALSE, "(.date_col) is missing. Please supply.")
    }

    if(rlang::quo_is_missing(value_col_var_expr)){
        stop(call. = FALSE, "(.value_col) is missing. Please supply.")
    }

    data_tbl <- tibble::as_tibble(.data)

    data_tbl <- data_tbl %>%
        dplyr::select({{date_col_var_expr}}, {{value_col_var_expr}}) %>%
        purrr::set_names("ds","y")

    y      <- data_tbl %>% dplyr::pull(y)
    max_ds <- data_tbl %>% dplyr::pull(ds) %>% base::max()

    # Construct control limit lines
    mean_alos   <- base::mean(y, na.rm = TRUE)
    median_alos <- stats::median(y, na.rm = TRUE)
    std_dev     <- stats::sd(y)
    cl_a        <- mean_alos + std_dev
    cl_b        <- mean_alos + (2 * std_dev)
    cl_c        <- mean_alos + (3 * std_dev)
    cl_d        <- mean_alos - std_dev
    cl_e        <- mean_alos - (2 * std_dev)
    cl_f        <- mean_alos - (3 * std_dev)

    # Plot
    p <- data_tbl %>%
        ggplot2::ggplot(
            mapping = ggplot2::aes(
                x = ds
                , y = y
            )
        ) +
        ggplot2::geom_line(size = .5, color = "#2C3E50") +
        ggplot2::theme_minimal()

    # Check if add median line
    if(.median){
        p <- p +
            ggplot2::geom_line(
                mapping = ggplot2::aes(y = median_alos)
                , linetype = "dashed"
                , size = 1
                , color = "#6A3D9A"
            )
    }

    # Check if add cl
    if(.cl){
        p <- p +
            ggplot2::geom_line(
                mapping = ggplot2::aes(y = cl_a)
                , color = "#18BC9C"
                , size = 1
            )
    }

    # Check if add mcl
    if(.mcl){
        p <- p +
            ggplot2::geom_line(
                mapping = ggplot2::aes(y = cl_b)
                , color = "#CCBE93"
                , size = 1
            )
    }

    # Check if add ucl
    if(.ucl){
        p <- p +
            ggplot2::geom_line(
                mapping = ggplot2::aes(y = cl_c)
                , color = "#E31A1C"
                , size = 1
            )
    }

    # Check if add lcl
    if(.lc){
        p <- p +
            ggplot2::geom_line(
                mapping = ggplot2::aes(y = cl_d)
                , color = "#18BC9C"
                , size = 1
            )
    }

    # Check if add mcl
    if(.lmcl){
        p <- p +
            ggplot2::geom_line(
                mapping = ggplot2::aes(y = cl_e)
                , color = "#CCBE93"
                , size = 1
            )
    }

    # Check if add ucl
    if(.llcl){
        p <- p +
            ggplot2::geom_line(
                mapping = ggplot2::aes(y = cl_f)
                , color = "#E31A1C"
                , size = 1
            )
    }

    # * Interactive ----
    if(.interactive){
        return(plotly::ggplotly(p))
    } else {
        p <- p +
            ggplot2::geom_text(
                mapping = ggplot2::aes(x = max_ds, y = cl_a)
                , label = round(cl_a, 2)
                , hjust = -.2
                , na.rm = TRUE
            ) +
            ggplot2::geom_text(
                mapping = ggplot2::aes(x = max_ds, y = cl_b)
                , label = round(cl_b, 2)
                , hjust = -.2
                , na.rm = TRUE
            ) +
            ggplot2::geom_text(
                mapping = ggplot2::aes(x = max_ds, y = cl_c)
                , label = round(cl_c, 2)
                , hjust = -.2
                , na.rm = TRUE
            ) +
            ggplot2::geom_text(
                mapping = ggplot2::aes(x = max_ds, y = cl_d)
                , label = round(cl_a, 2)
                , hjust = -.2
                , na.rm = TRUE
            ) +
            ggplot2::geom_text(
                mapping = ggplot2::aes(x = max_ds, y = cl_e)
                , label = round(cl_b, 2)
                , hjust = -.2
                , na.rm = TRUE
            ) +
            ggplot2::geom_text(
                mapping = ggplot2::aes(x = max_ds, y = cl_f)
                , label = round(cl_c, 2)
                , hjust = -.2
                , na.rm = TRUE
            ) +
            ggplot2::geom_text(
                mapping = ggplot2::aes(x = max_ds, y = median_alos)
                , label = median_alos
                , hjust = -.2
                , na.rm = TRUE
            )
    }

    # * Return ----
    print(p)
}
