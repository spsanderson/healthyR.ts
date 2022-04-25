#' Misc for boilerplate
#' @keywords internal
#' @export
get_recipe_call <- function(.rec_call){
    cl <- .rec_call
    cl$tune <- NULL
    cl$verbose <- NULL
    cl$colors <- NULL
    cl$prefix <- NULL
    rec_cl <- cl
    rec_cl[[1]] <- rlang::expr(recipe)
    rec_cl
}

#' Misc for boilerplat
#' @keywords internal
#' @export
assign_value <- function(name, value, cr = TRUE) {
    value <- rlang::enexpr(value)
    value <- rlang::expr_text(value, width = 74L)
    chr_assign(name, value, cr)
}

#' Misc for boilerplate
#' @keywords internal
#' @export
chr_assign <- function(name, value, cr = TRUE) {
    name <- paste(name, "<-")
    if (cr) {
        res <- c(name, paste0("\n  ", value))
    } else {
        res <- paste(name, value)
    }
    res
}
