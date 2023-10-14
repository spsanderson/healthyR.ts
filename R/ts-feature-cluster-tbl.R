#' Time Series Feature Clustering
#'
#' @family Clustering
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @details This function will return a list object output. The function itself
#' requires that a time series tibble/data.frame get passed to it, along with
#' the `.date_col`, the `.value_col` and a period of data. It uses the underlying
#' function `timetk::tk_tsfeatures()` and takes the output of that and performs
#' a clustering analysis using the `K-Means` algorithm.
#'
#' The function has a parameter of `.features` which can take any of the features
#' listed in the `tsfeatures` package by Rob Hyndman. You can also create custom
#' functions in the `.GlobalEnviron` and it will take them as quoted arguments.
#'
#' So you can make a function as follows
#'
#' `my_mean <- function(x){return(mean(x, na.rm = TRUE))}`
#'
#' You can then call this by using `.features = c("my_mean")`.
#'
#' The output of this function includes the following:
#'
#' __Data Section__
#' -  ts_feature_tbl
#' -  user_item_matrix_tbl
#' -  mapped_tbl
#' -  scree_data_tbl
#' -  input_data_tbl (the original data)
#'
#' __Plots__
#' -  static_plot
#' -  plotly_plot
#'
#' @seealso \url{https://pkg.robjhyndman.com/tsfeatures/index.html}
#'
#' @description This function returns an output list of data and plots that
#' come from using the `K-Means` clustering algorithm on a time series data.
#'
#' @param .data The data passed must be a `data.frame/tibble` only.
#' @param .date_col The date column.
#' @param .value_col The column that holds the value of the time series where you
#' want the features and clustering performed on.
#' @param .features This is a quoted string vector using c() of features that you
#' would like to pass. You can pass any feature you make or those from the `tsfeatures`
#' package.
#' @param .scale If TRUE, time series are scaled to mean 0 and sd 1 before features are computed
#' @param .prefix A prefix to prefix the feature columns. Default: "ts_"
#' @param .centers An integer of how many different centers you would like to generate.
#' The default is 3.
#' @param ... This is where you can place grouping variables that are passed off
#' to `dplyr::group_by()`
#'
#' @examples
#'
#' library(dplyr)
#'
#' data_tbl <- ts_to_tbl(AirPassengers) %>%
#'   mutate(group_id = rep(1:12, 12))
#'
#' ts_feature_cluster(
#'   .data = data_tbl,
#'   .date_col = date_col,
#'   .value_col = value,
#'   group_id,
#'   .features = c("acf_features","entropy"),
#'   .scale = TRUE,
#'   .prefix = "ts_",
#'   .centers = 3
#' )
#'
#' @return A list output
#'
#' @export
#'

ts_feature_cluster <- function(.data, .date_col, .value_col, ...,
                       .features = c("frequency","entropy","acf_features"),
                       .scale = TRUE, .prefix = "ts_", .centers = 3){

    # Tidyeval ----
    date_col_var_expr <- rlang::enquo(.date_col)
    value_col_var_expr <- rlang::enquo(.value_col)
    centers <- as.numeric(.centers)
    features <- as.character(.features)
    scale <- as.logical(.scale)
    prefix <- as.character(.prefix)
    groups <- rlang::enquos(...)

    # Checks ----
    # Is .data a time-series object or data.frame/tibble?
    if(inherits(.data, "ts") || inherits(.data, "mts") ||
       inherits(.data, "xts") || inherits(.data, "zoo")){
        rlang::abort(
            message = paste0(
                "You must pass a 'tibble/data.frame' to this function. You supplied
                data of the class: ", class(.data)
            ),
            use_cli_format = TRUE
        )
    } else if (is.data.frame(.data)){
        data_tbl <- tibble::as_tibble(.data)
    } else {
        rlang::abort(
            message = "You did not pass a 'tibble/data.frame'.",
            use_cli_format = TRUE
        )
    }

    if (rlang::quo_is_missing(date_col_var_expr)){
        rlang::abort(
            message = "You must supply '.date_col'.",
            use_cli_format = TRUE
        )
    }

    if (rlang::quo_is_missing(value_col_var_expr)){
        rlang::abort(
            message = "You must supply '.value_col'."
        )
    }

    if (!is.logical(scale)){
        rlang::abort(
            message = "The parameter of '.scale' must be a logical TRUE/FALSE.",
            use_cli_format = TRUE
        )
    }

    if (!is.character(prefix)){
        rlang::abort(
            message = "The parameter of '.prefix' must be a character.",
            use_cli_format = TRUE
        )
    }

    # * Data ----
    data_feature_tbl <- data_tbl %>%
        dplyr::group_by(!!!groups) %>%
        timetk::tk_tsfeatures(
            .date_var = {{ date_col_var_expr }},
            .value    = {{ value_col_var_expr }},
            .features = c(features),
            .scale    = scale,
            .prefix   = prefix
        ) %>%
        dplyr::ungroup()

    # Zero Variance function -- possible export on its own
    remove_zero_variance_columns <- function(df){
        df[, !sapply(df, function(x) min(x) == max(x))]
    }

    # * Remove zero var cols ----
    data_feature_tbl <- data_feature_tbl[ , colSums(is.na(data_feature_tbl)) < nrow(data_feature_tbl)]
    data_feature_tbl <- remove_zero_variance_columns(data_feature_tbl)

    # * User Item Matrix ----
    ui_tbl <- data_feature_tbl

    # * Kmeans Mapped Tibble ----
    kmm_tbl <- healthyR.ai::hai_kmeans_mapped_tbl(ui_tbl, .centers = centers)

    # * Scree data and plot
    kmm_scree_data <- healthyR.ai::hai_kmeans_scree_data_tbl(kmm_tbl)
    scree_plt <- healthyR.ai::hai_kmeans_scree_plt(kmm_tbl)
    scree_plotly_plt <- suppressWarnings(plotly::ggplotly(scree_plt))

    # * Return ----
    output <- list(
        data = list(
            ts_feature_tbl       = data_feature_tbl,
            user_item_matrix_tbl = ui_tbl,
            mapped_tbl           = kmm_tbl,
            scree_data_tbl       = kmm_scree_data,
            input_data_tbl       = data_tbl
        ),
        plots = list(
            static_plot = scree_plt,
            plotly_plot = scree_plotly_plt
        )
    )

    attr(output, "output_type") <- "ts_feature_cluster"
    return(output)

}
