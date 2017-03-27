#' Perform k-fold cross-validation
#'
#' @param func The function you'll be cross validating
#' (in this case, testFunc()).
#' @param N The size of the sample you want to use
#' @param k The number of folds
#' @param trainIn The training data over which you'll be cross validating.
#' (Output from cleanData())
#' @param trainOut The categories for the training data
#' @param verbose Should the accuracy be printed after each iteration of the
#' cross-validation procedure? (Defaults to TRUE so you won't your computer
#' has crashed.)
#' @param innerRes Should all k intermediate results for the individual cross-
#' validations be returned? By default only the summary of all k-folds is
#' returned because it's messy otherwise.
#' @param ... Any additional arguments for func.
#'
#' @return By default a list with two elements is returned. The first is the
#' summary confusion matrix and the second is the summary accuracy.
#' If innerRes == TRUE, then a list with two "sub" lists is returned.
#' The first "sub" list contains the default return value. The second "sub"
#' list is a list of all the confusion matrices and accuracies for each
#' individual iteration of the k-folds. These results are stored in a list
#' for each
#'
#' A list of two elements. The first is a list containing the results
#' from the confusion() function for every trial. The second is a list containing
#' the summary of the results in the first list.
#' @export
#'
#' @examples
#' # crossValidation(testFunc,5000,10,cleanTrainIn,cleanTrainOut,
#' # alpha = 0.01, diffuse = 0.9)
crossValidation <-
  function(func, N, k, trainIn, trainOut, verbose = TRUE, innerRes = FALSE, ...) {
    if (N > length(trainOut)) {
      stop("You've asked for a smaple size larger than your sample")
    }
    randSubSet <- sample(1:length(trainOut), N)
    trainIn <- trainIn[randSubSet]
    trainOut <- trainOut[randSubSet]
    cvIndex <- getCVIndex(N, k)
    funcRes <- list()
    tempRes <- list()
    for (i in 1:k) {
      tempTrainIn  <- trainIn[-cvIndex[[i]]]
      tempTrainOut <- trainOut[-cvIndex[[i]]]
      tempTestIn   <- trainIn[cvIndex[[i]]]
      tempTestOut  <- trainOut[cvIndex[[i]]]
      funcRes[[i]] <-
        func(tempTrainIn,
             tempTrainOut,
             tempTestIn,
             tempTestOut,
             ...)
      if(verbose){
        print(accuracy(funcRes[[i]]))
      }
    }
    meanCon <- Reduce("+", funcRes)
    meanAcc <- accuracy(meanCon)
    meanRes <- list(meanCon, meanAcc)
    if(innerRes){
      allAcc <- sapply(funcRes,accuracy)
      allRes <- list(funcRes,allAcc)
      return(list(meanRes,allRes))
    }else{
      return(meanRes)
    }
  }


#' Helper for crossValidation
#'
#' This is a function called by the crossValidation() function to help it
#' do its thing. This function has some of the other functions hard-coded
#' into it, so it's not really useable.
#'
#' @param trainIn NA
#' @param trainOut NA
#' @param testIn NA
#' @param testOut NA
#' @param ... NA
#'
#' @return NA
#' @export
#'
#' @examples
#' # What
testFunc <-
  function(trainIn,
           trainOut,
           testIn,
           testOut,
           ...) {
    postProbs <- bayesProb(trainIn, trainOut, ...)
    prediction <- bayesClassify(testIn, postProbs)
    results <- confusion(prediction, testOut)
    return(results)
  }

