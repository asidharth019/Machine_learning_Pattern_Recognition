function [ U S V ] = my_svd( A )
%MY_SVD decomposes matrix A in to U,S & V where A = U*S*V'

% Performing EVD of A'*A = X*D*inv(X)
% Here X = V and D is square of S
[V E] = eig(A'*A);
E1 = diag(sort(diag(E),'descend'));
[c, ind]=sort(diag(E),'descend');
V=V(:,ind);

E = E1;

S = sqrt(E);

% To get U from A = U*S*V' implies A*V = U*S
% Now, A*V*(1/S) = U*S*(1/S) , Here 1/S is matrix with reciprocal values of
% S, Thus making S*(1/S) = I
% A*V*(1/S) = U

U = A*V*diag(1./diag(S));

%% Another way to find U 
% [m n] = size(A)
% [n r] = size(V)
% U = zeros(m,r)
% 
% for i = 1:r
%    U(:,i) = A*V(:,i)./S(i,i); 
% end

end

