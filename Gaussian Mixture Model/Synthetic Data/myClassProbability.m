function [ g ] = myClassProbability( testdata,prior,mean,cov,prior1,mean1,cov1,no)
% Return Posterior Probability for a give point.

g1 = zeros(size(testdata,1),1);
for j = 1:size(testdata,1)
    for i =  1:length(prior)
       g1(j,1) =  g1(j,1) + prior(i)*calculateGPDF(testdata(j,:)',mean(i,:)',cov{i,1});
    end
end

g2 = zeros(size(testdata,1),1);
for j = 1:size(testdata,1)
    for i =  1:length(prior1)
       g2(j,1) =  g2(j,1) + prior1(i)*calculateGPDF(testdata(j,:)',mean1(i,:)',cov1{i,1});
    end
end



g1 = g1.*(1/2);
g2 = g2.*(1/2);


if no == 1
    g = g1./(g1+g2);
   
elseif no == 2    
     g = g2./(g1+g2);


end

end

