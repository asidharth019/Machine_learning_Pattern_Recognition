function [par, Y ] = Regression( input,output,n )
%REGRESSION returns Minimum parameter and Estimated Output

X = ones(size(input,1),1);
for i = 1:n
     X = [X input.^i]; 
for j=1:n
   
    if i+j <= n
       X = [X input(:,1).^i.*input(:,2).^j]; 
    end     
end

end
par = inv((X'*X))*X'*output;

Y = X*par;


end

