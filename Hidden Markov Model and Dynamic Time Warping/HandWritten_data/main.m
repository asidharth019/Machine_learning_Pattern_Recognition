% clc; clear all; close all

 k = 12;
 states=6;

%% Loading data
%  tar('eight.tgz','.');

inputdataai = dlmread('data_ai.txt');
inputdataba = dlmread('data_bA.txt');
inputdatala = dlmread('data_lA.txt');

lenai = inputdataai(:,1);
lenba = inputdataba(:,1);
lenla = inputdatala(:,1);

inputdataai(:,1) = [];
inputdataba(:,1) = [];
inputdatala(:,1) = [];

% dataai = zeros(sum(lenai),2);
% databa = zeros(sum(lenba),2);
% datala = zeros(sum(lenla),2);


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
   
   if i == 1
       datala = temp;
   else
       datala = [datala; temp];
   end
end


data1 = dataai(1:sum(lenai(1:85)),:);
tdata1 = dataai(sum(lenai(1:85))+1:end,:);


data2 = databa(1:sum(lenba(1:82)),:);
tdata2 = databa(sum(lenba(1:82))+1:end,:);


data3 = datala(1:sum(lenla(1:83)),:);
tdata3 = datala(sum(lenla(1:83))+1:end,:);






%% Running K-Means & Storing idx in txt files

 
  data = [data1; data2; data3];
 [idx,means,covs] = myKMeans(data,k);
 
%   elbowMethod(data);

 
 idx1 = idx(1:length(data1));
 idx2 = idx(length(data1)+1:length(data1)+length(data2));
 idx3 = idx(length(data1)+length(data2)+1:end);

fileID = fopen('ai.txt','w');
index = 1;
for i = 1:85
    for j = 1:lenai(i)
       fprintf(fileID,'%d ',((idx1(index))-1)); 
       index = index+1;
    end
    fprintf(fileID,'\n'); 
end
fclose(fileID);


fileID = fopen('ba.txt','w');
index = 1;
for i = 1:82
    for j = 1:lenba(i)
       fprintf(fileID,'%d ',((idx2(index))-1)); 
       index = index+1;
    end
    fprintf(fileID,'\n'); 
end
fclose(fileID);

fileID = fopen('la.txt','w');
index = 1;
for i = 1:83
    for j = 1:lenla(i)
       fprintf(fileID,'%d ',((idx3(index))-1)); 
       index = index+1;
    end
    fprintf(fileID,'\n'); 
end
fclose(fileID);


%% Testing

tdata = [tdata1; tdata2; tdata3];
tidx =  assignCluster(tdata,means,covs);

%% Saving Test sequence

fileID = fopen('test.txt','w');

index = 1;
for i = 1:15
    for j = 1:lenai(i+85)
       fprintf(fileID,'%d ',((tidx(index))-1)); 
       index = index+1;
    end
    fprintf(fileID,'\n'); 
end

for i = 1:15
    for j = 1:lenba(i+82)
       fprintf(fileID,'%d ',((tidx(index))-1)); 
       index = index+1;
    end
    fprintf(fileID,'\n'); 
end

for i = 1:15
    for j = 1:lenla(i+83)
       fprintf(fileID,'%d ',((tidx(index))-1)); 
       index = index+1;
    end
    fprintf(fileID,'\n'); 
end

fclose(fileID);

%% Training HMM Models & Testing on trained HMM Models

pathToHMMScript = fullfile('/Users/NiravMBA/Desktop/IIT\ Madras/Semester\ I/Pattern\ Recognition/Assignment/Assignment\ 4/HandWritten_data/Isolated/RunHMM.command'); 
pathToHMMScript = [pathToHMMScript,' ',num2str(states),' ',num2str(k)];
system(pathToHMMScript);
pause(2);

%% Loading Tested probabilities and plotting Confusion Matrix

actual = [ones(1,15) ones(1,15)*2 ones(1,15)*3];

predicted1 = load('testonai.txt');
predicted2 = load('testonba.txt'); 
predicted3 = load('testonla.txt');
predictedall = load('testonll.txt');


 predicted = [predicted1' predicted2' predicted3'];
 predicted = predicted - predictedall';
%    predicted = normalizescores(predicted,4);

 [ind,fpredicted] = max(predicted,[],2);

 myConfusionPlot(fpredicted',actual,k,states);


%% Plotting ROC

 
 scoresk16s5 = normalizescores(predicted,4);
 
   myPlotRoc(scoresk16s5,actual);
%  
%   myPlotRoc(scoresk4s2,actual);
%  myPlotRoc(scoresk6s3,actual);
%   myPlotRoc(scoresk5s3,actual);
%  
%   myPlotRoc(scoresk10s5,actual);
%  myPlotRoc(scoresk8s4,actual);
%  myPlotRoc(scoresk12s6,actual);
%  
%  
%  legend('Cluster = 4 & States = 2','Cluster = 5 & States = 3','Cluster = 6 & States = 3','Cluster = 8 & States = 4','Cluster = 10 & States = 5','Cluster = 12 & States = 6','Location','southeast');
%  
% t = 0:.5:1;
% plot(t,t,'--k');
% title(['ROC Curve of Handwritten Dataset']);
% set(gca,'FontSize',12,'FontWeight','bold')
% hold off
% print('-djpeg', ['ROC_Handwritten_K_',num2str(k),'.jpg'], '-r300');
% close all;
 
 
 %% Plotting DET
 target = [scoresk16s5(1:15,1); scoresk16s5(16:30,2); scoresk16s5(31:45,3)];
 nontarget = [scoresk16s5(16:45,1); scoresk16s5(1:15,2); scoresk16s5(16:45,2); scoresk16s5(1:30,3)]; 

 

%  demo_main(target,nontarget,'old');

% 
% 
% test_data.tar1 = targetk4s2;
% test_data.non1 = nontargetk4s2;
% 
% test_data.tar2 = targetk6s3;
% test_data.non2 = nontargetk6s3;
% 
% test_data.tar3 = targetk5s3;
% test_data.non3 = nontargetk5s3;
% 
% test_data.tar4 = targetk10s5;
% test_data.non4 = nontargetk10s5;
% 
% test_data.tar5 = targetk8s4;
% test_data.non5 = nontargetk8s4;
% 
% test_data.tar6 = target;
% test_data.non6 = nontarget;
% 
% 
% demo_main(test_data,'old');
% title(['DET Curve of Handwritten Dataset']);
% set(gca,'FontSize',12,'FontWeight','bold')
% print('-djpeg', ['DET_Handwritten_K_',num2str(k),'.jpg'], '-r300');
% close all;
 
 %% Concat HMM Models
 
 concatModels();
 pause(2);

%% Testing for connected letters

for i = 1:3

 load([num2str(i),'.mat']);
% scatter(xData,yData,'filled');
% title(['Continuous HandWritten Data ',num2str(i)]);
% set(gca,'FontSize',14,'FontWeight','bold')
% print('-djpeg', ['Continuous_HandWritten_Data_',num2str(i),'.jpg'], '-r300');
% close all;


testconnected = [xData' yData'];
  fder1 = calculateDerivative(testconnected);
   sder1 = calculateDerivative(fder1);
   cur1 = calculateCurvature(fder1,sder1);
   testconnected = [testconnected fder1 sder1 cur1];
   testconnected = normalizescores(testconnected,3);
   
 
tidx1o =  assignCluster(testconnected,means,covs);

fileID = fopen(['hmm-1.04/testfile/',num2str(i),'.txt'],'w');
for j = 1:length(tidx1o)
       fprintf(fileID,'%d ',((tidx1o(j))-1));
end
 
end

%% Creating Filenames array

filenames = zeros(27,1);
itr = 1;
for i = 1:3
    for j= 1:3
        for f = 1:3
            filenames(itr) = 100*i + 10*j + f;
            itr = itr + 1;
        end
    end
end
   

%% Testing on Connected Handwritten data

pathToHMM123Script = fullfile('/Users/NiravMBA/Desktop/IIT\ Madras/Semester\ I/Pattern\ Recognition/Assignment/Assignment\ 4/HandWritten_data/Isolated','RunHMM123.command'); 
system(pathToHMM123Script);
pause(2);


%% Classifying Class to which test point belongs

for i = 1:3
predictfortest = load(['hmm-1.04/Prob',num2str(i),'.txt']);
[ind,fpredictfortest] = max(predictfortest);
disp(['For Test Sequence : Prob',num2str(i),' File number is : ',num2str(fpredictfortest),' File Name is : ',num2str(filenames(fpredictfortest))]);
end








