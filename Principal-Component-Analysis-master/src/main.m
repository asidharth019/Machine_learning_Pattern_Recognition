% clc; clear all; close all;
% 
%load('/Users/NiravMBA/Downloads/EigenVectors.mat')

%% Q1
% a. Find the projection matrix Pc onto the column space of matrix A.
% b. Find the 3x3 projection matrix PR onto the row space of A. 
%Multiply B = PCAPR. Your answer B should be a little surprising -- Can you explain it?

A = [3 6 6;4 8 8];

c = [3; 4];
Pc = c*inv(c'*c)*c'

r = [3; 6; 6];
Pr =  r*inv(r'*r)*r'

B = Pc*A*Pr

%% Q2 a.
% For each image, plot the intensity histogram. The intensity histogram of an image is a
% histogram that shows the number of pixels in an image at each different intensity value
% found in that image.

for i = 1:10
I = imread(['face',num2str(i),'.pgm']);
imhist(I);

% My created function to plot histogram
%myHist(I);

xlabel('Pixel Intensity'); ylabel('Number of Pixels');
title(['Intensity Histogram Img ',num2str(i)]);
set(gca,'FontSize',14,'FontWeight','bold')
print('-djpeg',['My_Intensity_Histogram_Img_',num2str(i),'.jpg'], '-r300');
close all;
end



%% Q2 b.
%Convert the basis to images and plot the same. The basis are same as the set of eigen vectors given
figure;
j1 = 1;
eigindex = [30 35 40 50 60 70 85 100 120 150 200 260 300 350 380 400 420 500 800 1000 3800 5900 7500 8464];

for j = eigindex %[1:1:28]
e1 = COEFF(:,j);
e1 = reshape(e1,[92 92]);
i = mat2gray(e1);
subplot(4,6,j1); imshow(i);
title(['Index = ',num2str(j)]);
j1 = j1 + 1;
hold on
end
print('-djpeg','Eigen_Faces_Random24.jpg', '-r300');
close all;


%% Q2 c.

% For each image, project image onto the eigen space and find the top K (K<8464)
% directions such that the relative error(frobenius norm) is < 1 for reconstruction of image using these eigenvectors.
% figure;

 inverseCTC = inv(COEFF'*COEFF);
for i = 1:10
    
 I = double(imread(['face',num2str(i),'.pgm']));
 I = reshape(I,92*92,1);
 
 % Finding weights and projection image
 weight = COEFF'*I;
 projectionImage = COEFF*inverseCTC*weight;
 %We can also use below formula also to reduce computing complexity because inverseCTC = inv(COEFF'*COEFF) is Identity
% projectionImage = COEFF*weight;
 
%  figure;
%  bar(weight);
 

pi = reshape(projectionImage,[92 92]);
pim = mat2gray(pi);
f = frobeniusNorm(pi);
disp(['Frobenius Norm for projection image with all K is : ',num2str(f)])

% Sorting weights according to their magnitude
[~,ind] = sort(abs(weight),'descend');
wt1 = weight(ind,:);
tCOEFF = COEFF(:,ind);

% Ploting Frobenius Graph
frobeniusPlot(tCOEFF,wt1,f,i);

% Plotting projection image
figure;
subplot(3,2,1);
imshow(pim);
title('Projection image with all K');

Krange = [10 40 65 80 100];
it = 2;
for k = Krange

kCOEFF = tCOEFF(:,1:k);
kinverse = inv(kCOEFF'*kCOEFF);
kWeights = wt1(1:k,:);

reconstructedImage = kCOEFF*kinverse*kWeights;
% We can also use below formula  also to reduce computing complexity because kinverse = inv(kCOEFF'*kCOEFF) is Identity
%reconstructedImage = kCOEFF*kWeights;

% Plotting reconstructed image with top K
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
print('-djpeg',['Reconstructed_Image_',num2str(i),'.jpg'], '-r300');
close all;

end


