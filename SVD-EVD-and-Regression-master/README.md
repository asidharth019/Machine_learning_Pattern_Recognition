# SVD-EVD-and-Regression
Singular Value Decomposition, Eigen Value Decomposition and Polynomial Regression


Problem 1: Image Reconstruction 

Tasks to be performed:
1) Perform Singular Value Decomposition on both square and rectangular images (given below)

(a) by converting the image to grayscale.

(b) separately on each color bands.

(c) after concatenating the 8bit R,G,B channel to form a 24bit number. Experiment with the order of concatenation and analyze. 

Reconstruct the matrix using top N singular vectors corresponding to top N singular values. Experiment with the values of N. Also try random N singular values instead of top N.



2) Perform Eigen Value Decomposition (If image A is rectangular, use A' *A) on both square and rectangular images given to your group

(a) by converting the image to grayscale.

(b) separately on each color bands.

(c) after concatenating the 8bit R,G,B channel to form a 24bit number. Experiment with the order of concatenation and analyze. 

Reconstruct the matrix using top N eigen vectors corresponding to top N eigen values. Experiment with the values of N. Also try random N eigen values instead of top N.


TASK REQUIREMENTS:

(a) Plot the reconstructed images along with their corresponding error image.

(b) A comparative graph of the reconstruction error vs N is required in each experiment.

(c) You can use ONLY inbuilt function of EVD in this whole task. No other inbuilt functions are allowed and you have to code everything yourself.

(d) A brief comparison of all the techniques and their analysis is required in your report.

(e) Extra credits for more experiments and observations.

*************** USE SMAIL ACCOUNT TO OPEN THE LINKS ********************
Data For Image Reconstruction
1) Square Image (Image number to be chosen is same as your group number)
2) Rectangular Image (Image number to be chosen is same as your group number)




Problem 2: Polynomial Regression:

1) There are 3 datasets for polynomial regression: 1-dimensional data, 2-dimensional data and Multidimensional data and can be downloaded from here (Each group has 3 txt files)
1-dimensional data      - q<group_number>_1.txt
2-dimensional data      - q<group_number>_2.txt
Multidimensional data  - <group_number>_3.txt
2) For Dimension k, there are k+1 columns in the data. First k columns are the features and the last one is the outcome.
3) Use 70% of the data for training, 20% for validation and 10% of data for testing.

TASK REQUIREMENTS : 
(a) Try different orders of the polynomials and try to find which best fits your given data.
(b) Perform Ridge Regression also on each of the 3 datasets. 
(c) NO inbuilt functions are allowed in this task. Code everything yourself.
(d) Plots showing the data and the approximated polynomial is required (Refer figures 1.2 to 1.7 of Bishop book)
(e) Plots showing the scatter plot i.e the target output vs the model output is required.
(f) Be creative in comparing the model outcome (or the model itself) with the actual outcome.
(g) Extra credits for more experiments and observations.
