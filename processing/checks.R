get_dims <- function(df) dim(df) %>% {data.frame(rows = .[[1]], cols = .[[2]])}

get_types <- function(df){
  df %>% 
    lapply(class) %>% unlist %>% 
    {split(., .)} %>% lapply(length) %>% 
    as.data.frame()
}