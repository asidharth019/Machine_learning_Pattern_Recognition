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
% wholedata = normalizescores(wholedata,5);
% 
% data1 = wholedata(1:length(data1),:);
% data2 = wholedata(length(data1)+1:length(data1)+length(data2),:);
% data3 = wholedata(length(data1)+length(data2)+1:end,:);
% 
% data1 = normalizescores(data1,5);
% data2 = normalizescores(data2,5);
% data3 = normalizescores(data3,5);

tdata1 = data1(1:ceil(.7*(length(data1extract) - 1))*36,:);
vdata1 = data1(ceil(.7*(length(data1extract) - 1))*36+1:ceil(.853*(length(data1extract) - 1))*36,:);
ttdata1 = data1(ceil(.845*(length(data1extract) - 1))*36+1:end,:);

tdata2 = data2(1:ceil(.7*(length(data1extract) - 1))*36,:);
vdata2 = data2(ceil(.7*(length(data1extract) - 1))*36+1:ceil(.76*(length(data2extract) - 1))*36,:);
ttdata2 = data2(ceil(.86*(length(data2extract) - 1))*36+1:end,:);

tdata3 = data3(1:ceil(.7*(length(data1extract) - 1))*36,:);
vdata3 = data3(ceil(.7*(length(data3extract) - 1))*36+1:ceil(.813*(length(data3extract) - 1))*36,:);
ttdata3 = data3(ceil(.885*(length(data3extract) - 1))*36+1:end,:);


%%  Voting

% Validation

h = [.01 .1 .5 .8 1 2 5 10];
vdata = [vdata1; vdata2; vdata3];
density_estimate =  zeros(size(vdata,1),3);

for j = h
for i = 1:size(vdata,1)  
    temp = vdata(i,:);
    
    row = mod(1,36);
    
    if row == 0
        row = 36;
    end
    
    
    density_estimate(i,1) = parzen_window_all(tdata1,temp,row);
    density_estimate(i,2) = parzen_window_all(tdata2,temp,row);
    density_estimate(i,3) = parzen_window_all(tdata3,temp,row);
end



prob_estimates_avg = zeros(length(density_estimate)/36,1);
i = 1;
j = i+36-1;
for t = 1:length(density_estimate)/36
   
   [x,y] = max(density_estimate(i:j,:),[],2);
   temp = mode(y);
    prob_estimates_avg(t) = temp;
    i = j+1;
    j = i+36-1;
       
end


actual = [ones(40,1); ones(40,1)*2; ones(40,1)*3];

 disp(['Confusion Matrix for H = ',num2str(j)]);
 myConfusionPlot(prob_estimates_avg',actual',1,1);
 
end
 
 %% Testing

h = 0.5;
tdata = [ttdata1; ttdata2; ttdata3];
density_estimate_test = zeros(size(tdata,1),3);

for i = 1:size(tdata,1)  
    temp = tdata(i,:);
    
    row = mod(1,36);
    
    if row == 0
        row = 36;
    end
    
    
    density_estimate_test(i,1) = parzen_window_all(tdata1,temp,h,row);
    density_estimate_test(i,2) = parzen_window_all(tdata2,temp,h,row);
    density_estimate_test(i,3) = parzen_window_all(tdata3,temp,h,row);
end


class_estimates_avg = zeros(length(density_estimate_test)/36,1);
prob_estimates_avg = zeros(length(density_estimate_test)/36,3);

i = 1;
j = i+36-1;
for t = 1:length(density_estimate_test)/36
   
   [x,y] = max(density_estimate_test(i:j,:),[],2);
   prob_estimates_avg(t,:) = mean(density_estimate_test(i:j,:));
   temp = mode(y);
    class_estimates_avg(t) = temp;
    i = j+1;
    j = i+36-1;
       
end


actual = [ones(40,1); ones(40,1)*2; ones(40,1)*3];

[ind,class_estimates_avg] = max(prob_estimates_avg,[],2);

 disp(['Confusion Matrix for H = ',num2str(h)]);
 myConfusionPlot(class_estimates_avg',actual',1,1);
 
 %% Max Avg Prob
% Validation

h = [.01 .05 .1 .5 .8 1 2 5 10];
acc = zeros(length(h),1);
vdata = [vdata1; vdata2; vdata3];
density_estimate = zeros(120,3);
itr = 1;
for j = h
for i = 1:120  
    temp = vdata((i-1)*36 + 1:(i-1)*36 + 36,:);
    density_estimate(i,1) = parzen_window(tdata1,temp,j);
    density_estimate(i,2) = parzen_window(tdata2,temp,j);
    density_estimate(i,3) = parzen_window(tdata3,temp,j);
end


actual = [ones(40,1); ones(40,1)*2; ones(40,1)*3];
 [~,predicted_class] = max(density_estimate,[],2);
 disp(['Confusion Matrix for H = ',num2str(j)]);
 
acc(itr)=sum(predicted_class'==actual')/length(predicted_class')*100;
 myConfusionPlot(predicted_class',actual',1,1);
 itr = itr+1;
 
end
acc1 = acc;
plot(h,acc,'LineWidth',4);
axis([.01 5 0 100]);
title(['Accuracy Vs Variance h of Gaussian Kernel']);
xlabel('Varaince (h)') 
ylabel('Accuracy in %')
set(gca,'FontSize',12,'FontWeight','bold')
hold off
print('-djpeg', ['AccvsH.jpg'], '-r300');
close all;
 
 %% Testing

h = 0.5;
tdata = [ttdata1; ttdata2; ttdata3];
density_estimate_test = zeros(120,3);

for i = 1:120  
    temp = tdata((i-1)*36 + 1:(i-1)*36 + 36,:);
    density_estimate_test(i,1) = parzen_window(tdata1,temp,h);
    density_estimate_test(i,2) = parzen_window(tdata2,temp,h);
    density_estimate_test(i,3) = parzen_window(tdata3,temp,h);
end


actual = [ones(40,1); ones(40,1)*2; ones(40,1)*3];
 [~,predicted_class] = max(density_estimate_test,[],2);
 myConfusionPlot(predicted_class',actual',1,1);
 


%% Plotting ROC

% unnorm_hp5 = prob_estimates_avg;
% unnorm_hp5 = unnorm_hp5./(sum(unnorm_hp5,2));
% % unnorm_hp5 = normalizescores(unnorm_hp5,4);
% 
% norm_hp5 = prob_estimates_avg;
% norm_hp5 = norm_hp5./(sum(norm_hp5,2));
% % norm_hp5 = normalizescores(norm_hp5,4);

% unnorm_hp5_voting = prob_estimates_avg;
% unnorm_hp5_voting = normalizescores(unnorm_hp5_voting,4);

% norm_hp5_voting = prob_estimates_avg;
% norm_hp5_voting = normalizescores(norm_hp5_voting,4);

% 
% wnorm_hp5_voting = prob_estimates_avg;
% wnorm_hp5_voting = wnorm_hp5_voting./(sum(wnorm_hp5_voting,2));
% % wnorm_hp5_voting = normalizescores(wnorm_hp5_voting,4);
% % 
% myPlotRoc(wnorm_hp5_voting,actual);
h = 0.5;

myPlotRoc1(unnorm_hp5,actual);
myPlotRoc1(norm_hp5,actual);
% myPlotRoc(unnorm_hp5_voting,actual);
% myPlotRoc(norm_hp5_voting,actual);
myPlotRoc1(wnorm_hp5_voting,actual);



legend('Un Normalised','Variance Normalised','Within Class Normalised','Location','southeast');
t = 0:.5:1;
plot(t,t,'--k');
title(['ROC Curve of Image Dataset for h = ',num2str(h)]);
set(gca,'FontSize',12,'FontWeight','bold')
hold off
print('-djpeg', ['ROC_ImageDataSet_H_',num2str(h),'.jpg'], '-r300');
close all;

%% Plotting DET

   scores = 1- unnorm_hp5;
  target_linear_avg = [scores(1:40,1); scores(41:80,2); scores(81:120,3)];
  nontarget_linear_avg = [scores(41:120,1); scores(1:40,2); scores(81:120,2); scores(1:80,3)]; 
 
  scores = 1- norm_hp5;
   target_gaussian_avg =  [scores(1:40,1); scores(41:80,2); scores(81:120,3)];
   nontarget_gaussian_avg = [scores(41:120,1); scores(1:40,2); scores(81:120,2); scores(1:80,3)]; 
%   
%    scores = unnorm_hp5_voting;
%   target_linear_vector =  [scores(1:40,1); scores(41:80,2); scores(81:120,3)];
%   nontarget_linear_vector = [scores(41:120,1); scores(1:40,2); scores(81:120,2); scores(1:80,3)]; 
%   
%    scores = norm_hp5_voting;
%   target_gaussian_vector =  [scores(1:40,1); scores(41:80,2); scores(81:120,3)];
%   nontarget_gaussian_vector = [scores(41:120,1); scores(1:40,2); scores(81:120,2); scores(1:80,3)]; 
%   
  
   scores = 1- wnorm_hp5_voting;
  target_gaussian_vector1 =  [scores(1:40,1); scores(41:80,2); scores(81:120,3)];
  nontarget_gaussian_vector1 = [scores(41:120,1); scores(1:40,2); scores(81:120,2); scores(1:80,3)]; 
%   
  
%  target = transform_data(target,50);
%  nontarget = transform_data(nontarget,104);

%  demo_main(target,nontarget,'old');

 

test_data.tar1 = target_linear_avg;
test_data.non1 = nontarget_linear_avg;

test_data.tar2 = target_gaussian_avg;
test_data.non2 = nontarget_gaussian_avg;

test_data.tar3 = target_gaussian_vector1;
test_data.non3 = nontarget_gaussian_vector1;

% test_data.tar4 = target_gaussian_vector;
% test_data.non4 = nontarget_gaussian_vector;
% 
% test_data.tar5 = target_gaussian_vector1;
% test_data.non5 = nontarget_gaussian_vector1;

demo_main(test_data,'big');
title(['DET Curve of Image Dataset for Parzen']);
set(gca,'FontSize',12,'FontWeight','bold')
print('-djpeg', ['DET_Image_Parzen.jpg'], '-r300');
% close all;

disp('---------------- END ----------------');




