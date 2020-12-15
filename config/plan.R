the_plan <- drake_plan(
  raw_mtcars = target(
    command = {
      meta <- osfcache_get("8krjy", conflicts = "overwrite")

      fread(here::here(osf_path(meta)))
    },
    trigger = trigger(
      condition = osfcache_is_outdated("8krjy")
    )
  ),

  summarized_mtcars = 
    as_dt(raw_mtcars) %>% 
    summarize.(
      avg_mpg = mean(mpg),
      sd_mpg = sd(mpg),
      count = n.(),
      by = cyl
    ) %>%
    as.data.frame(),

  upload_summarized = target(
    command = {
      sum_file_path <- file.path(tempdir(), "summarized_mtcars.csv")
      sum_file <- fwrite(summarized_mtcars, file = sum_file_path)
  
      if (isTRUE(F_OSF_UPLOAD)) {
        osfr::osf_retrieve_node("dbpy9") %>% 
          osfr::osf_upload(sum_file_path, conflicts = "overwrite")
      }
    },
    trigger = trigger(
      condition = isTRUE(F_OSF_UPLOAD),
      mode = "condition"
    )
  )
)
