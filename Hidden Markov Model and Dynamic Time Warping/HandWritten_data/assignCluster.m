function [ idx ] = assignCluster( data,m,c )
%Assigns cluster number to Test data points

idx = zeros(length(data),1);
temp = zeros(1,length(c));

for i = 1:length(data)
   
   for j = 1:length(c)
   
       temp(j) = myeuclideanDistance(data(i,:),m(j,:));
       %temp(j) = myMahalanobisDistance(data(i,:),m(j,:),c{j});
       
   end
    
   [~,idx(i)] = min(temp);
    
end


end

