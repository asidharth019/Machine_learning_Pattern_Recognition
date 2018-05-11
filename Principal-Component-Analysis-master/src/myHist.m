function [  ] = myHist( I )
%Plots Intensity Histogram

I = reshape(I,[1 length(I)^2]);
x = 0:1:255;

histVal = zeros(1,length(x)); 
for i = 0:255
   histVal(i+1) = sum(I==i);
end


range = [0 255 min(histVal) max(histVal)];
histogram(I,x);
axis(range);


end

