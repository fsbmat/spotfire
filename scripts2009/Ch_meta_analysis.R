###################################################
### chunk number 1: setup
###################################################
rm(list = ls())
if (!file.exists("tables")) dir.create("tables")
set.seed(290875)
options(prompt = "R> ", continue = "+  ",
    width = 63, # digits = 4, 
    SweaveHooks = list(leftpar = function() 
        par(mai = par("mai") * c(1, 1.05, 1, 1))))
HSAURpkg <- require("HSAUR")
if (!HSAURpkg) stop("cannot load package ", sQuote("HSAUR"))
rm(HSAURpkg)
a <- Sys.setlocale("LC_ALL", "C")
book <- TRUE
refs <- cbind(c("AItR", "SI", "CI", "ANOVA", "MLR", "GLM", 
                "DE", "RP", "SA", "ALDI", "ALDII", "MA", "PCA", 
                "MDS", "CA"), 1:15)
ch <- function(x, book = TRUE) {
    ch <- refs[which(refs[,1] == x),]
    if (book) {
        return(paste("Chapter~\\\\ref{", ch[1], "}", sep = ""))
    } else {
        return(paste("Chapter~\\\\ref{", ch[2], "}", sep = ""))
    }
}


###################################################
### chunk number 2: MA-smoking-OR
###################################################
library("rmeta")
data("smoking", package = "HSAUR")
smokingOR <- meta.MH(smoking[["tt"]], smoking[["tc"]],
                     smoking[["qt"]], smoking[["qc"]], 
                     names = rownames(smoking))


###################################################
### chunk number 3: MA-smoking-OR-summary
###################################################
summary(smokingOR)


###################################################
### chunk number 4: MA-smoking-OR-plot
###################################################
plot(smokingOR, ylab = "")


###################################################
### chunk number 5: MA-smoking-random
###################################################
smokingDSL <- meta.DSL(smoking[["tt"]], smoking[["tc"]], 
                     smoking[["qt"]], smoking[["qc"]],
                     names = rownames(smoking))
print(smokingDSL)


###################################################
### chunk number 6: MA-BCG-odds
###################################################
data("BCG", package = "HSAUR")
BCG_OR <- meta.MH(BCG[["BCGVacc"]], BCG[["NoVacc"]],
                  BCG[["BCGTB"]], BCG[["NoVaccTB"]],
                  names = BCG$Study)
BCG_DSL <- meta.DSL(BCG[["BCGVacc"]], BCG[["NoVacc"]],
                  BCG[["BCGTB"]], BCG[["NoVaccTB"]],
                  names = BCG$Study)


###################################################
### chunk number 7: MA-BCGOR-summary
###################################################
summary(BCG_OR)


###################################################
### chunk number 8: MA-BCGDSL-summary
###################################################
summary(BCG_DSL)


###################################################
### chunk number 9: BCG-studyweights
###################################################
studyweights <- 1 / (BCG_DSL$tau2 + BCG_DSL$selogs^2)
y <- BCG_DSL$logs
BCG_mod <- lm(y ~ Latitude + Year, data = BCG, 
              weights = studyweights)


###################################################
### chunk number 10: MA-mod-summary
###################################################
summary(BCG_mod)


###################################################
### chunk number 11: BCG-Latitude-plot
###################################################
plot(y ~ Latitude, data = BCG, ylab = "Estimated log-OR")
abline(lm(y ~ Latitude, data = BCG, weights = studyweights))


###################################################
### chunk number 12: MA-funnel-ex
###################################################
set.seed(290875)
sigma <- seq(from = 1/10, to = 1, length.out = 35)
y <- rnorm(35) * sigma
gr <- (y > -0.5)
layout(matrix(1:2, ncol = 1))
plot(y, 1/sigma, xlab = "Effect size", ylab = "1 / standard error")
plot(y[gr], 1/(sigma[gr]), xlim = range(y),
     xlab = "Effect size", ylab = "1 / standard error")


###################################################
### chunk number 13: MA-smoking-funnel
###################################################
funnelplot(smokingDSL$logs, smokingDSL$selogs, 
           summ = smokingDSL$logDSL, xlim = c(-1.7, 1.7))
abline(v = 0, lty = 2)


