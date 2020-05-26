the_plan <- drake_plan(
  raw_mtcars = target(
    command = {
      meta <- osfcache_get("8krjy")

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
      sd_mpg = sd(mpg)
    ) %>%
    as.data.frame(),

  upload_summarized = {
    sum_file_path <- file.path(tempdir(), "summarized_mtcars.csv")
    sum_file <- fwrite(summarized_mtcars, file = sum_file_path)

    osfr::osf_retrieve_node("dbpy9") %>% 
      osfr::osf_upload(sum_file_path)
  }
)
