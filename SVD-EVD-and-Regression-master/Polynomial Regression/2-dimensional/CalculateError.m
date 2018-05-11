function [ E ] = CalculateError( estimatedY,Y )
%CALCULATEERROR return Sum of Squared Error



E = (estimatedY-Y)'*(estimatedY-Y);

%% Other Error Formula
%E = sqrt((estimatedY-Y).^2/(size(Y,1));
%E = sqrt(mean((Y-estimatedY).^2));
% 
% SSE = sum((estimatedY-Y).^2);
% E = sqrt(SSE/length(Y));



end

