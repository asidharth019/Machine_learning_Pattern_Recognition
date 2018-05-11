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


%% Splitting Training and Testing data

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

minlen = 1;

data1 = dataai(1:80*minlen,:);
tdata1 = dataai(80*minlen+1:end,:);


data2 = databa(1:80*minlen,:);
tdata2 = databa(80*minlen+1:end,:);


data3 = datala(1:80*minlen,:);
tdata3 = datala(80*minlen+1:end,:);






%% Training SVM and Predicting Output

 
 datatrain = [data1; data2; data3];
    cdatatrain = [ones(size(data1,1),1); ones(size(data2,1),1)*2; ones(size(data3,1),1)*3];

  datatest = [tdata1; tdata2; tdata3];
  cdatatest = [ones(size(tdata1,1),1); ones(size(tdata2,1),1)*2; ones(size(tdata3,1),1)*3];

  model =svmtrain(cdatatrain,datatrain,'-c 1 -t 0 -b 1');

[predict_label, accuracy, prob_estimates] = svmpredict(cdatatest, datatest, model, '-b 1');

  
%% Calculating Avg Max Probability
%   minlen = 28;
  prob_estimates_avg = zeros(length(prob_estimates)/minlen,3);
i = 1;
j = i+minlen-1;
for t = 1:length(prob_estimates)/minlen
   
    prob_estimates_avg(t,:) = mean(prob_estimates(i:j,:));
    i = j+1;
    j = i+minlen-1;
       
end

[predict,predictclass] = max(prob_estimates_avg,[],2);

actual = [ones(1,15) ones(1,15)*2 ones(1,15)*3];
 predictclass = predict_label;
 myConfusionPlot(predictclass',actual,1,1);
  

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
%  scores_linear_avg = prob_estimates_avg;
%  scores_gaussian_avg = prob_estimates_avg;
% scores_linear_vector = prob_estimates;
% scores_gaussian_vector = prob_estimates;


 
%   scores = normalizescores(predicted,4);
%   myPlotRoc(scores,actual);

 myPlotRoc(scores_linear_avg,actual);
 myPlotRoc(scores_gaussian_avg,actual);
myPlotRoc(scores_linear_vector,actual);
myPlotRoc(scores_gaussian_vector,actual);
 
 legend('Linear Kernel - Max Avg Prob','Gaussian Kernel - Max Avg Prob','Linear Kernel - Character Vector','Gaussian Kernel - Character Vector','Location','southeast');
 
t = 0:.5:1;
plot(t,t,'--k');
title(['ROC Curve of Handwritten Character Dataset for SVM']);
set(gca,'FontSize',12,'FontWeight','bold')
hold off
print('-djpeg', ['ROC_HC_SVM.jpg'], '-r300');
close all;
 
 
  %% Plotting DET
  
  
  %  scores_linear_avg = prob_estimates_avg;
%  scores_gaussian_avg = prob_estimates_avg;
% scores_linear_vector = prob_estimates;
% scores_gaussian_vector = prob_estimates;
 
   scores = scores_linear_avg;
  target_linear_avg = [scores(1:15,1); scores(16:30,2); scores(31:45,3)];
  nontarget_linear_avg = [scores(16:45,1); scores(1:15,2); scores(31:45,2); scores(1:30,3)]; 
 
  scores = scores_gaussian_avg;
   target_gaussian_avg = [scores(1:15,1); scores(16:30,2); scores(31:45,3)];
   nontarget_gaussian_avg = [scores(16:45,1); scores(1:15,2); scores(31:45,2); scores(1:30,3)]; 
 
  
   scores = scores_linear_vector;
  target_linear_vector = [scores(1:15,1); scores(16:30,2); scores(31:45,3)];
  nontarget_linear_vector = [scores(16:45,1); scores(1:15,2); scores(31:45,2); scores(1:30,3)]; 
 
  
   scores = scores_gaussian_vector;
  target_gaussian_vector = [scores(1:15,1); scores(16:30,2); scores(31:45,3)];
  nontarget_gaussian_vector = [scores(16:45,1); scores(1:15,2); scores(31:45,2); scores(1:30,3)]; 
  


test_data.tar1 = target_linear_avg;
test_data.non1 = nontarget_linear_avg;

test_data.tar2 = target_gaussian_avg;
test_data.non2 = nontarget_gaussian_avg;

test_data.tar3 = target_linear_vector;
test_data.non3 = nontarget_linear_vector;

test_data.tar4 = target_gaussian_vector;
test_data.non4 = nontarget_gaussian_vector;


demo_main(test_data,'big');
title(['DET Curve of HandWritten Character Dataset for SVM']);
set(gca,'FontSize',12,'FontWeight','bold')
print('-djpeg', ['DET_HW_SVM.jpg'], '-r300');
close all;
%  




