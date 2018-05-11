%  clc; clear all; close all

 normmethod = 0;
 minlen = 70;

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
%     temp = temp(:)';
    
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
%     temp = temp(:)';
    
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
%     temp = temp(:)';
    
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
% minlen = 1;

data = [data1; datao; dataz];
cdata = [ones(size(data1,1),1); ones(size(datao,1),1)*2; ones(size(dataz,1),1)*3];

alldata = [data cdata];

tdata1 = data1(1:40*minlen,:);
tdatao = datao(1:40*minlen,:);
tdataz = dataz(1:40*minlen,:);

ttdata1=  data1(40*minlen+1:end,:);
ttdatao=  datao(40*minlen+1:end,:);
ttdataz=  dataz(40*minlen+1:end,:);




%% Training SVM and Predicting outputs

 
  datatrain = [tdata1; tdatao; tdataz];
    cdatatrain = [ones(size(tdata1,1),1); ones(size(tdatao,1),1)*2; ones(size(tdataz,1),1)*3];

  datatest = [ttdata1; ttdatao; ttdataz];
  cdatatest = [ones(size(ttdata1,1),1); ones(size(ttdatao,1),1)*2; ones(size(ttdataz,1),1)*3];

  model =svmtrain(cdatatrain,datatrain,'-c 1 -t 0 -b 1');

[predict_label, accuracy, prob_estimates] = svmpredict(cdatatest, datatest, model, '-b 1');

%%
class_estimates_avg = zeros(length(prob_estimates)/minlen,1);
prob_estimates_avg = zeros(length(prob_estimates)/minlen,3);
i = 1;
j = i+minlen-1;
for t = 1:length(prob_estimates)/minlen
   
    prob_estimates_avg(t,:) = mean(prob_estimates(i:j,:));
    [x,y] = max(prob_estimates(i:j,:),[],2);
    temp = mode(y);
    class_estimates_avg(t) = temp;
    
    i = j+1;
    j = i+minlen-1;
       
end

[predict,predictclass] = max(prob_estimates_avg,[],2);

actual = [ones(1,17) ones(1,17)*2 ones(1,17)*3];
% predictclass = predict_label;
 myConfusionPlot(class_estimates_avg',actual,1,1);


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


myPlotRoc(scores_linear_avg,actual);
myPlotRoc(scores_gaussian_avg,actual);
myPlotRoc(scores_linear_vector,actual);
myPlotRoc(scores_gaussian_vector,actual);
 
 legend('Linear Kernel - Max Avg Prob','Gaussian Kernel - Max Avg Prob','Linear Kernel - Speech Vector','Gaussian Kernel - Speech Vector','Location','southeast');
 
t = 0:.5:1;
plot(t,t,'--k');
title(['ROC Curve of Speech Dataset for SVM']);
set(gca,'FontSize',12,'FontWeight','bold')
hold off
print('-djpeg', ['ROC_Speech_SVM.jpg'], '-r300');
close all;
 
 
  %% Plotting DET

%    scores = scores_linear_avg;
%    scores = normalizescores(scores,4);
%   target_linear_avg = [scores(1:17,1); scores(18:34,2); scores(35:51,3)];
%   nontarget_linear_avg = [scores(16:51,1); scores(1:17,2); scores(35:51,2); scores(1:34,3)]; 
%  
%   scores = scores_gaussian_avg;
%  scores = normalizescores(scores,3);
%    target_gaussian_avg = [scores(1:17,1); scores(18:34,2); scores(35:51,3)];
%    nontarget_gaussian_avg = [scores(16:51,1); scores(1:17,2); scores(35:51,2); scores(1:34,3)]; 
%  
%   
%    scores = scores_linear_vector;
%   target_linear_vector = [scores(1:17,1); scores(18:34,2); scores(35:51,3)];
%   nontarget_linear_vector = [scores(16:51,1); scores(1:17,2); scores(35:51,2); scores(1:34,3)]; 
%  
%   
%    scores = scores_gaussian_vector;
%   target_gaussian_vector = [scores(1:17,1); scores(18:34,2); scores(35:51,3)];
%   nontarget_gaussian_vector = [scores(16:51,1); scores(1:17,2); scores(35:51,2); scores(1:34,3)]; 
%  
%   
  
%  target = transform_data(target,50);
%  nontarget = transform_data(nontarget,104);

%  demo_main(target,nontarget,'old');

 

test_data.tar1 = target_linear_avg;
test_data.non1 = nontarget_linear_avg;

test_data.tar2 = target_gaussian_avg;
test_data.non2 = nontarget_gaussian_avg;

test_data.tar3 = target_linear_vector;
test_data.non3 = nontarget_linear_vector;

test_data.tar4 = target_gaussian_vector;
test_data.non4 = nontarget_gaussian_vector;


demo_main(test_data,'big');
title(['DET Curve of Speech Dataset for SVM']);
set(gca,'FontSize',12,'FontWeight','bold')
print('-djpeg', ['DET_Speech_SVM.jpg'], '-r300');
close all;
%  
