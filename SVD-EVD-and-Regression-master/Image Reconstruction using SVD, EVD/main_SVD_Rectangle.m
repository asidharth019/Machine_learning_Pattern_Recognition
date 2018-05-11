clc; clear all; close all;

img = imread('18_Rect.jpg');

randomN = randi([1 max(size(img))],1,10);
N = sort([10 30 60 randomN]);

%% Gray Scale Image

grayScaleImg = rgb2gray(img);
FNforGrayScale = SVD(grayScaleImg,N,'Gray Scale');

%% Red, Green, Blue Scale Image

redScaleImg = uint8((img(:,:,1)));
FNforRedScale = SVD_RGBScale(redScaleImg,N,'Red Scale');

greenScaleImg = uint8((img(:,:,2)));
FNforGreenScale = SVD_RGBScale(greenScaleImg,N,'Green Scale');

blueScaleImg = uint8((img(:,:,3)));
FNforBlueScale = SVD_RGBScale(blueScaleImg,N,'Blue Scale');
 
 
%% Concatenating the 8bit R,G,B channel to form a 24bit number
 
rgbimg =  uint32(img(:,:,1));
rgbimg = 2^8*(rgbimg) + uint32(img(:,:,2));
rgbimg = 2^8*(rgbimg) + uint32(img(:,:,3));
FNforRGBScale = SVD_Concat(rgbimg,N,'Concatened as RGB');


gbrimg =  uint32(img(:,:,2));
gbrimg = 2^8*(gbrimg) + uint32(img(:,:,3));
gbrimg = 2^8*(gbrimg) + uint32(img(:,:,1));
FNforGBRScale = SVD_Concat(gbrimg,N,'Concatened as GBR');

brgimg =  uint32(img(:,:,3));
brgimg = 2^8*(brgimg) + uint32(img(:,:,1));
brgimg = 2^8*(brgimg) + uint32(img(:,:,2));
FNforBRGScale = SVD_Concat(brgimg,N,'Concatened as BRG');


%% Plotting forbenius Norm Graph
figure;
plot(N,abs(FNforGrayScale),'-o','MarkerIndices',1:length(N),'LineWidth',2)
hold on

plot(N,abs(FNforRedScale),'-o','MarkerIndices',1:length(N),'LineWidth',2)
plot(N,abs(FNforGreenScale),'-o','MarkerIndices',1:length(N),'LineWidth',2)
plot(N,abs(FNforBlueScale),'-o','MarkerIndices',1:length(N),'LineWidth',2)

plot(N,abs(FNforRGBScale),'-o','MarkerIndices',1:length(N),'LineWidth',2)
plot(N,abs(FNforGBRScale),'-o','MarkerIndices',1:length(N),'LineWidth',2)
plot(N,abs(FNforBRGScale),'-o','MarkerIndices',1:length(N),'LineWidth',2)
hold off

legend('Frobenius Norm for Gray Scale','Frobenius Norm for Red Scale','Frobenius Norm for Green Scale','Frobenius Norm for Blue Scale','Frobenius Norm for Concat as RGB','Frobenius Norm for Concat as GBR','Frobenius Norm for Concat as BRG');


xlabel('Top N Values');
ylabel('Frobenius Norm of Error Image');
title('Comparision of 3 methods of SVD for Rectangle image');

