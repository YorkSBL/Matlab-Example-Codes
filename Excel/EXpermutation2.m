% ### EXpermutation2.m ###       11.19.14
% Demonstrates resampling into subsets both with and without replacement
clear
% --------
fileL= 'LatinLetters.xlsx'; % list
groupSize= 9;   % # of elements per group
fileS= 'test.mat';     % file to save to (.mat)
% --------
[junk,A]= xlsread(fileL);   % read in file
N= numel(A);
p= randperm(N);      % create a random permutation (w/o replacement)
NoReplace= A(p(1:groupSize))'
temp= floor(N*rand(1,N))+1;  % allow for possible repeated values
Replace= A(temp(1:groupSize))'

