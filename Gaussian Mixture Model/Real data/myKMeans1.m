function [ idx,mean,cov,priorProb ] = myKMeans( data,k )
% Runs K Means and return Mean, Covariance and Prior Probability for each

[idx,mean,sumd,D] = kmeans(data,k);

 
 % Calculating Prior Probability
 priorProb = zeros(k,1);
    for i = 1:k
       kind = find(idx==i);
       priorProb(i,1) = length(kind);
    end
    

 %Calculating Covariance Matrix
 cov = cell(k,1);
 
 for i = 1:k
  cov{i,1} = myCovariance(data',mean(i,:)');
end




end

