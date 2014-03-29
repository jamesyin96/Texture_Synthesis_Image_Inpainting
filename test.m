testIm = imread('T1.gif');

WindowSize = 9;
% must convert pixel values into 0~1 format
sample = im2double(testIm);
% get the size of sample image
samplesize = size(sample);
samplerow = samplesize(1);
samplecol = samplesize(2);
% vectorize the sample image
samplevector = im2col(sample(:,:),[WindowSize,WindowSize],'sliding');

% initial setting according to the requirements
ErrThreshold = 0.1;
MaxErrThreshold = 0.3;
Sigma = WindowSize/6.4;
% build GaussMask for later use
GaussMask = fspecial('gaussian',WindowSize,Sigma);
% initial output images, size 200x200
newrow = 200;
newcol = 200;
TotalPixels = newrow * newcol; 
newImage = zeros(newrow, newcol);

% get a seed: 3x3 random pixels from sample
seedr = floor(rand()*(samplerow-1)+1);
seedc = floor(rand()*(samplecol-1)+1);
% get the center of seed in newImage
seedrow = (floor(newrow/2)-1):(floor(newrow/2)+1);
seedcol = (floor(newcol/2)-1):(floor(newcol/2)+1);
% put the seed into the newImage
newImage(seedrow,seedcol) = sample(seedr-1:seedr+1,seedc-1:seedc+1);

% to conter how many pixels have been filled, initial value = 9;
fillCounter = 3*3;
% We should build a filling state matrix to the filling state of the image.
% The initial state should be an empty matrix.
Currentfill = zeros(newrow,newcol);
% the center 3x3 area has been filled
Currentfill(seedrow,seedcol)=[1 1 1;1 1 1;1 1 1];

%while fillCounter < TotalPixels
 %   progress = 0;
    
  %  PixelList = GetUnfilledNeighbors(Currentfill,WindowSize)
    
    
    
    
    
    
    