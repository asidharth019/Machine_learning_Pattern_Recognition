%  clc; clear all; close all

 normmethod = 0;
 minlen = 70;
 vec = 0;

%% Loading data
%  tar('test1.tgz','.');



data1extract = untar('1.tgz','1');
data1extract(1) = [];
data1len = zeros(length(data1extract),1);

for i = 1:length(data1extract)
    temp = dlmread(data1extract{i});
    data1len(i) = temp(1,2);
    temp(1,:) = [];
    temp = normalizescores(temp,normmethod);
    temp = compressToMinLen(temp,minlen);
    if vec == 1
        temp = temp(:)';
    end
    if i == 1
        data1 = temp;
    else
        data1 = [data1; temp];
    end
end



dataoextract = untar('o.tgz','o');
dataolen = zeros(length(dataoextract),1);


for i = 1:length(dataoextract)
    temp = dlmread(dataoextract{i});
    dataolen(i) = temp(1,2);
    temp(1,:) = [];
    temp = normalizescores(temp,normmethod);
    temp = compressToMinLen(temp,minlen);
    if vec == 1
        temp = temp(:)';
    end
        
    if i == 1
        datao = temp;
    else
        datao = [datao; temp];
    end
end



datazextract = untar('z.tgz','z');
datazlen = zeros(length(datazextract),1);

for i = 1:length(datazextract)
    temp = dlmread(datazextract{i});
    datazlen(i) = temp(1,2);
    temp(1,:) = [];
    temp = normalizescores(temp,normmethod);
    temp = compressToMinLen(temp,minlen);
    if vec == 1
        temp = temp(:)';
    end
        
    if i == 1
        dataz = temp;
    else
        dataz = [dataz; temp];
    end
end


datalen = [data1len dataolen datazlen];
maxlen = max(max(datalen));
minlen = min(min(datalen));


%% Seperating training and testing data

data = [data1; datao; dataz];
cdata = [[ones(size(data1,1),1) zeros(size(data1,1),2)]; [zeros(size(datao,1),1) ones(size(datao,1),1) zeros(size(datao,1),1)]; [zeros(size(dataz,1),2) ones(size(dataz,1),1)]];

NN;

%% Getting Testing Data
if vec == 1
 minlen = 1;
end

temp = y(:,1:size(data1,1))';
temp1 = y(:,size(data1,1)+1:size(data1,1)+size(datao,1))';
temp2 = y(:,size(data1,1)+size(datao,1)+1:end)';

tdata1 = data1(1:40*minlen,:);
tdatao = datao(1:40*minlen,:);
tdataz = dataz(1:40*minlen,:);

ttdata1=  temp(40*minlen+1:end,:);
ttdatao=  temp1(40*minlen+1:end,:);
ttdataz=  temp2(40*minlen+1:end,:);

 prob_estimates = [ttdata1; ttdatao; ttdataz];
% ctestdata = [[ones(size(ttdata1,1),1) zeros(size(ttdata1,1),2)]; [zeros(size(ttdatao,1),1) ones(size(ttdatao,1),1) zeros(size(ttdatao,1),1)]; [zeros(size(ttdataz,1),2) ones(size(ttdataz,1),1)]];
% 



%% Calculating Avg Max Probability

prob_estimates_avg = zeros(length(prob_estimates)/minlen,3);
i = 1;
j = i+minlen-1;
for t = 1:length(prob_estimates)/minlen
   
    prob_estimates_avg(t,:) = mean(prob_estimates(i:j,:));
    i = j+1;
    j = i+minlen-1;
       
end

%% Getting Avg Max Probability of prediction

ind = tr.testInd;
testd = data(ind,:);
ctestd = cdata(ind,:);

[cte,actual] = max(ctestd,[],2);


%% Predicting Class

prob_estimates_avg = y(:,ind)';
[predict,predictclass] = max(prob_estimates_avg,[],2);
 actual1 = [ones(1,17) ones(1,17)*2 ones(1,17)*3];
% predictclass = predict_label;
 myConfusionPlot(predictclass',actual1,1,1);


%% Plotting Confusion

%  [ind,fpredicted] = max(scores_linear_avg,[],2);
%  myConfusionPlot(fpredicted',actual,1,1);
%   [ind,fpredicted] = max(scores_gaussian_avg,[],2);
%  myConfusionPlot(fpredicted',actual,1,2);
%   [ind,fpredicted] = max(scores_linear_vector,[],2);
%  myConfusionPlot(fpredicted',actual,2,1);
%   [ind,fpredicted] = max(scores_gaussian_vector,[],2);
%  myConfusionPlot(fpredicted',actual,2,2);

 
 %% Plotting ROC
%  
%  scores_avg = prob_estimates_avg;
% scores_vector = prob_estimates_avg;


 myPlotRoc(scores_avg,actual1);
 myPlotRoc(scores_vector,actual);
 

 
 legend('Max Avg Prob','Speech Vector','Location','southeast');
 
t = 0:.5:1;
plot(t,t,'--k');
title(['ROC Curve of Speech Dataset for NN']);
set(gca,'FontSize',12,'FontWeight','bold')
hold off
print('-djpeg', ['ROC_Speech_NN.jpg'], '-r300');
close all;
 
 
  %% Plotting DET

 
   scores = scores_avg;
  target_linear_avg = [scores(1:17,1); scores(18:34,2); scores(35:51,3)];
  nontarget_linear_avg = [scores(18:51,1); scores(1:17,2); scores(35:51,2); scores(1:34,3)]; 
 
  scores = scores_vector;
   target_gaussian_avg = [scores(1:13,1); scores(14:34,2); scores(35:51,3)];
   nontarget_gaussian_avg = [scores(14:51,1); scores(1:13,2); scores(35:51,2); scores(1:34,3)]; 


test_data.tar1 = target_linear_avg;
test_data.non1 = nontarget_linear_avg;

test_data.tar2 = target_gaussian_avg;
test_data.non2 = nontarget_gaussian_avg;


demo_main(test_data,'big');
title(['DET Curve of Speech Dataset for NN']);
set(gca,'FontSize',12,'FontWeight','bold')
print('-djpeg', ['DET_Speech_NN.jpg'], '-r300');
close all;

