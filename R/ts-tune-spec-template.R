#' Time Series Model Spec Template
#'
#' @family Helper
#' @family Model Tuning
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description
#' This function will create a generic tuneable model specification, this function
#' can be used by itself and is called internally by [healthyR.ts::ts_model_auto_tune()].
#'
#' @details
#' This function takes in a single parameter and uses that to output a generic
#' tuneable model specification. This function can work with the following
#' parsnip/modeltime engines:
#' -  "auto_arima"
#' -  "auto_arima_xgboost"
#' -  "ets"
#' -  "croston"
#' -  "theta"
#' -  "smooth_es"
#' -  "stlm_ets"
#' -  "tbats"
#' -  "stlm_arima"
#' -  "nnetar"
#' -  "prophet"
#' -  "prophet_xgboost"
#' -  "lm"
#' -  "glmnet"
#' -  "stan"
#' -  "spark"
#' -  "keras"
#' -  "earth"
#' -  "xgboost"
#'
#' @param .parsnip_engine The model engine that is used by [parsnip::set_engine()].
#'
#' @examples
#' ts_model_spec_tune_template("ets")
#' ts_model_spec_tune_template("prophet")
#'
#' @return
#' A tuneable parsnip model specification.
#'
#' @export
#'

ts_model_spec_tune_template <- function(.parsnip_engine = NULL){


    # * Tidyeval ----
    pe <- base::as.character(.parsnip_engine)

    # * Checks ----
    if(!pe %in% c("auto_arima","auto_arima_xgboost",
                  "ets","croston","theta","smooth_es",
                  "stlm_ets","tbats","stlm_arima",
                  "nnetar",
                  "prophet","prophet_xgboost",
                  "lm","glmnet","stan","spark","keras",
                  "earth","xgboost")){
        stop(call. = FALSE, base::paste0("The parameter (.parsnip_engine) value of: ", pe, ", is not supported."))
    }

    if(pe %in% c("auto_arima","stlm_ets","tbats","stlm_arima")){
        stop(call. = FALSE, base::paste0("The parameter (.parsnip_engine) value of: ", pe, ", is an auto tuned model spec already."))
    }

    if(pe %in% c("lm")){
        stop(call. = FALSE, base::paste0("The parameter (.parsnip_engine) value of: ", pe, ", has no tuning parameters."))
    }

    # * Model Spec Tuner ----
    if (pe == "auto_arima_xgboost"){
        mst <- modeltime::arima_boost(
            trees            = tune::tune()
            , min_n          = tune::tune()
            , tree_depth     = tune::tune()
            , learn_rate     = tune::tune()
            , loss_reduction = tune::tune()
            , stop_iter      = tune::tune()
        ) %>%
            parsnip::set_engine(pe)
    } else if (pe == "ets"){
        mst <- modeltime::exp_smoothing(
            seasonal_period = "auto"
            , error         = "auto"
            , trend         = "auto"
            , season        = "auto"
            , damping       = "auto"
            , smooth_level    = tune::tune()
            , smooth_trend    = tune::tune()
            , smooth_seasonal = tune::tune()
        ) %>%
            parsnip::set_engine(pe)
    } else if (pe == "croston"){
        mst <- modeltime::exp_smoothing(
            seasonal_period = "auto"
            , smooth_level    = tune::tune()
        ) %>%
            parsnip::set_engine(pe)
    } else if (pe == "theta"){
        mst <- modeltime::exp_smoothing(
            seasonal_period = "auto"
        ) %>%
            parsnip::set_engine(pe)
    } else if (pe == "smooth_es"){
        mst <- modeltime::exp_smoothing(
            mode            = "regression",
            seasonal_period = seasonal_period,
            error           = error,
            trend           = trend,
            season          = season,
            damping         = damping,
            smooth_level    = smooth_level,
            smooth_trend    = smooth_trend,
            smooth_seasonal = smooth_seasonal
        ) %>%
            parsnip::set_engine(pe)
    } else if (pe == "nnetar"){
        mst <- modeltime::nnetar_reg(
            seasonal_period   = "auto"
            , non_seasonal_ar = tune::tune()
            , seasonal_ar     = tune::tune()
            , hidden_units    = tune::tune()
            , num_networks    = tune::tune()
            , penalty         = tune::tune()
            , epochs          = tune::tune()
        ) %>%
            parsnip::set_engine(pe)
    } else if (pe == "prophet"){
        mst <- modeltime::prophet_reg(
            changepoint_num      = tune::tune()
            , changepoint_range  = tune::tune()
            , seasonality_yearly = "auto"
            , seasonality_weekly = "auto"
            , seasonality_daily  = "auto"
            , prior_scale_changepoints = tune::tune()
            , prior_scale_seasonality  = tune::tune()
            , prior_scale_holidays     = tune::tune()
        ) %>%
            parsnip::set_engine(pe)
    } else if (pe == "prophet_xgboost"){
        mst <- modeltime::prophet_boost(
            changepoint_num      = tune::tune()
            , changepoint_range  = tune::tune()
            , seasonality_yearly = FALSE
            , seasonality_weekly = FALSE
            , seasonality_daily  = FALSE
            , prior_scale_changepoints = tune::tune()
            , prior_scale_seasonality  = tune::tune()
            , prior_scale_holidays     = tune::tune()
            , trees                    = tune::tune()
            , min_n                    = tune::tune()
            , tree_depth               = tune::tune()
            , learn_rate               = tune::tune()
            , loss_reduction           = tune::tune()
            , stop_iter                = tune::tune()
        ) %>%
            parsnip::set_engine(pe)
    } else if (pe == "glmnet") {
        mst <- parsnip::linear_reg(
            penalty   = tune::tune()
            , mixture = tune::tune()
        ) %>%
            parsnip::set_engine(pe)
    } else if (pe == "stan"){
        mst <- parsnip::linear_reg() %>%
            parsnip::set_engine(
                engine   = pe
                , chains = tune::tune()
                , iter   = tune::tune()
                , seed   = 123
            )
    } else if (pe == "spark"){
        mst <- parsnip::linear_reg(
            penalty   = tune::tune()
            , mixture = tune::tune()
        ) %>%
            parsnip::set_engine(pe)
    } else if (pe == "keras"){
        mst <- parsnip::linear_reg(
            penalty   = tune::tune()
            , mixture = tune::tune()
        ) %>%
            parsnip::set_engine(pe)
    } else if (pe == "earth"){
        mst <- parsnip::mars(
            num_terms = tune::tune()
            , prod_degree = tune::tune()
        ) %>%
            parsnip::set_engine(pe)
    } else if (pe == "xgboost"){
        mst <- parsnip::boost_tree(
            trees          = tune::tune()
            , min_n          = tune::tune()
            , tree_depth     = tune::tune()
            , learn_rate     = tune::tune()
            , loss_reduction = tune::tune()
        ) %>%
            parsnip::set_engine(pe)
    }

    # * Return ----
    return(mst)


}
