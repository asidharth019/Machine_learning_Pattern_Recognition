% using addpath(genpath('/Users/NiravMBA/Desktop/IIT Madras/Semester I/Pattern Recognition/Assignment/Assignment 3/bosaris_toolkit'))

function [] = det_main(target,nontarget,target1,nontarget1,type)
% To plot DET Curve

close all;

fprintf('You need to run this script in Matlab''s graphical mode to see the plots.\n');

% calculate an effective prior from target prior, Cmiss, and Cfa
prior = effective_prior(0.33,1,1);


%% Assign Target and Non Target Scores


test_data.tar1 = target;
test_data.non1 = nontarget;

test_data.tar2 = target1;
test_data.non2 = nontarget1;



%% make a DET plot for all the five cases.
demo_plot_det_for_fusion(test_data,prior,type);

end
