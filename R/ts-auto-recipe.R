#' Build a Time Series Recipe
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description Automatically builds generic time series recipe objects from a given
#' recipe.
#'
#' @details
#' This will build out a couple of generic recipe objects and return those items
#' in a list. It is required to pass a recipe object to this function.
#'
#' @param .data The data that is going to be modeled. You must supply a tibble.
#' @param .date_col The column that holds the date for the time series. This must be
#' in quotes like "date_col"
#' @param .pred_col The column that is to be predicted.
#'
#' @examples
#'
#' @export
#'

ts_auto_recipe <- function(.rec_obj
                           , .date_col
                           , .step_ts_sig = TRUE
                           , .step_rm_misc = TRUE) {

    # * Tidy'ish ----
    date_col     <- .date_col
    step_ts_sig  <- .step_ts_sig

    # * Checks ----
    if(class(.rec_obj) != "recipe"){
        stop(call. = FALSE, "You must supply an object of class recipe.")
    }

    if(!is.character(date_col)){
        stop(call. = FALSE, "The (.date_col) column must be in quotes, a character string.")
    }

    # * Recipe Objects ----
    # Base recipe
    rec_base_obj <- .rec_obj

    # * Add Steps ----
    if(isTRUE(step_ts_sig)){
        rec_date_obj <- rec_base_obj %>%
            timetk::step_timeseries_signature(date_col)
    }

    # * Recipe List Obj ----
    rec_obj_lst <- list(
        rec_base_obj   = rec_base_obj
        , rec_date_obj = rec_date_obj
    )

    # * Step rm --- needs it's own function

    # * Return ----
    return(rec_obj_lst)

}

ts_auto_recipe(
    .rec_obj = rec_obj
    , .date_col = "visit_end_date_time"
    , .step_ts_sig = TRUE
)
