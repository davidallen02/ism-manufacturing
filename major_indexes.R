library(magrittr)

headline <- pamngr::get_data("napmnmi")
production <- pamngr::get_data("napmprod")
new_orders <- pamngr::get_data("napmnewo")
deliveries <- pamngr::get_data("napmsupl")

ism_manuf <- headline %>%
  dplyr::left_join(production, by = "Dates") %>%
  dplyr::left_join(new_orders, by = "Dates") %>%
  dplyr::left_join(deliveries, by = "Dates") %>%
  set_colnames(c("Dates", "Headline", "Production","New Orders", "Supplier Deliveries")) %>%
  reshape2::melt(id.vars = "Dates") %>%
  dplyr::group_by(variable) %>%
  dplyr::slice_max(Dates, n = 60)

p <- ism_manuf %>%
  ggplot2::ggplot(ggplot2::aes(Dates, value, color = variable)) +
  ggplot2::geom_line(size = 2) +
  ggplot2::facet_wrap(. ~ variable, nrow = 2) +
  ggplot2::scale_color_manual(values = c("#850237", "black","blue","red")) +
  ggplot2::labs(title = "ISM Manufacturing Index") +
  ggplot2::theme(
    plot.title = ggplot2::element_text(face = "bold", size = ggplot2::rel(3.25)),
    legend.title = ggplot2::element_blank(),
    legend.text = ggplot2::element_text(size = ggplot2::rel(1.5)),
    legend.position = "none",
    axis.title = ggplot2::element_blank(),
    axis.text = ggplot2::element_text(size = ggplot2::rel(1.5)),
    strip.text = ggplot2::element_text(size = ggplot2::rel(1.5), color = "white"),
    strip.background = ggplot2::element_rect(fill = "#850237")
  )

ggplot2::ggsave(
  filename = "./output/ppt/major-indexes.png",
  plot     = p,
  width    = 13.33,
  height   = 7.5,
  units    = 'in'
)