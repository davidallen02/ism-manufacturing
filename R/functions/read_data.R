read_data <- function(index_name){
  dat <- readxl::read_xlsx(
    path      = paste0('./data/', index_name, '.xlsx'), 
    skip      = 5, 
    # col_types = c('date', 'numeric'),
    na        = '#N/A N/A'
  ) %>%
    set_colnames(c('date', index_name))
  
  return(dat)
}