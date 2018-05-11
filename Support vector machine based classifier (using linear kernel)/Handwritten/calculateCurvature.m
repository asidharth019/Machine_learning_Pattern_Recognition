function [ cur ] = calculateCurvature( fder,sder )
%Returns curvature from first and second derivative

cur = zeros(length(fder),1);
fx = fder(:,1);
fy = fder(:,2);
sx = sder(:,1);
sy = sder(:,2);

for i = 1:length(fder)
   
    num = fx(i)*sy(i) - sx(i)*fy(i);
    
    deno = (fx(i)^2 + fy(i)^2)^(3/2);
    
    if deno > 0
        cur(i) = num/deno;
    end
    
end

cur(1:2) = 0;
cur(length(fder)-1:length(fder)) = 0;

end

