% ### EXpermutation.m ###       10.27.14
% Demonstrates reading in a specified Excel file and creates a 
% random permutation into smaller groups 
clear
% --------
fileL= 'GreekLetters.xlsx'; % list
groupSize= 5;   % # of elements per group
fileS= 'test.mat';     % file to save to (.mat)
% --------
[junk,A]= xlsread(fileL);   % read in file
p= randperm(numel(A));      % create a random permutation
% loop to group elements together
indx= 1;
for nn=indx:ceil(numel(A)/groupSize)
    % allow for odd-ish number of elements
    if (indx+groupSize>=numel(A))
        Group{nn}= A(p(indx:end));
    else
        Group{nn}= A(p(indx:indx+groupSize-1));
    end
    indx= indx+ groupSize;
    Group{nn}   % display to screen
end
% save to file?
if (1==0), save(fileS,'Group'); end