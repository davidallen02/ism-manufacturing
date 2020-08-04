source('./R/functions/read_data.R')
source('./R/functions/solo.R')
source('./R/functions/duet.R')
source('./R/functions/trio.R')
source('./R/functions/quartet.R')
source('./R/functions/ppt_output.R')


# PMI - headline index --------------------------------------------------------------

solo('pmi', 'ISM Manufacturing PMI') %>% ppt_output('pmi')




# Production, New Orders, and Employment subindexes ---------------------------------

trio('production','new_orders','employment', 'ISM Manufacturing', ncols = 1) %>%
  ppt_output('subindexes')
   