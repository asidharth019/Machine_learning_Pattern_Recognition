#!/bin/bash
cd /Users/NiravMBA/Desktop/IIT\ Madras/Semester\ I/Pattern\ Recognition/Assignment/Assignment\ 4/Digits\ Isolated 


cat 1.txt o.txt z.txt > g.txt

states=$1
clusters=$2

echo "======================= Begining of HMM Traininig ======================="


./train_hmm 1.txt 1234 $states $clusters .01
./train_hmm o.txt 1234 $states $clusters .01
./train_hmm z.txt 1234 $states $clusters .01
./train_hmm g.txt 1234 $states $clusters .01


echo "======================= Begining of HMM Testing ======================="

./test_hmm test.txt 1.txt.hmm 
./test_hmm test.txt o.txt.hmm 
./test_hmm test.txt z.txt.hmm 
./test_hmm test.txt g.txt.hmm 
