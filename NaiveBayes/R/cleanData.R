#' Read, clean, and format text data
#'
#' Read, clean, and format text data from a .csv file. The function treats
#' each row of the .csv file as a single string. The function splits each
#' string into a vector of "words." A "word" is any consecutive series of
#' alphabetic characters. All spaces and non-alphabetic characters are
#' treated as word-separators and are removed. All "words" are coerced to
#' lower case.
#'
#' @param fileName A string of the name of the .csv file to be read. If the
#' file is not in the working directory, the full path name must be specified.
#' The "id" column is discarded when the .csv file is read, so the input text
#' .csv file and the category .csv file must be matched by row beforehand.
#'
#' @return A list of character vectors. All vector entries are strings of only
#'  lowercase , alphabetic characters.
#'
#' @export
#'
#' @examples
#' #cleanTrainIn <- cleanData("train_in.csv")
#'
cleanInData <- function(filename) {
  rawData <- read.csv(file = filename, stringsAsFactors = FALSE)
  cleanAbs <- gsub("[^[:alpha:]]", " ", rawData$abstract)
  cleanAbs <- gsub("\\s+", " ", cleanAbs)
  cleanAbs <- tolower(cleanAbs)
  splitAbs <- lapply(cleanAbs, strsplit, split = " ")
  splitAbs <- lapply(splitAbs, unlist, recursive = FALSE)

  return(splitAbs)
}

#' Read and format the known categories for text data from a .csv file
#'
#' @param filename A string of the name of the .csv file to be read. If the
#' file is not in the working directory, the full path name must be specified.
#' The "id" column is discarded when the .csv file is read, so the input text
#' .csv file and the category .csv file must be matched by row beforehand.
#'
#' @return A factor vector of category names. The  vector must be in the
#' same order as the The factor has levels c("math","cs","physics","stat",
#' "category") which correspond to numeric values c(1,2,3,4,5) (if coerced).
#'
#' @export
#'
#' @examples
#' # Blarge
cleanOutData <- function(filename){
  rawData <- read.csv(file = filename, stringsAsFactors = FALSE)
  cleanCat <- rawData[,2]
  cleanCat <- factor(cleanCat, levels=c("math","cs","physics","stat","category"))
  return(cleanCat)
}

#' Writes the results of the predictions in the specified format.
#'
#' @param output The pediction from bayesClassify()
#' @param filename The name of the .csv file to which to write the prediction
#'
#' @return NULL
#' @export
#'
#' @examples
#' # Meh
writeResults <- function(output,filename = "test_out.csv"){
  testRes <- as.character(output)
  results <- data.frame(id=(0:(length(testRes)-1)),category=testRes)
  write.csv(results,file=filename,quote=FALSE,row.names=FALSE)
  return(NULL)
}
