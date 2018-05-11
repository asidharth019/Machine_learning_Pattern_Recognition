% addpath(genpath('/Users/NiravMBA/Desktop/IIT Madras/Semester I/Pattern Recognition/Assignment/Assignment 4/HandWritten_data/Isolated/bosaris_toolkit'))

function [] = det_main(target,nontarget,caseno)
% To plot DET Curve

close all;

fprintf('You need to run this script in Matlab''s graphical mode to see the plots.\n');

% calculate an effective prior from target prior, Cmiss, and Cfa
prior = effective_prior(0.33,1,1);


%% Assign Target and Non Target Scores


test_data.tar1 = target;
test_data.non1 = nontarget;

% test_data.tar2 = target1;
% test_data.non2 = nontarget1;
% 
% test_data.tar3 = target2;
% test_data.non3 = nontarget2;
% 
% test_data.tar4 = target3;
% test_data.non4 = nontarget3;
% 
% test_data.tar5 = target4;
% test_data.non5 = nontarget4;
% 
% test_data.tar6 = target5;
% test_data.non6 = nontarget5;

%% make a DET plot for all the five cases.
demo_plot_det_for_fusion(test_data,prior);

end
