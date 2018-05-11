function [ idx,mean,cov,priorProb ] = myKMeans( data,k )
% Runs K Means and return Mean, Covariance and Prior Probability for each
% cluster

%% Initializing Random Means
oldmean = zeros(k,size(data,2));
for i = 1:k
oldmean(i,:) = min(data) + (max(data) - min(data)).*(rand(1,1));
end


%% Running K Means Algorithm

%disp(oldmean);
distance = zeros(k,1);
idx = zeros(length(data),1);
newmean = zeros(k,size(data,2));
itr = 1;

while (oldmean - newmean) ~= zeros(k,size(data,2))

    if itr > 1
     oldmean=newmean;
    end
     
    % Assigning data to closest mean
    for i = 1:length(data)
        for j = 1:k
           distance(j,1) =  myeuclideanDistance(data(i,:)',oldmean(j,:)');
        end
        [~,idx(i,1)] = min(distance);
    end
    
    
    % Recalculate Mean
    for i = 1:k
       kind = find(idx==i);
       if length(kind) > 0
          newmean(i,:) = sum(data(kind,:))/length(kind);  
       else
          newmean(i,:) =  min(data) + (max(data) - min(data)).*(rand(1,1));
       end
    end
    
    
    itr = itr + 1;
    
end

 disp(['Total number of Iterations of K Means for K = ',num2str(k),' is : ',num2str(itr)]);

 % Returning New Mean
 mean = newmean;
 
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

