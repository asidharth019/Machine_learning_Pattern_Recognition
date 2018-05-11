function [  ] = frobeniusPlotMyPhoto( tCOEFF,wt1,f,i )
% Plots Top K Vs Relative Frobenius Norm difference Graph

KLength = 1:100:3000;
itr = 1;
diff = zeros(length(KLength),1);


for k = KLength
    

kCOEFF = tCOEFF(:,1:k);
kinverse = inv(kCOEFF'*kCOEFF);
kWeights = wt1(1:k,:);

reconstructedImage = kCOEFF*kinverse*kWeights;
% We can also use below formula  also to reduce computing complexity because kinverse = inv(kCOEFF'*kCOEFF) is Identity
% reconstructedImage = kCOEFF*kWeights;

pi1 = reshape(reconstructedImage,[92 92]);

f1 = frobeniusNorm(pi1);
disp(['Frobenius Norm for reconstructed image with top K = ',num2str(k),' is : ',num2str(f1)])
diff(itr,1) = abs(((f1-f))/f)*100;
disp(['Relative Frobenius Norm difference is : ',num2str(diff(itr,1)), '%'])
itr = itr + 1;

end

figure;
plot(KLength,diff,'LineWidth',3);
xlabel('Top K'); ylabel('Relative Frobenius Norm difference in %');
title(['Top K Vs Relative Frobenius Norm difference for image ',num2str(i)]);
axis([0 3000 0 30]);
xticks(0:500:3000);
yticks([1 4 8 12 16 20 24 28]);

set(gca,'FontSize',14,'FontWeight','bold')
print('-djpeg',['Frobenius_Norm_Plot_Image_',num2str(i),'.jpg'], '-r300');
close all;

end

