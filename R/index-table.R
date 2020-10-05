dat <- pamngr::join_sheets(c("napmpmi",
                             "napmnewo",
                             "napmprod",
                             "napmempl",
                             "napmsupl",
                             "napminv",
                             "napmcinv",
                             "napmpric",
                             "napmback",
                             "napmexpt",
                             "napmimpt")) %>%
  dplyr::slice_max(dates, n = 12) %>%
  dplyr::arrange(dates) %>%
  dplyr::mutate(dates = dates %>% format("%b %Y")) %>%
  tidyr::pivot_longer(cols = -dates, names_to = "security") %>%
  tidyr::pivot_wider(names_from = dates)

key <- readRDS("./data/key.RDS") %>%
  dplyr::mutate(Index = LONG_COMP_NAME %>% 
                  stringr::str_remove_all("ISM Manufacturing") %>%
                  stringr::str_remove_all("Report on Business") %>%
                  stringr::str_remove_all(" SA") %>%
                  stringr::str_remove_all(" NSA") %>%
                  stringr::str_trim()) %>%
  dplyr::select(security, Index)

dat <- dat %>% 
  dplyr::left_join(key, by = "security") %>%
  dplyr::mutate(security = Index) %>%
  dplyr::select(-Index)

periods_shown <- names(dat)[-1]

t <- dat %>% 
  gt::gt() %>%
  gt::cols_label(security = "Index") %>%
  gt::data_color(
    columns  = dplyr::vars(periods_shown),
    colors = scales::col_numeric(
      palette = as.character(paletteer::paletteer_c("ggthemes::Red-Green Diverging", n = 40)),
      domain = c(20,80))
  ) %>%
  gt::tab_header(title = gt::md("**ISM Manufacturing Indexes**")) %>%
  gt::tab_style(
    style = list(gt::cell_text(align = "left")),
    locations = list(gt::cells_title(groups = "title"))
  ) %>%
  gt::tab_style(
    style = list(gt::cell_text(align = "center", v_align = "middle")),
    locations = list(gt::cells_column_labels(gt::everything()),
                     gt::cells_body())
  ) %>%
  gt::tab_style(
    style = list(gt::cell_text(align = "left")),
    locations = list(gt::cells_column_labels(columns = gt::vars(security)),
                     gt::cells_body(columns = gt::vars(security)))
  ) %>%
  gt::tab_style(
    style = list(gt::cell_borders(sides = "bottom", color = "black", weight = gt::px(3))),
    locations = list(gt::cells_column_labels(gt::everything()))
  )

t 

t %>% gt::gtsave("output/tables/index-table.png")