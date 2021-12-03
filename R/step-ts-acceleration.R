#' Recipes Time Series Acceleration Generator
#'
#' @family Recipes
#'
#' @description
#' `step_ts_acceleration` creates a a *specification* of a recipe
#'  step that will convert numeric data into from a time series into its
#'  acceleration.
#'
#' @param recipe A recipe object. The step will be added to the
#'  sequence of operations for this recipe.
#' @param ... One or more selector functions to choose which
#'  variables that will be used to create the new variables. The
#'  selected variables should have class `numeric`
#' @param trained A logical to indicate if the quantities for
#'  preprocessing have been estimated.
#' @param role For model terms created by this step, what analysis
#'  role should they be assigned?. By default, the function assumes
#'  that the new variable columns created by the original variables
#'  will be used as predictors in a model.
#' @param columns A character string of variables that will be
#'  used as inputs. This field is a placeholder and will be
#'  populated once `recipes::prep()` is used.
#' @param skip A logical. Should the step be skipped when the recipe is
#'  baked by bake.recipe()? While all operations are baked when prep.recipe()
#'  is run, some operations may not be able to be conducted on new data
#'  (e.g. processing the outcome variable(s)). Care should be taken when
#'  using skip = TRUE as it may affect the computations for subsequent operations.
#' @param id A character string that is unique to this step to identify it.
#'
#' @return For `step_ts_acceleration`, an updated version of recipe with
#'  the new step added to the sequence of existing steps (if any).
#'
#'  Main Recipe Functions:
#'  - `recipes::recipe()`
#'  - `recipes::prep()`
#'  - `recipes::bake()`
#'
#'
#' @details
#'
#' __Numeric Variables__
#'  Unlike other steps, `step_ts_acceleration` does *not*
#'  remove the original numeric variables. [recipes::step_rm()] can be
#'  used for this purpose.
#'
#' @examples
#' suppressPackageStartupMessages(library(dplyr))
#' suppressPackageStartupMessages(library(recipes))
#'
#' len_out    = 10
#' by_unit    = "month"
#' start_date = as.Date("2021-01-01")
#'
#' data_tbl <- tibble(
#'   date_col = seq.Date(from = start_date, length.out = len_out, by = by_unit),
#'   a    = rnorm(len_out),
#'   b    = runif(len_out)
#' )
#'
#' # Create a recipe object
#' rec_obj <- recipe(a ~ ., data = data_tbl) %>%
#'   step_ts_acceleration(b)
#'
#' # View the recipe object
#' rec_obj
#'
#' # Prepare the recipe object
#' prep(rec_obj)
#'
#' # Bake the recipe object - Adds the Time Series Signature
#' bake(prep(rec_obj), data_tbl)
#'
#' rec_obj %>% get_juiced_data()
#'
#' @export
#'
#' @importFrom recipes prep bake rand_id

step_ts_acceleration <- function(recipe,
                                ...,
                                role       = "predictor",
                                trained    = FALSE,
                                columns    = NULL,
                                skip       = FALSE,
                                id         = rand_id("ts_acceleration")
){

    terms <- recipes::ellipse_check(...)

    recipes::add_step(
        recipe,
        step_ts_acceleration_new(
            terms      = terms,
            role       = role,
            trained    = trained,
            columns    = columns,
            skip       = skip,
            id         = id
        )
    )
}

step_ts_acceleration_new <-
    function(terms, role, trained, columns, skip, id){

        recipes::step(
            subclass   = "ts_acceleration",
            terms      = terms,
            role       = role,
            trained    = trained,
            columns    = columns,
            skip       = skip,
            id         = id
        )

    }

#' @export
prep.step_ts_acceleration <- function(x, training, info = NULL, ...) {

    col_names <- recipes::recipes_eval_select(x$terms, training, info)

    value_data <- info[info$variable %in% col_names, ]

    if(any(value_data$type != "numeric")){
        rlang::abort(
            paste0("All variables for `step_hai_hyperbolic` must be `numeric`",
                   "`integer` `double` classes.")
        )
    }

    step_ts_acceleration_new(
        terms      = x$terms,
        role       = x$role,
        trained    = TRUE,
        columns    = col_names,
        skip       = x$skip,
        id         = x$id
    )

}

#' @export
bake.step_ts_acceleration <- function(object, new_data, ...){

    make_call <- function(col, scale_type){
        rlang::call2(
            "ts_acceleration_vec",
            .x            = rlang::sym(col)
            , .ns         = "healthyR.ts"
        )
    }

    grid <- expand.grid(
        col                = object$columns
        , stringsAsFactors = FALSE
    )

    calls <- purrr::pmap(.l = list(grid$col), make_call)

    # Column Names
    newname <- paste0("acceleration_", grid$col)
    calls   <- recipes::check_name(calls, new_data, object, newname, TRUE)

    tibble::as_tibble(dplyr::mutate(new_data, !!!calls))

}

#' @export
print.step_ts_acceleration <-
    function(x, width = max(20, options()$width - 35), ...) {
        cat("Time Series Acceleration transformation on ", sep = "")
        printer(
            # Names before prep (could be selectors)
            untr_obj = x$terms,
            # Names after prep:
            tr_obj = names(x$columns),
            # Has it been prepped?
            trained = x$trained,
            # An estimate of how many characters to print on a line:
            width = width
        )
        invisible(x)
    }

#' Requited Packages
#' @rdname required_pkgs.healthyR.ts
#' @keywords internal
#' @return A character vector
#' @param x A recipe step
# @noRd
#' @export
required_pkgs.step_ts_acceleration <- function(x, ...) {
    c("healthyR.ts")
}
