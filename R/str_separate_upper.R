#' Modify string from 'AaBbbCc' to 'aa_bbb_cc'
#'
#' @param string a string.
#' @param sep a string.
#' @param to_lower logical.
#'
#' @return a string
#' @export
#'
str_separate_upper <- function(string, sep = '_', to_lower = TRUE){
  x_split <- stringr::str_split(string , "") %>% unlist()
  x_upper <- x_split %>% stringr::str_detect("^[:upper:]+$")
  x_pos <- which((x_upper - lag(x_upper)) == 1)
  x_split[x_pos] <- paste0(sep, x_split[x_pos])
  x_out <- paste0(x_split, collapse = "")
  if(to_lower){
    return(stringr::str_to_lower(x_out))
  }
  x_out
}
