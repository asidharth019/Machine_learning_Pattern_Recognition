clc; clear all;

a = imread('18_Rect.jpg');
a = double(a(:,:,1));

img = double(a*a');


[eigVector, eigVal] = eig(double(img));

sortedEigVal = diag(sort(diag(eigVal),'descend'));

[c, ind]=sort(diag(eigVal),'descend');
sortedEigVector=eigVector(:,ind);

reconstructedImage = sortedEigVector*sortedEigVal*(inv(sortedEigVector));

forbeniusNormError = frobeniusNorm(reconstructedImage,double(img));
fprintf('frobenius Norm on reconstructed image with original image %f \n',forbeniusNormError);  

% To reconstruct A from A*A' we multiply Right Psuedo Inverse of A'
%that is inv(A*A')*A 
newa = reconstructedImage*inv(a*a')*a;
forbeniusNormError = frobeniusNorm(a,double(newa));
fprintf('frobenius Norm on reconstructed image with original image %f \n',forbeniusNormError); 
imshow(uint8(newa))
