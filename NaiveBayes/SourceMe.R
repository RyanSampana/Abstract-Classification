## This file can be sourced to obtain the results reported in the accompanying
## paper. This file is a walkthrough introduction of the code. See the
## README for instructions.

## Read, clean, and format the training data. (The data has been provided
## with the package.)
train_in <- cleanInData("train_in.csv")
train_out <- cleanOutData("train_out.csv")

## Perform cross validation (for time, on a small subset of the data)
## to test different values of alpha and diffuse
alphaVec <- c(0,0.001,0.1,0.5,0.7,1)
diffuseVec <- c(0,0.5,1)
la <- length(alphaVec)
ld <- length(diffuseVec)
cross_valid <- matrix(rep(list(),la*ld),nrow=la,ncol=ld)

## We're planning to make a plot of the accuracies for these values later,
## so let's store the accuracies in a matrix as we get them.
accMat <- matrix(0,nrow=la,ncol=ld)

k <- 1
for(i in 1:la){
  for(j in 1:ld){
    cat("alpha = ",alphaVec[i],"  diffuse = ",diffuseVec[j],"\n",sep="")
    cross_valid[i,j][[1]] <- crossValidation(testFunc, 2500, 10,
                                             train_in,
                                             train_out,
                                             alpha=alphaVec[i],
                                             diffuse=diffuseVec[j])

    accMat[i,j] <- cross_valid[i,j][[1]][[2]]

    cat(round(k/(la*ld)*100,1),"% Finished","\n\n",sep="")
    k <- k+1
  }
}
## To access the data list you want, call cross_valid[i,j][[1]]
## Ex: to get alpha=0.001, diffuse=1 call cross_valid[2,3][[1]]
## I only got the summary results from crossValidation(), so to
## access the confusion matrix call cross_valid[2,3][[1]][[1]]
## and for the accuracy cross_valid[2,3][[1]][[2]]

## Let's plot the accuracies from different values of alpha for each value
## of diffuse
accMat <- matrix(0,nrow=la,ncol=ld)
for(i in 1:la){
  for(j in 1:ld){
    accMat[i,j] <- cross_valid[i,j][[1]][[2]]
  }
}

## Plot the summary 1-accuracies (error)
## for the alphas for each value of diffuse
matplot(alphaVec,1-accMat,xlab="alpha",ylab="error",
        type="b",pch=16,col=1:ld, lty=1, lwd=2)
legend("top",title="diffuse",legend=diffuseVec,pch=16,col=1:ld)

## Let's get rid of the alpha=0 points to get a better look
matplot(alphaVec[-1],1-accMat[-1,],xlab="alpha",ylab="error",
        type="b",pch=16,col=1:ld, lty=1, lwd=2)
legend("top",title="diffuse",legend=diffuseVec,pch=16,col=1:ld)


## Use the data to train the Naive Bayes Classifier
## with the optimal settings. (I've restricted the
## size of the data set so that it runs quickly for
## the example.)
NBParameters <- bayesProb(train_out[1:5000],train_in[1:5000],
                          alpha=0.01,diffuse=1)

## Read, clean, and format the test data
test_in <- cleanInData("test_in.csv")

## Use the classifier to predict the categories for the test data.
## (I've restricted the size of the data set so that it runs quickly
## for the example.)
test_pred <- bayesClassify(test_in[1:5000], NBClassifier)

## Write the predictions to a file
writeResults(test_pred,"test_out.csv")

## If you feel comfortable with the code, you can use the functions
## freely by typing them in the console or creating a new script file
## in the "AbstractPackage" folder. You can also edit or write code in
## this file, if you'd like. If you want to run the full model,
## remove the code that says [1:5000] on the last few lines and
## prepare to wait (~20min). Best!
