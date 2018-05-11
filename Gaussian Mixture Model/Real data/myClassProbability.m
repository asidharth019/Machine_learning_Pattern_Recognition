function [ g ] = myClassProbability( testdata,prior,mean,cov,prior1,mean1,cov1,prior2,mean2,cov2,no)
% Return Posterior Probability for a give point.

g1 = zeros(size(testdata,1),1);
for j = 1:size(testdata,1)
    for i =  1:length(prior)
       g1(j,1) =  g1(j,1) + prior(i)*calculateGPDF(testdata(j,:)',mean(i,:)',cov{i});
    end
end

g2 = zeros(size(testdata,1),1);
for j = 1:size(testdata,1)
    for i =  1:length(prior1)
       g2(j,1) =  g2(j,1) + prior1(i)*calculateGPDF(testdata(j,:)',mean1(i,:)',cov1{i});
    end
end


g3 = zeros(size(testdata,1),1);
for j = 1:size(testdata,1)
    for i =  1:length(prior2)
       g3(j,1) =  g3(j,1) + prior2(i)*calculateGPDF(testdata(j,:)',mean2(i,:)',cov2{i});
    end
end

g1 = g1.*(1/3);
g2 = g2.*(1/3);
g3 = g3.*(1/3);

if no == 1
    g = g1./(g1+g2+g3);
   
elseif no == 2    
     g = g2./(g1+g2+g3);

elseif no == 3    
     g = g3./(g1+g2+g3);      
     
end

end

