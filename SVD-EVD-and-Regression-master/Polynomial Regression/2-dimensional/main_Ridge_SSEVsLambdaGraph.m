clc; clear; close all; clf;

%% Loading data and seperating Training, Validation and Testing Input and output
data = load('q18_2.txt');

data = data(randperm(length(data)),:);

trainingDataInput = data(1:.7*(size(data,1)),1:2);
validationDataInput = data(.7*(size(data,1))+1:.9*(size(data,1)),1:2);
testingDataInput = data(.9*(size(data,1))+1:end,1:2);

trainingDataOutput = data(1:.7*(size(data,1)),3);
validationDataOutput = data(.7*(size(data,1))+1:.9*(size(data,1)),3);
testingDataOutput = data(.9*(size(data,1))+1:end,3);

%% Getting Training Data Input
input = trainingDataInput;
Y = trainingDataOutput;

X1 = trainingDataInput(:,1);
X2 = trainingDataInput(:,2);


%% Calculating parameter different Polynomials from Training Data

L = exp([-10:.2:10]);
%L = exp(-3);

minerror = zeros(length(L),2);
m = 1;
t = 1;
N = [5];

parTrain = cell(1,length(L));
% rmsFromTraining = zeros(1,length(N));
% rmsFromValidation = zeros(1,length(N));

rmsFromTraining = zeros(1,length(L));
rmsFromValidation = zeros(1,length(L));

rms = 1;

for l = L


%parTrain = zeros(size(trainingDataInput,1),length(N));
i = 1;

for n=N
    
[parTrain{1,rms},E1] = RidgeRegression(input,Y,n,l);
rmsFromTraining(rms) = CalculateError(E1,Y);
fprintf('Sum of Squared Error for polynomial degree M = %d and lambda = %d is %f \n',n,log(l),rmsFromTraining(rms));



i = i+1;
end


%% Finding correct order M from Validation Data

i = 1;
t=1;
for n=N
    
 testingV = ones(size(validationDataInput,1),1);
for y = 1:n
    testingV = [testingV validationDataInput.^y];  
for u=1:n
   
    if y+u <= n
       testingV = [testingV validationDataInput(:,1).^y.*validationDataInput(:,2).^u]; 
    end     
end     
end

E2 = testingV*parTrain{1,rms}; 

rmsFromValidation(rms) = CalculateError(E2,validationDataOutput);
fprintf('Sum of Square Error for polynomial degree M = %d  and lambda = %d is %f \n',n,log(l),rmsFromValidation(rms));

i = i+1;

end

t = t+1;
[rmsmin, M] = min(rmsFromValidation);

minerror(m,1) = rmsmin;
minerror(m,2) = M;
m = m+1;

rms =rms+1;
end

%% Plotting SSE Vs Lambda Graph

figure;
plot(log(L),rmsFromTraining,'-',log(L),rmsFromValidation,'--','LineWidth',2); 
title(['SSE Vs Lambda for M = ',num2str(n)],'FontSize',15,'FontWeight','bold'); 
xlabel('Log of Lambda','FontSize',15,'FontWeight','bold');
ylabel('Sum of Squared Error','FontSize',15,'FontWeight','bold');
legend('Training Data','Validation Data');

