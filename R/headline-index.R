library(magrittr)

dat <- readxl::read_xlsx(
  path      = './data/headline-index.xlsx', 
  skip      = 5, 
  col_types = c('date', 'numeric'),
  na        = '#N/A N/A'
) %>%
  tidyr::drop_na() %>%
  dplyr::filter(Dates >= '2000-01-01') %>%
  reshape2::melt(id.vars = 'Dates') 

p <- ggplot2::ggplot(
  data = dat,
  ggplot2::aes(x = Dates, y = value)
) +
  ggplot2::geom_hline(yintercept = 50) +
  ggplot2::geom_line(color = '#850237') +
  ggplot2::labs(
    title = 'ISM Manufacturing Index',
    caption = paste('Current as of', Sys.Date() %>% format('%m/%d/%Y'))
  ) +
  ggplot2::theme_bw() +
  ggplot2::theme(
    plot.title   = ggplot2::element_text(face = 'bold', size = ggplot2::rel(2)),
    axis.title   = ggplot2::element_blank(),
    axis.text    = ggplot2::element_text(size = ggplot2::rel(1.5)),
    plot.caption = ggplot2::element_text(size = ggplot2::rel(1))
  )

ggplot2::ggsave(
  filename = './output/ppt/headline-index.png',
  plot = p,
  width = 13.33,
  height = 7.5,
  units = 'in'
)
