#' Time Series Splits Plot
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description
#' Sometimes we want to see the training and testing data in a plot. This is a
#' simple wrapper around a couple of functions from the `timetk` package.
#'
#' @seealso
#'   * \url{https://business-science.github.io/timetk/reference/index.html#section-cross-validation-plan-visualization-resample-sets-} (timetk)
#'   * \url{https://business-science.github.io/timetk/reference/plot_time_series_cv_plan.html}(tk_time_sers_cv_plan)
#'   * \url{https://business-science.github.io/timetk/reference/plot_time_series_cv_plan.html}(plot_time_series_cv_plan)
#'
#' @details
#' You should already have a splits object defined. This function takes in three
#' parameters, the splits object, a date column and the value column.
#'
#' @param .splits_obj The predefined splits object.
#' @param .date_col The date column for the time series.
#' @param .value_col The value column of the time series.
#'
#' @examples
#' suppressPackageStartupMessages(library(modeltime))
#' suppressPackageStartupMessages(library(timetk))
#' suppressPackageStartupMessages(library(dplyr))
#' suppressPackageStartupMessages(library(healthyR.data))
#'
#' data <- healthyR_data %>%
#'    filter(ip_op_flag == "I") %>%
#'    select(visit_end_date_time) %>%
#'    rename(date_col = visit_end_date_time) %>%
#'    summarise_by_time(
#'         .date_var = date_col
#'         , .by     = "month"
#'         , value   = n()
#'     ) %>%
#'    filter_by_time(
#'        .date_var     = date_col
#'        , .start_date = "2012"
#'        , .end_date   = "2019"
#'    )
#'
#' splits <- time_series_split(
#'     data
#'     , date_col
#'     , assess = 12
#'     , skip = 3
#'     , cumulative = TRUE
#' )
#'
#' ts_splits_plot(
#'     .splits_obj = splits,
#'     .date_col   = date_col,
#'     .value_col  = value
#' )
#
#'
#' @return
#' A time series cv plan plot
#'
#' @export
#'

ts_splits_plot <- function(.splits_obj, .date_col, .value_col){

    # * Tidyeval ----
    date_col_var_expr  <- rlang::enquo(.date_col)
    value_col_var_expr <- rlang::enquo(.value_col)

    # Splits Object
    splits_object <- .splits_obj

    # * Plot out splits
    plt <- splits_object %>%
        timetk::tk_time_series_cv_plan() %>%
        timetk::plot_time_series_cv_plan(
            .date_var = {{ date_col_var_expr }}
            , .value  = {{ value_col_var_expr }}
        )

    # * Return ----
    return(plt)

}
