clc; close all; clear all; clf;

%% Loading data and seperating Training, Validation and Testing Input and output
data = load('q18_3.txt');

data = data(randperm(length(data)),:);

trainingDataInput = data(1:.7*(size(data,1)),1:8);
validationDataInput = data(.7*(size(data,1))+1:.9*(size(data,1)),1:8);
testingDataInput = data(.9*(size(data,1))+1:end,1:8);
trainingDataInput(:,5) = [];
validationDataInput(:,5) = [];
testingDataInput(:,5) = [];

trainingDataOutput = data(1:.7*(size(data,1)),9);
validationDataOutput = data(.7*(size(data,1))+1:.9*(size(data,1)),9);
testingDataOutput = data(.9*(size(data,1))+1:end,9);

%% Getting Training Data Input
input = trainingDataInput;
Y = trainingDataOutput;


%% Calculating parameter different Polynomials from Training Data
 
N = [1:10];
i = 1;
rmsFromTraining = zeros(1,length(N));

%parTrain = zeros(size(trainingDataInput,1),length(N));
parTrain = cell(1,length(N));

for n=N
    
[parTrain{1,i},E1] = Regression(input,Y,n);
rmsFromTraining(i) = CalculateError(E1,Y);

fprintf('Sum of Squared Error for polynomial degree M = %d is %f \n',n,rmsFromTraining(i));

i = i+1;
end


%% Finding correct order M from Validation Data

i = 1;
rmsFromValidation = zeros(1,length(N));
for n=N
    
 testingV = ones(size(validationDataInput,1),1);
for j = 1:n
    testingV = [testingV validationDataInput.^j];  
end     

E2 = testingV*parTrain{1,i}; 

rmsFromValidation(i) = CalculateError(E2,validationDataOutput);
fprintf('Sum of Squared Error for polynomial degree M = %d is %f \n',n,rmsFromValidation(i));

i = i+1;
end

[rmsmin, M] = min(rmsFromValidation);



%% Calculating Error and plotting data from Testing Data

index = M;
M = N(M);

testingX1 = ones(size(testingDataInput,1),1);
for i = 1:M
    testingX1 = [testingX1 testingDataInput.^i];
    
end  

E4 = testingX1*parTrain{1,index};
rmsFromTesting = CalculateError(testingDataOutput,E4);
fprintf('Sum of Squared Error for Training data polynomial degree M = %d is %f \n',M,rmsFromTesting);

plot(testingDataInput,testingDataOutput,'o',testingDataInput,E4,'LineWidth',2);
xlabel('Input (X)','FontSize',15,'FontWeight','bold'); ylabel('Output (Y)','FontSize',15,'FontWeight','bold');
title('Testing Data','FontSize',16,'FontWeight','bold');


%% Plotting Error graph


plot(N,rmsFromTraining,'-o',N,rmsFromValidation,'-o','LineWidth',2); 
title('SSE Vs Degree','FontSize',16,'FontWeight','bold'); 
xlabel('Degree of X','FontSize',15,'FontWeight','bold'); 
ylabel('Sum of Squared Error','FontSize',15,'FontWeight','bold');
legend('Training Data','Validation Data');

%% Plotting Targeted Regression graph
 figure;
 plotregression(testingDataOutput,E4); 
