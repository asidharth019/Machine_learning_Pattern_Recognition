function [ dist ] = AvgDistance( x )
%Returns euclidean distance between X and m

dist = sum(sum(x))/length(x);

end

