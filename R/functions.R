#' Retrieve an object from the OSF cache
#' 
#' By default, objects downloaded from OSF will be stored in the "osfcache"
#' folder. In that folder there are two folders: "meta" and "assets".
#' The "meta" stores serialized `osfr` metadata objects, and the
#' "assets" folder keeps the downloads themselves. If the requested object
#' doesn't exist in the cache or is outdated, the most recently updated
#' object will be downloaded.
#' 
#' @param guid The GUID on OSF for the desired object.
#' @param cache_dir The OSF cache location. Defaults to `here::here("osfcache")`
#' @param create_cache_dir Create the cache directories if they don't exist. Defaults to `TRUE`
#' @param ... Any parameters passed to `osfr::osf_download`
#' @return The current `osf_tbl` associated with the requested object
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

  TRUE
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

#' Get the location of a cached OSF download
#' 
#' @param osf_tbl An `osf_tbl` metadata object that is associated with an object
#'                in the OSF cache.
#'  @return The object's local path
osf_path <- function(osf_tbl) {
  osf_tbl$local_path
}
