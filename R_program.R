##Figure 2
data<-read.csv("11.csv",header = T) 
#install.packages("ggpubr")
library("ggpubr")
p<-ggviolin(data, x="Methods",y ="Values",color="Values",fill="Methods",
            palette = c("#56B4E9", "#009E73","#E69F00"),
            xlab="Evaluation methods",ylab="Values",draw_quantiles = 1,
            title="Value distribution of evaluation methods",add="jitter",error.plot = "pointrange",
            size=0.1,width=0.8,notch=T,orientation = "horizontal",
            add.params = list(color="Values",shape="Methods",size = 2,fill="Value"),label.rectangle=T)
p+scale_color_gradient(low="#4B0082",high="#9370DB")+ylim(-4,4)+
  geom_segment(aes(x = 0.7, y =-2.08629, xend = 1.3, yend = -2.08629),color="red",
               size=0.3,linetype="dashed")+
  geom_segment(aes(x = 0.7, y =1.998851, xend = 1.3, yend = 1.998851),color="red",
               size=0.3,linetype="dashed")+
  geom_segment(aes(x = 1.7, y = -3.082816, xend = 2.3, yend =  -3.082816),color="red",
               size=0.3,linetype="dashed")+
  geom_segment(aes(x = 1.7, y =3.005776, xend = 2.3, yend = 3.005776),color="red",
               size=0.3,linetype="dashed")+
  geom_segment(aes(x = 2.7, y =-2.795795, xend = 3.3, yend = -2.795795),color="red",
               size=0.3,linetype="dashed")+
  geom_segment(aes(x = 2.7, y =2.662503, xend = 3.3, yend = 2.662503),color="red",
               size=0.3,linetype="dashed")

##Figure 3
#Figure 3(a)
#install.packages("corrplot")
library("corrplot")
data<-read.csv("C:/Users/X_X-lin/Desktop/AVG.csv",header = T,row.names=NULL) 
res<-cor(data[,2:28])
corr<-cor.mtest(data[,2:28])
colnames(res) <- c("AHs/Cs","C2sfc","Ci/Ca","Ci_Pa","CndCO2","CndTotal","CO2S","Cond",
                   "CTleaf","Fo","Fm","Fv","H20diff","H2o_i","H2OS","Photo","PARabs",
                   "PhiCO2","qN_Fo","RH_S","SVTleaf","Trans","VpdL","CO2S/CO2R",
                   "H2OS/H2OR","RH_S/RH_R","Zscore")
rownames(res) <- c("AHs/Cs","C2sfc","Ci/Ca","Ci_Pa","CndCO2","CndTotal","CO2S","Cond",
                   "CTleaf","Fo","Fm","Fv","H20diff","H2o_i","H2OS","Photo","PARabs",
                   "PhiCO2","qN_Fo","RH_S","SVTleaf","Trans","VpdL","CO2S/CO2R",
                   "H2OS/H2OR","RH_S/RH_R","Zscore")
color<-colorRampPalette(c("#1366AC","#55BCF6","#E7F2F3","#FF9E9D","#FF3D7F"))(100)
corrplot(res, tl.col ="black",order = "hclust",method="pie", col=color,
         p.mat=corr$p,insig = "blank")

#Figure 3(b)
#install.packages("corrplot")
library("corrplot")
data<-read.csv("C:/Users/X_X-lin/Desktop/corr13.csv",header = T,row.names=NULL) 
res<-cor(data[,2:8])
corr<-cor.mtest(data[,2:8])
colnames(res) <- c("Fm","Fv","H2OS","qN_Fo","H2OS/H2OR","RH_S/RH_R","Zscore")
rownames(res) <- c("Fm","Fv","H2OS","qN_Fo","H2OS/H2OR","RH_S/RH_R","Zscore")
color<-colorRampPalette(c("#1366AC","#55BCF6","#E7F2F3","#FF9E9D","#FF3D7F"))(100)
corrplot(res, tl.col ="black",order = "hclust",method="pie", col=color,
         p.mat=corr$p,insig = "blank")

#Figure 3(c)
#install.packages("corrplot")
library("corrplot")
data<-read.csv("C:/Users/X_X-lin/Desktop/corr13.csv",header = T,row.names=NULL) 
res<-cor(data[,2:8])
corr<-cor.mtest(data[,2:8])
colnames(res) <- c("Fm","Fv","H2OS","qN_Fo","H2OS/H2OR","RH_S/RH_R","Zscore")
rownames(res) <- c("Fm","Fv","H2OS","qN_Fo","H2OS/H2OR","RH_S/RH_R","Zscore")
corrplot(res, tl.col ="black",order = "hclust",method="number", col="#0000CD",cl.pos="n",
         p.mat=corr$p,insig = "blank")
corrplot(corr = cor(data[,2:12]),add=TRUE, type="upper", method="number",
         order="hclust", col="#0000CD",diag=FALSE,tl.pos="n", cl.pos="n",
         p.mat=corr$p,insig = "blank")

##Figure 4
library(ggplot2)
library(ggpubr)
library(ggpmisc)
#Fv
df<-read.csv("C:/Users/X_X-lin/Desktop/AVG2.csv",header = T) 
ggscatter(df,x="Fv",y="Zscore",add = "reg.line", conf.int = TRUE,color="#DC143C",    
          shape = 19,size=3,add.params = list(fill = "#87CEFA"))+
  stat_cor( aes(label = paste(..rr.label.., ..p.label.., sep = "~`,`~")),
            method = "pearson", label.x = 450, label.y = 1.35)+
  coord_cartesian(xlim =c(270,610), ylim = c(-1.3, 1.4))+theme_bw()+
  theme(panel.grid=element_blank())
#qN_Fo
df<-read.csv("C:/Users/X_X-lin/Desktop/AVG2.csv",header = T) 
ggscatter(df,x="qN_Fo",y="Zscore",add = "reg.line", conf.int = TRUE,color="#00008B",    
          shape = 18,size=4,add.params = list(fill = "#87CEFA"))+
  stat_cor( aes(label = paste(..rr.label.., ..p.label.., sep = "~`,`~")),
            method = "pearson", label.x = 1.43, label.y = 1.35)+
  coord_cartesian(xlim =c(1.2,1.635), ylim = c(-1.3, 1.4))+theme_bw()+
  theme(panel.grid=element_blank())
#Fm
df<-read.csv("C:/Users/X_X-lin/Desktop/AVG2.csv",header = T) 
ggscatter(df,x="Fm",y="Zscore",add = "reg.line", conf.int = TRUE,color="#9400D3",    
          shape = 15,size=3,add.params = list(fill = "#87CEFA"))+
  stat_cor( aes(label = paste(..rr.label.., ..p.label.., sep = "~`,`~")),
            method = "pearson", label.x = 580, label.y = 1.35)+
  coord_cartesian(xlim =c(380,730), ylim = c(-1.3, 1.4))+theme_bw()+
  theme(panel.grid=element_blank())
#H2OS/H2OR
df<-read.csv("C:/Users/X_X-lin/Desktop/AVG2.csv",header = T) 
ggscatter(df,x="H2OS.H2OR",y="Zscore",add = "reg.line", conf.int = TRUE,color="#008B8B",    
          shape = 17,size=3,add.params = list(fill = "#87CEFA"))+
  stat_cor( aes(label = paste(..rr.label.., ..p.label.., sep = "~`,`~")),
            method = "pearson", label.x = 1.045, label.y = 1.35)+
  coord_cartesian(xlim =c(0.965,1.108), ylim = c(-1.3, 1.4))+theme_bw()+
  theme(panel.grid=element_blank())
#RH_S/RH_R
df<-read.csv("C:/Users/X_X-lin/Desktop/AVG2.csv",header = T) 
ggscatter(df,x="RH_S.RH_R",y="Zscore",add = "reg.line", conf.int = TRUE,color="#FC4E07",    
          shape=25,size=2,fill="#FC4E07",add.params = list(fill = "#87CEFA"))+
  stat_cor( aes(label = paste(..rr.label.., ..p.label.., sep = "~`,`~")),
            method = "pearson", label.x = 1.045, label.y = 1.35)+
  coord_cartesian(xlim =c(0.96,1.11), ylim = c(-1.3, 1.4))+theme_bw()+
  theme(panel.grid=element_blank())

##Figure 5
#Figure 5(a)
#install.packages("pheatmap")
library(pheatmap)
a<-read.csv("C:/Users/X_X-lin/Desktop/Pheatmap.csv",header = T,row.names=1)
df<-scale(a)
b<-read.csv("C:/Users/X_X-lin/Desktop/p1.csv",header = T,row.names=1)
c<-read.csv("C:/Users/X_X-lin/Desktop/p2.csv",header = T,row.names=1)
anno_colors<-list(Fcluster=c(F1="#0000CD",F2="#008B8B",F3="#FFD700"),
                  Vtype=c(A="#DC143C",B="#FF8C00",C="#51449A"))
pheatmap(df,annotation_row = b,annotation_col = c,main="A",angle_col=90,
         cutree_rows=3,cutree_cols=3,
         color<-colorRampPalette(c("#C6DBEF","#DEEBF7","#F7FBFF","#FAF0E6","#FFDAB9","#FF7F50"))(100),
         annotation_colors = anno_colors)
#Figure 5(b)
#install.packages("BiocManager")
#BiocManager::install("ggtree")
library(ggtree)
library(ggplot2)
data<-read.csv("C:/Users/X_X-lin/Desktop/AVG1.csv",header = T,row.names=NULL)
df <- scale(data[,2:6])
rownames(df)<-paste(data$Variety)
hc<-hclust(dist(df),method="complete")
ggtree(hc,layout="circular",size=0.5)+
  geom_tiplab(offset=0.1,size=3,font=3)+
  #geom_text(aes(label=node))+
  geom_highlight(node = 22,fill="#DC143C")+
  geom_highlight(node=24,fill="#FF8C00")+  
  geom_highlight(node=25,fill="#51449A")+
  geom_cladelabel(node=22,label="A",fontsize = 5,
                  offset=2.5,barsize = 5,offset.text=0.6,
                  color="#DC143C")+
  geom_cladelabel(node=24,label="B",fontsize = 5,
                  offset=2.5,barsize = 5,offset.text=0.9,
                  color="#FF8C00")+
  geom_cladelabel(node=25,label="C",fontsize = 5,
                  offset=2.5,barsize = 5,offset.text=0.6,
                  color="#51449A")
#Figure 5(c)
library(ggtree)
library(ggplot2)
a1<-read.csv("C:/Users/X_X-lin/Desktop/AVG1.csv",header = T,row.names=NULL)
a<-read.csv("C:/Users/X_X-lin/Desktop/AVG1.csv",header = T,row.names=1)
df<-scale(a)
b<-t(df)
rownames(df)<-paste(a1$Variety)
hc<-hclust(dist(b),method="complete")
ggtree(hc,layout="circular",size=0.5)+
  geom_tiplab(offset=0.2,size=4,font=3)+
  #geom_text(aes(label=node))+
  geom_highlight(node = 2,fill="#0000CD")+
  geom_highlight(node=8,fill="#008B8B")+  
  geom_highlight(node=9,fill="#FFD700")+
  geom_cladelabel(node=2,label="F1",fontsize = 5,
                  offset=5.5,barsize = 5,offset.text=1,
                  color="#0000CD")+
  geom_cladelabel(node=8,label="F2",fontsize = 5,
                  offset=5.8,barsize = 5,offset.text=2,
                  color="#008B8B")+
  geom_cladelabel(node=9,label="F3",fontsize = 5,
                  offset=5,barsize = 5,offset.text=1,
                  color="#FFD700")



##Figure 7
a <- c(0.5847,0.6401,0.7027,0.8847)
b<-c("BPR","ELMR","SVR","RFR")
barplot(a,names.arg=b,xlab="Methods",ylab = "Values",
        col=c("#F67280","#F8B195","#9fd8df","dodgerblue4"),ylim=c(0,1))
title(main="R^2 of four methods on the training set")

a <- c(0.3680,0.3426,0.3113,0.1940)
b<-c("BPR","ELMR","SVR","RFR")
barplot(a,names.arg=b,xlab="Methods",ylab = "Values",
        col=c("#F67280","#F8B195","#9fd8df","dodgerblue4"),ylim=c(0,0.4))
title(main="RMSE of four methods on the training set")


a <- c(0.3019,0.2741,0.1920,0.1591)
b<-c("BPR","ELMR","SVR","RFR")
barplot(a,names.arg=b,xlab="Methods",ylab = "Values",
        col=c("#F67280","#F8B195","#9fd8df","dodgerblue4"),ylim=c(0,0.4))
title(main="MAE of four methods on the training set")

##Figure 10
a <- c(0.5703,0.6207,0.6864,0.8351)
b<-c("BPR","ELMR","SVR","RFR")
barplot(a,names.arg=b,xlab="Methods",ylab = "Values",
        col=c("#F67280","#F8B195","#9fd8df","dodgerblue4"),ylim=c(0,1))
title(main="R^2 of four methods on the test set")

a <- c(0.3254,0.3057,0.2780,0.2016)
b<-c("BPR","ELMR","SVR","RFR")
barplot(a,names.arg=b,xlab="Methods",ylab = "Values",
        col=c("#F67280","#F8B195","#9fd8df","dodgerblue4"),ylim=c(0,0.4))
title(main="RMSE of four methods on the test set")

a <- c(0.2806,0.2456,0.2032,0.1782)
b<-c("BPR","ELMR","SVR","RFR")
barplot(a,names.arg=b,xlab="Methods",ylab = "Values",
        col=c("#F67280","#F8B195","#9fd8df","dodgerblue4"),ylim=c(0,0.4))
title(main="MAE of four methods on the test set")


##Figure A1
a <- c(0.5616,0.3781,0.3260)
b<-c("R^2","RMSE","MAE")
barplot(a,names.arg=b,xlab="Methods",ylab = "Values",
        col=c("#F67280","#F8B195","#9fd8df"),ylim=c(0,0.6))
title(main="MLR training set")

a <- c(0.5172,0.3449,0.2555)
b<-c("R^2","RMSE","MAE")
barplot(a,names.arg=b,xlab="Methods",ylab = "Values",
        col=c("#F67280","#F8B195","#9fd8df"),ylim=c(0,0.6))
title(main="MLR test set")

##others
#Stepwise
#install.packages("MASS")
library(MASS)
data<-read.csv("C:/Users/X_X-lin/Desktop/Stepwise.csv",header = T,row.names=NULL) 
fit<-lm(data[,7]~data[,2]+data[,3]+data[,4]+data[,5]+data[,6])
stepAIC(fit,direction="backward")
#Lasso
#install.packages("tidyverse")
#install.packages("broom")
#install.packages("glmnet")
library("tidyverse")
library("broom")
library("glmnet")
data<-read.csv("C:/Users/X_X-lin/Desktop/Stepwise.csv",header = T,row.names=NULL)
a<-as.matrix(data[,2:7])
x<-a[1:20,-6]
y<-a[1:20,6]
cvfit=cv.glmnet(x,y,type.measure="mse",nfolds=3,alpha=1)
cvfit$lambda.min
lasso<-glmnet(x,y,family="gaussian",alpha=1)
ridge.coef<-predict(lasso,s=0.04,type="coefficients")
ridge.coef

