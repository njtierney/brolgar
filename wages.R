# Interfacing with ggobi
library(rggobi) # Changed Rggobi to rggobi TP 17/9/18
ggobi() # Open wages3.xml

d.wages1<-getData.ggobi(.data=1)
d.wages2<-getData.ggobi(.data=2)
d.wages3<-getData.ggobi(.data=3)

# Plot all the traces - spagetti
postscript("wages-individuals.ps",width=8.0,height=6.0,horizontal=FALSE,
  paper="special",family="URWHelvetica")
par(mar=c(5,5,3,1))
plot(d.wages1[,3],d.wages1[,2],pch=".",xlab="Experience",ylab="ln(Wages)",
  type="n")
for (i in 1:888)
  lines(d.wages1[d.wages1[,1]==d.wages3[i,1],3],
    d.wages1[d.wages1[,1]==d.wages3[i,1],2])
title("All the profiles")
dev.off()

# Plot a sample of 50 profiles
postscript("wages-individuals-sample1.ps",
  width=8.0,height=6.0,horizontal=FALSE,
  paper="special",family="URWHelvetica")
par(mar=c(5,5,3,1))
plot(d.wages1[,3],d.wages1[,2],pch=".",xlab="Experience",ylab="ln(Wages)",
  type="n")
smp<-sample(c(1:888),50)
for (i in 1:50)
  lines(d.wages1[d.wages1[,1]==d.wages3[smp[i],1],3],
    d.wages1[d.wages1[,1]==d.wages3[smp[i],1],2])
title("Sample the profiles")
dev.off()

# Animate the individuals

for (i in 11:30) {
postscript(paste("/home/dicook/papers/Longitudinal.Data/wages-individuals",i,
  ".ps",sep=""),width=8.0,height=6.0,horizontal=FALSE,
  paper="special",family="URWHelvetica")
par(mar=c(5,5,3,1))
plot(d.wages1[,3],d.wages1[,2],pch=".",xlab="Experience",ylab="ln(Wages)",
  type="n")
  lines(d.wages1[d.wages1[,1]==d.wages3[i,1],3],
    d.wages1[d.wages1[,1]==d.wages3[i,1],2])
title(paste("Individual",i))
dev.off()
}

# Code from Singer and Willett

#reading in the wages data
wages <- read.table("c:/wages_pp.txt", header=T, sep=",")

#table 5.3, p. 147
wages[wages$id %in% c(206, 332, 1028), c(1, 3, 2, 6, 8, 10)]

#Table 5.4, p. 149
#Model A
model.a <- lme(lnw~exper, wages, random= ~exper | id, method="ML")
summary(model.a)

#Model B
model.b <- update(model.a, lnw~exper*hgc.9+exper*black)
summary(model.b)

#Model C
model.c <- update(model.b, lnw~exper+exper:black+hgc.9)
summary(model.c)

#fig. 5.2, p. 150
exper.seq <- seq(0, 12)
fixef.c <- fixef(model.c)
x.w9 <- fixef.c[[1]] + fixef.c[[2]]*exper.seq
x.w12 <-  fixef.c[[1]] + fixef.c[[2]]*exper.seq + fixef.c[[3]]*3
x.b9 <- fixef.c[[1]] + fixef.c[[2]]*exper.seq + fixef.c[[4]]*exper.seq
x.b12 <- fixef.c[[1]] + fixef.c[[2]]*exper.seq + fixef.c[[3]]*3 + 
  fixef.c[[4]]*exper.seq

windows(5,5)
postscript("wages-singer.ps",width=8.0,height=6.0,horizontal=FALSE,
  paper="special",family="URWHelvetica")
plot(exper.seq, x.w9, ylim=c(1.6, 2.4), ylab="LNW.hat", xlab="EXPER", 
  type="l", lwd=2)
#plot(exper.seq, x.w9, ylim=c(1, 4), ylab="LNW.hat", xlab="EXPER", 
#  type="l", lwd=2) # di's modification to plot on scale of the data
lines(exper.seq, x.w12, lty=3)
lines(exper.seq, x.b9, lty=4, lwd=2)
lines(exper.seq, x.b12, lty=5)
#legend(0, 4, c("9th grade, White/Latino", "9th grade, Black", # di modified
# "12th grade, White/Latino", "12th grade, Black"), lty=c(1, 4, 3, 5), cex=.8)
legend(0, 2.4, c("9th grade, White/Latino", "9th grade, Black", 
 "12th grade, White/Latino", "12th grade, Black"), lty=c(1, 4, 3, 5), cex=.8)
dev.off()

# Lowess smoothers
postscript("wages-smooth.ps",width=6.0,height=8.0,horizontal=FALSE,
  paper="special",family="URWHelvetica")
plot(d.wages1[,3],d.wages1[,2],pch=".",xlab="Experience",ylab="ln(Wages)",
  col="gray")
lines(lowess(d.wages1[,3],d.wages1[,2],f=0.3),lwd=2)
title("ln(Wages) vs Experience: Lowess smoother")
dev.off()

postscript("wages-smooth-race.ps",width=6.0,height=8.0,horizontal=FALSE,
  paper="special",family="URWHelvetica")
plot(d.wages1[,3],d.wages1[,2],pch=".",xlab="Experience",ylab="ln(Wages)",
  col="gray")
lines(lowess(d.wages1[as.numeric(d.wages1[,6])==1&
  as.numeric(d.wages1[,7])==1,3],
  d.wages1[as.numeric(d.wages1[,6])==1&
  as.numeric(d.wages1[,7])==1,2],f=0.3),lwd=2,lty=2)
lines(lowess(d.wages1[as.numeric(d.wages1[,6])==2,3],
  d.wages1[as.numeric(d.wages1[,6])==2,2],f=0.3),lwd=2,lty=1)
lines(lowess(d.wages1[as.numeric(d.wages1[,7])==2,3],
  d.wages1[as.numeric(d.wages1[,7])==2,2],f=0.3),lwd=2,lty=5)
title("Lowess smoother by Race")
legend(7,4.4,lty=c(1,5,2),lwd=c(2,2,2),legend=c("Black","Hispanic","White"))
dev.off()

library(lattice)
race<-rep("white",6402)
race[as.numeric(d.wages1[,7])==2]<-"hispanic"
race[as.numeric(d.wages1[,6])==2]<-"black"
postscript("wages-trellis-race.ps",width=6.0,height=8.0,horizontal=FALSE,
  paper="special",family="URWHelvetica")
bg<-trellis.par.get("background")
bg$col<-"white"
trellis.par.set("background",bg)
fg<-trellis.par.get("foreground")
fg$col<-"black"
trellis.par.set("foreground",bg)
xyplot(d.wages1[,2]~d.wages1[,3]|race,xlab="Experience",
  ylab="ln(Wages)",pch="x",cex=0.7,col="black")
dev.off()

# confidence intervals
prace<-sample(race.demog)
x<-NULL
for (i in 1:888) {
  id<-d.wages3[i,1]
  y<-cbind(d.wages1[d.wages1[,1]==id,2:3],
    rep(prace[i],length(d.wages1[d.wages1[,1]==id,2])))
  x<-rbind(x,y)
}
ci.white<-cbind(seq(0.1,12,by=0.1),
    predict(loess(x[x[,3]=="white",1]~x[x[,3]=="white",2],span=0.3),
    data.frame(seq(0.1,12,by=0.1))))
ci.white<-ci.white[,c(1,2,2)]
# run 5, 10, 
for (k in 1:100) {
  prace<-sample(race.demog)
  x<-NULL
  for (i in 1:888) {
    id<-d.wages3[i,1]
    y<-cbind(d.wages1[d.wages1[,1]==id,2:3],
      rep(prace[i],length(d.wages1[d.wages1[,1]==id,2])))
    x<-rbind(x,y)
  }
  ci2<-predict(loess(x[x[,3]=="white",1]~x[x[,3]=="white",2],span=0.3),
    data.frame(seq(0.1,12,by=0.1)))
  #for (j in 1:120) {
  #  if (ci2[j]<ci.white[j,2]) ci.white[j,2]<-ci2[j]
  #  if (ci2[j]>ci.white[j,3]) ci.white[j,3]<-ci2[j]
  #}
  ci.white[ci2<ci.white[,2],2]<-ci2[ci2<ci.white[,2]]
  ci.white[ci2>ci.white[,3],3]<-ci2[ci2>ci.white[,3]]
  cat(k,"\n")
}

prace<-sample(race.demog)
x<-NULL
for (i in 1:888) {
  id<-d.wages3[i,1]
  y<-cbind(d.wages1[d.wages1[,1]==id,2:3],
    rep(prace[i],length(d.wages1[d.wages1[,1]==id,2])))
  x<-rbind(x,y)
}
ci.hispanic<-cbind(seq(0.1,12,by=0.1),
    predict(loess(x[x[,3]=="hispanic",1]~x[x[,3]=="hispanic",2],span=0.3),
    data.frame(seq(0.1,12,by=0.1))))
ci.hispanic<-ci.hispanic[,c(1,2,2)]
# run 5, 10, 
for (k in 1:100) {
  prace<-sample(race.demog)
  x<-NULL
  for (i in 1:888) {
    id<-d.wages3[i,1]
    y<-cbind(d.wages1[d.wages1[,1]==id,2:3],
      rep(prace[i],length(d.wages1[d.wages1[,1]==id,2])))
    x<-rbind(x,y)
  }
  ci2<-predict(loess(x[x[,3]=="hispanic",1]~x[x[,3]=="hispanic",2],span=0.3),
    data.frame(seq(0.1,12,by=0.1)))
  #for (j in 1:120) {
  #  if (ci2[j]<ci.hispanic[j,2]) ci.hispanic[j,2]<-ci2[j]
  #  if (ci2[j]>ci.hispanic[j,3]) ci.hispanic[j,3]<-ci2[j]
  #}
  ci.hispanic[ci2<ci.hispanic[,2],2]<-ci2[ci2<ci.hispanic[,2]]
  ci.hispanic[ci2>ci.hispanic[,3],3]<-ci2[ci2>ci.hispanic[,3]]
  cat(k,"\n")
}

prace<-sample(race.demog)
x<-NULL
for (i in 1:888) {
  id<-d.wages3[i,1]
  y<-cbind(d.wages1[d.wages1[,1]==id,2:3],
    rep(prace[i],length(d.wages1[d.wages1[,1]==id,2])))
  x<-rbind(x,y)
}
ci.black<-cbind(seq(0.1,12,by=0.1),
    predict(loess(x[x[,3]=="black",1]~x[x[,3]=="black",2],span=0.3),
    data.frame(seq(0.1,12,by=0.1))))
#ci.black<-cbind(seq(0.1,12,by=0.1),
#    predict(loess(x[x[,3]=="black",1]~x[x[,3]=="black",2],span=0.3),
#    data.frame(seq(0.1,12,by=0.1))))
ci.black<-ci.black[,c(1,2,2)]
for (k in 1:100) {
  prace<-sample(race.demog)
  x<-NULL
  for (i in 1:888) {
    id<-d.wages3[i,1]
    y<-cbind(d.wages1[d.wages1[,1]==id,2:3],
      rep(prace[i],length(d.wages1[d.wages1[,1]==id,2])))
    x<-rbind(x,y)
  }
  ci2<-predict(loess(x[x[,3]=="black",1]~x[x[,3]=="black",2],span=0.3),
    data.frame(seq(0.1,12,by=0.1)))
  #for (j in 1:120) {
  #  if (ci2[j]<ci.black[j,2]) ci.black[j,2]<-ci2[j]
  #  if (ci2[j]>ci.black[j,3]) ci.black[j,3]<-ci2[j]
  #}
  ci.black[ci2<ci.black[,2],2]<-ci2[ci2<ci.black[,2]]
  ci.black[ci2>ci.black[,3],3]<-ci2[ci2>ci.black[,3]]
  cat(k,"\n")
}

postscript("wages-race-ci.ps",width=8.0,height=5.0,horizontal=FALSE,
  paper="special",family="URWHelvetica")
par(mfrow=c(1,3))
plot(ci.white[,1],ci.white[,2],type="l",ylim=c(1,4),lty=2,xlab="Experience",
  ylab="Wages")
lines(ci.white[,1],ci.white[,3],lty=2)
lines(lowess(x[race=="white",2],x[race=="white",1],f=0.3),lty=1,lwd=2)
title("White")

plot(ci.hispanic[,1],ci.hispanic[,2],type="l",ylim=c(1,4),lty=2,
  xlab="Experience",ylab="Wages")
lines(ci.hispanic[,1],ci.hispanic[,3],lty=2)
lines(lowess(x[race=="hispanic",2],x[race=="hispanic",1],f=0.3),lty=1,lwd=2)
title("Hispanic")

plot(ci.black[,1],ci.black[,2],type="l",ylim=c(1,4),lty=2,xlab="Experience",
  ylab="Wages")
lines(ci.black[,1],ci.black[,3],lty=2)
lines(lowess(x[race=="black",2],x[race=="black",1],f=0.3),lty=1,lwd=2)
title("Black")
dev.off()

# Find the people who started off with high salaries
setColors.ggobi(colors=rep(3,6402),which=c(1:6402))
setGlyphs.ggobi(types=rep(0,6402),which=c(1:6402))
earlyhigh<-NULL
for (i in 1:888)
{
  id<-d.wages3[i,1]
  indx<-c(1:6402)
  indx<-indx[d.wages1[,1]==id]
  if (d.wages1[indx[1],2]>3) {
    earlyhigh<-c(earlyhigh,indx)
  }
}
setColors.ggobi(colors=rep(5,length(earlyhigh)),which=earlyhigh)
setGlyphs.ggobi(types=rep(5,length(earlyhigh)),sizes=rep(3,length(earlyhigh)),
  which=earlyhigh)

# Find interesting individuals
# This measures the volatility of an individual
indsd<-NULL
for (i in 1:888)
{
  id<-d.wages3[i,1]
  indx<-c(1:6402)
  indx<-indx[d.wages1[,1]==id]
  indsd<-c(indsd,sd(d.wages1[indx,2]))
}
addVariable.ggobi(indsd,"SDWages",.data=3)

# This measures smoothly upward trend
indup<-NULL
for (i in 1:888)
{
  chngsgn<-1
  id<-d.wages3[i,1]
  indx<-c(1:6402)
  indx<-indx[d.wages1[,1]==id]
  if (length(indx)>1) {
    difs<-NULL
    for (j in 2:length(indx))
      difs<-c(difs,d.wages1[indx[j],2]-d.wages1[indx[j]-1,2])
    way<-sum(sign(difs))
    if (way<0) chngsgn<-(-1)
  }
  else
    difs<-c(difs,-1)
  indup<-c(indup,sd(difs)*chngsgn)
}
addVariable.ggobi(indup,"UpWages",.data=3)
