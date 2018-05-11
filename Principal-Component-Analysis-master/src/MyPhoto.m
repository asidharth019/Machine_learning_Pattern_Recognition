% clc; clear all; close all;
% 
%load('/Users/NiravMBA/Downloads/EigenVectors.mat')


%% Q2 c.

% For each image, project image onto the eigen space and find the top K (K<8464)
% directions such that the relative error(frobenius norm) is < 1 for reconstruction of image using these eigenvectors.
% figure;

% inverseCTC = inv(COEFF'*COEFF);
    
 I = double(rgb2gray(imread('face11.pgm')));
 I = reshape(I,92*92,1);
 
 imhist(uint8(I));
xlabel('Pixel Intensity'); ylabel('Number of Pixels');
title(['Intensity Histogram Img ',num2str(11)]);
set(gca,'FontSize',14,'FontWeight','bold')
print('-djpeg',['My_Intensity_Histogram_Img_',num2str(11),'.jpg'], '-r300');
close all;
 
 weight = COEFF'*I;
 %projectionImage = COEFF*inverseCTC*weight;
 %We can also use below formula also to reduce computing complexity because inverseCTC = inv(COEFF'*COEFF) is Identity
 projectionImage = COEFF*weight;
 
%  figure;
%  bar(weight);
 
pi = reshape(projectionImage,[92 92]);
pim = mat2gray(pi);
f = frobeniusNorm(pi);
disp(['Frobenius Norm for projection image with all K is : ',num2str(f)])

% Selecting Top K

[~,ind] = sort(abs(weight),'descend');

wt1 = weight(ind,:);
tCOEFF = COEFF(:,ind);

% Ploting Frobenius Graph
frobeniusPlotMyPhoto(tCOEFF,wt1,f,11);

figure;
subplot(3,2,1);
imshow(pim);
title('Projection image with all K');


Krange = [10 100 1000 2000 3000];
it = 2;
for k = Krange

kCOEFF = tCOEFF(:,1:k);
kinverse = inv(kCOEFF'*kCOEFF);
kWeights = wt1(1:k,:);

reconstructedImage = kCOEFF*kinverse*kWeights;
% We can also use below formula  also to reduce computing complexity because kinverse = inv(kCOEFF'*kCOEFF) is Identity
%reconstructedImage = kCOEFF*kWeights;

pi1 = reshape(reconstructedImage,[92 92]);
pim1 = mat2gray(pi1);
subplot(3,2,it);
imshow(pim1);

f1 = frobeniusNorm(pi1);
disp(['Frobenius Norm for reconstructed image with top K = ',num2str(k),' is : ',num2str(f1)])
diff = abs(((f1-f))/f)*100;
disp(['Relative Frobenius Norm difference is : ',num2str(diff), '%'])

title({['Reconstructed image with top K = ',num2str(k),' &'],['Frobenius Norm difference = ',num2str(diff), '%']});


it = it + 1;
end

hold off
print('-djpeg',['Reconstructed_Image_',num2str(11),'.jpg'], '-r300');
close all;

