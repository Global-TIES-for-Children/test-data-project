osfcache_get <- function(guid, cache_dir = here::here("osfcache"), create_cache_dir = TRUE, ...) {
  meta_dir <- file.path(cache_dir, "meta")
  asset_dir <- file.path(cache_dir, "assets")

  if (!dir.exists(meta_dir) || !dir.exists(asset_dir)) {
    if (!isTRUE(create_cache_dir)) {
      stop0("OSF cache directories not found. Set `create_cache_dir` to `TRUE` to automatically create them.")
    }

    dir.create(meta_dir, recursive = TRUE)
    dir.create(asset_dir, recursive = TRUE)
  }

  remote_file_meta <- tryCatch(
    osfr::osf_retrieve_file(guid),
    error = function(e) stop0(e$message)
  )

  if (!osfcache_is_outdated(guid, cache_dir = cache_dir, create_cache_dir = create_cache_dir)) {
    active_file_meta <- readRDS(file.path(meta_dir, guid))
  } else {
    active_file_meta <- osfcache_download(remote_file_meta, asset_dir, meta_dir, ...)
  }

  active_file_meta
}

osfcache_is_outdated <- function(guid, cache_dir = here::here("osfcache"), create_cache_dir = TRUE) {
  meta_dir <- file.path(cache_dir, "meta")
  asset_dir <- file.path(cache_dir, "assets")

  if (!dir.exists(meta_dir) || !dir.exists(asset_dir)) {
    if (!isTRUE(create_cache_dir)) {
      stop0("OSF cache directories not found. Set `create_cache_dir` to `TRUE` to automatically create them.")
    }

    dir.create(meta_dir, recursive = TRUE)
    dir.create(asset_dir, recursive = TRUE)
  }

  remote_file_meta <- tryCatch(
    osfr::osf_retrieve_file(guid),
    error = function(e) stop0(e$message)
  )

  if (file.exists(file.path(meta_dir, guid))) {
    cached_file_meta <- readRDS(file.path(meta_dir, guid))

    return(osf_last_updated(remote_file_meta) > osf_last_updated(cached_file_meta))
  }

  FALSE
}

osfcache_download <- function(osf_file_meta, asset_dir, meta_dir, ...) {
  file_meta <- osfr::osf_download(osf_file_meta, path = asset_dir, ...)
  saveRDS(file_meta, file = file.path(meta_dir, osf_guid(file_meta)))

  file_meta
}

osf_last_updated <- function(osf_tbl) {
  osf_tbl$meta[[1]]$attributes$date_modified
}

osf_guid <- function(osf_tbl) {
  osf_tbl$meta[[1]]$attributes$guid
}

osf_path <- function(osf_tbl) {
  osf_tbl$local_path
}
