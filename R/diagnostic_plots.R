#' Get Random Walk `ggplot2` layers
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description
#' Get layers to add to a `ggplot` graph from the [ts_random_walk()] function.
#'
#' @details
#' - Set the intercept of the initial value from the random walk
#' - Set the max and min of the cumulative sum of teh random walks
#'
#' @examples
#' library(ggplot2)
#'
#' df <- ts_random_walk()
#'
#' df %>%
#'   ggplot(
#'     mapping = aes(
#'       x = x
#'       , y = cum_y
#'       , color = factor(run)
#'       , group = factor(run)
#'    )
#'  ) +
#'  geom_line(alpha = 0.8) +
#'  get_gg_layers(df)
#'
#' @return
#' A `ggplot2` layers object
#'
#' @export
#'

# Function for obtaining ggplot layers to commonly apply to subsequent plots
get_gg_layers <- function(df) {
    gg_layers <- list(
        ggplot2::geom_hline(
            yintercept = attr(df, ".initial_value"),
            color = "black", linetype = "dotted"
        ),
        ggplot2::geom_hline(
            yintercept = max(subset(df, x == max(x))$cum_y),
            color = "steelblue", linetype = "dashed"
        ),
        ggplot2::geom_hline(
            yintercept = min(subset(df, x == max(x))$cum_y),
            color = "firebrick", linetype = "dashed"
        ),
        ggplot2::annotate(
            geom = "label",
            x = max(df$x), y = max(subset(df, x == max(x))$cum_y),
            label = prettyNum(round(max(subset(df, x == max(x))$cum_y), 0), big.mark = ","),
            size = 3, hjust = 1, color = "white", fill = "steelblue"
        ),
        ggplot2::annotate(
            geom = "label",
            x = max(df$x), y = min(subset(df, x == max(x))$cum_y),
            label = prettyNum(round(min(subset(df, x == max(x))$cum_y), 0), big.mark = ","),
            size = 3, hjust = 1, color = "white", fill = "firebrick"
        ),
        ggplot2::labs(
            title = "Random Walk Simulation",
            subtitle = paste(
                attr(df, ".num_walks"), "Random walks with",
                paste0("an initial value of: ", prettyNum(attr(df, ".initial_value"), big.mark = ",")),
                "and", paste0(round(attr(df, ".sd") * 100, 0), "%"),
                "volatility"
            ),
            x = "Days into future", y = "Value"
        ),
        tidyquant::scale_colour_tq(),
        tidyquant::scale_fill_tq(),
        tidyquant::theme_tq(),
        ggplot2::theme(legend.position = "none")
    )
    return(gg_layers)
}
