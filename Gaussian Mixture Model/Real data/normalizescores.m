function scores = normalizescores(score,method)
%Normalizes given scores


if method == 1  % Min Max Normilization
    mins = (min(score));
    maxs = (max(score));

    for i = 1:size(score,2)
        scores(:,i) = (score(:,i) - mins(i))/(maxs(i) - mins(i));
    end
elseif method == 2 % Mean Normilization
    
    means = sum(score)/length(score);
    for i = 1:size(score,2)
        scores(:,i) = (score(:,i) - means(i));
    end
    
    
else  % Mean Variance Normilization
    means = sum(score)/length(score);
    sigma= zeros(1,size(score,2));
    for j=1:length(score)
        sigma = sigma + (score(j,:)-means).*(score(j,:)-means);
    end
    sigma = sigma/(length(score)-1);
    sigma = sigma.^0.5;

    for i = 1:size(score,2)
        scores(:,i) = (score(:,i) - means(i))/sigma(i);
    end
end



end

