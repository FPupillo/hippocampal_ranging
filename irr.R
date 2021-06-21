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
KappaCalc<-function(rater1, rater2){
  
  # calculating kappas of interest 
  StartLeftKappa <- kappa2(cbind(rater1$Starting.slice.left,rater2$Starting.slice.left))
  StartRightKappa <-kappa2(cbind(rater1$Starting.slice.right,rater2$Starting.slice.right))
  EndLeftKappa <-kappa2(cbind(rater1$end.slice.left,rater2$end.slice.left))
  EndRightKappa <-kappa2(cbind(rater1$end.slice.right,rater2$end.slice.right))
  
  # writing these in a vector
  AllKappas <- cbind(StartLeftKappa$value,StartRightKappa$value,EndLeftKappa$value,EndRightKappa$value)
  
  return(AllKappas)
}

# compare against correct slices or with another rater?
# 1: correct slices 
# 2: another rater
whichComp<-2

# list all the test sets
rater1<-list.files("rater1")

# load data
cd<-getwd() # store the current path in a variable
setwd("rater1") # navigate to the folder where the test sets are
for (n in 1:length(rater1)){
  # extract the test set from name of the file
  testset<- as.numeric(substr(rater1[n], 8,8))
  # extract the round
  round<-as.numeric(substr(rater1[n], 10,10))
  # create a dataset
  assign(paste("rater1.", testset,".",round, sep=""), read.csv(rater1[n])) # load each test set and store in a variable
}
setwd(cd) # return to the previous folder

# load correct slices or rater two slices

# list all the correct slices sets
if (whichComp==1){
  
rater2<-list.files("correct.slices")

setwd("correct.slices")

for (n in 1:length(rater2)){

  assign(paste("rater2.", n, sep=""), read.csv(rater2[n]))
}
setwd(cd)

} else if (whichComp==2){
  
  rater2<-list.files("rater2")
  
  setwd("rater2")
  
  for (n in 1:length(rater2)){
    
    # extract test set
    testset<-as.numeric(substr(rater2[n], 8,8))
    
    # extract the round
      round<-as.numeric(substr(rater2[n], 10,10))
    
    assign(paste("rater2.", testset, ".", round, sep=""), read.csv(rater2[n]))
  }
  setwd(cd)
  
}

# calculate the kappa
files<-ls(pattern ="^rater1.")

for (n in files){
  
  # get the set number
  setN<-substr(n, 8, 8)
  # extract the round

  round<-as.numeric(substr(n, 10,10))
  
  curr_rater1<-get(n) 
  
  if (whichComp==1){ # it we are comparing against correct slices
  curr_rater2<-get(paste("rater2.", setN, sep="")) # the corresponsed correct slice
  } else { # if we are comparing against other rather
    curr_rater2<-get(paste("rater2.", setN, ".", round, sep="")) # the corresponsed correct slice
  }
assign(paste("kappa_",n, sep=""), 
       KappaCalc(curr_rater1, curr_rater2))
}


# plot 
# bind the kappa
kappaAll<-vector()
for (n in ls(pattern="^kappa_rater")){
  
curr_kappa<-data.frame(get(n))

names(curr_kappa)<-c("start.left", "start.right", "end.left", "end.right")

kappaAll<-data.frame(rbind(kappaAll, curr_kappa))

}

# get the round 
# and the testset
round<-vector()
testset<-vector()
kappas<-ls(pattern="^kappa_rater")

for(n in 1: length(kappas)){
  round[n]<-as.numeric(substr(kappas[n], nchar(kappas[n]), nchar(kappas[n])))
  testset[n]<-as.numeric(substr(kappas[n], 14,14))
  
}

# create test set variable
kappaAll$round<-round
kappaAll$testset<-testset

# sort
kappaAll<-kappaAll[order(kappaAll$round, kappaAll$testset),]

# create progressive variable
kappaAll$testN<-1:nrow(kappaAll)

# merge
kappamer<-melt(kappaAll[,c(1:4,7)], id.vars="testN")
names(kappamer)[2:3]<-c("Slice", "IRR")

# plot
print(
ggplot(kappamer, aes(x=testN, y=IRR, group = Slice, colour=Slice))+
  geom_line()+
  geom_point()+
  geom_text(aes(label = round(IRR, 2)),
            vjust = "outward", hjust = "inward",
            show.legend = FALSE, colour = "black") 
)
# save the plot
ggsave( "irr.jpg", plot = last_plot())
