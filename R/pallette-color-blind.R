#' Provide Colorblind Compliant Colors
#'
#' @family Color_Blind
#'
#' 8 Hex RGB color definitions suitable for charts for colorblind people.
#'
#' @export
color_blind <- function(){
    c("#000000", "#E69F00", "#56B4E9",
      "#009E73", "#F0E442", "#0072B2",
      "#D55E00", "#CC79A7")
}

#' Provide Colorblind Compliant Colors
#'
#' @family Color_Bline
#'
#' @export
ts_scale_fill_colorblind <- function(..., theme = "ts") {

    pal <- switch(theme,
                  "ts" = unname(color_blind()) %>% rep(100)
    )

    ggplot2::scale_fill_manual(values = pal)
}

#' Provide Colorblind Compliant Colors
#'
#' @format Color_Blind
#'
#' @export
ts_scale_color_colorblind = function(..., theme = "ts") {

    pal <- switch(theme,
                  "ts" = unname(color_blind()) %>% rep(100)
    )

    ggplot2::scale_color_manual(values = pal)
}
