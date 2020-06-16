# All r_* functions in drake use this file to create/restore
# child R sessions to improve reproducibility.

# Load all associated functions and packages with the plan
# utils.R: All utility functions that don't depend on other packages
# packages.R: All packages you need to attach using library()
# functions.R: All other functions used in your project
# plan.R: The drake plan
source(here::here("R/utils.R"))
source(here::here("R/packages.R"))
source(here::here("R/functions.R"))
source(here::here("R/plan.R"))

# For future projects, you may use as many R files as necessary to organize
# your functions, but they should *always* be sourced prior to sourcing your
# plan files.

# Set up the OSF authentication
osfr::osf_auth(token = Sys.getenv("OSF_PAT"))

drake_config(the_plan)
