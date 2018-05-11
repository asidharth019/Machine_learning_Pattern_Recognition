function [ idx,mean,cov,priorProb ] = myKMeans( data,k,it )
% Runs K Means and return Mean, Covariance and Prior Probability for each
% cluster

%% Initializing Random Means
oldmean = zeros(k,2);
for i = 1:k
oldmean(i,:) = min(data) + (max(data) - min(data)).*(rand(1,1));
end

%% Assigning data to closest mean

%disp(oldmean);
distance = zeros(k,1);
idx = zeros(length(data),1);
newmean = zeros(k,2);
itr = 1;

while (oldmean - newmean) ~= zeros(k,2)

    if itr > 1
     oldmean=newmean;
    end
      
    for i = 1:length(data)
        for j = 1:k
           distance(j,1) =  myeuclideanDistance(data(i,:)',oldmean(j,:)');
        end
        [~,idx(i,1)] = min(distance);
    end
    
    
    % Recalculate Mean
    for i = 1:k
       kind = find(idx==i);
       newmean(i,:) = sum(data(kind,:))/length(kind);  
    end
    
    
    itr = itr + 1;
    
end

 disp(['Total Iterations : ',num2str(itr)]);

 mean = newmean;
 cov = 0;
 priorProb = 0;





end

