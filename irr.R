#------------------------------------------------------------------------------------------------#
# ----------------------- Calculate interrater reliability---------------------------------------#
# ------------------------ hippocampal ranging --------------------------------------------------#
#------------------------------------------------------------------------------------------------#
# Created by Francesco Pupillo, Goethe University
# date: "Fri May 21 09:47:04 2021"
# 
#------------------------------------------------------------------------------------------------#

rm(list = ls())

# getting the neccessary libs
library(irr)
library(reshape)
library(ggplot2)

# function to calculate the kappa
KappaCalc<-function(test.set, correct){
  
  # calculating kappas of interest
  StartLeftKappa <- kappa2(cbind(test.set$Starting.slice.left,correct$Starting.slice.left))
  StartRightKappa <-kappa2(cbind(test.set$Starting.slice.right,correct$Starting.slice.right))
  EndLeftKappa <-kappa2(cbind(test.set$end.slice.left,correct$end.slice.left))
  EndRightKappa <-kappa2(cbind(test.set$end.slice.right,correct$end.slice.right))
  
  # writing these in a vector
  AllKappas <- cbind(StartLeftKappa$value,StartRightKappa$value,EndLeftKappa$value,EndRightKappa$value)
  
  return(AllKappas)
}

# list all the test sets
testsets<-list.files("test_sets")

# load data
cd<-getwd() # store the current path in a variable
setwd("test_sets") # navigate to the folder where the test sets are
for (n in 1:length(testsets)){
  assign(paste("test.set", n, sep=""), read.csv(testsets[n])) # load each test set and store in a variable
}
setwd(cd) # return to the previous folder

# load correct slices
# load data

# list all the correct slices sets
correctslices<-list.files("correct_slices")

setwd("correct_slices")
for (n in 1:length(correctslices)){
  assign(paste("Correct-slices", n, sep=""), read.csv(correctslices[n]))
}
setwd(cd)

# calculate the kappa
files<-ls(pattern ="^test.set")

for (n in files){
  # get the set number
  setN<-substr(n, 9, 10)
  
  curr_test_set<-get(n) # the test set
  
  curr_corr_slices<-get(paste("Correct-slices", setN, sep="")) # the corresponsed correct slice
  
assign(paste("kappa_",n, sep=""), 
       KappaCalc(curr_test_set, curr_corr_slices))
}


# plot 
# bind the kappa
kappaAll<-vector()
for (n in ls(pattern="^kappa_test")){
  
curr_kappa<-data.frame(get(n))

names(curr_kappa)<-c("start.left", "start.right", "end.left", "end.right")

kappaAll<-data.frame(rbind(kappaAll, curr_kappa))

}

# create test set variable
kappaAll$testset<-as.factor(1:nrow(kappaAll))

# merge
kappamer<-melt(kappaAll, id.vars="testset")

# plot
ggplot(kappamer, aes(x=testset, y=value, group = variable, colour=variable))+
  geom_line()+
  geom_point()+
  geom_text(aes(label = round(value, 2)),
            vjust = "outward", hjust = "inward",
            show.legend = FALSE, colour = "black") 

# save the plot
ggsave( "irr.jpg", plot = last_plot())
