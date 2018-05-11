function [ forbeniusNormArray ] = EVD_REC_Concat( img,N )
%% To perform EVD on given Image and return frobenius Norm

image=img*img';
%% Performing EVD & Reconstructing Original Image
[eigVector, eigVal] = eig(double(image));

sortedEigVal = diag(sort(diag(eigVal),'descend'));

[c, ind]=sort(diag(eigVal),'descend');
sortedEigVector=eigVector(:,ind);

reconstructedPart = sortedEigVector*sortedEigVal*(inv(sortedEigVector));
reconstructedImage = reconstructedPart*inv(img*img')*img;
reconstructedImageConcat=ReconstructedConcat(reconstructedImage);

figure;
subplot(2,1,1); imshow(uint8(ReconstructedConcat(img))); title('Original image');
subplot(2,1,2); imshow(uint8(reconstructedImageConcat));
title('Reconstructed image');

forbeniusNormError = frobeniusNorm(reconstructedImage,double(img));
fprintf('frobenius Norm on reconstructed image with original image %f \n',forbeniusNormError);    
figure;
%% Selecting Top N Eigne Values and reconstructing image with corresponding error image

forbeniusNormArray = zeros(1,length(N));
i = 1;
j = 1;
for n = N 
    kEigVal = sortedEigVal;
    kEigVal(n+1:end,:) = 0;

   reconstructedPartwithN = sortedEigVector*kEigVal*(inv(sortedEigVector));
    reconstructedImagewithN = reconstructedPartwithN*inv(img*img')*img;
    reconstructedImagewithNConcat = ReconstructedConcat(reconstructedImagewithN);
       
   subplot(3,4,j); imshow(uint8(reconstructedImagewithNConcat)); 
    if i > 3
         title(['Reconst. img for rand N = ',num2str(n),' eigen val']);
    else
         title(['Reconst. img for top N = ',num2str(n),' eigen val']);
    end    
   
     errorImageN = reconstructedImage-reconstructedImagewithN;
    subplot(3,4,j+1); imshow(uint8(ReconstructedConcat(errorImageN))); 
    if i > 3
          title(['Error img for rand N = ',num2str(n),' eigen val']);
    else
          title(['Error img for top N = ',num2str(n),' eigen val']);
    end   
    forbeniusNormArray(i) = frobeniusNorm(reconstructedImage,reconstructedImagewithN)/2^16;
    fprintf('frobenius Norm with K = %d is %f \n',n,forbeniusNormArray(i));
     i = i+1;
     j = j+2;
end

%% Plotting Forbenius Norm Error for Gray Image
 figure;
 plot(N,abs(forbeniusNormArray),'-o','MarkerIndices',1:length(N))





end


