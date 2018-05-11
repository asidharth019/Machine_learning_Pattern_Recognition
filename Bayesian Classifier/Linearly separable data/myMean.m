function [ m ] = myMean( x )
% Return Mean of a given input.

[d n] = size(x);
m = zeros(d,1);

m = sum(x,2)/n;


end

