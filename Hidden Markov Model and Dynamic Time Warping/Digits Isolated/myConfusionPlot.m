function [  ] = myConfusionPlot( predicttest,op,k,s )
% Calculates & Plots Confusion Matrix


%% Calculate Confusion Matrix

conf=sum(predicttest==op)/length(predicttest);
disp(['Accuracy of system from Confusion Matrix is : ',num2str(conf*100),' %'])

yu=unique(predicttest);
confMat=zeros(length(yu));
for i=1:length(yu)
    for j=1:length(yu)
        confMat(i,j)=sum(predicttest==yu(i) & op==yu(j));
    end
end

disp(['Confusion :'])
disp(confMat)


%% Plots Confusion Matrix
% figure;
% 
% % Convert this data to a [numClasses x length(op)] matrix
% targets = zeros(3,length(op));
% outputs = zeros(3,length(op));
% targetsIdx = sub2ind(size(targets), op, 1:length(op));
% outputsIdx = sub2ind(size(outputs), predicttest, 1:length(op));
% targets(targetsIdx) = 1;
% outputs(outputsIdx) = 1;
% 
% % Plot the confusion matrix for a 3-class problem
% plotconfusion(targets,outputs)
% 
% h = gca;
% h.XTickLabel = {'Class 1','Class o','Class z',''};
% h.YTickLabel = {'Class 1','Class o','Class z',''};
% h.FontSize = 12;
% h.FontWeight = 'bold';
% h.YTickLabelRotation = 90;
% title(['Confusion with acc. = ',num2str(conf*100),'% & K = ',num2str(k),' & S = ',num2str(s),],'FontSize',12,'FontWeight','bold')
% set(gca,'FontSize',14,'FontWeight','bold')
% print('-djpeg', ['Confusion_Matrix_K_',num2str(k),'_S_',num2str(s),'.jpg'], '-r300');
% close all;


end

