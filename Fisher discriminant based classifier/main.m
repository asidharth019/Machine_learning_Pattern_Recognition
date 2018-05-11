%clc; clear all; close all;

%% Getting data and splitting into Training, Validation and Testing
data1extract = untar('highway.tar.gz');

for i = 2:length(data1extract)
    temp = load(data1extract{i});
    if i == 2
        data1 = temp;
    else
        data1 = [data1; temp];
    end
end

data2extract = untar('street.tar.gz');

for i = 2:length(data2extract)
    temp = load(data2extract{i});
    if i == 2
        data2 = temp;
    else
        data2 = [data2; temp];
    end
end

data3extract = untar('tallbuilding.tar.gz');

for i = 2:length(data3extract)
    temp = load(data3extract{i});
    if i == 2
        data3 = temp;
    else
        data3 = [data3; temp];
    end
end

% wholedata = [data1; data2; data3];
% wholedata = normalizescores(wholedata,3);
% 
% data1 = wholedata(1:length(data1),:);
% data2 = wholedata(length(data1)+1:length(data1)+length(data2),:);
% data3 = wholedata(length(data1)+length(data2)+1:end,:);
% 

% Normalizing Individual Classes
% data1 = normalizescores(data1,3);
% data2 = normalizescores(data2,3);
% data3 = normalizescores(data3,3);

% tdata1 = [tdata1; vdata1];
% tdata2 = [tdata2; vdata2];
% tdata3 = [tdata3; vdata3];
tdata1 = data1(1:ceil(.7*(length(data1extract) - 1))*36,:);
ttdata1 = data1(ceil(.845*(length(data1extract) - 1))*36+1:end,:);

tdata2 = data2(1:ceil(.7*(length(data1extract) - 1))*36,:);
ttdata2 = data2(ceil(.86*(length(data2extract) - 1))*36+1:end,:);

tdata3 = data3(1:ceil(.7*(length(data1extract) - 1))*36,:);
ttdata3 = data3(ceil(.885*(length(data3extract) - 1))*36+1:end,:);

tdata = [tdata1;tdata2;tdata3];

X = [ tdata1 ; tdata2 ; tdata3 ];
T = [ones(size(tdata1,1),1) ; 2*ones(size(tdata2,1),1) ; 3*ones(size(tdata3,1),1)];

%% Mean of Probabilities

[Y, W, lambda] = LDA(X, T);


data1 = Y(1:size(tdata1,1),:);
data2 = Y(size(tdata1,1)+1:size(tdata1,1)+size(tdata2,1),:);
data3 =  Y(size(tdata1,1)+size(tdata2,1)+1:end,:);

% for finding the prob.of all point and find avg of 36
m1 = myMean(data1');
m2 = myMean(data2');
m3 = myMean(data3');

cov1 = myCovariance(data2');
cov2 = cov1;
cov3 = cov1;

test1 = [ttdata1;ttdata2;ttdata3];

temp1 = zeros(size(test1,1),1);
temp2 = zeros(size(test1,1),1);
temp3 = zeros(size(test1,1),1);

test = test1*W;

for i=1:size(test,1)    
    temp1(i,1)=myClassProbability( test(i,:)',m1,cov1,m2,cov2,m3,cov3,1);
end

for i=1:size(test,1)
    temp2(i,1)=myClassProbability( test(i,:)',m1,cov1,m2,cov2,m3,cov3,2);
end

for i=1:size(test,1)
    temp3(i,1)=myClassProbability( test(i,:)',m1,cov1,m2,cov2,m3,cov3,3);
end

avgprob = [temp1 temp2 temp3];

Z = zeros(size(test,1)/36,3);
i=1;
len=1;
while len < size(test,1)
    Z(i,:)=sum(avgprob(len:len+35,:),1)/36;
    i=i+1;
    len=len+36;
end


[predict,predictclass] = max(Z,[],2);

%% Mean of Points Method
% 
% [Y, W, lambda] = LDA(X, T);
% 
% data1 = Y(1:size(tdata1,1),:);
% data2 = Y(size(tdata1,1)+1:size(tdata1,1)+size(tdata2,1),:);
% data3 =  Y(size(tdata1,1)+size(tdata2,1)+1:end,:);
% 
% % for finding the prob.of all point and find avg of 36
% m1 = myMean(data1');
% m2 = myMean(data2');
% m3 = myMean(data3');
% 
% cov1 = myCovariance(data1');
% cov2 = myCovariance(data2');
% cov3 = myCovariance(data3');
% 
% 
% test1 = [ttdata1;ttdata2;ttdata3];
% 
% test = zeros(size(test1,1),2);
% for i= 1:size(test1,1)
%     test(i,:)=test1(i,:)*W;
% end
% 
% Z = zeros(size(test,1)/36,2);
% i=1;
% len=1;
% while len < size(test,1)
%     Z(i,:)=sum(test(len:len+35,:),1)/36;
%     i=i+1;
%     len=len+36;
% end
% 
% temp1 = zeros(size(Z,1),1);
% temp2 = zeros(size(Z,1),1);
% temp3 = zeros(size(Z,1),1);
% 
% for i=1:size(Z,1)    
%     temp1(i,1)=myClassProbability( Z(i,:)',m1,cov1,m2,cov2,m3,cov3,1);
% end
% 
% for i=1:size(Z,1)
%     temp2(i,1)=myClassProbability( Z(i,:)',m1,cov1,m2,cov2,m3,cov3,2);
% end
% 
% for i=1:size(Z,1)
%     temp3(i,1)=myClassProbability( Z(i,:)',m1,cov1,m2,cov2,m3,cov3,3);
% end
% 
% avgprob = [temp1 temp2 temp3];
% 
% [predict,predictclass] = max(avgprob,[],2);

%% Plotting points

% a= ttdata1*W;
% b= ttdata2*W;
% c=ttdata3*W;
% figure;
% set(gcf,'Renderer','painters')
% 
% scatter(test(:,1),test(:,2),'filled','r');
% hold on;
% scatter(b(:,1),b(:,2),'filled','g');
% scatter(c(:,1),c(:,2),'filled','b');

% 
% data = Z;
% range = [1*min(data(:,1)) 1*max(data(:,1)) 1*min(data(:,2)) 1*max(data(:,2))];
% %range = [-15 20 -10 20];
% axis(range);
% 
% 
% xvals = linspace(1*min(data(:,1)), 1*max(data(:,1)), 50);
% yvals = zeros(size(xvals));
% yvals1 = zeros(size(xvals));
% yvals2 = zeros(size(xvals));
% 
% [p q r] = case3par(m1,cov1,m2,cov2);
%  f = @(x,y) p(1,1).*(x.^2) + p(1,2).*x.*y + p(2,1).*x.*y + p(2,2).*(y.^2) + q(1,1).*x + q(2,1).*y + r;
% fimplicit(f,range,'--b','LineWidth',3); 
% 
% [p2 q2 r2] = case3par(m2,cov2,m3,cov3);
% f2 = @(x,y) p2(1,1).*(x.^2) + p2(1,2).*x.*y + p2(2,1).*x.*y + p2(2,2).*(y.^2) + q2(1,1).*x + q2(2,1).*y + r2;
% fimplicit(f2,range,'--r','LineWidth',3); 



%% Confusion Plot

actual = [ 1*ones(1,size(ttdata1,1)/36) 2*ones(1,size(ttdata2,1)/36) 3*ones(1,size(ttdata3,1)/36)];   

myConfusionPlot(predictclass,actual',1);



%% Plotting ROC


% votingavgunnorm = Z;
% covnormvotingavg = Z;
%meannormvot = Z;
% wholenorm = avgprob;
% withinnorm = avgprob;
%avgpointcovnorm = avgprob;
%avgpointunnorm = avgprob;

sumavg = sum(votingavgunnorm,2);
sumavgn = votingavgunnorm./sumavg;

sumavg = sum(avgpointunnorm,2);
sumavgu = avgpointunnorm./sumavg;

sumavg = sum(withinnorm,2);
sumvotn = withinnorm./sumavg;

sumavg = sum(wholenorm,2);
sumwhole = wholenorm./sumavg;

figure;
%myPlotRoc(sumavgu,actual);
myPlotRoc(sumavgn,actual);
myPlotRoc(sumwhole,actual);
myPlotRoc(sumvotn,actual);



% figure;
% myPlotRoc(avgpointunnorm,actual);
% myPlotRoc(votingavgunnorm,actual);
% myPlotRoc(wholenorm,actual);
% myPlotRoc(withinnorm,actual);
t = 0:.25:1;
plot(t,t,'--k');
legend('Average Prob.','Variance Normalised','Within Class Normalised','location','southeast');


%title(['ROC Curve of Image Dataset with Image Mean']);
 title(['ROC Curve of Image Dataset for LDA']);
set(gca,'FontSize',12,'FontWeight','bold')
hold off
print('-djpeg', ['ROC_ImageDataSet_LDA.jpg'], '-r300');
% close all;

%% Plotting DET

targetn = [sumavgn(1:40,1); sumavgn(41:80,2);sumavgn(81:end,3)];
nontargetn = [sumavgn(41:end,1); sumavgn(1:40,2);sumavgn(81:end,2);sumavgn(1:80,3)];

targetv = [sumwhole(1:40,1); sumwhole(41:80,2);sumwhole(81:end,3)];
nontargetv = [sumwhole(41:end,1); sumwhole(1:40,2);sumwhole(81:end,2);sumwhole(1:80,3)];
 
targetw = [sumvotn(1:40,1); sumvotn(41:80,2);sumvotn(81:end,3)];
nontargetw = [sumvotn(41:end,1); sumvotn(1:40,2);sumvotn(81:end,2);sumvotn(1:80,3)];

% demo_main(targetavgu,nontargetavgu,targetavgn,nontargetavgn);
% title(['DET Curve of Image Dataset with Image Mean']);

demo_main(targetn,nontargetn,targetv,nontargetv,targetw,nontargetw);
title(['DET Curve of Image Dataset for LDA']);

set(gca,'FontSize',12,'FontWeight','bold')
print('-djpeg', ['DET_ImageDataSet_LDA.jpg'], '-r300');
%close all;

% 
% disp('---------------- END ----------------');


