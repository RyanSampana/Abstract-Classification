#' Calculates likelihoods, priors, and evidence for classifying text data by
#' Category
#'
#' Calculates likelihoods, priors, and evidence for classifying text data by
#' Category for a particular word P(Category|word). The function determines:
#' P(word|Category) as the frequency of the word within each Category divided
#' by the total number of words within each Category; P(word) is the frequency
#' of the word among all Categories divided by the number of words among all
#' Categories; P(Category) is calculated as the total number of words within
#' each Category divided by the total number of words in all Categories.
#' (There is an option to adjust the influence of the prior.)
#'
#' @param trainIn A list of character vectors. (Output from cleanData())
#' @param trainOut A character vector denoting the Category to which each
#' element of the trainIn list belongs.
#' @param alpha The smoothing term for words whose frequencies are 0.
#' @param priors A vector of prior probabilities for each category. The order
#' matters and is as follows c(Math, Comp, Phys, Stat, Misc). If this is
#' left NULL, the default method to calculate priors is used.
#' (Including a prior for the Misc Category is optional.)
#' @param diffuse A number between 0 and 1 that scales the influence of
#' the prior, P(Category). (If priors are self-specified, this does nothing.)
#' P(Category') = P(Category)*(diffuse) + (1/4)*(1-diffuse).
#' This is a simple scaling system where, when diffuse=0, a uniform
#' prior is used (1/4 for each Category), when 1, the whole prior is used.
#'
#' @return A list with two entries. The first is a dataframe with six columns.
#' The first column identifies is a vector of words and the last column is
#' the evidence for each word. The middle five columns are the likelihoods
#' for each word for the Categories Math, Comp, Phys, Stat, and Misc, in that
#' order EDIT: (Misc is never used, so it's actually removed before output).
#' @export
#'
#' @examples
#' #postProbs <- bayesProb(cleanTrainIn,cleanTrainOut,diffusePrior=0.1)
bayesProb <-
  function(trainIn,
           trainOut,
           alpha = 1,
           diffuse = 1,
           priors = NULL
) {
    abstractVecs <- vectorizeAbstracts(trainIn, trainOut)

    freqMath <-
      as.data.frame.table(table(abstractVecs$Math), stringsAsFactors = FALSE)
    freqComp <-
      as.data.frame.table(table(abstractVecs$Comp), stringsAsFactors = FALSE)
    freqPhys <-
      as.data.frame.table(table(abstractVecs$Phys), stringsAsFactors = FALSE)
    freqStat <-
      as.data.frame.table(table(abstractVecs$Stat), stringsAsFactors = FALSE)
    freqMisc <-
      as.data.frame.table(table(abstractVecs$Misc), stringsAsFactors = FALSE)
    freqAll  <-
      as.data.frame.table(table(unlist(abstractVecs)), stringsAsFactors = FALSE)

    if (nrow(freqMisc) == 0) {
      freqMisc <- freqAll
      freqMisc[, 2] <- NA
    }
    tempList <-
      list(freqAll, freqMath, freqComp, freqPhys, freqStat, freqMisc)
    nameVec <- c("All", "Math", "Comp", "Phys", "Stat", "Misc")
    for (i in 1:length(tempList)) {
      names(tempList[[i]]) <- c("Words", nameVec[i])
    }
    fullFreq <-
      Reduce(function(x, y)
        merge(x, y, by = "Words", all = TRUE), tempList)
    fullFreq[is.na(fullFreq)] <- 0
    fullFreq[, 3:7] <- fullFreq[, 3:7] + alpha
    fullFreq$All <- fullFreq$All + alpha * 4

    wordCounts <- c(colSums(fullFreq[, 3:7]), sum(fullFreq[, 2]))

    fullLike <- fullFreq[, c(1, 3:7)]
    for (i in 2:ncol(fullLike)) {
      fullLike[, i] <- fullLike[, i] / wordCounts[i - 1]
    }

    fullLike$Evidence <- fullFreq[, 2] / wordCounts[6]

    if (length(priors) < 4 || !is.numeric(priors)) {
      if (!is.null(priors)) {
        warning(
          "You need at least 4 numeric values for your priors.
          Using default method to generate priors.",
          call. = FALSE
        )
      }
      priorMath <-
        (wordCounts[1] / wordCounts[6]) * diffuse + (1 / 4) * (1 - diffuse)
      priorComp <-
        (wordCounts[2] / wordCounts[6]) * diffuse + (1 / 4) * (1 - diffuse)
      priorPhys <-
        (wordCounts[3] / wordCounts[6]) * diffuse + (1 / 4) * (1 - diffuse)
      priorStat <-
        (wordCounts[4] / wordCounts[6]) * diffuse + (1 / 4) * (1 - diffuse)
      priorMisc <-
        (wordCounts[5] / wordCounts[6]) * diffuse + (0) * (1 - diffuse)
    } else{
      priors <- abs(priors)
      if (length(priors) > 5) {
        priors <- priors[1:5]
      } else{
        priors <- c(priors, 0)
      }
      priors <- priors / sum(priors)

      priorMath <- priors[1]
      priorComp <- priors[2]
      priorPhys <- priors[3]
      priorStat <- priors[4]
      priorMisc <- priors[5]
    }

    fullPrior <- c(priorMath, priorComp, priorPhys, priorStat, priorMisc)

    ## Remove the stupid Misc column
    fullLike <- fullLike[, -6]
    fullPrior <- fullPrior[-5]

    return(list(fullLike, fullPrior))
    }
