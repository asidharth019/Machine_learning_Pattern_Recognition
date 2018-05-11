function [  ] = myConfusionPlot( predicttest,op,k )
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
h.XTickLabel = {'Digit 1','Digit o','Digit z',''};
h.YTickLabel = {'Digit 1','Digit o','Digit z',''};
h.FontSize = 12;
h.FontWeight = 'bold';
h.YTickLabelRotation = 90;
title(['Confusion Matrix  with acc. ',num2str(conf*100),'% for Templates = ',num2str(k),],'FontSize',12,'FontWeight','bold')
set(gca,'FontSize',14,'FontWeight','bold')
print('-djpeg', ['Confusion_Matrix_K',num2str(k),'.jpg'], '-r300');
close all;


end

