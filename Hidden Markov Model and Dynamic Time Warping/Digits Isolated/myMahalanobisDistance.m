function [ dist ] = myMahalanobisDistance( x,m,c )
%Returns Mahalanobis distance between X and Mean

dist = sqrt((x-m)*inv(c)*(x-m)');

end

