library(magrittr)

dat <- pamngr::get_data("napmpmi") %>%
  tidyr::pivot_longer(cols = -dates, names_to = "variable") %>%
  dplyr::slice_max(dates, n = 60)

p <- dat %>%
  pamngr::lineplot() %>%
  pamngr::pam_plot(
    plot_title = "ISM Manufacturing PMI",
    show_legend = FALSE
  )

p %>% pamngr::all_output("headline")
