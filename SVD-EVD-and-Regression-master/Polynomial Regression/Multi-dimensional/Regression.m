function [par, Y ] = Regression( input,output,n )
%REGRESSION returns Minimum parameter and Estimated Output

X = ones(size(input,1),1);
for i = 1:n
    X = [X input.^i];
    
end    

par = inv((X'*X))*X'*output;

Y = X*par;


end

