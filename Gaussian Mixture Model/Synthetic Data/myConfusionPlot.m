function [  ] = myConfusionPlot( predicttest,op,caseno,k)
% Calculates & Plots Confusion Matrix


%% Calculate Confusion Matrix

conf=sum(predicttest==op)/length(predicttest);
disp(['Accuracy for case ',num2str(caseno),' = ',num2str(conf*100),'%'])

yu=unique(predicttest);
confMat=zeros(length(yu));
for i=1:length(yu)
    for j=1:length(yu)
        confMat(i,j)=sum(predicttest==yu(i) & op==yu(j));
    end
end

disp(['Confusion  for case ',num2str(caseno),':'])
disp(confMat)


%% Plots Confusion Matrix
figure;

% Convert this data to a [numClasses x length(op)] matrix
targets = zeros(2,length(op));
outputs = zeros(2,length(op));
targetsIdx = sub2ind(size(targets), op, 1:length(op));
outputsIdx = sub2ind(size(outputs), predicttest, 1:length(op));
targets(targetsIdx) = 1;
outputs(outputsIdx) = 1;

% Plot the confusion matrix for a 3-class problem
plotconfusion(targets,outputs)

h = gca;
h.XTickLabel = {'Class 1','Class 2',''};
h.YTickLabel = {'Class 1','Class 2',''};
h.FontSize = 12;
h.FontWeight = 'bold';
h.YTickLabelRotation = 90;

if caseno == 1
    title(['Confusion Matrix for K ',num2str(caseno),' with accuracy ',num2str(conf*100),'% Diag. Cov'],'FontSize',12,'FontWeight','bold')
else
    title(['Confusion Matrix for K ',num2str(caseno),' with accuracy ',num2str(conf*100),'%NonDiagCov'],'FontSize',12,'FontWeight','bold')
end

set(gca,'FontSize',14,'FontWeight','bold')

if caseno == 1
    print('-djpeg',['Confusion_Matrix_K_',num2str(k),'for_Diagonal_Cov.jpg'], '-r300');
else
    print('-djpeg',['Confusion_Matrix_K_',num2str(k),'for_Non-Diagonal_Cov.jpg'], '-r300');
end

end

