clc; clear all; close all

%% Calling Bayesian Classifier function for all five cases

% CaseNumber: 1 -- Bayes with Covariance same for all classes
% 
%             2 -- Bayes with Covariance different for all classes
% 
%             3 -- Naive Bayes with C = \sigma^2*I.
% 
%             4 -- Naive Bayes with C same for all classes.
% 
%             5 -- Naive Bayes with C different for all classes.


[t,nt] = myBayesianClassifier(1);
[t1,nt1] = myBayesianClassifier(2);
[t2,nt2] =  myBayesianClassifier(3);
[t3,nt3] = myBayesianClassifier(4);
[t4,nt4] = myBayesianClassifier(5);
 
%% Uncomment this to plot ROC
% legend('Case 1','Case 2','Case 3','Case 4','Case 5')
%  print('-djpeg','LS_ROC.jpg', '-r300');
%  hold off


%% Uncomment this to plot DET
% demo_main(t,nt,t1,nt1,t2,nt2,t3,nt3,t4,nt4,1);
%  print('-djpeg','LS_DET.jpg', '-r300');


 close all
