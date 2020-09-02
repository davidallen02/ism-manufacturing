library(magrittr)

dat <- pamngr::join_sheets(c("napmnmi","napmprod","napmnewo","napmempl")) %>%
  magrittr::set_colnames(c(
    "dates", "Headline", "Production","New Orders", "Employment"
    )) %>%
  reshape2::melt(id.vars = "dates") %>%
  dplyr::slice_max(dates, n = 60) 
p <- dat %>% 
  pamngr::lineplot() %>%
  pamngr::pam_plot(plot_title = "ISM Manufacturing Index")

p <- p + 
  ggplot2::geom_hline(yintercept = 50, color = "black") +
  ggplot2::facet_wrap(. ~ variable, nrow = 2) 

p %>% pamngr::all_output("major-indexes")
