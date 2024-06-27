#' Time Series Feature Clustering
#'
#' @family Clustering
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @details This function will return a list object output. The function itself
#' requires that the `ts_feature_cluster()` be passed to it as it will look for
#' a specific attribute internally.
#'
#' The output of this function includes the following:
#'
#' __Data Section__
#' -  original_data
#' -  kmm_data_tbl
#' -  user_item_tbl
#' -  cluster_tbl
#'
#' __Plots__
#' -  static_plot
#' -  plotly_plot
#'
#' __K-Means Object__
#' -  k-means object
#'
#' @description This function returns an output list of data and plots that
#' come from using the `K-Means` clustering algorithm on a time series data.
#'
#' @param .data The data passed must be the output of the `ts_feature_cluster()`
#' function.
#' @param .date_col The date column.
#' @param .value_col The column that holds the value of the time series that the
#' featurs were built from.
#' @param .center An integer of the chosen amount of centers from the `ts_feature_cluster()`
#' function.
#' @param .facet_ncol This is passed to the `timetk::plot_time_series()` function.
#' @param .smooth This is passed to the `timetk::plot_time_series()` function and
#' is set to a default of FALSE.
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
#' output <- ts_feature_cluster(
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
#' ts_feature_cluster_plot(
#'   .data = output,
#'   .date_col = date_col,
#'   .value_col = value,
#'   .center = 2,
#'   group_id
#' )
#'
#' @return A list output
#' @name ts_feature_cluster_plot
NULL

#' @export
#' @rdname ts_feature_cluster_plot

ts_feature_cluster_plot <- function(.data, .date_col, .value_col, ...,
                                    .center = 3, .facet_ncol = 3,
                                    .smooth = FALSE){

    # Tidyeval ----
    km_center          <- as.integer(.center)
    id_col_var_expr    <- rlang::enquos(...)
    date_col_var_expr  <- rlang::enquo(.date_col)
    value_col_var_expr <- rlang::enquo(.value_col)
    facet_ncol         <- as.integer(.facet_ncol)
    smooth             <- as.logical(.smooth)

    # * Checks ----
    atb <- attributes(.data)

    if (atb$output_type != "ts_feature_cluster"){
        rlang::abort(
            message = "You must use the 'ts_feature_cluster()' function on the
            data passed to this plotting function.",
            use_cli_format = TRUE
        )
    }

    if (!is.integer(km_center)){
        rlang::abort(
            message = paste0("You must supply an integer value for '.km_center'.

                       Value supplied is: .km_center = ", km_center),
            use_cli_format = TRUE
        )
    }

    if (!is.integer(facet_ncol)){
        rlang::abort(
            message = paste0("You must supply an integer value for '.facet_ncol'.

                       Value supplied is: .facet_ncol = ", facet_ncol),
            use_cli_format = TRUE
        )
    }

    if (!is.logical(smooth)){
        rlang::abort(
            message = "You must supply either TRUE or FALSE for the '.smooth' parameter.",
            use_cli_format = TRUE
        )
    }

    # * Data ----
    input_list   <- .data
    original_tbl <- dplyr::as_tibble(input_list$data$input_data_tbl)
    kmm_data_tbl <- dplyr::as_tibble(input_list$data$mapped_tbl)
    ui_tbl       <- dplyr::as_tibble(input_list$data$user_item_matrix_tbl)

    km_obj <- kmm_data_tbl %>%
        dplyr::filter(centers == km_center) %>%
        purrr::pluck("k_means")

    cluster_tbl <- km_obj[[1]]$cluster %>%
        dplyr::as_tibble() %>%
        dplyr::rename(cluster = value) %>%
        dplyr::bind_cols(ui_tbl)

    # * Plot ----
    g <- cluster_tbl %>%
        dplyr::select(cluster, !!!id_col_var_expr) %>%
        dplyr::right_join(original_tbl) %>%
        dplyr::group_by(!!!id_col_var_expr) %>%
        dplyr::arrange(cluster) %>%
        timetk::plot_time_series(
            .date_var = {{ date_col_var_expr }},
            .value = {{ value_col_var_expr }},
            .color_var = cluster,
            .facet_ncol = facet_ncol,
            .interactive = FALSE,
            .smooth = smooth
        ) +
        ggplot2::theme_minimal() +
        ggplot2::labs(
            title = "Time Series Feature Cluster Plot",
        ) +
        ggplot2::theme(legend.position = "bottom")

    # Output -----
    output <- list(
        plot = list(
            static_plot = g,
            plotly_plot = suppressWarnings(plotly::ggplotly(g))
        ),
        data = list(
            original_data = original_tbl,
            kmm_data_tbl  = kmm_data_tbl,
            user_item_tbl = ui_tbl,
            cluster_tbl   = cluster_tbl
        ),
        kmeans_object = km_obj
    )

    # * Return ----
    print(output$plot$static_plot)
    return(output)

}
