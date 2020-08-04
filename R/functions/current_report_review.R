library(magrittr)

source("./R/functions/read_data.R")
source("./R/functions/ppt_output.R")

dat <- read_data('pmi_with_consensus') %>%
  set_colnames(c('date','pmi','consensus'))

current <- dat %>%
  dplyr::filter(date == max(date)) 

current.value <- current %>%
  dplyr::select(pmi) %>%
  dplyr::pull() 

current.period <- current %>%
  dplyr::select(date) %>%
  dplyr::pull() %>%
  format('%B\n%Y')


previous <- dat %>%
  dplyr::filter(date != max(date)) %>%
  dplyr::filter(date == max(date)) 

previous.value <- previous %>%
  dplyr::select(pmi) %>%
  dplyr::pull() 

previous.period <- previous %>%
  dplyr::select(date) %>%
  dplyr::pull() %>%
  format('%B %Y')

change <- (current.value - previous.value)

consensus <- dat %>%
  dplyr::filter(date == max(date)) %>%
  dplyr::select(consensus) %>%
  dplyr::pull() %>%
  format(nsmall = 1)

if(change < 0){
  change <- change %>% format(nsmall = 1)
  change.col <- 'red'
} else{
  if(change > 0){
    change <- change %>% format(nsmall = 1) %>% paste0('+', .)
    change.col <- 'forestgreen'
  } else{
    change <- 'unch'
    change.col <- 'black'
  }
}
title <- 'ISM Manufacturing' %>% grid::textGrob(
  gp = grid::gpar(fontsize = 50,
                  fontface = 'bold')
)

subtitle.1 <- current.period %>% 
  grid::textGrob(gp = grid::gpar(fontsize = 30),
                 just = 'top')
subtitle.2 <- paste0('Change from\n', previous.period) %>% 
  grid::textGrob(gp = grid::gpar(fontsize = 30),
                 just = 'top')
subtitle.3 <- 'Consensus\nEstimate' %>% 
  grid::textGrob(gp = grid::gpar(fontsize = 30),
                 just = 'top')

current.value <- current.value %>% 
  grid::textGrob(gp = grid::gpar(fontsize = 40),
                 just = 'bottom')

change <- change %>% 
  grid::textGrob(gp = grid::gpar(fontsize = 40, col = change.col),
                 just = 'bottom')

consensus <- consensus %>%
  grid::textGrob(gp = grid::gpar(fontsize = 40),
                 just = 'bottom')
blank <- grid::textGrob(' ')

lay <- rbind(c(1,1,1),
             c(2,3,4),
             c(5,6,7),
             c(8,8,8))
gridExtra::grid.arrange(title, 
                        subtitle.1, subtitle.2, subtitle.3, 
                        current.value, change, consensus,
                        blank,
                        layout_matrix = lay) %>% 
  pamngr::ppt_output('current_report_review.png')


