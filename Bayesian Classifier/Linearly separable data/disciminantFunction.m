function [ A,B,C ] = disciminantFunction(m,c )
%Returns Parameter A,B & C for decison boundary which is of form 
%  X'AX + B'X + C = 0.

A = -1/2*inv(c);
B = inv(c)*m;
C = -1/2*m'*inv(c)*m - 1/2*log(det(c));


end

