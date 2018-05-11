clc; close all; clf;

%% Loading data and seperating Input and output Y
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

N = [5];
i = 1;
rmsFromTraining = zeros(1,length(N));

%parTrain = zeros(size(trainingDataInput,1),length(N));
parTrain = cell(1,length(N));

for n=N
    
[parTrain{1,i},E1] = Regression(input,Y,n);
rmsFromTraining(i) = CalculateError(E1,Y);

fprintf('Sum of Squared Error for polynomial degree M = %d is %f \n',n,rmsFromTraining(i));


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
title(['Training data Data for M = ',num2str(n)],'FontSize',16,'FontWeight','bold');
hold off

i = i+1;
end


%% Finding correct order M from Validation Data

p = 1;
rmsFromValidation = zeros(1,length(N));
for n=N
      
testingV = ones(size(validationDataInput,1),1);
for i = 1:n
    testingV = [testingV validationDataInput.^i];  
for j=1:n
   
    if i+j <= n
       testingV = [testingV validationDataInput(:,1).^i.*validationDataInput(:,2).^j]; 
    end     
end

end

E2 = testingV*parTrain{1,p}; 

rmsFromValidation(p) = CalculateError(E2,validationDataOutput);
fprintf('Sum of Squared Error for polynomial degree M = %d is %f \n',n,rmsFromValidation(p));

%subplot(2,2,i); plot(input,Y,'o',input,E1,'LineWidth',2); title(['M = ',num2str(n)]); xlabel('X'); ylabel('Y');

p = p+1;
end

[rmsmin, M] = min(rmsFromValidation);



%% Calculating Error and plotting data from Testing Data

index = M;
M = N(M);

testingX1 = ones(size(testingDataInput,1),1);
for i = 1:M
    testingX1 = [testingX1 testingDataInput.^i];  
for j=1:M
   
    if i+j <= M
       testingX1 = [testingX1 testingDataInput(:,1).^i.*testingDataInput(:,2).^j]; 
    end     
end

end 
 
i = 1;
xaxis = linspace(min(testingDataInput(:,1)),max(testingDataInput(:,1)),100);
 yaxis = linspace(min(testingDataInput(:,2)),max(testingDataInput(:,2)),100);
[x, y] = meshgrid( xaxis, yaxis );

E3=o(1).*(x.^0).*(y.^0) + o(2).*(x.^1).*(y.^0) + o(3).*(x.^0).*(y.^1) + o(4).*(x.^2).*(y.^0) + o(5).*(x.^1).*(y.^1) + o(6).*(x.^0).*(y.^2) + o(7).*(x.^3).*(y.^0) + o(8).*(x.^2).*(y.^1) + o(9).*(x.^1).*(y.^2) + o(10).*(x.^0).*(y.^3) + o(11).*(x.^4).*(y.^0) + o(12).*(x.^3).*(y.^1) + o(13).*(x.^2).*(y.^2) + o(14).*(x.^1).*(y.^3) + o(15).*(x.^0).*(y.^4) + o(16).*(x.^5).*(y.^0) + o(17).*(x.^4).*(y.^1) + o(18).*(x.^3).*(y.^2) + o(19).*(x.^2).*(y.^3) + o(20).*(x.^1).*(y.^4) + o(21).*(x.^0).*(y.^5); 


figure;
plot3(testingDataInput(:,1),testingDataInput(:,2),testingDataInput,'.','MarkerFaceColor','y','MarkerEdgeColor','red','MarkerSize',18)
hold on

surf(x, y, E3) 
xlabel('X1','FontSize',15,'FontWeight','bold'); ylabel('X2','FontSize',15,'FontWeight','bold');
zlabel('Y','FontSize',15,'FontWeight','bold');
title(['Testing data Data for M = ',num2str(n)],'FontSize',16,'FontWeight','bold');
hold off

E4 = testingX1*parTrain{1,index};
rmsFromTesting = CalculateError(testingDataOutput,E4);
fprintf('Sum of Squared Error for Training data polynomial degree M = %d is %f \n',M,rmsFromTesting);


%% Plotting Error graph

figure;
plot(N,rmsFromTraining,'-o',N,rmsFromValidation,'-o','LineWidth',2); 
title('SSE Vs Degree','FontSize',16,'FontWeight','bold'); 
xlabel('Degree of X','FontSize',15,'FontWeight','bold'); 
ylabel('Sum of Squared Error','FontSize',15,'FontWeight','bold');
legend('Training Data','Validation Data');
%print('-djpeg', 'text.jpg', '-r300');

%% Plotting Targeted Regression graph

 figure;
 plotregression(testingDataOutput,E4); 

