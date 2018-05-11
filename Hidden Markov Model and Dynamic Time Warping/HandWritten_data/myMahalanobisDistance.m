function [ dist ] = myMahalanobisDistance( x,m,c )
%Returns Mahalanobis distance between X and Mean

dist = sqrt((x-m)*pinv(c)*(x-m)');

end

