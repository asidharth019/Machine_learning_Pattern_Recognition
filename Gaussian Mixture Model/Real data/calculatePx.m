function [ Px ] = calculatePx( testdata,prior,mean,cov)
%Returns probability of data points

Px = zeros(size(testdata,1),1);
for j = 1:size(testdata,1)
    for i =  1:length(prior)
       Px(j,1) =  Px(j,1) + prior(i)*calculateGPDF(testdata(j,:)',mean(i,:)',cov{i,1});
    end
end


end

