clc; clear; close all; clf;

%% Loading data and seperating Training, Validation and Testing Input and output
data = load('q18_1.txt');

data = data(randperm(length(data)),:);

trainingDataInput = data(1:.7*(size(data,1)),1);
validationDataInput = data(.7*(size(data,1))+1:.9*(size(data,1)),1);
testingDataInput = data(.9*(size(data,1))+1:end,1);

trainingDataOutput = data(1:.7*(size(data,1)),2);
validationDataOutput = data(.7*(size(data,1))+1:.9*(size(data,1)),2);
testingDataOutput = data(.9*(size(data,1))+1:end,2);

%% Getting Training Data Input
input = trainingDataInput;
Y = trainingDataOutput;


%% Calculating parameter different Polynomials from Training Data
% plot(input,Y,'s');
% hold on


%L = rand(1,10);
L = exp([-10:.4:10]);
%L = exp(-2);

minerror = zeros(length(L),2);
m = 1;
t = 1;

N = [1:10];

parTrain = cell(1,length(N),length(L));
rmsFromTraining = zeros(1,length(N));
rmsFromValidation = zeros(1,length(N));
rms = 1;

for l = L




%parTrain = zeros(size(trainingDataInput,1),length(N));
i = 1;

for n=N
    
[parTrain{1,i,t},E1] = RidgeRegression(input,Y,n,l);
rmsFromTraining(i) = CalculateRidgeError(E1,Y,l,parTrain{1,i,t});
fprintf('Sum of Squared Error for polynomial degree M = %d and lambda = %d is %f \n',n,log(l),rmsFromTraining(i));

% subplot(2,2,i); plot(input,Y,'o',input,E1,'LineWidth',2); 
% title(['M = ',num2str(n),' and Lambda = e^',num2str(log(l))]); xlabel('X'); ylabel('Y');

i = i+1;
end


%% Finding correct order M from Validation Data


i = 1;

for n=N
    
 testingV = ones(size(validationDataInput,1),1);
for j = 1:n
    testingV = [testingV validationDataInput.^j];  
end

E2 = testingV*parTrain{1,i,t};

rmsFromValidation(i) = CalculateRidgeError(E2,validationDataOutput,l,parTrain{1,i,t});
fprintf('Sum of Square Error for polynomial degree M = %d  and lambda = %d is %f \n',n,log(l),rmsFromValidation(i));

%subplot(2,2,i); plot(input,Y,'o',input,E1,'LineWidth',2); title(['M = ',num2str(n)]); xlabel('X'); ylabel('Y');

i = i+1;
end

t = t+1;
[rmsmin, M] = min(rmsFromValidation);

minerror(m,1) = rmsmin;
minerror(m,2) = M;
m = m+1;

rms =rms+1;
end


% figure;
% plot(log(L),rmsFromTraining,'-',log(L),rmsFromValidation,'--','LineWidth',2); 
% title(['SSE Vs Lambda for M = ',num2str(n)],'FontSize',15,'FontWeight','bold'); 
% xlabel('Log of Lambda','FontSize',15,'FontWeight','bold');
% ylabel('Sum of Squared Error','FontSize',15,'FontWeight','bold');
% legend('Training Data','Validation Data');

%% Calculating Error and plotting data from Testing Data


[e,in] = min(minerror)
l = L(in(1))
M = N(e(2))


testingX1 = ones(size(testingDataInput,1),1);
for i = 1:M
    testingX1 = [testingX1 testingDataInput.^i];
    
end  

 xaxis = linspace(min(testingDataInput),max(testingDataInput),100);
 xaxis = xaxis';
 testingX = ones(size(xaxis,1),1);
for i = 1:M
    testingX = [testingX xaxis.^i];
    
end  
 

E3 = testingX*parTrain{1,e(2),in(1)};

E4 = testingX1*parTrain{1,e(2),in(1)};
rmsFromTesting = CalculateError(testingDataOutput,E4);

fprintf('Sum of Squared Error for Training data polynomial degree M = %d is %f \n',M,rmsFromTesting);

figure;
plot(testingDataInput,testingDataOutput,'o',xaxis,E3,'LineWidth',2);
title(['Testing data for M = ',num2str(M),' and lambda : e^',num2str(log(l))],'FontSize',15,'FontWeight','bold'); 
xlabel('X','FontSize',15,'FontWeight','bold');
ylabel('Y','FontSize',15,'FontWeight','bold');



%% Plotting Error graph

figure;
plot(N,rmsFromTraining,'-o',N,rmsFromValidation,'-o','LineWidth',2); 
title(['SSE Vs Degree for lambda : e^',num2str(log(l))],'FontSize',15,'FontWeight','bold'); 
xlabel('Degree of X','FontSize',15,'FontWeight','bold');
ylabel('Sum of Squared Error','FontSize',15,'FontWeight','bold');
legend('Training Data','Validation Data');


%% Plotting Targeted Regression graph

figure;
plotregression(testingDataOutput,E4); 

 



