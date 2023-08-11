## code to prepare `loader_tbl` dataset goes here
loader_list <- loader_list
loader_tbl <- purrr::list_rbind(
  purrr::map(
    .x = loader_list,
    .f = ~ tibble::tibble(
      .x$filetype,
      .x$file,
      .x$table,
      list(.x$col_names),
      list(.x$col_types)
    )
  )
)
names(loader_tbl) <- names(loader_list[[1]])

usethis::use_data(loader_tbl, overwrite = TRUE)
