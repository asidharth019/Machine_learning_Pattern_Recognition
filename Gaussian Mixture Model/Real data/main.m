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

% Normalizing Dataset
wholedata = [data1; data2; data3];
wholedata = normalizescores(wholedata,2);

data1 = wholedata(1:length(data1),:);
data2 = wholedata(length(data1)+1:length(data1)+length(data2),:);
data3 = wholedata(length(data1)+length(data2)+1:end,:);

%Normalizing Individual Classes
% data1 = normalizescores(data1,2);
% data2 = normalizescores(data2,2);
% data3 = normalizescores(data3,2);

tdata1 = data1(1:ceil(.7*(length(data1extract) - 1))*36,:);
vdata1 = data1(ceil(.7*(length(data1extract) - 1))*36+1:ceil(.853*(length(data1extract) - 1))*36,:);
ttdata1 = data1(ceil(.845*(length(data1extract) - 1))*36+1:end,:);

tdata2 = data2(1:ceil(.7*(length(data1extract) - 1))*36,:);
vdata2 = data2(ceil(.7*(length(data1extract) - 1))*36+1:ceil(.76*(length(data2extract) - 1))*36,:);
ttdata2 = data2(ceil(.86*(length(data2extract) - 1))*36+1:end,:);

tdata3 = data3(1:ceil(.7*(length(data1extract) - 1))*36,:);
vdata3 = data3(ceil(.7*(length(data3extract) - 1))*36+1:ceil(.813*(length(data3extract) - 1))*36,:);
ttdata3 = data3(ceil(.885*(length(data3extract) - 1))*36+1:end,:);


% tdata1 = [tdata1; vdata1];
% tdata2 = [tdata2; vdata2];
% tdata3 = [tdata3; vdata3];


%% Running K Means for K = 2 to 10 to find best k using Elbow Method

elbowMethod(tdata1,vdata1,'Highway');
elbowMethod(tdata2,vdata2,'Street');
elbowMethod(tdata2,vdata2,'TallBulding');


%% Selecting K = 3 by observing above graph

for test = [1 0]

k = ones(1,3)*2;
itr = 6;
diag = test;
regularition = 0;
 
if diag == 1
    
  
    
    [idx,m,cov,pi] = myKMeans1(tdata1,k(1));
    [m1,cov1,pi1,gnk1] = myGMM1(m,cov,pi,tdata1,k(1),itr,diag,regularition);

    [idx2,m2,cov2,pi2] = myKMeans1(tdata2,k(2));
    [m3,cov3,pi3,gnk3] = myGMM1(m2,cov2,pi2,tdata2,k(2),itr,diag,regularition);

    [idx4,m4,cov4,pi4] = myKMeans1(tdata2,k(3));
    [m5,cov5,pi5,gnk5] = myGMM1(m4,cov4,pi4,tdata3,k(3),itr,diag,regularition);
   
    
else
    
         [fidx,fm,fcov,fpi] = myKMeans1(tdata1,k(1));
        [fm1,fcov1,fpi1,fgnk1] = myGMM1(fm,fcov,fpi,tdata1,k(1),itr,diag,regularition);

        [fidx2,fm2,fcov2,fpi2] = myKMeans1(tdata2,k(2));
        [fm3,fcov3,fpi3,fgnk3] = myGMM1(fm2,fcov2,fpi2,tdata2,k(2),itr,diag,regularition);

        [fidx4,fm4,fcov4,fpi4] = myKMeans1(tdata2,k(3));
        [fm5,fcov5,fpi5,fgnk5] = myGMM1(fm4,fcov4,fpi4,tdata3,k(3),itr,diag,regularition);

     

end


%% Calculating Scores
testdata = [ttdata1; ttdata2(1:1440,:); ttdata3(1:1440,:)];

    if diag == 1
        
%         Px1 = calculatePx(testdata,pi1,m1,cov1);
%         Px2 = calculatePx(testdata,pi3,m3,cov3);
%         Px3 = calculatePx(testdata,pi5,m5,cov5);
% 
%         Px1 = log(Px1);
%         Px2 = log(Px2);
%         Px3 = log(Px3);


        Px1 = myClassProbability(testdata,pi1,m1,cov1,pi3,m3,cov3,pi5,m5,cov5,1);
        Px2 = myClassProbability(testdata,pi1,m1,cov1,pi3,m3,cov3,pi5,m5,cov5,2);
        Px3 = myClassProbability(testdata,pi1,m1,cov1,pi3,m3,cov3,pi5,m5,cov5,3);
        
        actual = [ones(length(ttdata1)/36,1); ones(length(ttdata1)/36,1)*2; ones(length(ttdata1)/36,1)*3];

        Px = [Px1 Px2 Px3];
        [~,predicted] = max(Px,[],2);

        predictedreshaped = reshape(predicted,[36 length(predicted)/36]);
        c1 = sum(predictedreshaped==1);
        c2 = sum(predictedreshaped==2);
        c3 = sum(predictedreshaped==3);

        c = [c1' c2' c3'];
        [~,predictedImage] = max(c,[],2);
        
        disp('Confusion Matrix from scores of points : ');
        myConfusionPlot(predictedImage',actual',k(1),diag);
    else

%         fPx1 = calculatePx(testdata,fpi1,fm1,fcov1);
%         fPx2 = calculatePx(testdata,fpi3,fm3,fcov3);
%         fPx3 = calculatePx(testdata,fpi5,fm5,fcov5);
% 
%         fPx1 = log(fPx1);
%         fPx2 = log(fPx2);
%         fPx3 = log(fPx3);
        
        fPx1 = myClassProbability(testdata,fpi1,fm1,fcov1,fpi3,fm3,fcov3,fpi5,fm5,fcov5,1);
        fPx2 = myClassProbability(testdata,fpi1,fm1,fcov1,fpi3,fm3,fcov3,fpi5,fm5,fcov5,2);
        fPx3 = myClassProbability(testdata,fpi1,fm1,fcov1,fpi3,fm3,fcov3,fpi5,fm5,fcov5,3);

        factual = [ones(length(ttdata1)/36,1); ones(length(ttdata1)/36,1)*2; ones(length(ttdata1)/36,1)*3];

        fPx = [fPx1 fPx2 fPx3];
        [~,fpredicted] = max(fPx,[],2);

        fpredictedreshaped = reshape(fpredicted,[36 length(fpredicted)/36]);
        fc1 = sum(fpredictedreshaped==1);
        fc2 = sum(fpredictedreshaped==2);
        fc3 = sum(fpredictedreshaped==3);

        fc = [fc1' fc2' fc3'];
        [~,fpredictedImage] = max(fc,[],2);
        
        disp('Confusion Matrix from scores of points : ');
        myConfusionPlot(fpredictedImage',factual',k(1),diag);

    end


%% Calculating scores for ROC

if diag == 1


    reshapedPx1 = (sum(reshape(Px(:,1),[36 length(predicted)/36]))/36)';
    reshapedPx2 = (sum(reshape(Px(:,2),[36 length(predicted)/36]))/36)';
    reshapedPx3 = (sum(reshape(Px(:,3),[36 length(predicted)/36]))/36)';


    scores1 = [reshapedPx1 reshapedPx2 reshapedPx3];
    [~,indexs] = max(scores1,[],2);
    disp('Confusion Matrix from ROC scores before normalisition : ');
    myConfusionPlot(indexs',actual',k(1),diag);

    scores2 = normalizescores(scores1,1);
    [~,indexs1] = max(scores2,[],2);
    disp('Confusion Matrix from ROC scores after normalisition : ');
    myConfusionPlot(indexs1',actual',k(1),diag);
else
    

    freshapedPx1 = (sum(reshape(fPx1,[36 length(predicted)/36]))/36)';
    freshapedPx2 = (sum(reshape(fPx2,[36 length(predicted)/36]))/36)';
    freshapedPx3 = (sum(reshape(fPx3,[36 length(predicted)/36]))/36)';


    fscores1 = [freshapedPx1 freshapedPx2 freshapedPx3];
    [~,findexs] = max(fscores1,[],2);
    disp('Confusion Matrix from ROC scores before normalisition : ');
    myConfusionPlot(findexs',actual',k(1),diag);

 
    fscores2 = normalizescores(fscores1,1);
    [~,findexs1] = max(fscores2,[],2);
     disp('Confusion Matrix from ROC scores after normalisition : ');
    myConfusionPlot(findexs1',factual',k(1),diag);
    
    
end

end

%% Plotting ROC

% without norm
% mean norm
% mean var norm
% min max norm
% indivial class mean norm
%k =3
% scoresmean = scores2;   
% fscoresmean = fscores2;
%  scoresmean1 = scores2;
%  fscoresmean1 = fscores2;
%    scoresmean2 = scores2;
%   fscoresmean2 = fscores2;
%    scoresmean3 = scores2;
%   fscoresmean3 = fscores2;
%     scoresmean8 = scores2;
%    fscoresmean8 = fscores2;

% without norm
% mean norm
% indivial class mean norm
%k =4
% scoresmean4 = scores2;   
% fscoresmean4 = fscores2;
%  scoresmean5 = scores2;
%  fscoresmean5 = fscores2;
%     scoresmean9 = scores2;
%    fscoresmean9 = fscores2;

% without norm
% mean norm
% indivial class mean norm
%k = 2
% scoresmean6 = scores2;   
% fscoresmean6 = fscores2;
%  scoresmean7 = scores2;
%  fscoresmean7 = fscores2;
%   scoresmean10 = scores2;
%   fscoresmean10 = fscores2;


myPlotRoc(scoresmean6,actual);
myPlotRoc(fscoresmean6,factual);
myPlotRoc(scoresmean7,actual);
myPlotRoc(fscoresmean7,factual);
myPlotRoc(scoresmean10,actual);
myPlotRoc(fscoresmean10,factual);



legend('Diagonal CoV','Full CoV','Diagonal CoV - Normalized Dataset','Full CoV - Normalized Dataset','Diagonal CoV - Normalized Individual Class','Full CoV - Normalized Individual Class','Location','southeast');
t = 0:.5:1;
plot(t,t,'--k');
title(['ROC Curve of Image Dataset for K = ',num2str(k(1))]);
set(gca,'FontSize',12,'FontWeight','bold')
hold off
print('-djpeg', ['ROC_ImageDataSet_K_',num2str(k(1)),'.jpg'], '-r300');
close all;

% Plotting DET

% target = [scores2(1:40,1); scores2(41:80,2); scores2(81:120,3)];
% nontarget = [scores2(41:120,1); scores2(1:40,2); scores2(81:120,2); scores2(1:80,3)];
% 
% target1 = [fscores2(1:40,1); fscores2(41:80,2); fscores2(81:120,3)];
% nontarget1 = [fscores2(41:end,1); fscores2(1:40,2); fscores2(81:120,2); fscores2(1:80,3)];
 


target = [scoresmean6(1:40,1); scoresmean6(41:80,2); scoresmean6(81:120,3)];
nontarget = [scoresmean6(41:120,1); scoresmean6(1:40,2); scoresmean6(81:120,2); scoresmean6(1:80,3)];

target1 = [fscoresmean6(1:40,1); fscoresmean6(41:80,2); fscoresmean6(81:120,3)];
nontarget1 = [fscoresmean6(41:end,1); fscoresmean6(1:40,2); fscoresmean6(81:120,2); fscoresmean6(1:80,3)];


target2 = [scoresmean7(1:40,1); scoresmean7(41:80,2); scoresmean7(81:120,3)];
nontarget2 = [scoresmean7(41:120,1); scoresmean7(1:40,2); scoresmean7(81:120,2); scoresmean7(1:80,3)];

target3 = [fscoresmean7(1:40,1); fscoresmean7(41:80,2); fscoresmean7(81:120,3)];
nontarget3 = [fscoresmean7(41:end,1); fscoresmean7(1:40,2); fscoresmean7(81:120,2); fscoresmean7(1:80,3)];


target4 = [scoresmean10(1:40,1); scoresmean10(41:80,2); scoresmean10(81:120,3)];
nontarget4 = [scoresmean10(41:120,1); scoresmean10(1:40,2); scoresmean10(81:120,2); scoresmean10(1:80,3)];

target5 = [fscoresmean10(1:40,1); fscoresmean10(41:80,2); fscoresmean10(81:120,3)];
nontarget5 = [fscoresmean10(41:end,1); fscoresmean10(1:40,2); fscoresmean10(81:120,2); fscoresmean10(1:80,3)];


demo_main(target,nontarget,target1,nontarget1,target2,nontarget2,target3,nontarget3,target4,nontarget4,target5,nontarget5,'old');
title(['DET Curve of Image Dataset for K = ',num2str(k(1))]);
set(gca,'FontSize',12,'FontWeight','bold')
print('-djpeg', ['DET_ImageDataSet_K_',num2str(k(1)),'.jpg'], '-r300');
close all;


disp('---------------- END ----------------');


