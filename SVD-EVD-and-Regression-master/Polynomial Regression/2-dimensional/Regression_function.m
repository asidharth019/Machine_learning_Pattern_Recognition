function [Y ] = Regression_function( input,par,n )
%REGRESSION returns Minimum parameter and Estimated Output


X = ones(size(input,1),1);
for i = 1:n
for j=1:n
   
    if i+j <= n
       X = [X input(:,1).^i.*input(:,2).^j]; 
    end     
end
X = [X input.^i];
    
end   

Y = X*par;


end

