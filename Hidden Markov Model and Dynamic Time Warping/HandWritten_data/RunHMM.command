#!/bin/bash
cd /Users/NiravMBA/Desktop/IIT\ Madras/Semester\ I/Pattern\ Recognition/Assignment/Assignment\ 4/HandWritten_data/Isolated 


cat ai.txt ba.txt la.txt > ll.txt

states=$1
clusters=$2

echo "======================= Begining of HMM Traininig ======================="


./train_hmm ai.txt 1234 $states $clusters .01
./train_hmm ba.txt 1234 $states $clusters .01
./train_hmm la.txt 1234 $states $clusters .01
./train_hmm ll.txt 1234 $states $clusters .01


echo "======================= Begining of HMM Testing ======================="

./test_hmm test.txt ai.txt.hmm 
./test_hmm test.txt ba.txt.hmm 
./test_hmm test.txt la.txt.hmm 
./test_hmm test.txt ll.txt.hmm 
