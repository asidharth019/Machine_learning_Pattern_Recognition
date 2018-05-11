% clc; clear all; close all

 k = 14;
 states = 8;
 normmethod = 3;

%% Loading data
%  tar('test1.tgz','.');



data1extract = untar('1.tgz','1');
data1extract(1) = [];

for i = 1:ceil(.7*(length(data1extract)))
    temp = dlmread(data1extract{i});
    temp(1,:) = [];
    temp = normalizescores(temp,normmethod);
    if i == 1
        data1 = temp;
    else
        data1 = [data1; temp];
    end
end

for i = ceil(.7*(length(data1extract)))+1:length(data1extract)
    temp = dlmread(data1extract{i});
    temp(1,:) = [];
    temp = normalizescores(temp,normmethod);
    if i == ceil(.7*(length(data1extract)))+1
        tdata1 = temp;
    else
        tdata1 = [tdata1; temp];
    end
end


dataoextract = untar('o.tgz','o');

for i = 1:ceil(.7*(length(dataoextract)))
    temp = dlmread(dataoextract{i});
    temp(1,:) = [];
    temp = normalizescores(temp,normmethod);
    if i == 1
        datao = temp;
    else
        datao = [datao; temp];
    end
end

for i = ceil(.7*(length(dataoextract)))+1:length(dataoextract)
    temp = dlmread(dataoextract{i});
    temp(1,:) = [];
    temp = normalizescores(temp,normmethod);
    if i == ceil(.7*(length(dataoextract)))+1
        tdatao = temp;
    else
        tdatao = [tdatao; temp];
    end
end


datazextract = untar('z.tgz','z');

for i = 1:ceil(.7*(length(datazextract)))
    temp = dlmread(datazextract{i});
    temp(1,:) = [];
    temp = normalizescores(temp,normmethod);
    if i == 1
        dataz = temp;
    else
        dataz = [dataz; temp];
    end
end

for i = ceil(.7*(length(datazextract)))+1:length(datazextract)
    temp = dlmread(datazextract{i});
    temp(1,:) = [];
    temp = normalizescores(temp,normmethod);
    if i == ceil(.7*(length(datazextract)))+1
        tdataz = temp;
    else
        tdataz = [tdataz; temp];
    end
end





%% Running K-Means & Storing idx in txt files

 
  data = [data1; datao; dataz];
 [idx,means,covs] = myKMeans(data,k);
 
%  elbowMethod(data);

 
 idx1 = idx(1:length(data1));
 idxo = idx(length(data1)+1:length(data1)+length(datao));
 idxz = idx(length(data1)+length(datao)+1:end);

fileID = fopen('1.txt','w');
index = 1;
for i = 1:ceil(.7*(length(data1extract)))
    temp = (dlmread(data1extract{i}));
    templ = temp(1,2);
    for j = 1:templ
       fprintf(fileID,'%d ',((idx1(index))-1)); 
       index = index+1;
    end
    fprintf(fileID,'\n'); 
end

fclose(fileID);


fileID = fopen('o.txt','w');

index = 1;
for i = 1:ceil(.7*(length(dataoextract)))
    temp = (dlmread(dataoextract{i}));
    templ = temp(1,2);
    for j = 1:templ
       fprintf(fileID,'%d ',((idxo(index))-1)); 
       index = index+1;
    end
    fprintf(fileID,'\n'); 
end

fclose(fileID);


fileID = fopen('z.txt','w');

index = 1;
for i = 1:ceil(.7*(length(datazextract)))
    temp = (dlmread(datazextract{i}));
    templ = temp(1,2);
    for j = 1:templ
       fprintf(fileID,'%d ',((idxz(index))-1)); 
       index = index+1;
    end
    fprintf(fileID,'\n'); 
end

fclose(fileID);


% Testing

tdata = [tdata1; tdatao; tdataz];
tidx =  assignCluster(tdata,means,covs);

fileID = fopen('test.txt','w');

index = 1;
for i = ceil(.7*(length(data1extract)))+1:length(data1extract)
    temp = dlmread(data1extract{i});
    templ = temp(1,2);
    for j = 1:templ
       fprintf(fileID,'%d ',((tidx(index))-1)); 
       index = index+1;
    end
    fprintf(fileID,'\n'); 
end

for i = ceil(.7*(length(dataoextract)))+1:length(dataoextract)
    temp = dlmread(dataoextract{i});
    templ = temp(1,2);
    for j = 1:templ
       fprintf(fileID,'%d ',((tidx(index))-1)); 
       index = index+1;
    end
    fprintf(fileID,'\n'); 
end

for i = ceil(.7*(length(datazextract)))+1:length(datazextract)
    temp = dlmread(datazextract{i});
    templ = temp(1,2);
    for j = 1:templ
       fprintf(fileID,'%d ',((tidx(index))-1)); 
       index = index+1;
    end
    fprintf(fileID,'\n'); 
end

fclose(fileID);


%% Training HMM Models & Testing on trained HMM Models

pathToHMMScript = fullfile('/Users/NiravMBA/Desktop/IIT\ Madras/Semester\ I/Pattern\ Recognition/Assignment/Assignment\ 4/Digits\ Isolated/RunHMM.command'); 
pathToHMMScript = [pathToHMMScript,' ',num2str(states),' ',num2str(k)];
system(pathToHMMScript);
pause(2);


%% Loading Tested probabilities

actual = [ones(1,17) ones(1,17)*2 ones(1,17)*3];

predicted1 = load('teston1.txt');
predictedo = load('testono.txt'); 
predictedz = load('testonz.txt');
predictedall = load('testong.txt');


 predicted = [predicted1' predictedo' predictedz'];
 predicted = predicted - predictedall';
 %    predicted = normalizescores(predicted,4);
 
 [ind,fpredicted] = max(predicted,[],2);
 myConfusionPlot(fpredicted',actual,k,states);

 
 %% Plotting ROC
 %scoresk12s5

 
  scores = normalizescores(predicted,4);
%   myPlotRoc(scores,actual);
%  pause(2);
%  close all;

%    scoresk12s5 = scores;
%  scoresk14s6 = scores;
%  scoresk10s5 = scores;
%   scoresk8s5 = scores;
%  scoresk6s3 = scores;
% scoresk4s2 = scores;
% scoresk5s3 = scores;


%  [ind,fpredicted] = max(scoresk6s3,[],2);
%  myConfusionPlot(fpredicted',actual,6,6);
%   [ind,fpredicted] = max(scoresk8s5,[],2);
%  myConfusionPlot(fpredicted',actual,8,6);
%   [ind,fpredicted] = max(scoresk10s5,[],2);
%  myConfusionPlot(fpredicted',actual,10,6);
%   [ind,fpredicted] = max(scoresk12s5,[],2);
%  myConfusionPlot(fpredicted',actual,12,6);
%  
 
 
% 
%  myPlotRoc(scoresk6s3,actual);
%  myPlotRoc(scoresk8s5,actual);
% myPlotRoc(scoresk10s5,actual);
% myPlotRoc(scoresk12s5,actual);
%  
%  legend('Cluster = 6 & States = 3','Cluster = 8 & States = 4','Cluster = 10 & States = 5','Cluster = 12 & States = 6','Location','southeast');
%  
% t = 0:.5:1;
% plot(t,t,'--k');
% title(['ROC Curve of Normalised Isolated Dataset']);
% set(gca,'FontSize',12,'FontWeight','bold')
% hold off
% print('-djpeg', ['ROC_Normalised_Isolated_K_',num2str(k),'.jpg'], '-r300');
% close all;
 
 
  %% Plotting DET
 
  target = [scores(1:17,1); scores(18:34,2); scores(35:51,3)];
  nontarget = [scores(16:51,1); scores(1:17,2); scores(35:51,2); scores(1:34,3)]; 
 
%  mu = 0;
% sigma = 1;
% target = mu + sqrt(2)*sigma*erfinv(2*target-1);
% nontarget = mu + sqrt(2)*sigma*erfinv(2*nontarget-1);
 %  hist(Y)

%  target = transform_data(target,50);
%  nontarget = transform_data(nontarget,104);

%  demo_main(target,nontarget,'old');
%  
%  pause(2);
%  close all;


%   targetk12s6 = target;
%   nontargetk12s6 = nontarget;
%  targetk14s6 = target;
%  nontargetk14s6 = nontarget;
%  targetk10s5 = target;
%  nontargetk10s5 = nontarget;
%  targetk8s5 = target;
%  nontargetk8s5 = nontarget;
%  targetk6s3 = target;
%  nontargetk6s3 = nontarget;
%  targetk4s2 = target;
%  nontargetk4s2 = nontarget;
%  targetk5s3 = target;
%  nontargetk5s3 = nontarget;
 
% 
% test_data.tar1 = targetk6s3;
% test_data.non1 = nontargetk6s3;
% 
% test_data.tar2 = targetk8s5;
% test_data.non2 = nontargetk8s5;
% 
% test_data.tar3 = targetk10s5;
% test_data.non3 = nontargetk10s5;
% 
% test_data.tar4 = targetk12s6;
% test_data.non4 = nontargetk12s6;
% 
% % test_data.tar5 = targetk8s4;
% % test_data.non5 = nontargetk8s4;
% % 
% % test_data.tar1 = target;
% % test_data.non1 = nontarget;
% % 
% % 
% % % 
% demo_main(test_data,'old');
% title(['DET Curve of Unnormalised Digit Dataset']);
% set(gca,'FontSize',12,'FontWeight','bold')
% print('-djpeg', ['DET_UnNormalised_Isolated_K_',num2str(k),'.jpg'], '-r300');
% close all;
%  
 
  %% Concat HMM Models
 
 concatModels();
 pause(1);

% Testing for connected letters

test1extract = untar('test1.tgz','test1');
test1extract(1) = [];


for i = 1:length(test1extract)

  testconnected =   dlmread(data1extract{i});
  testconnected(1,:) = [];

   testconnected = normalizescores(testconnected,normmethod);
   
 
tidx1o =  assignCluster(testconnected,means,covs);
if i < 7
    fileID = fopen(['hmm-1.04/testfile2/',num2str(i+9),'.txt'],'w');
elseif i > 6 && i < 13
    fileID = fopen(['hmm-1.04/testfile/',num2str(i+13),'.txt'],'w');
else
    fileID = fopen(['hmm-1.04/testfile4/',num2str(i+17),'.txt'],'w');
end
for j = 1:length(tidx1o)
       fprintf(fileID,'%d ',((tidx1o(j))-1));
end
 
end

% Creating Filenames array

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
   
filenames2 = zeros(9,1);


itr = 1;
for i = 1:3
    for j= 1:3
            filenames2(itr) = 10*i + j;
            itr = itr + 1;
    end
end
    
 


%% Testing on Connected Handwritten data for 3

pathToHMM123Script = fullfile('/Users/NiravMBA/Desktop/IIT\ Madras/Semester\ I/Pattern\ Recognition/Assignment/Assignment\ 4/Digits\ Isolated/RunHMM123.command'); 
system(pathToHMM123Script);
pause(2);


% Classifying Class to which test point belongs
%  myConfusionPlot(fpredicted',actual);
 
act = [121; 133; 113; 222; 313; 331];
itr = 1;
for i = 20:25
predictfortest = load(['hmm-1.04/Prob',num2str(i),'.txt']);
[ind,fpredictfortest] = max(predictfortest);

if act(itr) == (filenames(fpredictfortest))
    temp = '  Classified : Correctly';
else
     temp = '  Classified : Incorrectly';
end

disp(['For Test Sequence : Prob',num2str(i),' Test File : ',test1extract{i-13}(10:12),' File number is : ',num2str(fpredictfortest),' File Name is : ',num2str(filenames(fpredictfortest)),temp]);
itr = itr+1;

end

 
%% Testing on Connected Handwritten data for 2

 concatModels2();
 pause(1);
pathToHMM12Script = fullfile('/Users/NiravMBA/Desktop/IIT\ Madras/Semester\ I/Pattern\ Recognition/Assignment/Assignment\ 4/Digits\ Isolated/RunHMM12.command'); 
system(pathToHMM12Script);
pause(1);


% Classifying Class to which test point belongs
%  myConfusionPlot(fpredicted',actual);
 
act = [12; 13; 21; 22; 31; 33];
itr = 1;
for i = 10:15
predictfortest = load(['hmm-1.04/Prob',num2str(i),'.txt']);
[ind,fpredictfortest] = max(predictfortest);

if act(itr) == (filenames2(fpredictfortest))
    temp = '  Classified : Correctly';
else
     temp = '  Classified : Incorrectly';
end

disp(['For Test Sequence : Prob',num2str(i),' Test File : ',test1extract{i-9}(10:11),' File number is : ',num2str(fpredictfortest),' File Name is : ',num2str(filenames2(fpredictfortest)),temp]);
itr = itr+1;

end

  

 
%% Testing for Unknown connected digits
% 
for i = 120:130

  testUnknownConnected =   dlmread(['test2/',num2str(i),'.mfcc']);
  testUnknownConnected(1,:) = [];

   testUnknownConnected = normalizescores(testUnknownConnected,normmethod);
   
 
tidx1o =  assignCluster(testUnknownConnected,means,covs);

fileID = fopen(['hmm-1.04/testsforunknow/',num2str(i),'.txt'],'w');
for j = 1:length(tidx1o)
       fprintf(fileID,'%d ',((tidx1o(j))-1));
end
 
end


%% Testing on Connected Handwritten data

pathToUnknownHMM123Script = fullfile('/Users/NiravMBA/Desktop/IIT\ Madras/Semester\ I/Pattern\ Recognition/Assignment/Assignment\ 4/Digits\ Isolated/RunHMMUnknown123.command'); 
system(pathToUnknownHMM123Script);
pause(2);


%% Classifying Class to which test point belongs

for i = 120:130
predictfortest = load(['hmm-1.04/Prob',num2str(i),'.txt']);
[ind,fpredictfortest] = max(predictfortest);
disp(['For Test Sequence : Prob',num2str(i),' File number is : ',num2str(fpredictfortest),' File Name is : ',num2str(filenames(fpredictfortest))]);
end



%%
