% clc; clear all; close all

%% Loading training data

data1extract = untar('1.tgz','1');
data1extract(1) = [];
len1 = zeros(ceil(.7*(length(data1extract))),1);
dis1 = zeros(ceil(.7*(length(data1extract))),1);
len11 = zeros(templates,1);

for i = 1:ceil(.7*(length(data1extract)))
    temp = dlmread(data1extract{i});
    len1(i) = temp(1,2);
    temp(1,:) = [];
    if i == 1
        data1 = temp;
    else
        data1 = [data1; temp];
    end
end


dataoextract = untar('o.tgz','o');
dataoextract{53} = 'o/nh_o.mfcc';
leno = zeros(ceil(.7*(length(dataoextract))),1);
diso = zeros(ceil(.7*(length(data1extract))),1);
lenoo = zeros(templates,1);
for i = 1:ceil(.7*(length(dataoextract)))
    temp = dlmread(dataoextract{i});
    leno(i) = temp(1,2);
    temp(1,:) = [];
    if i == 1
        datao = temp;
    else
        datao = [datao; temp];
    end
end


datazextract = untar('z.tgz','z');
lenz = zeros(ceil(.7*(length(datazextract))),1);
disz = zeros(ceil(.7*(length(data1extract))),1);
lenzz = zeros(templates,1);
for i = 1:ceil(.7*(length(datazextract)))
    temp = dlmread(datazextract{i});
    lenz(i) = temp(1,2);
    temp(1,:) = [];
    if i == 1
        dataz = temp;
    else
        dataz = [dataz; temp];
    end
end



%% Loading Validation Data


vlen1 = zeros(9,1);
vleno = zeros(9,1);
vlenz = zeros(9,1);

vpredicted = zeros(45,1);
vdist1 = zeros(40,9);
vdisto = zeros(40,9);
vdistz = zeros(40,9);
vdistance = zeros(3,1);

itr=  1;
for i = ceil(.70*(length(data1extract)))+1:ceil(.85*(length(data1extract)))
    temp = dlmread(data1extract{i});
    vlen1(itr) = temp(1,2);
    temp(1,:) = [];
    
    for j = 1:40
        temp1 = dlmread(data1extract{j});
        vdist1(j,itr) = DTWDistance(temp1,temp);
    end
    itr = itr + 1;
end



itr=  1;
for i = ceil(.70*(length(dataoextract)))+1:ceil(.85*(length(dataoextract)))
    temp = dlmread(dataoextract{i});
    vleno(itr) = temp(1,2);
    temp(1,:) = [];
    
    for j = 1:40
        temp1 = dlmread(dataoextract{j});
        vdisto(j,itr) = DTWDistance(temp1,temp);
    end
    itr = itr + 1;
end



itr=  1;
for i = ceil(.70*(length(datazextract)))+1:ceil(.85*(length(datazextract)))
    temp = dlmread(datazextract{i});
    vlenz(itr) = temp(1,2);
    temp(1,:) = [];
    
    for j = 1:40
        temp1 = dlmread(datazextract{j});
        vdistz(j,itr) = DTWDistance(temp1,temp);
    end
    itr = itr + 1;
end

%% Selecting Template

[val1,ind1] = sort(vdist1);
template1 = ind1(1:3,:);
[M1,F1] = mode(template1,2);
inds1 = [1 38];  %17 2 38
    
[valo,indo] = sort(vdisto);
templateo = indo(1:3,:);
[Mo,Fo] = mode(templateo,2);
indso = [15 19]; %17 16

[valz,indz] = sort(vdistz);
templatez = indz(1:3,:);
[Mz,Fz] = mode(templatez,2);
indsz = [27 35]; %28 33

templates = 2;
%% Loading Testing data

tlen1 = zeros(8,1);
tleno = zeros(8,1);
tlenz = zeros(8,1);

predicted = zeros(24,1);
dist1 = zeros(templates,1);
disto = zeros(templates,1);
distz = zeros(templates,1);
distance = zeros(3,1);
alldist = zeros(24,3);

%  alldist1 = alldist;
%  alldist2 = alldist;
% alldist3 = alldist;



itr=  1;
for i = ceil(.85*(length(data1extract)))+1:length(data1extract)
    temp = dlmread(data1extract{i});
    tlen1(i) = temp(1,2);
    temp(1,:) = [];
    
    for j = 1:templates
        temp1 = dlmread(data1extract{inds1(j)});
        dist1(j) = DTWDistance(temp1,temp);
    end
    distance(1) = min(dist1);
    
    for j = 1:templates
        temp1 = dlmread(dataoextract{indso(j)});
        disto(j) = DTWDistance(temp1,temp);
    end
    distance(2) = min(disto);
    
    for j = 1:templates
        temp1 = dlmread(datazextract{indsz(j)});
        distz(j) = DTWDistance(temp1,temp);
    end
    distance(3) = min(distz);
    alldist(itr,:) = distance';
   
    [~,predicted(itr)] = min(distance);
    
    itr = itr + 1;
end



for i = ceil(.85*(length(dataoextract)))+1:length(dataoextract)
    temp = dlmread(dataoextract{i});
    tleno(i) = temp(1,2);
    temp(1,:) = [];
    
    
    for j = 1:templates
        temp1 = dlmread(data1extract{inds1(j)});
        dist1(j) = DTWDistance(temp1,temp);
    end
    distance(1) = min(dist1);
    
    for j = 1:templates
        temp1 = dlmread(dataoextract{indso(j)});
        disto(j) = DTWDistance(temp1,temp);
    end
    distance(2) = min(disto);
    
    for j = 1:templates
        temp1 = dlmread(datazextract{indsz(j)});
        distz(j) = DTWDistance(temp1,temp);
    end
    distance(3) = min(distz);
    alldist(itr,:) = distance';

    [~,predicted(itr)] = min(distance);
    
    itr = itr + 1;
end


for i = ceil(.85*(length(datazextract)))+1:length(datazextract)
    temp = dlmread(datazextract{i});
    tlenz(i) = temp(1,2);
    temp(1,:) = [];
    
    for j = 1:templates
        temp1 = dlmread(data1extract{inds1(j)});
        dist1(j) = DTWDistance(temp1,temp);
    end
    distance(1) = min(dist1);
    
    for j = 1:templates
        temp1 = dlmread(dataoextract{indso(j)});
        disto(j) = DTWDistance(temp1,temp);
    end
    distance(2) = min(disto);
    
    for j = 1:templates
        temp1 = dlmread(datazextract{indsz(j)});
        distz(j) = DTWDistance(temp1,temp);
    end
    distance(3) = min(distz);
       alldist(itr,:) = distance';

    [~,predicted(itr)] = min(distance);
    
    itr = itr + 1;
end



% Testing


actual = [ones(1,8) ones(1,8)*2 ones(1,8)*3];

myConfusionPlot(predicted',actual,templates);
 
 
%% Confusion Matrix

[~,pred1] = min(alldist1,[],2);
[~,pred2] = min(alldist2,[],2);
[~,pred3] = min(alldist3,[],2);

myConfusionPlot(pred1',actual,1);
myConfusionPlot(pred2',actual,2);
myConfusionPlot(pred3',actual,3);



 %% Plotting ROC
 
 sumalldist1 = sum(alldist1,2);
 alldist11 = alldist1./sumalldist1;
 
  sumalldist2 = sum(alldist2,2);
 alldist22 = alldist2./sumalldist2;
 
  sumalldist3 = sum(alldist3,2);
 alldist33 = alldist3./sumalldist3;
 
 alldist1n = normalizescores(alldist11,1);
 alldist2n = normalizescores(alldist22,1);
 alldist3n = normalizescores(alldist33,1);

myPlotRoc(alldist1n,actual);
 myPlotRoc(alldist2n,actual);
 myPlotRoc(alldist3n,actual);
 
 
 legend('Top 1 Template','Top 2 Templates','Top 3 Templates','Location','southeast');
 
t = 0:.5:1;
plot(t,t,'--k');
title(['ROC Curve of DTW Isolated Digits']);
set(gca,'FontSize',12,'FontWeight','bold')
hold off
print('-djpeg', ['DTW_ROC_Isolated_Digit.jpg'], '-r300');
close all;



%% Plotting DET

alldist1n = alldist11;
 alldist2n = alldist22;
 alldist3n = alldist33;

% target1 = [alldist1(1:8,1); alldist1(9:16,2); alldist1(17:24,3)];
% nontarget1 = [alldist1(9:24,1); alldist1(1:8,2); alldist1(17:24,2); alldist1(1:16,3)]; 
%  
% target2 = [alldist2(1:8,1); alldist2(9:16,2); alldist2(17:24,3)];
% nontarget2 = [alldist2(9:24,1); alldist2(1:8,2); alldist2(17:24,2); alldist2(1:16,3)]; 
%  
% target3 = [alldist3(1:8,1); alldist3(9:16,2); alldist3(17:24,3)];
% nontarget3 = [alldist3(9:24,1); alldist3(1:8,2); alldist3(17:24,2); alldist3(1:16,3)]; 
 
target1 = [alldist1n(1:8,1); alldist1n(9:16,2); alldist1n(17:24,3)];
nontarget1 = [alldist1n(9:24,1); alldist1n(1:8,2); alldist1n(17:24,2); alldist1n(1:16,3)]; 
 
target2 = [alldist2n(1:8,1); alldist2n(9:16,2); alldist2n(17:24,3)];
nontarget2 = [alldist2n(9:24,1); alldist2n(1:8,2); alldist2n(17:24,2); alldist2n(1:16,3)]; 
 
target3 = [alldist3n(1:8,1); alldist3n(9:16,2); alldist3n(17:24,3)];
nontarget3 = [alldist3n(9:24,1); alldist3n(1:8,2); alldist3n(17:24,2); alldist3n(1:16,3)];

test_data.tar1 = target1;
test_data.non1 = nontarget1;

test_data.tar2 = target2;
test_data.non2 = nontarget2;

test_data.tar3 = target3;
test_data.non3 = nontarget3;


demo_main(test_data,'big');
title(['DET Curve of DTW Isolated Digits']);
set(gca,'FontSize',12,'FontWeight','bold')
print('-djpeg', ['DTW_DET_Isolated.jpg'], '-r300');
close all;
