function [ sse ] = sumOfSquaredError( data,idx,mean )
%Returns Sum of Squared Error
sse = zeros(length(data),1);

for i = 1:length(data)
 
sse(i,1) = (data(i,:)-mean(idx(i),:))*(data(i,:)-mean(idx(i),:))';
    
end

sse = sum(sse);

end

