function [ dist ] = myeuclideanDistance( x,m )
%Returns euclidean distance between X and m

dist = sqrt((x-m)*(x-m)');

end

