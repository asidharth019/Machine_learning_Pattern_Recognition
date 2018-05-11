clc; clear all; close all;

img = imread('18_Rect.jpg');

randomN = randi([1 max(size(img))],1,3);
N = sort([5 30 100 randomN]);
N = 1000;

%% Gray Scale Image

grayScaleImg = double(rgb2gray(img));
FNforGrayScale = EVD_REC(grayScaleImg,N);

%% Red, Green, Blue Scale Image

redScaleImg = double((img(:,:,1)));
FNforRedScale = EVD_REC_RGBScale(redScaleImg,N,'Red Scale');

greenScaleImg = double((img(:,:,2)));
FNforGreenScale = EVD_REC_RGBScale(greenScaleImg,N,'Green Scale');

blueScaleImg = double((img(:,:,3)));
FNforBlueScale = EVD_REC_RGBScale(blueScaleImg,N,'Blue Scale');
 
 
%% Concatenating the 8bit R,G,B channel to form a 24bit number

rgbimg =  uint32(img(:,:,1));
rgbimg = 2^8*(rgbimg) + uint32(img(:,:,2));
rgbimg = 2^8*(rgbimg) + uint32(img(:,:,3));
FNforRGBScale = EVD_REC_Concat(double(rgbimg),N);


gbrimg =  uint32(img(:,:,2));
gbrimg = 2^8*(gbrimg) + uint32(img(:,:,3));
gbrimg = 2^8*(gbrimg) + uint32(img(:,:,1));
FNforGBRScale = EVD_REC_Concat(double(gbrimg),N);

brgimg =  uint32(img(:,:,3));
brgimg = 2^8*(brgimg) + uint32(img(:,:,1));
brgimg = 2^8*(brgimg) + uint32(img(:,:,2));
FNforBRGScale = EVD_REC_Concat(double(brgimg),N);


%% Plotting forbenius Norm Graph
figure;
plot(N,abs(FNforGrayScale),'-o','MarkerIndices',1:length(N),'LineWidth',1)
hold on

plot(N,abs(FNforRedScale),'-o','MarkerIndices',1:length(N))
plot(N,abs(FNforGreenScale),'-o','MarkerIndices',1:length(N))
plot(N,abs(FNforBlueScale),'-o','MarkerIndices',1:length(N))

plot(N,abs(FNforRGBScale),'-o','MarkerIndices',1:length(N))
plot(N,abs(FNforGBRScale),'-o','MarkerIndices',1:length(N))
plot(N,abs(FNforBRGScale),'-o','MarkerIndices',1:length(N))
hold off

legend('Frobenius Norm for Gray Scale','Frobenius Norm for Red Scale','Frobenius Norm for Green Scale','Frobenius Norm for Blue Scale','Frobenius Norm for Concat as RGB','Frobenius Norm for Concat as GBR','Frobenius Norm for Concat as BRG');


xlabel('Top N Values');
ylabel('Frobenius Norm of Error Image');
title('Comparision of 3 methods of EVD for Square image');

