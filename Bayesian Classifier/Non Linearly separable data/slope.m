function [ p ] = slope( x,y,c )
% Calculates Slope, Intercept (Equation for a line) from given two point and returns Value for
% given x-point c.

if (y(1) - x(1)) == 0
    m = 0;
else
    m = (y(2) - x(2))/(y(1) - x(1));
end 
b = x(2) - m*x(1);

p = m*c + b;

end

