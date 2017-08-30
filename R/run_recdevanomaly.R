#' Run the analysis
#'
#' @param species
#' @param replicates
#' @param cores The number of cores that you want to run the analysis on.
#' The default is one, which leads to things not running in parallel.
#' @authors Kelli Faye Johnson
#'
run_recdevanomaly <- function (species, replicates, cores = 1) {

  set.seed(20)

  if (cores > 1) {
    numcores <- Sys.getenv("NUMBER_OF_PROCESSORS")
    mode(cores) <- "numeric"
    if (numcores <= cores) stop("You specified too many cores",
    	" because your computer only has ", numcores)
    cl <- makeCluster(cores)
  registerDoParallel(cl)
  }
  
  use.cases <- list(D = "index", A = "agecomp", L = "lcomp", F = "F")

  run_cases(species = species)
  models <- sapply(species, function(x) {
    om <- system.file("models", x, "om", package = "ss3models")
    em <- system.file("models", x, "em", package = "ss3models")
    return(c("om" = om, "em" = em))
  })
  recdevs <- run_recdevs(species = species, replicates = replicates)


  run_ss3sim(
    iterations = 1:replicates,
    scenarios = c("F1-D0-A100-L100-cod"),
    user_recdevs = recdevs[[1]][[1]],
    bias_adjust = FALSE,
    om_dir = models[1, 1],
    em_dir = models[2, 1],
    hess_always = FALSE,
    parallel = ifelse(cores > 1, TRUE, FALSE),
    parallel_iterations = ifelse(cores > 1, TRUE, FALSE),
    case_files = use.cases, case_folder = "cases",
    user_recdevs_warn = FALSE
  )

  get_results_all()
  sc1 <- read.csv("ss3sim_scalar.csv")
  ts1 <- read.csv("ss3sim_ts.csv")
  ts1 <- calculate_re(ts1, add = TRUE)
  plot_ts_boxplot(ts1, y = "SpawnBio_re", relative.error = TRUE)
  ggplot2::ggsave(filename = "steepnessSSB.png",
    path = getwd())
  dev.off()

}
