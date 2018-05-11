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

%L = exp([-10:.5:10]);
L = exp(-8);

minerror = zeros(length(L),2);
m = 1;
t = 1;
N = [7];

parTrain = cell(1,length(N),length(L));
rmsFromTraining = zeros(1,length(N));
rmsFromValidation = zeros(1,length(N));

% rmsFromTraining = zeros(1,length(L));
% rmsFromValidation = zeros(1,length(L));

rms = 1;

for l = L


%parTrain = zeros(size(trainingDataInput,1),length(N));
i = 1;

for n=N
    
[parTrain{1,i,t},E1] = RidgeRegression(input,Y,n,l);
rmsFromTraining(i) = CalculateError(E1,Y);
fprintf('Sum of Squared Error for polynomial degree M = %d and lambda = %d is %f \n',n,log(l),rmsFromTraining(i));

xaxis = linspace(min(testingDataInput(:,1)),max(testingDataInput(:,1)),100);
 yaxis = linspace(min(testingDataInput(:,2)),max(testingDataInput(:,2)),100);
 [x, y] = meshgrid( xaxis, yaxis );
 t = ones(length(x),1);
 o = parTrain{1,i,1};
 E1=o(1).*(x.^0).*(y.^0) + o(2).*(x.^1).*(y.^0) + o(3).*(x.^0).*(y.^1) + o(4).*(x.^2).*(y.^0) + o(5).*(x.^1).*(y.^1) + o(6).*(x.^0).*(y.^2) + o(7).*(x.^3).*(y.^0) + o(8).*(x.^2).*(y.^1) + o(9).*(x.^1).*(y.^2) + o(10).*(x.^0).*(y.^3) + o(11).*(x.^4).*(y.^0) + o(12).*(x.^3).*(y.^1) + o(13).*(x.^2).*(y.^2) + o(14).*(x.^1).*(y.^3) + o(15).*(x.^0).*(y.^4) + o(16).*(x.^5).*(y.^0) + o(17).*(x.^4).*(y.^1) + o(18).*(x.^3).*(y.^2) + o(19).*(x.^2).*(y.^3) + o(20).*(x.^1).*(y.^4) + o(21).*(x.^0).*(y.^5);

plot3(X1,X2,Y,'.','MarkerFaceColor','y','MarkerEdgeColor','red','MarkerSize',18)
hold on

surf((x), (y), E1) 
xlabel('X1','FontSize',15,'FontWeight','bold'); ylabel('X2','FontSize',15,'FontWeight','bold');
zlabel('Y','FontSize',15,'FontWeight','bold');
title(['Training Data for M = ',num2str(n),' & lambda = ',num2str(log(l))],'FontSize',16,'FontWeight','bold');
hold off

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

E2 = testingV*parTrain{1,i,t}; 

rmsFromValidation(i) = CalculateError(E2,validationDataOutput);
fprintf('Sum of Square Error for polynomial degree M = %d  and lambda = %d is %f \n',n,log(l),rmsFromValidation(i));

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

% figure;
% plot(log(L),rmsFromTraining,'-',log(L),rmsFromValidation,'--','LineWidth',2); 
% title(['SSE Vs Lambda for M = ',num2str(n)],'FontSize',15,'FontWeight','bold'); 
% xlabel('Log of Lambda','FontSize',15,'FontWeight','bold');
% ylabel('Sum of Squared Error','FontSize',15,'FontWeight','bold');
% legend('Training Data','Validation Data');

%% Calculating Error and plotting data from Testing Data


% [e,in] = min(minerror)
% l = L(in(1))
% M = N(e(2))
in = 1;
M = N
l = L

testingX1 = ones(size(testingDataInput,1),1);
for i = 1:M
    testingX1 = [testingX1 testingDataInput.^i];  
for j=1:M
   
    if i+j <= M
       testingX1 = [testingX1 testingDataInput(:,1).^i.*testingDataInput(:,2).^j]; 
    end     
end

    
 end  


 E4 = testingX1*parTrain{1,in(1),in(1)};
 rmsFromTesting = CalculateError(testingDataOutput,E4);
 fprintf('Sum of Squared Error for Training data polynomial degree M = %d is %f \n',M,rmsFromTesting);

 figure;
 xaxis = linspace(min(testingDataInput(:,1)),max(testingDataInput(:,1)),100);
 yaxis = linspace(min(testingDataInput(:,2)),max(testingDataInput(:,2)),100);
 [x, y] = meshgrid( xaxis, yaxis );
 
 E3=o(1).*(x.^0).*(y.^0) + o(2).*(x.^1).*(y.^0) + o(3).*(x.^0).*(y.^1) + o(4).*(x.^2).*(y.^0) + o(5).*(x.^1).*(y.^1) + o(6).*(x.^0).*(y.^2) + o(7).*(x.^3).*(y.^0) + o(8).*(x.^2).*(y.^1) + o(9).*(x.^1).*(y.^2) + o(10).*(x.^0).*(y.^3) + o(11).*(x.^4).*(y.^0) + o(12).*(x.^3).*(y.^1) + o(13).*(x.^2).*(y.^2) + o(14).*(x.^1).*(y.^3) + o(15).*(x.^0).*(y.^4) + o(16).*(x.^5).*(y.^0) + o(17).*(x.^4).*(y.^1) + o(18).*(x.^3).*(y.^2) + o(19).*(x.^2).*(y.^3) + o(20).*(x.^1).*(y.^4) + o(21).*(x.^0).*(y.^5) + o(22).*(x.^6).*(y.^0) + o(23).*(x.^5).*(y.^1) + o(24).*(x.^4).*(y.^2) + o(25).*(x.^3).*(y.^3) + o(26).*(x.^2).*(y.^4) + o(27).*(x.^1).*(y.^5) + o(28).*(x.^0).*(y.^6) + o(29).*(x.^7).*(y.^0) + o(30).*(x.^6).*(y.^1) + o(31).*(x.^5).*(y.^2) + o(32).*(x.^4).*(y.^3) + o(33).*(x.^3).*(y.^4) + o(34).*(x.^2).*(y.^5) + o(35).*(x.^1).*(y.^6) + o(36).*(x.^0).*(y.^7);



figure;
plot3(testingDataInput(:,1),testingDataInput(:,2),testingDataInput,'.','MarkerFaceColor','y','MarkerEdgeColor','red','MarkerSize',18)
hold on

surf(x, y, E3) 
xlabel('X1','FontSize',15,'FontWeight','bold'); ylabel('X2','FontSize',15,'FontWeight','bold');
zlabel('Y','FontSize',15,'FontWeight','bold');
title(['Testing data Data for M = ',num2str(n)],'FontSize',16,'FontWeight','bold');
hold off



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

 
