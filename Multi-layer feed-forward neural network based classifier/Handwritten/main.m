% clc; clear all; close all

 k = 12;
 states=6;
 l = 95;

%% Loading data
%  tar('eight.tgz','.');

inputdataai = dlmread('data_ai.txt');
inputdataba = dlmread('data_bA.txt');
inputdatala = dlmread('data_lA.txt');

lenai = inputdataai(:,1);
lenba = inputdataba(:,1);
lenla = inputdatala(:,1);

[lenai,ainid] = sort(lenai,'descend');
[lenba,baind] = sort(lenba,'descend');
[lenla,laind] = sort(lenla,'descend');


inputdataai = inputdataai(ainid(1:l),:);
inputdataba = inputdataba(baind(1:l),:);
inputdatala = inputdatala(laind(1:l),:);

lenai = lenai(1:l);
lenba = lenba(1:l);
lenla = lenla(1:l);

datalen = [lenai lenba lenla];
datalen = sort(datalen,'descend');
maxlen = max(max(datalen));
minlen = min(min(datalen));

inputdataai(:,1) = [];
inputdataba(:,1) = [];
inputdatala(:,1) = [];

% dataai = zeros(sum(lenai),2);
% databa = zeros(sum(lenba),2);
% datala = zeros(sum(lenla),2);

%% Seperating Training and Testing data

for i = 1:length(lenai)
   index = 1;
   temp = zeros(lenai(i),2);
   for j = 1:2:2*lenai(i)
      temp(index,1) = inputdataai(i,j);
      temp(index,2) = inputdataai(i,j+1);
      index = index + 1;
   end
   
   %scatter(temp(:,1),temp(:,2),'filled');
   fder1 = calculateDerivative(temp);
   sder1 = calculateDerivative(fder1);
   cur1 = calculateCurvature(fder1,sder1);
   temp = [temp fder1 sder1 cur1];
   temp = normalizescores(temp,3);
   temp = compressToMinLen(temp,minlen);
    temp = temp(:)';
   if i == 1
       dataai = temp;
   else
       dataai = [dataai; temp];
   end
end

for i = 1:length(lenba)
   index = 1;
   temp = zeros(lenba(i),2);
   for j = 1:2:2*lenba(i)
      temp(index,1) = inputdataba(i,j);
      temp(index,2) = inputdataba(i,j+1);
      index = index + 1;
   end
   
%     scatter(temp(:,1),temp(:,2),'filled');
   fder1 = calculateDerivative(temp);
   sder1 = calculateDerivative(fder1);
   cur1 = calculateCurvature(fder1,sder1);
   temp = [temp fder1 sder1 cur1];
      temp = normalizescores(temp,3);
   temp = compressToMinLen(temp,minlen);
    temp = temp(:)';
   if i == 1
       databa = temp;
   else
       databa = [databa; temp];
   end
end



for i = 1:length(lenla)
   index = 1;
   temp = zeros(lenla(i),2);
   for j = 1:2:2*lenla(i)
      temp(index,1) = inputdatala(i,j);
      temp(index,2) = inputdatala(i,j+1);
      index = index + 1;
   end
   
%     scatter(temp(:,1),temp(:,2),'filled');
   fder1 = calculateDerivative(temp);
   sder1 = calculateDerivative(fder1);
   cur1 = calculateCurvature(fder1,sder1);
   temp = [temp fder1 sder1 cur1];
     temp = normalizescores(temp,3);
   temp = compressToMinLen(temp,minlen);
    temp = temp(:)';
   if i == 1
       datala = temp;
   else
       datala = [datala; temp];
   end
end

%% Combining all class Training data and Training NN


data = [dataai; databa; datala];
cdata = [[ones(size(dataai,1),1) zeros(size(dataai,1),2)]; [zeros(size(databa,1),1) ones(size(databa,1),1) zeros(size(databa,1),1)]; [zeros(size(datala,1),2) ones(size(datala,1),1)]];

NN;


%% Getting Predicted probabilities from NN

temp = y(:,1:size(dataai,1))';
temp1 = y(:,size(dataai,1)+1:size(dataai,1)+size(databa,1))';
temp2 = y(:,size(dataai,1)+size(databa,1)+1:end)';


ttdata1=  temp(80*minlen+1:end,:);
ttdatao=  temp1(80*minlen+1:end,:);
ttdataz=  temp2(80*minlen+1:end,:);

 prob_estimates = [ttdata1; ttdatao; ttdataz];

%% Getting Testing data

minlen = 1;

data1 = dataai(1:80*minlen,:);
tdata1 = dataai(80*minlen+1:end,:);


data2 = databa(1:80*minlen,:);
tdata2 = databa(80*minlen+1:end,:);


data3 = datala(1:80*minlen,:);
tdata3 = datala(80*minlen+1:end,:);







%% Calculating Max Avg Probability
%   minlen = 28;
  prob_estimates_avg = zeros(length(prob_estimates)/minlen,3);
i = 1;
j = i+minlen-1;
for t = 1:length(prob_estimates)/minlen
   
    prob_estimates_avg(t,:) = mean(prob_estimates(i:j,:));
    i = j+1;
    j = i+minlen-1;
       
end


%% Getting Predicting from NN

ind = tr.testInd;
ind = [2 6 ind];
testd = data(ind,:);
ctestd = cdata(ind,:);

[cte,actual] = max(ctestd,[],2);


prob_estimates_avg = y(:,ind)';


%% Predicting Class Label

[predict,predictclass] = max(prob_estimates_avg,[],2);

actual1 = [ones(1,15) ones(1,15)*2 ones(1,15)*3];
%  predictclass = predict_label;
 myConfusionPlot(predictclass',actual',1,2);
  

%% Plotting Confusion
% 
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

 
 legend('Max Avg Prob','Character Vector','Location','southeast');
 
t = 0:.5:1;
plot(t,t,'--k');
title(['ROC Curve of Handwritten Character Dataset for NN']);
set(gca,'FontSize',12,'FontWeight','bold')
hold off
print('-djpeg', ['ROC_HW_NN.jpg'], '-r300');
close all;
 
 
  %% Plotting DET

   scores = scores_avg;
  target_linear_avg = [scores(1:15,1); scores(16:30,2); scores(31:45,3)];
  nontarget_linear_avg = [scores(16:45,1); scores(1:15,2); scores(31:45,2); scores(1:30,3)]; 
 
  scores = scores_vector;
   target_gaussian_avg = [scores(1:14,1); scores(15:25,2); scores(26:45,3)];
   nontarget_gaussian_avg = [scores(15:45,1); scores(1:14,2); scores(26:45,2); scores(1:25,3)]; 
 

 

test_data.tar1 = target_linear_avg;
test_data.non1 = nontarget_linear_avg;

test_data.tar2 = target_gaussian_avg;
test_data.non2 = nontarget_gaussian_avg;


demo_main(test_data,'big');
title(['DET Curve of Handwritten Character Dataset for NN']);
set(gca,'FontSize',12,'FontWeight','bold')
print('-djpeg', ['DET_HW_NN.jpg'], '-r300');
close all;
%  


