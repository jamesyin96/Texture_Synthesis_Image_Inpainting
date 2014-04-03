function [PixelR PixelC]= GetUnfilledNeighbors(Currentfill, WindowSize)
% first do the dilation of current filled image
dimage = imdilate(Currentfill,strel('square',3));
% take out the current filled image, we can get the neighbors surrounding
% the currently filled pixels
Neighbors = dimage - Currentfill;
[row,col] = find(Neighbors>0);

T = length(row);
result = zeros(2,T);

%randomly permute a list from 1 to T, which is the index permutation, we
%can apply the index permutation into the row and col permutation.
randindex = randperm(T);
%randindex = T;
temprow = row(randindex); 
tempcol = col(randindex); 

%sort by number of neighbors     
filledneighbornum = colfilt(Currentfill, [WindowSize WindowSize], 'sliding', @sum); 
selectneighbors = filledneighbornum(sub2ind(size(Currentfill), temprow, tempcol)); 
[sorted, sortIndex] = sort(selectneighbors, 1, 'descend');

PixelR = temprow(sortIndex); 
PixelC = tempcol(sortIndex);

end