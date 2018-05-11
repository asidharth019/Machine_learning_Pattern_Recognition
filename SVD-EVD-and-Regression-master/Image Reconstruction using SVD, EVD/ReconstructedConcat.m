function [reconstructedThreeColorImage] = ReconstructedConcat(img)
img=abs(img);
for i=1:size(img,1)
    for j=1:size(img,2)
        element=dec2bin(img(i,j),24);
        string=num2str(element);
        c3=bin2dec(string(1:8));
        c2=bin2dec(string(9:16));
        c1=bin2dec(string(17:24));
        reconstructedThreeColorImage(i,j,1)=c1;
        reconstructedThreeColorImage(i,j,2)=c2;
        reconstructedThreeColorImage(i,j,3)=c3;        
    end
end
% %imshow(uint8(reconstructedThreeColorImage));
% reconstructedThreeColorImage=uint8(reconstructedThreeColorImage);
%  image=img/2^16
%  reconstructedThreeColorImage(:,:,1)=uint8(image(:,:));
%  image=img/2^8;
%  image=image*2^24;
%  image=image/2^24;
%  reconstructedThreeColorImage(:,:,2)=uint8(image(:,:));
%  image=img*2^24;
%  image=image/2^24;
%  reconstructedThreeColorImage(:,:,3)=uint8(image(:,:));
end
