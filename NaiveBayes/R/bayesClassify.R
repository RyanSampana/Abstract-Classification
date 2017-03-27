#' Take a list of texts and classify them using naive Bayes
#'
#' Take a list of texts and try to classify them using naive bayes. The sum of
#' the log-likelihoods of each word in each text in the list is computed
#' for each category. The log-prior is added to each result. Each text
#' is predicted to belong to the category with the maximal sum. (Words within
#' the test texts that were not observed in training are ignored.)
#'
#' @param testSet A list of character vectors. (Output from cleanData())
#' @param postList A list of two elements. The first is a data frame containing
#' likelihoods (and evidence) and the second is a vector of prior probabilities.
#' (This list is obtained from bayesProb().)
#'
#' @return A factor vector a prediction of either "cs", "math", "physics",
#' or "stat" for each text provided in the testSet list.
#' @export
#'
#' @examples
#' #bayesClassify(cleanTestIn, bayesProbList)
bayesClassify <- function(testSet,
                          postList) {
  likeProbs <- postList[[1]]
  priorProbs <- postList[[2]]

  loglikeProbs <- likeProbs
  loglikeProbs[, 2:5] <- log(likeProbs[, 2:5])

  logPrior <- log(priorProbs)

  sumlogProb <- matrix(nrow = length(testSet), ncol = 4)
  for (i in 1:length(testSet)) {
    temp <- merge(testSet[[i]], loglikeProbs, by = 1, all.x = TRUE)
    sumlogProb[i, ] <- colSums(temp[, 2:5], na.rm = TRUE) + logPrior
  }

  maxVec <- max.col(sumlogProb)
  results <-
    factor(
      maxVec,
      levels = c(1, 2, 3, 4),
      labels = c("math", "cs", "physics", "stat")
    )
  return(results)
}

#' Computes a confusion matrix for a set of predictions and their known true
#' values
#'
#' @param predOut The prediction results as a vector. (Best if factor vector)
#' @param realOut The real values as a vector. (Best if factor vector)
#'
#' @return The confusion matrix
#' @export
#'
#' @examples
#' # What
confusion <- function(predOut, realOut) {
  return(table(predOut, realOut))
}

#' Computes the accuracy from a confusion matrix
#'
#' @param confusionMat A confusion matrix
#'
#' @return The accuracy of a prediction given by
#' #-of-correct-predictions/total-#-of-predictions
#' @export
#'
#' @examples
#' #Yeah
accuracy <- function(confusionMat){
  return(sum(diag(confusionMat))/sum(confusionMat))
}
