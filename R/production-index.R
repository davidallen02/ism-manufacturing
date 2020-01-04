library(magrittr)

dat <- readxl::read_xlsx(
  path      = './data/production-index.xlsx', 
  skip      = 5, 
  col_types = c('date', 'numeric'),
  na        = '#N/A N/A'
)