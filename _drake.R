# All r_* functions in drake use this file to create/restore
# child R sessions to improve reproducibility.

# Load function source files from R folder
for (func_source in list.files(here::here("R"), full.names = TRUE)) {
  source(func_source)
}

# Environment variables -- necessary for global variables that change execution
F_RUN_TESTS <- as.logical(Sys.getenv("F_RUN_TESTS") %if_empty_string% "FALSE")
F_OSF_UPLOAD <- as.logical(Sys.getenv("F_OSF_UPLOAD") %if_empty_string% "FALSE")
GH_TAG <- Sys.getenv("GH_TAG") %if_empty_string% NULL

# Set up the OSF authentication
osfr::osf_auth(token = Sys.getenv("OSF_PAT"))

# Set Drake configuration
source(here::here("config/packages.R"))
source(here::here("config/plan.R"))

# Run tests if configured
if (isTRUE(F_RUN_TESTS)) {
  library(testthat)
  test_dir(here::here("tests/testthat/"))
}

drake_config(
  the_plan,
  verbose = TRUE
)
