clear;
clc;
x1=xlsread('C:\Users\X_X-lin\Desktop\AVG11.xlsx','B2:B21');
x2=xlsread('C:\Users\X_X-lin\Desktop\AVG11.xlsx','C2:C21');
x3=xlsread('C:\Users\X_X-lin\Desktop\AVG11.xlsx','D2:D21');
x4=xlsread('C:\Users\X_X-lin\Desktop\AVG11.xlsx','E2:E21');
x5=xlsread('C:\Users\X_X-lin\Desktop\AVG11.xlsx','F2:F21');
X=[x1(1:20),x2(1:20),x5(1:20)];
Y=xlsread('C:\Users\X_X-lin\Desktop\AVG11.xlsx','G2:G21');
Y1=Y(1:16);
Y2=Y(17:20);
X1=X(1:16,:);
X2=X(17:20,:);

%%BP net
input_train = X1';
B_train =Y1';
input_test = X2';
B_test =Y2';
setdemorandstream(5);
inputnum=3;
hiddennum=9; 
outputnum=1;
[inputn,inputps]=mapminmax(input_train,0,1);
[outputn,outputps]=mapminmax(B_train);
net=newff(inputn,outputn,hiddennum,{'tansig','purelin'},'trainbr');
W1= net. iw{2, 1};
B1 = net.b{2};
W2 = net.lw{2,1};
B2 = net. b{2};
net.trainParam.epochs=1000;        
net.trainParam.lr=0.01;                   
net.trainParam.goal=0.0001;                    
net=train(net,inputn,outputn);
inputn_test=mapminmax('apply',input_test,inputps);
Bn1_sim=sim(net,inputn); 
Bn_sim=sim(net,inputn_test); 
By1 = mapminmax('reverse',Bn1_sim,outputps);
By2 =mapminmax('reverse',Bn_sim,outputps); 
BR1=1-sum((Y1 -By1').*(Y1-By1')) /sum((Y1-mean(Y1)).*(Y1-mean(Y1)));
BR2=1-sum((Y2 -By2').*(Y2-By2')) /sum((Y2-mean(Y2)).*(Y2-mean(Y2)));

%%ELM net
P_train= X1';
T_train=Y1';
P_test=X2';
T_test=Y2';
setdemorandstream(4);
[Pn_train,inputps] = mapminmax(P_train,-1,1);
Pn_test = mapminmax('apply',P_test,inputps);
[Tn_train,outputps] = mapminmax(T_train,-1,1);
Tn_test = mapminmax('apply',T_test,outputps);
[IW,B,LW,TF,TYPE] = elmtrain(Pn_train,Tn_train,5,'sig',0);
Tn1_sim = elmpredict(Pn_train,IW,B,LW,TF,TYPE);
Tn_sim = elmpredict(Pn_test,IW,B,LW,TF,TYPE);
Ey1 = mapminmax('reverse',Tn1_sim,outputps);
Ey2 = mapminmax('reverse',Tn_sim,outputps);
ER1=1-sum((Y1 -Ey1').*(Y1-Ey1')) /sum((Y1-mean(Y1)).*(Y1-mean(Y1)));
ER2=1-sum((Y2 -Ey2').*(Y2-Ey2')) /sum((Y2-mean(Y2)).*(Y2-mean(Y2)));

%%SVR
model1=svmtrain(Y1,X1,'-s 3 -t 2 -c 65 -g 0.001 -p 0.01 ');
[Sy1,mse1]=svmpredict(Y1,X1,model1);
[Sy2,tmse1]=svmpredict(Y2,X2,model1);
Hmse1=sum((Y1-Sy1).*(Y1-Sy1)) /16;
Hmse2=sum((Y2-Sy2).*(Y2-Sy2)) /4;

SR1=1-sum((Y1 -Sy1).*(Y1-Sy1)) /sum((Y1-mean(Y1)).*(Y1-mean(Y1)));
SR2=1-sum((Y2 -Sy2).*(Y2-Sy2)) /sum((Y2-mean(Y2)).*(Y2-mean(Y2)));

%%RFR
leaf = 1;
ntrees = 200;  %ntree指定随机森林所包含的决策树数目
fboot = 1;
setdemorandstream(5);
b = TreeBagger(ntrees, X1,Y1, 'Method','regression', 'oobvarimp','on', 'surrogate', 'on', 'minleaf',leaf,'FBoot',fboot);
% 使用训练好的模型进行预测
y1 = predict(b, X1);
y2 = predict(b, X2);
R1=1-sum((Y1 -y1).*(Y1-y1)) /sum((Y1-mean(Y1)).*(Y1-mean(Y1)));
R2=1-sum((Y2 -y2).*(Y2-y2)) /sum((Y2-mean(Y2)).*(Y2-mean(Y2)));


%%Figure 6
figure(1)
subplot(2,2,1)
plot(Y1,'r*-','linewidth',2,'MarkerSize',7)
hold on
plot(By1,'MarkerFaceColor',[0.600000023841858 0.200000002980232 1],...
    'Marker','o',...
    'LineStyle','--',...
    'Color',[0.600000023841858 0.200000002980232 1],...
    'linewidth',2,'MarkerSize',6)
hold on
xlim([0 17]);
ylim([-2 3]);
legend('Actual','Predicted')
title('BPR Training set','FontSize',13)
xlabel('Poplar samples')
ylabel('Zscores')

subplot(2,2,2)
plot(Y1,'r*-','linewidth',2,'MarkerSize',7)
hold on
plot(Ey1,'MarkerFaceColor',[0.23137255012989 0.443137258291245 0.337254911661148],...
    'Marker','square',...
    'LineStyle','--',...
    'Color',[0.23137255012989 0.443137258291245 0.337254911661148],...
    'linewidth',2,'MarkerSize',5)
hold on
xlim([0 17]);
ylim([-2 3]);
legend('Actual','Predicted')
title('ELMR Training set','FontSize',13)
xlabel('Poplar samples')
ylabel('Zscores')

subplot(2,2,3)
plot(Y1,'r*-','linewidth',2,'MarkerSize',7)
hold on
plot(Sy1,'^--','Color',[0 0.749 0.749],'MarkerFaceColor',[0 0.749 0.749],...
    'MarkerEdgeColor',[0 0.749 0.749],...
    'linewidth',2,'MarkerSize',6)
hold on
xlim([0 17]);
ylim([-2 3]);
legend('Actual','Predicted')
title('SVR Training set','FontSize',13)
xlabel('Poplar samples')
ylabel('Zscores')

subplot(2,2,4)
plot(Y1,'r*-','linewidth',2,'MarkerSize',7)
hold on
plot(y1,'v--','Color',[0.314 0.314 0.314],'MarkerFaceColor',[0.314 0.314 0.314],...
    'MarkerEdgeColor',[0.314 0.314 0.314],...
    'linewidth',2,'MarkerSize',6)
hold on
xlim([0 17]);
ylim([-2 3]);
legend('Actual','Predicted')
title('RFR Training set','FontSize',13)
xlabel('Poplar samples')
ylabel('Zscores')


figure(2)
subplot(2,2,1)
plot(Y1,Y1,'Color',[1 0 0],'LineWidth',2);
hold on
scatter(Y1,By1,'MarkerFaceColor',[0.600000023841858 0.200000002980232 1],...
    'MarkerEdgeColor',[0.600000023841858 0.200000002980232 1],...
    'Marker','o',...
    'LineWidth',1);
hold on
xlim([-1.5 1.5]);
ylim([-1.5 1.5]);
xlabel('Actual','FontSize',9)
ylabel('Predicted','FontSize',9)
title(['BPR Training set, R^2=' num2str(BR1)],'FontSize',13)
subplot(2,2,2)
plot(Y1,Y1,'Color',[1 0 0],'LineWidth',2);
hold on
scatter(Y1,Ey1,'MarkerFaceColor',[0.23137255012989 0.443137258291245 0.337254911661148],...
    'MarkerEdgeColor',[0.23137255012989 0.443137258291245 0.337254911661148],...
    'Marker','square',...
    'LineWidth',1);
hold on
xlim([-1.5 1.5]);
ylim([-1.5 1.5]);
xlabel('Actual','FontSize',9)
ylabel('Predicted','FontSize',9)
title(['ELMR Training set, R^2=' num2str(ER1)],'FontSize',13)
subplot(2,2,3)
plot(Y1,Y1,'Color',[1 0 0],'LineWidth',2);
hold on
scatter(Y1,Sy1,'MarkerFaceColor',[0 0.749 0.749],...
    'MarkerEdgeColor',[0 0.749 0.749],...
    'Marker','^',...
    'LineWidth',1);
hold on
xlim([-1.5 1.5]);
ylim([-1.5 1.5]);
xlabel('Actual','FontSize',9)
ylabel('Predicted','FontSize',9)
title(['SVR Training set, R^2=' num2str(SR1,4)],'FontSize',13)
subplot(2,2,4)
plot(Y1,Y1,'Color',[1 0 0],'LineWidth',2);
hold on
scatter(Y1,y1,'MarkerFaceColor',[0.314 0.314 0.314],...
    'MarkerEdgeColor',[0.314 0.314 0.314],...
    'Marker','v',...
    'LineWidth',1);
hold on
xlim([-1.5 1.5]);
ylim([-1.5 1.5]);
xlabel('Actual','FontSize',9)
ylabel('Predicted','FontSize',9)
title(['RFR Training set, R^2=' num2str(R1,4)],'FontSize',13)

figure(3)
subplot(1,2,1)
plot(Y1,'r*-','linewidth',2,'MarkerSize',7)
hold on;
plot(By1,'MarkerFaceColor',[0.600000023841858 0.200000002980232 1],...
    'Marker','o',...
    'LineStyle','--',...
    'Color',[0.600000023841858 0.200000002980232 1],...
    'linewidth',2,'MarkerSize',6)
hold on;
plot(Ey1,'MarkerFaceColor',[0.23137255012989 0.443137258291245 0.337254911661148],...
    'Marker','square',...
    'LineStyle','--',...
    'Color',[0.23137255012989 0.443137258291245 0.337254911661148],...
    'linewidth',2,'MarkerSize',6)
hold on;
plot(Sy1,'^--','Color',[0 0.749 0.749],'MarkerFaceColor',[0 0.749 0.749],...
    'MarkerEdgeColor',[0 0.749 0.749],...
    'linewidth',2,'MarkerSize',6)
hold on
plot(y1,'v--','Color',[0.314 0.314 0.314],'MarkerFaceColor',[0.314 0.314 0.314],...
    'MarkerEdgeColor',[0.314 0.314 0.314],...
    'linewidth',2,'MarkerSize',6)
hold on
xlim([0 17]);
ylim([-2 3]);
legend('Actual','BPR','ELMR','SVR','RFR')
title('Four methods','FontSize',14)
xlabel('Poplar samples')
ylabel('Zscores')

subplot(1,2,2)
plot(Y1,Y1,'r','LineWidth',2);
hold on
scatter(Y1,By1,'MarkerFaceColor',[0.600000023841858 0.200000002980232 1],...
    'MarkerEdgeColor',[0.600000023841858 0.200000002980232 1],...
    'Marker','o',...
    'LineWidth',1);
scatter(Y1,Ey1,'MarkerFaceColor',[0.23137255012989 0.443137258291245 0.337254911661148],...
    'MarkerEdgeColor',[0.23137255012989 0.443137258291245 0.337254911661148],...
    'Marker','square',...
    'LineWidth',1);
scatter(Y1,Sy1,'MarkerFaceColor',[0 0.749 0.749],...
    'MarkerEdgeColor',[0 0.749 0.749],...
    'Marker','^',...
    'LineWidth',1);
scatter(Y1,y1,'MarkerFaceColor',[0.314 0.314 0.314],...
    'MarkerEdgeColor',[0.314 0.314 0.314],...
    'Marker','v',...
    'LineWidth',1);
xlim([-1.5 1.5]);
ylim([-2 2]);
legend('Actual','BPR','ELMR','SVR','RFR')
title('Four methods','FontSize',14)
xlabel('Actual')
ylabel('Predicted')

%% Figure 8
figure(6)
subplot(2,2,1)
plot(Y2,'r*-','linewidth',2,'MarkerSize',7)
hold on
plot(By2,'MarkerFaceColor',[0.600000023841858 0.200000002980232 1],...
    'Marker','o',...
    'LineStyle','--',...
    'Color',[0.600000023841858 0.200000002980232 1],...
    'linewidth',2,'MarkerSize',6)
hold on
xlim([0.8,4.2])
ylim([-2,2])
legend('Actual','Predicted')
title('BPR Test set','FontSize',13)
xlabel('Poplar samples')
ylabel('Zscores')
subplot(2,2,2)
plot(Y2,'r*-','linewidth',2,'MarkerSize',7)
hold on
plot(Ey2,'MarkerFaceColor',[0.23137255012989 0.443137258291245 0.337254911661148],...
    'Marker','square',...
    'LineStyle','--',...
    'Color',[0.23137255012989 0.443137258291245 0.337254911661148],...
    'linewidth',2,'MarkerSize',5)
legend('Actual','Predicted')
hold on
xlim([0.8,4.2])
ylim([-2,2])
title('ELMR Test set','FontSize',13)
xlabel('Poplar samples')
ylabel('Zscores')
subplot(2,2,3)
plot(Y2,'r*-','linewidth',2,'MarkerSize',7)
hold on
plot(Sy2,'^--','Color',[0 0.749 0.749],'MarkerFaceColor',[0 0.749 0.749],...
    'MarkerEdgeColor',[0 0.749 0.749],...
    'linewidth',2,'MarkerSize',6)
hold on
xlim([0.8,4.2])
ylim([-2,2])
legend('Actual','Predicted')
title('SVR Test set','FontSize',13)
xlabel('Poplar samples')
ylabel('Zscores')
subplot(2,2,4)
plot(Y2,'r*-','linewidth',2,'MarkerSize',7)
hold on
plot(y2,'v--','Color',[0.314 0.314 0.314],'MarkerFaceColor',[0.314 0.314 0.314],...
    'MarkerEdgeColor',[0.314 0.314 0.314],...
    'linewidth',2,'MarkerSize',6)
hold on;
xlim([0.8,4.2])
ylim([-2,2])
legend('Actual','Predicted')
title('RFR Test set','FontSize',13)
xlabel('Poplar samples')
ylabel('Zscores')

figure(7)
subplot(2,2,1)
plot(Y2,Y2,'Color',[1 0 0],'LineWidth',2);
hold on
scatter(Y2,By2,'MarkerFaceColor',[0.600000023841858 0.200000002980232 1],...
    'MarkerEdgeColor',[0.600000023841858 0.200000002980232 1],...
    'Marker','o',...
    'LineWidth',1);
hold on
xlim([-1.5 1.5]);
ylim([-1.5 1.5]);
xlabel('Actual','FontSize',9)
ylabel('Predicted','FontSize',9)
title(['BPR Test set, R^2=' num2str(BR2)],'FontSize',13)

subplot(2,2,2)
plot(Y2,Y2,'Color',[1 0 0],'LineWidth',2);
hold on
scatter(Y2,Ey2,'MarkerFaceColor',[0.23137255012989 0.443137258291245 0.337254911661148],...
    'MarkerEdgeColor',[0.23137255012989 0.443137258291245 0.337254911661148],...
    'Marker','square',...
    'LineWidth',1);
hold on
xlim([-1.5 1.5]);
ylim([-1.5 1.5]);
xlabel('Actual','FontSize',9)
ylabel('Predicted','FontSize',9)
title(['ELMR Test set, R^2=' num2str(ER2)],'FontSize',13)

subplot(2,2,3)
plot(Y2,Y2,'Color',[1 0 0],'LineWidth',2);
hold on
scatter(Y2,Sy2,'MarkerFaceColor',[0 0.749 0.749],...
    'MarkerEdgeColor',[0 0.749 0.749],...
    'Marker','^',...
    'LineWidth',1);
hold on
xlim([-1.5 1.5]);
ylim([-1.5 1.5]);
xlabel('Actual','FontSize',9)
ylabel('Predicted','FontSize',9)
title(['SVR Test set, R^2=' num2str(SR2,4)],'FontSize',13)

subplot(2,2,4)
plot(Y2,Y2,'Color',[1 0 0],'LineWidth',2);
hold on
scatter(Y2,y2,'MarkerFaceColor',[0.314 0.314 0.314],...
    'MarkerEdgeColor',[0.314 0.314 0.314],...
    'Marker','v',...
    'LineWidth',1);
hold on
xlim([-1.5 1.5]);
ylim([-1.5 1.5]);
xlabel('Actual','FontSize',9)
ylabel('Predicted','FontSize',9)
title(['RFR Test set, R^2=' num2str(R2)],'FontSize',13)

figure(8)
subplot(1,2,1)
plot(Y2,'r*-','linewidth',2,'MarkerSize',7)
hold on;
plot(By2,'MarkerFaceColor',[0.600000023841858 0.200000002980232 1],...
    'Marker','o',...
    'LineStyle','--',...
    'Color',[0.600000023841858 0.200000002980232 1],...
    'linewidth',2,'MarkerSize',6)
hold on;
plot(Ey2,'MarkerFaceColor',[0.23137255012989 0.443137258291245 0.337254911661148],...
    'Marker','square',...
    'LineStyle','--',...
    'Color',[0.23137255012989 0.443137258291245 0.337254911661148],...
    'linewidth',2,'MarkerSize',6)
hold on;
plot(Sy2,'^--','Color',[0 0.749 0.749],'MarkerFaceColor',[0 0.749 0.749],...
    'MarkerEdgeColor',[0 0.749 0.749],...
    'linewidth',2,'MarkerSize',6)
hold on
plot(y2,'v--','Color',[0.314 0.314 0.314],'MarkerFaceColor',[0.314 0.314 0.314],...
    'MarkerEdgeColor',[0.314 0.314 0.314],...
    'linewidth',2,'MarkerSize',6)
hold on
xlim([0.8 4.2]);
ylim([-2 3]);
legend('Actual','BPR','ELMR','SVR','RFR')
title('Four methods','FontSize',14)
xlabel('Poplar samples')
ylabel('Zscores')

subplot(1,2,2)
plot(Y1,Y1,'r','LineWidth',2);
hold on
scatter(Y1,By1,'MarkerFaceColor',[0.600000023841858 0.200000002980232 1],...
    'MarkerEdgeColor',[0.600000023841858 0.200000002980232 1],...
    'Marker','o',...
    'LineWidth',1);
scatter(Y1,Ey1,'MarkerFaceColor',[0.23137255012989 0.443137258291245 0.337254911661148],...
    'MarkerEdgeColor',[0.23137255012989 0.443137258291245 0.337254911661148],...
    'Marker','square',...
    'LineWidth',1);
scatter(Y1,Sy1,'MarkerFaceColor',[0 0.749 0.749],...
    'MarkerEdgeColor',[0 0.749 0.749],...
    'Marker','^',...
    'LineWidth',1);
scatter(Y1,y1,'MarkerFaceColor',[0.314 0.314 0.314],...
    'MarkerEdgeColor',[0.314 0.314 0.314],...
    'Marker','v',...
    'LineWidth',1);
xlim([-1.5 1.5]);
ylim([-2 2]);
legend('Actual','BPR','ELMR','SVR','RFR')
title('Four methods','FontSize',14)
xlabel('Actual')
ylabel('Predicted')


BRmse1=sqrt(sum((Y1'-By1).*(Y1'-By1)) /16);
BRmse2=sqrt(sum((Y2'-By2).*(Y2'-By2)) /4);

ERmse1=sqrt(sum((Y1'-Ey1).*(Y1'-Ey1)) /16);
ERmse2=sqrt(sum((Y2'-Ey2).*(Y2'-Ey2)) /4);

SRmse1=sqrt(sum((Y1-Sy1).*(Y1-Sy1)) /16);
SRmse2=sqrt(sum((Y2-Sy2).*(Y2-Sy2)) /4);

Rmse1=sqrt(sum((Y1-y1).*(Y1-y1)) /16);
Rmse2=sqrt(sum((Y2-y2).*(Y2-y2)) /4);

Bmae1=sum(abs(Y1'-By1))/16;
Emae1=sum(abs(Y1'-Ey1))/16;
Smae1=sum(abs(Y1-Sy1))/16;
Rmae1=sum(abs(Y1-y1))/16;

Bmae2=sum(abs(Y2'-By2))/4;
Emae2=sum(abs(Y2'-Ey2))/4;
Smae2=sum(abs(Y2-Sy2))/4;
Rmae2=sum(abs(Y2-y2))/4;

BRmse1,BRmse2
ERmse1,ERmse2
SRmse1,SRmse2
Rmse1,Rmse2

Bmae1,Bmae2
Emae1,Emae2
Smae1,Smae2
Rmae1,Rmae2

%%Figure A1 - MLR
MX=[x1(1:20),x2(1:20),x5(1:20)];
MX1=MX(1:16,:);
MX2=MX(17:20,:);
[b1,bint,r,rint,stats1]=regress(Y1,MX1);
Ly1=MX1*b1;
Ly2=MX2*b1;
Lmse1=sum((Y1-Ly1).*(Y1-Ly1)) /16;
Lmse2=sum((Y2-Ly2).*(Y2-Ly2)) /4;
LR1=1-sum((Y1 -Ly1).*(Y1-Ly1)) /sum((Y1-mean(Y1)).*(Y1-mean(Y1)));
LR2=1-sum((Y2 -Ly2).*(Y2-Ly2)) /sum((Y2-mean(Y2)).*(Y2-mean(Y2)));
stats1

figure(9)
subplot(2,2,1)
plot(Y1,'r*-','linewidth',2,'MarkerSize',7)
hold on
plot(Ly1,'b+--','linewidth',2,'MarkerSize',6)
hold on
xlim([0 17]);
ylim([-2 3]);
legend('Actual','Predicted')
title('MLR Training set','FontSize',13)
xlabel('Poplar samples')
ylabel('Zscores')

subplot(2,2,2)
plot(Y1,Y1,'Color',[1 0 0],'LineWidth',2);
hold on
scatter(Y1,Ly1,'MarkerFaceColor',[0 0 1],'MarkerEdgeColor',[0 0 1],...
    'Marker','+',...
    'LineWidth',2);
hold on
xlim([-1.5 1.5]);
ylim([-1.5 1.5]);
xlabel('Actual','FontSize',9)
ylabel('Predicted','FontSize',9)
title(['MLR Training set, R^2=' num2str(LR1)],'FontSize',13)

subplot(2,2,3)
plot(Y2,'r*-','linewidth',2,'MarkerSize',7)
hold on
plot(Ly2,'b+--','linewidth',2,'MarkerSize',6)
hold on
xlim([0.8 4.2]);
ylim([-2 3]);
legend('Actual','Predicted')
title('MLR Test set','FontSize',13)
xlabel('Poplar samples')
ylabel('Zscores')

subplot(2,2,4)
plot(Y2,Y2,'Color',[1 0 0],'LineWidth',2);
hold on
scatter(Y2,Ly2,'MarkerFaceColor',[0 0 1],'MarkerEdgeColor',[0 0 1],...
    'Marker','+',...
    'LineWidth',2);
hold on
xlim([-1.5 1.5]);
ylim([-1.5 1.5]);
xlabel('Actual','FontSize',9)
ylabel('Predicted','FontSize',9)
title(['MLR Test set, R^2=' num2str(LR2)],'FontSize',13)

LRmse1=sqrt(sum((Y1-Ly1).*(Y1-Ly1)) /16)
LRmse2=sqrt(sum((Y2-Ly2).*(Y2-Ly2)) /4)

Lmae1=sum(abs(Y1-Ly1))/16
Lmae2=sum(abs(Y2-Ly2))/4

