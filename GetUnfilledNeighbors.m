function PixelList = GetUnfilledNeighbors(Currentfill, WindowSize)
% first do the dilation of current filled image
dimage = imdilate(Currentfill,strel('square',3));
% take out the current filled image, we can get the neighbors surrounding
% the currently filled pixels
Neighbors = dimage - Currentfill;
[row,col] = find(Neighbors=1);
