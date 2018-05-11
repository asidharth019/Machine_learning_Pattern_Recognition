function [ E ] = CalculateRidgeError( estimatedY,Y,l,par )
%CALCULATEERROR return Sum of Squared Error

E = (estimatedY-Y)'*(estimatedY-Y);

%% Other Methods to calulate Error
%E = sqrt((estimatedY-Y).^2/(size(Y,1));
%E = sqrt(mean((Y-estimatedY).^2));
% 
% SSE = sum((estimatedY-Y).^2);
% E = sqrt(SSE/length(Y));


%E = E + l/2*(par'*par);

end

