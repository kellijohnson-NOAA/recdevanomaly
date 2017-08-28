#' Generate a matrix of random recruitment deviations with anomalies
#'
#' @param species
#' @param AR
#' @param nyears
#' @param replicates
#' @param verbose
#' @param year
#' @param percent
#'
run_recdevs <- function(species, AR = 0.0, nyears = 100, replicates = 100,
  verbose = FALSE, year = 90, percent = 200) {
 # year can handle multiple years
 # percent to handle multiple numbers

  returnme <- list()

  for (spp in species) {
     # Create recruitment deviations
     # A list is generated with one matrix per level of AR
     SDmarg <- get_sigmar(file.path(
       system.file("models", spp, "om", package = "ss3models"), "ss3"))
     SDcond = SDmarg * sqrt(1 - AR^2)
     EpsList <- list()
     for (ar in seq_along(AR)) {
       EpsList[[ar]] <- matrix(0, nrow = nyears, ncol = replicates + 5)
       # Create a temporary matrix with 1 column
       Eps_s <- matrix(0, nrow = NROW(EpsList[[ar]]), ncol = 1)
       for (i in 1:NCOL(EpsList[[ar]])) {
         set.seed(i)
         # Bias correction added
         Eps_k = rnorm(NROW(EpsList[[ar]]), mean = 0, sd = SDcond[ar])
         Eps_s[1] <- Eps_k[1] * SDmarg/SDcond[ar]
         for (t in 2:NROW(EpsList[[ar]])) {
           Eps_s[t] <- Eps_s[t - 1] * AR[ar] + Eps_k[t]
         }
         EpsList[[ar]][, i] <- Eps_s - SDmarg^2 / 2
       }
     }

     # NEW SANITY CHECKS (actually, I decided to just make it a message)
     sanity_check <- function(vec, num, rel.tol=0.01, infl=0, failmessage="Sanity check failed"){
       if( any(abs(vec-num)/(num+infl)>rel.tol) ) stop(failmessage)
     }
    if (verbose) {
      message("exponentiated mean equals ",paste(round(sapply(EpsList, FUN=function(mat){ mean(exp(mat)) }),3),collapse=" "))
      message("marginal standard deviation equals ",paste(round(sapply(EpsList, FUN=function(mat){ sd(mat) }),3),collapse=" "))
      message("autocorrelation equals ",paste(round(sapply(EpsList, FUN=function(mat){ mean(apply(mat,MARGIN=2,FUN=function(vec){var(vec[-length(vec)],vec[-1])/var(vec)})) }),3),collapse = " "))
    }

    names(EpsList) <- AR
    EpsList <- lapply(EpsList, function(x) {
      apply(x, 2, function(y) {
        y[year] <- max(y) * (percent / 100)
        return(y)
      })
    })
    returnme[[length(returnme) + 1]] <- EpsList
   } # End species loop
  names(returnme) <- species
  invisible(returnme)
}
