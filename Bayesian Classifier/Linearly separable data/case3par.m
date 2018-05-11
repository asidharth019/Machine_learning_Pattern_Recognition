function [ A,B,C ] = case3par(m,c,m1,c1 )
%Returns Parameters A,B & C which would be of form X'AX + B'X + C = 0 for
%calculating decision boundary 

A = -1/2*(inv(c) - inv(c1));
B = inv(c)*m - inv(c1)*m1;
C = -1/2*((m'*inv(c)*m) - (m1'*inv(c1)*m1)) - 1/2*log(det(c)/det(c1));


end

