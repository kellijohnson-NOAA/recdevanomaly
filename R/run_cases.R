#' Make case files
#' @param species The life histories you want to run the analysis for.
#'
run_cases <- function(species, nsamp = c(10, 100, 0.2),
  years = list(1:100, 1:100), burnin = 25, length = 100) {

  #### Fishing
  # F
  tofind <- paste0("F[0]+-", species)
  ffiles <- sapply(tofind, grep, value = TRUE,
    x = list.files(system.file("cases", package = "ss3models"), full.names = TRUE))
  ignore <- sapply(ffiles, function(x) {
    file.copy(x, file.path("cases", basename(x)))
  })

  for (spp in species) {
    fmsy <- ss3sim:::get_args(
      file.path("cases", paste0("F0-", spp, ".txt")))$fvals
    fmsy <- unique(fmsy[fmsy != 0])
    case_fishing(
      fvals = c(rep(0, burnin), rep(fmsy, length - burnin)),
      years_alter = 1:length,
      spp = spp, case = 1, years = 1:length)
  }
    ignore <- file.rename(from = dir(pattern = "F1"),
      to = file.path("cases", dir(pattern = "F1")))

  #### Data cases
    # Index
  case_index(fleets = 2,
    years = list(years[[1]]), sd = list(nsamp[3]),
    case = 0, spp = species)
  ignore <- file.rename(from = dir(pattern = "index"), to = file.path("cases", dir(pattern = "index")))
  for (ii_type in c("agecomp", "lcomp")) {
    # Data rich
    ss3sim::case_comp(fleets = 1:2,
      Nsamp = list(
        rep(nsamp[2], length(years[[1]])),
        rep(nsamp[2], length(years[[2]]))),
      years = years,
      cpar = 2:1, type = ii_type, case = nsamp[2], spp = species)
    # Data poor
    ss3sim::case_comp(fleets = 1:2,
      Nsamp = list(
        rep(nsamp[1], length(years[[1]])),
        rep(nsamp[1], length(years[[2]]))),
      years = years,
      cpar = 2:1, type = ii_type, case = nsamp[1], spp = species)
  }
    ignore <- file.rename(from = dir(pattern = "agecomp|lcomp"), to = file.path("cases", dir(pattern = "agecomp|lcomp")))

}
