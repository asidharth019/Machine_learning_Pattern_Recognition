function [norm] = myNormalise(score)

norm = zeros(1,length(score));
% minimum=min(score(1,:));
% maximum=1*max(score(1,:));
% for i=1:length(score)
%     norm(1,i) = (score(1,i) - minimum)/(maximum-minimum);
% end

mean = sum(score)/length(score);
sigma=0;
for j=1:length(score)
    sigma = sigma + (score(1,j)-mean).*(score(1,j)-mean);
end
sigma = sqrt(sigma/(length(score)-1));

for i=1:length(score)
    norm(1,i) = (score(1,i)-mean)/sigma;
end
end