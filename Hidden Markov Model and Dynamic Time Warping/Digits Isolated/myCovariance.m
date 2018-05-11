function [ c ] = myCovariance( x,m )
% Return Covariance Matrix for a given input.

[d n] = size(x);
c = zeros(d);

   for j = 1:n
     
     c = c + (x(:,j) - m)*(x(:,j) - m)';   
       
   end
    
c = c./(n);

end

