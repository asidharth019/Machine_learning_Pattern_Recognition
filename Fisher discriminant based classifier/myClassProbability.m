function [ g ] = myClassProbability( x,m,cov,m1,cov1,m2,cov2,no)
% Return Posterior Probability for a give point.

s = (x-m);
p1 = s'*inv(cov)*s;
g1 = ( ((1/(2*pi*sqrt(det(cov)))) * exp(-0.5 * (p1)))*(1/3));


s1 = (x-m1);
p2 = s1'*inv(cov1)*s1;
g2 = (((1/(2*pi*sqrt(det(cov1)))) * exp(-0.5 * (p2)))*(1/3));

s2 = (x-m2);
p3 = s2'*inv(cov2)*s2;
g3 = (((1/(2*pi*sqrt(det(cov2)))) * exp(-0.5 * (p3)))*(1/3));


g1s = g1/(g1+g2+g3);
g2s= g2/(g1+g2+g3);
g3s = g3/(g1+g2+g3);  

if no == 1
    g = g1s;
   
elseif no == 2    
     g = g2s;

elseif no == 3    
     g = g3s;    
     
end

end

