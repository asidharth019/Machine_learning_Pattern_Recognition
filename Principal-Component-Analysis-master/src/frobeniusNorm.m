function n = frobeniusNorm( A )
%Calculates frobeniusNorm of matrix A.

 sq = A.*A;
 n = sqrt(sum(sum(sq)));


end

