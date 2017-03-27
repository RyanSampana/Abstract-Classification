#' Performs the full naive bayes procedure without the user having to know
#' anything about the code.
#'
#' @return Returns the prediction (it also writes a file called
#' "test_out_runTest.csv" to the working directory.)
#' @export
#'
#' @examples
#' # Ah
runTest <- function(){
  ## Clean the data
  cleanTrainIn <- cleanData("train_in.csv")
  cleanTestIn  <- cleanData("test_in.csv")

  trainOut <- read.csv("train_out.csv",stringsAsFactors = FALSE)
  cleanTrainOut <- factor(trainOut$category,levels = c("cs","math","physics","stat","category"))

  ## Get the likelihoods and priors (train)
  fullBayes <- bayesProb(cleanTrainIn,cleanTrainOut,alpha=0.01,diffuse=0.8)

  ## Make the predictions
  prediction <- bayesClassify(cleanTestIn,fullBayes)

  ## Write the prediction to a file
  writeResults(prediction, "test_out_runTest.csv")

  return(prediction)
}

#' Runs cross validation without the user having to know anything about the code
#'
#' @return See crossValidation()
#' @export
#'
#' @examples
#' # Bleh
runCV <- function(){
  ## Clean the data
  cleanTrainIn <- cleanData("train_in.csv")

  trainOut <- read.csv("train_out.csv",stringsAsFactors = FALSE)
  cleanTrainOut <- factor(trainOut$category,levels = c("cs","math","physics","stat","category"))

  ## Run Cross Validation
  crossTest <- crossValidation(testFunc, 500, 10,
                               cleanTrainIn, cleanTrainOut,
                               alpha=0.01,diffuse=0.8)

  return(crossTest)
}
