 function [ forbeniusNormArray ] = EVD_REC_RGBScale( img,N,imagetype )
%% To perform EVD on given Image and return frobenius Norm

image=(img*img');
%% Performing EVD on A*A' & Reconstructing Original Image
[eigVector, eigVal] = eig(double(image));

sortedEigVal = diag(sort(diag(eigVal),'descend'));

[c, ind]=sort(diag(eigVal),'descend');
sortedEigVector=eigVector(:,ind);

reconstructedPart = sortedEigVector*sortedEigVal*(inv(sortedEigVector));
reconstructedImage = reconstructedPart*inv(img*img')*img;
% subplot(2,1,1); imshow(img); title('Original image');
% subplot(2,1,2); imshow(uint8(reconstructedImage)); title('Reconstructed image');

forbeniusNormError = frobeniusNorm(reconstructedImage,double(img));
fprintf('frobenius Norm on reconstructed image with original image %f \n',forbeniusNormError);    

%% Selecting Top N Eigne Values and reconstructing image with corresponding error image

forbeniusNormArray = zeros(1,length(N));
i = 1;
j = 1;
%figure;
for n = N 
    kEigVal = sortedEigVal;
    kEigVal(n+1:end,:) = 0;

    reconstructedPartwithN = sortedEigVector*kEigVal*(inv(sortedEigVector));
    reconstructedImagewithN = reconstructedPartwithN*inv(img*img')*img;
    
   reconstructedImagewithNRGB(:,:,1) = reconstructedImagewithN;
    if strcmp(imagetype,'Red Scale')
          reconstructedImagewithNRGB(:,:,1) = reconstructedImagewithN;
          reconstructedImagewithNRGB(:,:,[2 3]) = 0;
     elseif  strcmp(imagetype,'Green Scale')
         reconstructedImagewithNRGB(:,:,2) = reconstructedImagewithN;
         reconstructedImagewithNRGB(:,:,[1 3]) = 0;
     elseif  strcmp(imagetype,'Blue Scale')
         reconstructedImagewithNRGB(:,:,3) = reconstructedImagewithN;
         reconstructedImagewithNRGB(:,:,[1 2]) = 0;
     end      
    
    subplot(3,4,j); imshow(uint8(reconstructedImagewithNRGB)); 
    title(['Reconstructed image for N = ',num2str(n),' eigen values']);
    errorImageN = reconstructedImage-reconstructedImagewithN;
    
     if strcmp(imagetype,'Red Scale')
         errorImageNRGB(:,:,1) = errorImageN;
          errorImageNRGB(:,:,[2 3]) = 0;
     elseif  strcmp(imagetype,'Green Scale')
         errorImageNRGB(:,:,2) = errorImageN;
         errorImageNRGB(:,:,[1 3]) = 0;
     elseif  strcmp(imagetype,'Blue Scale')
         errorImageNRGB(:,:,3) = errorImageN;
         errorImageNRGB(:,:,[1 2]) = 0;
   end       
    
    subplot(3,4,j+1); imshow(uint8(errorImageNRGB)); 
    
    forbeniusNormArray(i) = frobeniusNorm(reconstructedImage,reconstructedImagewithN);
    fprintf('frobenius Norm with K = %d is %f \n',n,forbeniusNormArray(i));
     i = i+1;
     j = j+2;
end

%% Plotting Forbenius Norm Error for Gray Image
figure;

plot(N,abs(forbeniusNormArray),'-o','MarkerIndices',1:length(N))





end

