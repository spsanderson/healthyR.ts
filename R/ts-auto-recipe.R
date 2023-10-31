#' Build a Time Series Recipe
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description Automatically builds generic time series recipe objects from a given
#' tibble.
#'
#' @details
#' This will build out a couple of generic recipe objects and return those items
#' in a list.
#'
#' @param .data The data that is going to be modeled. You must supply a tibble.
#' @param .date_col The column that holds the date for the time series.
#' @param .pred_col The column that is to be predicted.
#' @param .step_ts_sig A Boolean indicating should the [timetk::step_timeseries_signature()]
#' be added, default is TRUE.
#' @param .step_ts_rm_misc A Boolean indicating should the following items be removed from
#' the time series signature, default is TRUE.
#'   * iso$
#'   * xts$
#'   * hour
#'   * min
#'   * sec
#'   * am.pm
#' @param .step_ts_dummy A Boolean indicating if all_nominal_predictors() should
#' be dummied and with one hot encoding.
#' @param .step_ts_fourier A Boolean indicating if [timetk::step_fourier()] should
#' be added to the recipe.
#' @param .step_ts_fourier_period A number such as 365/12, 365/4 or 365 indicting
#' the period of the fourier term. The numeric period for the oscillation frequency.
#' @param .K The number of orders to include for each sine/cosine fourier series.
#' More orders increase the number of fourier terms and therefore the variance
#' of the fitted model at the expense of bias. See details for examples of K
#' specification.
#' @param .step_ts_yeo A Boolean indicating if the [recipes::step_YeoJohnson()] should
#' be added to the recipe.
#' @param .step_ts_nzv A Boolean indicating if the [recipes::step_nzv()] should be run
#' on all predictors.
#'
#' @examples
#' suppressPackageStartupMessages(library(dplyr))
#' suppressPackageStartupMessages(library(rsample))
#'
#' data_tbl <- ts_to_tbl(AirPassengers) %>%
#'   select(-index)
#'
#' splits <- initial_time_split(
#'  data_tbl
#'  , prop = 0.8
#' )
#'
#' ts_auto_recipe(
#'     .data = data_tbl
#'     , .date_col = date_col
#'     , .pred_col = value
#' )
#'
#' ts_auto_recipe(
#'   .data = training(splits)
#'   , .date_col = date_col
#'   , .pred_col = value
#' )
#'
#' @name ts_auto_recipe
NULL

#' @export
#' @rdname ts_auto_recipe

ts_auto_recipe <- function(.data
                           , .date_col
                           , .pred_col
                           , .step_ts_sig = TRUE
                           , .step_ts_rm_misc = TRUE
                           , .step_ts_dummy = TRUE
                           , .step_ts_fourier = TRUE
                           , .step_ts_fourier_period = 365/12
                           , .K = 1
                           , .step_ts_yeo = TRUE
                           , .step_ts_nzv = TRUE) {

    # * Tidyeval ----
    date_col_var_expr      <- rlang::enquo(.date_col)
    pred_col_var_expr      <- rlang::enquo(.pred_col)
    step_ts_sig            <- .step_ts_sig
    step_ts_rm_misc        <- .step_ts_rm_misc
    step_ts_dummy          <- .step_ts_dummy
    step_ts_fourier        <- .step_ts_fourier
    step_ts_fourier_k      <- .K
    step_ts_fourier_period <- .step_ts_fourier_period
    step_ts_yeo            <- .step_ts_yeo
    step_ts_nzv            <- .step_ts_nzv

    # * Checks ----
    if(!is.data.frame(.data)){
        stop(call. = FALSE, "You must supply a data.frame/tibble.")
    }

    if(rlang::quo_is_missing(date_col_var_expr)){
        stop(call. = FALSE, "The (.date_col) must be supplied.")
    }

    if(rlang::quo_is_missing(pred_col_var_expr)){
        stop(call. = FALSE, "The (.pred_col) must be supplied.")
    }

    # * Data ----
    data_tbl <- tibble::as_tibble(.data)

    data_tbl <- data_tbl %>%
        dplyr::select(
            {{ date_col_var_expr }}
            , {{ pred_col_var_expr }}
            , dplyr::everything()
        )

    # * Orignal Cols and formula ----
    ds <- rlang::sym(base::names(data_tbl)[[1]])
    v  <- rlang::sym(base::names(data_tbl)[[2]])
    f  <- stats::as.formula(base::paste(v, " ~ ."))

    # * Recipe Objects ----
    # ** Base recipe ----
    rec_base_obj <- recipes::recipe(
        formula = f
        , data = data_tbl
    )

    # * Add Steps ----
    # ** ts signature and normalize ----
    if(step_ts_sig){
        rec_date_obj <- rec_base_obj %>%
            timetk::step_timeseries_signature(ds) %>%
            recipes::step_normalize(
                dplyr::contains("index.num")
                , dplyr::contains("date_col_year")
            )
    }

    # ** Step rm ----
    if(step_ts_rm_misc){
        rec_date_obj <- rec_date_obj %>%
            recipes::step_rm(dplyr::matches("(iso$)|(xts$)|(hour)|(min)|(sec)|(am.pm)"))
    }

    # ** Step Dummy ----
    if(step_ts_dummy){
        rec_date_obj <- rec_date_obj %>%
            recipes::step_dummy(recipes::all_nominal_predictors(), one_hot = TRUE)
    }

    # ** Step Fourier ----
    if(step_ts_fourier){
        rec_date_fourier_obj <- rec_date_obj %>%
            timetk::step_fourier(
                ds
                , period = step_ts_fourier_period
                , K      = step_ts_fourier_k
            )
    }
    # ** Step YeoJohnson ----
    if(step_ts_yeo){
        rec_date_fourier_obj <- rec_date_fourier_obj %>%
            recipes::step_YeoJohnson(!!v, limits = c(0, 1))
    }

    # ** Step NZV ----
    if(step_ts_nzv){
        rec_date_fourier_nzv_obj <- rec_date_fourier_obj %>%
            recipes::step_nzv(recipes::all_predictors())
    }

    # * Recipe List ----
    rec_lst <- list(
        rec_base             = rec_base_obj,
        rec_date             = rec_date_obj,
        rec_date_fourier     = rec_date_fourier_obj,
        rec_date_fourier_nzv = rec_date_fourier_nzv_obj
    )

    # * Return ----
    return(rec_lst)

}

