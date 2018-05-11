function [ forbeniusNormArray ] = EVD_RGB( img,N )
%% To perform EVD on given Image and return frobenius Norm


%% Performing EVD & Reconstructing Original Image
[eigVector, eigVal] = eig(double(img));

sortedEigVal = diag(sort(diag(eigVal),'descend'));

[c, ind]=sort(diag(eigVal),'descend');
sortedEigVector=eigVector(:,ind);

reconstructedImage = sortedEigVector*sortedEigVal*(inv(sortedEigVector));

% subplot(2,1,1); imshow(img); title('Original image');
% subplot(2,1,2); imshow(uint8(reconstructedImage)); title('Reconstructed image using EVD');

forbeniusNormError = frobeniusNorm(reconstructedImage,double(img));
fprintf('frobenius Norm on reconstructed image with original image %f \n',forbeniusNormError);    

%% Selecting Top N Eigne Values and reconstructing image with corresponding error image

forbeniusNormArray = zeros(1,length(N));
i = 1;
j = 1;
for n = N 
    kEigVal = sortedEigVal;
    kEigVal(n+1:end,:) = 0;

    reconstructedImagewithN = sortedEigVector*kEigVal*(inv(sortedEigVector));

    reconstructedImagewithNR = reconstructedImagewithN;
    reconstructedImagewithNR(:,:,[2 3]) = 0;
    
    subplot(3,4,j); imshow(uint8(reconstructedImagewithNR)); 
    title(['Reconstructed image for N = ',num2str(n),' eigen values']);
    
    errorImageN = reconstructedImage-reconstructedImagewithN;
    
    subplot(3,4,j+1); imshow(uint8(errorImageN)); 
    title(['Error image for N = ',num2str(n),' eigen values']);
    forbeniusNormArray(i) = frobeniusNorm(reconstructedImage,reconstructedImagewithN);
    
    fprintf('frobenius Norm with K = %d is %f \n',n,forbeniusNormArray(i));
     i = i+1;
     j = j+2;
end

%% Plotting Forbenius Norm Error for Gray Image
figure;
plot(N,abs(forbeniusNormArray),'-o','MarkerIndices',1:length(N),'LineWidth',2)
xlabel('Top N singular Values');
ylabel('Frobenius Norm of Error Image');
title(['Gray Scale',' Square Image']);


end

