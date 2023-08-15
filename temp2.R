library(tidyverse)
library(adintelr)
library(fdutils)
library(glue)

tbl_list <- adintel_list() %>% str_remove_all("public.")
media_layout <- read_csv("media_layout.csv", col_types = cols(media_type_id = col_integer())) %>% 
  filter(old_table %in% tbl_list,
         new_table %notin% tbl_list,
         new_table != old_table)

i=1
for(i in seq_along(media_layout$new_table)){
  
  new_table <- media_layout$new_table[[i]]
  old_table <- media_layout$old_table[[i]]
  media_type_id <- media_layout$media_type_id[[i]]
  
  query <- glue('CREATE TABLE {new_table} AS SELECT * FROM {old_table} WHERE "MediaTypeID" = {media_type_id}')
  
  print(
    glue(
      "
      
      {query} ({new_table})"
    )
  )

  init_time <- Sys.time()
  print(init_time)
  
  adintel_execute(query = query)

  end_time <- Sys.time()
  elapsed <- end_time - init_time
  
  print(
    elapsed
  )
}


