function [ forbeniusNormArray ] = EVD_REC( img,N )
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

for n = N 
    kEigVal = sortedEigVal;
    kEigVal(n+1:end,:) = 0;

    % To reconstruct A from A*A' we multiply Right Psuedo Inverse of A'
    %that is inv(A*A')*A 
    reconstructedPartwithN = sortedEigVector*kEigVal*(inv(sortedEigVector));
    reconstructedImagewithN = reconstructedPartwithN*inv(img*img')*img;
    
    subplot(3,4,j); imshow(uint8(reconstructedImagewithN)); 
    if i > 3
         title(['Reconst.img for rand N = ',num2str(n),' eigen val']);
    else
         title(['Reconst. img for top N = ',num2str(n),' eigen val']);
    end    
   
    errorImageN = reconstructedImage-reconstructedImagewithN;
    
    subplot(3,4,j+1); imshow(uint8(errorImageN)); 
    if i > 3
          title(['Error img for rand N = ',num2str(n),' eigen val']);
    else
          title(['Error img for top N = ',num2str(n),' eigen val']);
    end
    
    forbeniusNormArray(i) = frobeniusNorm(reconstructedImage,reconstructedImagewithN);
    fprintf('frobenius Norm with K = %d is %f \n',n,forbeniusNormArray(i));
     i = i+1;
     j = j+2;
end

%% Plotting Forbenius Norm Error for Gray Image
figure;

plot(N,abs(forbeniusNormArray),'-o','MarkerIndices',1:length(N))





end

