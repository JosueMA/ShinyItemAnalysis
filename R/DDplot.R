#' Graphical representation of difficulty and discrimination in item analysis
#'
#' @aliases DDplot
#'
#' @description Plots difficulty and discrimination for items ordered by difficulty
#' @param data numeric: binary data matrix or data frame. See \strong{Details}.
#' @usage DDplot(data)
#' @details
#' The \code{data} is a matrix or data frame whose rows represents examinee answers ("1" correct, "0" incorrect) and columns correspond to the items. The \code{group} must be a vector of the same length as \code{nrow(data)}.
#' @author
#' Adela Drabinova \cr
#' Institute of Computer Science, The Czech Academy of Sciences \cr
#' Faculty of Mathematics and Physics, Charles University \cr
#' adela.drabinova@gmail.com \cr
#'
#' Patricia Martinkova \cr
#' Institute of Computer Science, The Czech Academy of Sciences \cr
#' martinkova@cs.cas.cz \cr
#' @examples
#' \dontrun{
#' # loading data based on GMAT
#' data(GMAT, package = "difNLR")
#' data  <- GMAT[, colnames(GMAT) != "group"]
#'
#' # Difficulty/Discrimination plot
#' DDplot(data)
#' }
#' @export


DDplot <- function(data){
  if (is.matrix(data) | is.data.frame(data)) {
    if (!all(apply(data, 2, function(i) {
      length(levels(as.factor(i))) == 2
    })))
      stop("'data' must be data frame or matrix of binary vectors",
           call. = FALSE)
  }
  else {
    stop("'data' must be data frame or matrix of binary vectors",
         call. = FALSE)
  }

  # difficulty and discrimination
  difc <- psychometric::item.exam(data, discr = T)[, "Difficulty"]
  disc <- psychometric::item.exam(data, discr = T)[, "Discrimination"]
  value <- c(rbind(difc, disc)[, order(difc)])
  parameter <- rep(c("Difficulty", "Discrimination"), ncol(data))
  # ordered by difficulty
  item <- factor(rep(order(difc), rep(2, ncol(data))),
                 levels = factor(order(difc)))
  df <- data.frame(item, parameter, value)

  # plot
  col <- c("red", "darkblue")
  ggplot(df,
         aes_string(x = "item", y = "value", fill = "parameter", color = "parameter")) +
    stat_summary(fun.y = mean,
                 position = position_dodge(),
                 geom = "bar",
                 alpha = 0.7,
                 width = 0.8) +
    geom_hline(yintercept = 0.2) +
    xlab("Item Number (Ordered by Difficulty)") +
    ylab("Difficulty/Discrimination") +
    scale_y_continuous(expand = c(0, 0), limits = c(0, 1)) +
    scale_fill_manual(breaks = parameter,
                      values = col) +
    scale_colour_manual(breaks = parameter,
                        values = col) +
    theme_bw() +
    theme(axis.line  = element_line(colour = "black"),
          text = element_text(size = 14),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background = element_blank(),
          legend.title = element_blank(),
          legend.position = c(0, 1),
          legend.justification = c(0, 1),
          legend.background = element_blank(),
          legend.key = element_rect(colour = "white"))
}
