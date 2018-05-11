function scores = normalizescores(score,method)
%Normalizes given scores


if method == 1  % Min Max
    mins = (min(score));
    maxs = (max(score));

    for i = 1:size(score,2)
        scores(:,i) = (score(:,i) - mins(i))/(maxs(i) - mins(i));
    end
elseif method == 2 % Mean Normalise
    
    means = sum(score)/length(score);
    for i = 1:size(score,2)
        scores(:,i) = (score(:,i) - means(i));
    end
    
    
elseif method == 4  % Global Min Max
    mins = min(min(score));
    maxs = max(max(score));

    for i = 1:size(score,2)
        scores(:,i) = (score(:,i) - mins)/(maxs - mins);
    end
elseif method == 0 % Nothing
    scores = score;
elseif method == 3 % Only Variance
    means = sum(score)/length(score);
    sigma= zeros(1,size(score,2));
    for j=1:length(score)
        sigma = sigma + (score(j,:)-means).*(score(j,:)-means);
    end
    sigma = sigma/(length(score)-1);
    sigma = sigma.^0.5;

    for i = 1:size(score,2)
        scores(:,i) = (score(:,i))/sigma(i);
    end
    
else  % 4 Mean - Variance 
        
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

