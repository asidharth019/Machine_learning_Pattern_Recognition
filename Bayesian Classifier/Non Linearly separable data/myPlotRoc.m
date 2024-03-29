function [  ] = myPlotRoc( scores,actual )
% Calculates Target, Non Target Scores for all classes and Plots ROC Curve.

% Scores(i,j) dimension is 450 X 3
 TPR = zeros(1,101);
 FPR = zeros(1,101);
 FNR = zeros(1,101);
 
 t1 = 1;
for t = 0:0.01:1
    
    TP = 0;
    FP = 0;
    TN = 0;
    FN = 0;
  
    for i = 1:size(scores,1)
        for j = 1:size(scores,2)
            
            if actual(i) == j
               
                if scores(i,j) > t
                    TP = TP +1;
                else
                    FN = FN + 1;
                end
            else
                
                 if scores(i,j) > t
                    FP = FP +1;
                else
                    TN = TN + 1;
                 end
                
            end
            
        end
    end
    
    TPR(t1) = TP/(TP + FN);
    FPR(t1) = FP/(FP + TN);
    FNR(t1) = FN/(FN + TP);
   t1 = t1+1;
    
end

plot(FPR,TPR,'LineWidth',3);
hold on
xlabel('False positive rate') 
ylabel('True positive rate')
title('ROC Curve for Non Linearly Seperable Data')
set(gca,'FontSize',14,'FontWeight','bold')


end

