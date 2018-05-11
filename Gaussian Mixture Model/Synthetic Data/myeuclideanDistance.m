function [ dist ] = myeuclideanDistance( x,m )
%Returns euclidean distance between X and Mean

dist = sqrt((x-m)'*(x-m));

end

