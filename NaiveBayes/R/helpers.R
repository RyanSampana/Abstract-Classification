#' Vectorize a list of text vectors
#'
#' Take a list of individual text vectors and use a vector of categories to
#' get a list of text vectors concatenated by category.
#'
#'
#' @param trainIn A list of character vectors. (Output from cleanData())
#' @param trainOut A character vector denoting the Category to which each
#' element of the trainIn list belongs.
#'
#' @return A list of length C of character vectors, where C is the number of
#' unique categories in the trainOut vector.
#' @export
#'
#' @examples
#' ## The number of texts
#' length(cleanTrainIn)
#'
#' ## The number of categories
#' length(vectorizeAbstracts(cleanTrainIn,cleanTrainOut))
vectorizeAbstracts <- function(trainIn, trainOut) {
  indexMath <- which(trainOut == "math")
  indexComp <- which(trainOut == "cs")
  indexPhys <- which(trainOut == "physics")
  indexStat <- which(trainOut == "stat")
  indexMisc <- which(trainOut == "category")

  fullMath <- do.call("c", trainIn[indexMath])
  fullComp <- do.call("c", trainIn[indexComp])
  fullPhys <- do.call("c", trainIn[indexPhys])
  fullStat <- do.call("c", trainIn[indexStat])
  fullMisc <- do.call("c", trainIn[indexMisc])

  return(
    list(
      "Math" = fullMath,
      "Comp" = fullComp,
      "Phys" = fullPhys,
      "Stat" = fullStat,
      "Misc" = fullMisc
    )
  )
}

#' Provides the indices for the training and validation sets for k-fold
#' cross-validation.
#'
#' @param N The size of the total sample.
#' @param k The number of folds.
#'
#' @return A list of k index-vectors denoting which elements of the data set
#' is to be used for training.
#' @export
#'
#' @examples
#' # What
getCVIndex <- function(N, k) {
  cv <- sample(1:N)
  size <- floor(N / k)
  remain <- N %% k

  cvList <- list()
  for (i in 1:k) {
    if (i <= remain) {
      cvList[[i]] <- cv[(1:(size + 1)) + ((i - 1) * (size + 1))]
    } else if (i > remain) {
      cvList[[i]] <- cv[(1:size) + ((i - 1) * size) + remain]
    }
  }
  return(cvList)
}

#' Profile a function to determine how much processing time each segment of
#' code within the function takes.
#'
#' @param func A function to be profiled
#' @param ... The necessary arguments to be passed to the function
#'
#' @return A list of two elements. The first element contains the output
#' of func. The second element is the profile of func.
#' @export
#'
#' @examples
#' #profileFunc(runAll())
profileFunc <- function(func, ...) {
  Rprof()
  output <- func(...)
  Rprof(NULL)
  profileResults <- summaryRprof()
  return(list(output, profileResults))
}
