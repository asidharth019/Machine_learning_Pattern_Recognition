function [ forbeniusNormarray ] = SVD_RGBScale( img,N,imagetype )
%% To perform SVD on given Image and return frobenius Norm

%% Performing SVD & Reconstructing Original Image
[U S V] = my_svd(double(img));

reconstructedImage = U*S*V';
% figure;
% subplot(2,1,1); imshow(uint8(img)); title('Original Grayscale image');
% subplot(2,1,2); imshow(uint8(reconstructedImage)); title('Reconstructed image using SVD');

forbeniusNormError = frobeniusNorm(reconstructedImage,double(img));
fprintf('frobenius Norm on reconstructed image with original image %f \n',forbeniusNormError);    

%% Selecting Top N Eigne Values and reconstructing image with corresponding error image

forbeniusNormarray = zeros(1,length(N));
i = 1;
j = 1;
for n = N 
    kEigVal = S;
    kEigVal(n+1:end,:) = 0;

     reconstructedImagewithN = U*kEigVal*V';
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
    
    if i > 3
         title(['Reconstructed image for random N = ',num2str(n),' singular values']);
    else
         title(['Reconstructed image for top N = ',num2str(n),' singular values']);
    end    
   
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
    if i > 3
          title(['Error image for random N = ',num2str(n),' singular values']);
    else
          title(['Error image for top N = ',num2str(n),' singular values']);
    end   
   
    forbeniusNormarray(i) = frobeniusNorm(reconstructedImage,reconstructedImagewithN);
    fprintf('frobenius Norm with K = %d is %f \n',n,forbeniusNormarray(i));
     i = i+1;
     j = j+2;
end
%print(['SVD_Square_',imagetype],'-djpeg')
%% Plotting Forbenius Norm Error for Gray Image
figure;
plot(N,abs(forbeniusNormarray),'-o','MarkerIndices',1:length(N),'LineWidth',2)
xlabel('Top N singular Values');
ylabel('Frobenius Norm of Error Image');
title([imagetype,' Square Image']);



end

