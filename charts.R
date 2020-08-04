## Employment subindex
pamngr::get_data("napmempl") %>% 
  reshape2::melt(id.vars = "dates") %>% 
  pamngr::lineplot() %>%
  pamngr::pam.plot(
    plot.title = "ISM Manufacturing Employment Subindex",
    show.legend = FALSE
  ) %>%
  pamngr::ppt_output("employment.png")
