function [ par, Y  ] = RidgeRegression( input,output,n,l )
%RIDGEREGRESSION returns Minimum parameter and Estimated Output

X = ones(size(input,1),1);
for i = 1:n
     X = [X input.^i]; 
for j=1:n
   
    if i+j <= n
       X = [X input(:,1).^i.*input(:,2).^j]; 
    end     
end

end  

l = l*eye(size(X,2));
par = inv((X'*X) + eye(size((X'*X),1))*l)*X'*output;

Y = X*par;


end

