function [ distance ] = DTWDistance(data1,tdata1)
%Returns DTW Distance between two sequence

DTW = zeros(length(data1)+1,length(tdata1)+1);
DTW(1,:) = Inf;
DTW(:,1) = Inf;
DTW(1,1) = 0;

for i = 2:length(data1)+1
    for j = 2:length(tdata1)+1
        cost = myeuclideanDistance(data1(i-1,:),tdata1(j-1,:));
        min1 = min(DTW(i-1,j),DTW(i,j-1));
        min2 = min(min1,DTW(i-1,j-1));
        DTW(i,j) = cost + min2;
    end
end
   
distance = DTW(length(data1)+1,length(tdata1)+1);


end

