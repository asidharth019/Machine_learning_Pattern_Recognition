function [  ] = myConfusionPlot( predicttest,op,k,diag )
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

disp(['Confusion  for K = ',num2str(k),':'])
disp(confMat)


%% Plots Confusion Matrix
figure;

% Convert this data to a [numClasses x length(op)] matrix
targets = zeros(3,length(op));
outputs = zeros(3,length(op));
targetsIdx = sub2ind(size(targets), op, 1:length(op));
outputsIdx = sub2ind(size(outputs), predicttest, 1:length(op));
targets(targetsIdx) = 1;
outputs(outputsIdx) = 1;

% Plot the confusion matrix for a 3-class problem
plotconfusion(targets,outputs)

h = gca;
h.XTickLabel = {'Highway','Street','Tall Building',''};
h.YTickLabel = {'Highway','Street','Tall Building',''};
h.FontSize = 12;
h.FontWeight = 'bold';
h.YTickLabelRotation = 90;
title(['Confusion Matrix for K = ',num2str(k),' & diag ',num2str(diag),' with acc. ',num2str(conf*100),'%'],'FontSize',12,'FontWeight','bold')
set(gca,'FontSize',14,'FontWeight','bold')
print('-djpeg', ['LS_Confusion_Matrix_K_',num2str(k),'_diag_',num2str(diag),'.jpg'], '-r300');
close all;


end

