function [ der ] = calculateDerivative( data )
%Returns First Derivative of given data

wsize = 2;

warr = 1:wsize;

deno = 2*warr*warr';

der = zeros(length(data),2);

x = data(:,1);
y = data(:,2);

for i = 3:length(data)-2

    temp = 0;
    for j = 1:wsize
         temp = temp + warr(j)*(x(i+warr(j))-x(i-warr(j)));
    end
    
    der(i,1) = (temp)/deno;
    
    temp = 0;
    for j = 1:wsize
         temp = temp + warr(j)*(y(i+warr(j))-y(i-warr(j)));
    end
    der(i,2) = (temp)/deno;
    
end



end

