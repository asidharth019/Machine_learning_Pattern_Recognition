# Hidden-Markov-Model-and-Dynamic-Time-Warping
Hidden Markov Model and Dynamic Time Warping


You need to do the following task:

1. DHMM (code)
      (a) Work on Digit dataset (one HMM for one digit): Follow group_mapping.txt for your group's 3 classes. Using the model built on isolated digits test (no need train on continuous data) for continues digits in the given dataset.

      (b) Work on Handwriting dataset: Follow this group mapping for your group's 3 classes. Using the model built on isolated characters test (no need train on continuous data) for continues characters in the given here.
      

2. DTW

      (a) Digit dataset: Follow group_mapping.txt for your group's 3 classes.
 

DATASET FORMATS:

TIDIGITS (Digit recognition) 

Isolated digits

Data for each batch can be accessed from the respective directory inside the directory named "isolated" in the data directory
Inside your batch's directory, there are three sub-directories with the corresponding digits.
57 files corresponding to 57 utterances are there in each of the sub-directories. 
The data given are the MFCC features of speech audio.
For the isolated digit recognition task, you are supposed to split the data into train and test. Train HMMs using the train utterances and test for all the test utterances.
Structure of MFCC file: The first line of MFCC file contains two space separated integers. First integer NC - The dimension of the feature vector (The number of MFC coefficients) Second integer NF - The number of frames , the wav file is divided into. Starting from the second line, there will be NF lines. Each line contains NC numbers corresponding to the MFCC feature vector for a particular frame.
Connected digits

There are two sub-directories in the directory names "connected".
The directory "test1" contains directories with group number. Work only on your respective directory.
Each directory contains features from utterances of multiple digits (corresponding to the isolated digits assigned to your batch). 
The set of digits uttered are given below: symbol - uttered word 1 - one 2 - two 3 - three 4 - four 5 - five 6 - six 7 - seven 8 - eight 9 - nine z - zero o - o
Eg. In file 534z29a.mfcc, the digits spoken are five three four zero two nine 
Do testing for the files in the directory "test2". This is similar to Test1, but the underlying digits  are not shown to you.
ONLINE HANDWRITTEN DATASET:

The data given are the sampled coordinates of telugu letters, as they are written.
A stroke is a coordinate sequence traced without lifting the pen.
A letter can be written with a different number of strokes.
The ldf file of a particular letter consists of multiple examples for that letter.
The first line of each example is NS - the number of strokes.
Followed by 2 * NS lines, the stroke name, and the stroke coordinate sequence for each stroke.
The stroke coordinate sequence is given in a single line, in the following format <NC> <x1> <y1> <x2> <y2> ... <xNC> <yNC> where NC - Num of coordinates
For continues characters given here, for each test sequence you have a '.mat' file, with x-coordinate vaules in array xData and y-coordinated in array yData.
Apart from using the (x,y) positions as given in the data, you can generate other features such as slope and curvature ( Example ) also to perform the hand-written letter recognition task.



Guidelines:
1. You need to plot ROC, DET and confusion matrices (your own). 
2. You can include graphs and tables of your results.
3. This time TAs will not entertain any doubts in the last 5 days. You need to start early. 
4. Follow the same procedure for Turnitin. Please use the correct naming as specified by us.
5. Deadline and page limit will be informed shortly.
6. Divide the dataset into 70% training, 15% validation and 15% testing before proceeding.
