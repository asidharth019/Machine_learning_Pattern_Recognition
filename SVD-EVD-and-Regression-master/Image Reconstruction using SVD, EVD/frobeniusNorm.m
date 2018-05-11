function n = frobeniusNorm( A,B )
%Calculates frobeniusNorm of matrix A & B.

diff = A - B;
sq = diff.*diff;
n = sqrt(sum(sum(sq)));

end

