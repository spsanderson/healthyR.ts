ts_info_tbl <- function(.data){

    # Internal Data Var ----
    ts_obj <- .data

    # * Checks ----
    if(!stats::is.ts(ts_obj) & !xts::is.xts(ts_obj) & !zoo::is.zoo(ts_obj)){
        stop(call. = FALSE, "(.data) must be a valid time series object, ts, xts, mts, or zoo.")
    }

    ts_name <- NULL
    ts_info <- NULL

    # Get Name
    ts_name <- base::deparse(base::substitute(.data))

    # * TS Object Tyep ----
    # ** Stats TS Object ----
    if(stats::is.ts(ts_obj) & !is.mts(ts_obj)){
        ts_info  <- tibble::tibble(
            name = ts_name,
            class = "ts",
            frequency = stats::frequency(ts_obj),
            start = base::paste(stats::start(ts_obj), collapse = " "),
            end = base::paste(stats::end(ts_obj), collapse = " "),
            var = "univariate",
            length = base::length(ts_obj)
        )
    } else if(stats::is.ts(ts_obj) & stats::is.mts(ts_obj)){
        ts_info <- tibble::tibble(
            name = ts_name,
            class = "mts",
            frequency = stats::frequency(ts_obj),
            start = base::paste(stats::start(ts_obj), collapse = " "),
            end = base::paste(stats::end(ts_obj), collapse = " "),
            var = base::paste(dim(ts_obj)[2], "variables", sep = " "),
            length = base::dim(ts_obj)[1],
        )
    } else if(xts::is.xts(ts_obj)){
        ts_info <- tibble::tibble(
            name = ts_name,
            class = "xts",
            frequency = dplyr::case_when(
                xts::periodicity(ts_obj)$scale != "minute" ~ xts::periodicity(ts_obj)$scale
                , TRUE ~ base::paste(xts::periodicity(ts_obj)$frequency, xts::periodicity(ts_obj)$units, collapse = " ")
            ),
            start = base::paste(stats::start(ts_obj), collapse = " "),
            end = base::paste(stats::end(ts_obj), collapse = " "),
            var = if(base::is.null(base::dim(ts_obj)) & !base::is.null(base::length(ts_obj))){
                "univariate"
            } else if(dim(ts_obj)[2] == 1){
                base::paste(dim(ts_obj)[2], "variable", sep = " ")
            } else if (dim(ts_obj)[2] > 1){
                base::paste(dim(ts_obj)[2], "variables", sep = " ")
            },
            length = if(base::is.null(base::dim(ts_obj)) & !base::is.null(base::length(ts_obj))){
                base::length(ts_obj)
            } else {
                base::dim(ts_obj)[1]
            }
        )
    } else if(zoo::is.zoo(ts_obj)){
        ts_info <- tibble::tibble(
            name = ts_name,
            class = "zoo",
            frequency = xts::periodicity(ts_obj)$scale,
            start = base::paste(stats::start(ts_obj), collapse = " "),
            end = base::paste(stats::end(ts_obj), collapse = " "),
            var = if(base::is.null(base::dim(ts_obj)) & !base::is.null(base::length(ts_obj))){
                "univariate"
            } else if(dim(ts_obj)[2] == 1){
                base::paste(dim(ts_obj)[2], "variable", sep = " ")
            } else {
                base::paste(dim(ts_obj)[2], "variables", sep = " ")
            },
            length = if(base::is.null(base::dim(ts_obj)) & !base::is.null(base::length(ts_obj))){
                base::length(ts_obj)
            } else if(dim(ts_obj)[2] == 1){
                base::dim(ts_obj)[1]
            } else {
                base::length(ts_obj)
            }
        )
    }

    # * Return ----
    return(ts_info)
}
