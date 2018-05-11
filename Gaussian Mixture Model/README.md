# Gaussian-Mixture-Model
Gaussian Mixture Model


The task is to perform classification by modeling  the class conditional density as Gaussian Mixture Model for the following datasets:

a) Image dataset
b) Synthetic dataset

Please use your smail account to open the attached links.

Image Dataset: 23-dimensional image data corresponding to different classes. Every group is provided with the data for three classes. Please check here to find the mapping for your group. The "Images" folder is provided so that you can see the images on which you are working. You are required to work on the features extracted (which can be found in the "Features" folder). The 23-dimensional features include color histogram, edge-directed histograms, and Entropy of wavelet coefficients extracted from local blocks of an image for a particular scene. Dataset can be downloaded from here.

Synthetic Dataset:- The synthetic dataset can be found here. The folder name corresponds to the group number. Please use the data allocated for your group only.

Experiment Instructions:
0. Sample plots: here. You have to code GMM yourself but you can use 'kmeans' inbuilt function. 
1. Try with different values of 'k' (the number of mixtures in each class model). You can use the same or different number of mixtures for your classes. Your k can be as low as 2 and as high as 30 though you should get an idea of how many mixtures to choose on seeing your data.
2. Try with both Diagonal and Non-diagonal covariances and report results for different k.
3. Plot ROC and DET for both dataset. Each of your ROC and DET plot should compare the Diagonal and Non-Diagonal Cov model.
4. You can use Matlab's function for confusion matrices but while putting it in the report, draw a table yourself instead of that figure which the function gives.
5. Try normalizing your dataset also. Experiment with the number of Kmeans iterations and EM iterations also.
6. Please write generalized codes as we will be asking you to revisit GMMs with different datasets in future assignments.
7. Divide the dataset into 70% training, 15% validation (to find your best 'k') and 15% testing.
