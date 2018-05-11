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
data1= [ones(size(data1,1),1) data1];
data2= [ones(size(data2,1),1) data2];
data3= [ones(size(data3,1),1) data3];


% Normalizing Dataset
% wholedata = [data1; data2; data3];
% wholedata = normalizescores(wholedata,3);
% 
% data1 = wholedata(1:length(data1),:);
% data2 = wholedata(length(data1)+1:length(data1)+length(data2),:);
% data3 = wholedata(length(data1)+length(data2)+1:end,:);

% Normalizing Individual Classes
% data1 = normalizescores(data1,2);
% data2 = normalizescores(data2,2);
% data3 = normalizescores(data3,2);

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
%data = normalizescores(data,3);

% data1 = data(1:size(data1,1),:);
% data2 = data(size(data1,1)+1:size(data1,1)+size(data2,1),:);
% data3 = data(size(data1,1)+size(data2,1)+1:end,:);



%% Perceptron one by one
% 
% w1 = zeros(24,1);
% for i = 1:24
%     w1(i,1) = randi();
% end
% 
% eta = 0.1;
% newdata2 = newdata2*(-1);
% 
% data = [ newdata1;newdata2];
% i=1;
% k=1;
% while k < 100000 && i ~= size(data,1)
%     val = w1'*data(i,:)';
%     if val < 0
%         i=0;
%         w1= w1 + eta*data(i,:);
%     end
%     i = i + 1;
%     k = k + 1;
% end
% 
% 
% w2 = zeros(24,1);
% for i = 1:24
%     w2(i,1) = randi();
% end
% 
% eta = 0.1;
% newdata3 = newdata3*(-1);
% 
% data = [ newdata2;newdata3];
% i=1;
% k=1;
% while k < 100000 && i ~= size(data,1)
%     val = w2'*data(i,:)';
%     if val < 0
%         i=0;
%         w2 = w2 + eta*data(i,:);
%     end
%     i = i + 1;
%     k = k + 1;
% end

%% Perceptron summation

num =100;

w11 = zeros(24,1);
for i = 1:24
    w11(i,1) = rand();
end

eta = 0.01; 

data = [ tdata1;tdata2*(-1);tdata3*(-1)];
itr=0;
miss = 1;
while itr < num
    miss=0;
    misssum=0;
    for j = 1:size(data,1)
        val = w11'*data(j,:)';
        if val < 0
            miss = miss + 1;
            misssum = misssum + data(j,:);
        end
    end
    if miss > 0
        w11 = w11 + eta*misssum';
    else
        break;
    end
    itr = itr  + 1;    
end


w22 = zeros(24,1);
for i = 1:24
    w22(i,1) = rand();
end

eta = 0.01;

data = [ tdata2;tdata3*(-1);tdata1*(-1)];
itr=0;
while itr< num
    miss=0;
    misssum=0;
    for i = 1: size(data,1)
        val = w22'*data(i,:)';
        if val < 0
            miss = miss + 1;
            misssum = misssum + data(i,:);
        end
    end  
    if miss > 0
        w22 = w22 + eta*misssum';
    else
        break;
    end
    itr = itr  + 1;    
end


w33 = zeros(24,1);
for i = 1:24
    w33(i,1) = rand();
end

eta = 0.01;

data = [ tdata3;tdata1*(-1);tdata2*(-1)];
itr=0;
while itr< num
    miss=0;
    misssum=0;
    for i = 1: size(data,1)
        val = w33'*data(i,:)';
        if val < 0
            miss = miss + 1;
            misssum = misssum + data(i,:);
        end
    end    
    if miss > 0
        w33 = w33 + eta*misssum';
    else 
        break;
    end
    itr = itr  + 1;    
end

%% Classification


test = [ttdata1;ttdata2;ttdata3];

predictclass = zeros(size(test,1)/36,1);
f = 1;
i = 1;
scores = zeros(size(test,1),3);
while i <= (size(test,1)-35)   
    k=1;
    count= zeros(3,1);
    while k < 37
        scores(i,1) = test(i,:)*w11 ;
        if scores(i,1) > 0
            count(1,1) = count(1,1) + 1;
        end
        scores(i,2) = test(i,:)*w22;
        if test(i,:)*w22 > 0
            count(2,1) = count(2,1) + 1;
        end
        scores(i,3) = test(i,:)*w33;
        if test(i,:)*w33 > 0
            count(3,1) = count(3,1) + 1;
        end
        k = k + 1;
        i = i + 1;
    end
   [predict, predictclass(f,1)] = max(count);
    f = f + 1;
end
disp(f);
%[predict,predictclass] = max(Z,[],2);

% votingavgunnorm = Z;
% covnormvotingavg = Z;
%meannormvot = Z;

%avgpointcovnorm = avgprob;
%avgpointunnorm = avgprob;


% data1 = Z(1:length(data1extract),:);
% data2 = Z(length(data1extract)+1:length(data1extract)+length(data2extract),:);
% data3 =  Z(length(data1extract)+length(data2extract)+1:end,:);

% figure;
% set(gcf,'Renderer','painters')
% 
% scatter(data1(:,1),data1(:,2),'filled','r');
% hold on;
% scatter(data2(:,1),data2(:,2),'filled','g');
% scatter(data3(:,1),data3(:,2),'filled','b');






%% Confusion Plot

actual = [ 1*ones(1,size(ttdata1,1)/36) 2*ones(1,size(ttdata2,1)/36) 3*ones(1,size(ttdata3,1)/36)];   

myConfusionPlot(predictclass,actual',1);



%% Plotting ROC

%snorm = finalscore;
%sunorm = finalscore;
% votingavgunnorm = Z;
% covnormvotingavg = Z;
%meannormvot = Z;

%avgpointcovnorm = avgprob;
%avgpointunnorm = avgprob;
finalscore = zeros(size(actual,1),3);

for i = 1:size(actual,2)
    finalscore(i,:) = sum(scores((i-1)*36+1:(i-1)*36 +36,:),1);
end

score1 = normalizescores(finalscore(:,1),1);
score2 = normalizescores(finalscore(:,2),1);
score3 = normalizescores(finalscore(:,3),1);

finalscore = [score1 score2 score3];

figure;
myPlotRoc(snorm,actual);
myPlotRoc(sunorm,actual);
t = 0:.25:1;
plot(t,t,'--k');
legend('Variance Normalised','Unnormalised','location','southeast');
 title(['ROC Curve of Image Dataset with Average Distances']);
set(gca,'FontSize',12,'FontWeight','bold')
hold off
print('-djpeg', ['ROC_ImageDataSet_Average.jpg'], '-r300');
close all;

%% Plotting DET

targetn = [snorm(1:40,1); snorm(41:80,2);snorm(81:end,3)];
nontargetn = [snorm(41:end,1); snorm(1:40,2);snorm(81:end,2);snorm(1:80,3)];

targetu = [sunorm(1:40,1); sunorm(41:80,2);sunorm(81:end,3)];
nontargetu = [sunorm(41:end,1); sunorm(1:40,2);sunorm(81:end,2);sunorm(1:80,3)];
 

% demo_main(targetavgu,nontargetavgu,targetavgn,nontargetavgn);
% title(['DET Curve of Image Dataset with Image Mean']);

demo_main(targetu,nontargetu,targetn,nontargetn);
title(['DET Curve of Image Dataset with Average Distances']);

set(gca,'FontSize',12,'FontWeight','bold')
print('-djpeg', ['DET_ImageDataSet_Average.jpg'], '-r300');
close all;

% 
% disp('---------------- END ----------------');


