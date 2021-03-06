testIm = imread('T1.gif');

WindowSize = 9;
% must convert pixel values into 0~1 format
sample = im2double(testIm);
% get the size of sample image
samplesize = size(sample);
samplerow = samplesize(1);
samplecol = samplesize(2);

windowlessSize = [(samplerow - WindowSize + 1) (samplecol - WindowSize + 1)];
% initial setting according to the requirements
ErrThreshold = 0.1;
MaxErrThreshold = 0.3;
Sigma = WindowSize/6.4;

% initial output images, size 200x200
newImageRow = 50;
newImageCol = 50;
TotalPixels = newImageRow * newImageCol; 
newImage = zeros(newImageRow, newImageCol);

% get a seed: 3x3 random pixels from sample
seedwidth = 3;
seedrandomR = floor(rand()*(samplerow-2)+2);
seedrandomC = floor(rand()*(samplecol-2)+2);
% get the center of seed in newImage
seedrow = (floor(newImageRow/2)-1):(floor(newImageRow/2)+1);
seedcol = (floor(newImageCol/2)-1):(floor(newImageCol/2)+1);
% put the seed into the newImage
newImage(seedrow,seedcol) = sample(seedrandomR-1:seedrandomR+1,seedrandomC-1:seedrandomC+1);

% to conter how many pixels have been filled, initial value = 9;
fillCounter = 9;
% We should build a filling state matrix to the filling state of the image.
% The initial state should be an empty matrix.
Currentfill = zeros(newImageRow,newImageCol);
% the center 3x3 area has been filled
Currentfill(seedrow,seedcol)=[1 1 1;1 1 1;1 1 1];
half = (WindowSize - 1)/2;

while fillCounter < TotalPixels
    % set the progress flag to 0 at the start of each outer loop
    progress = 0;
    % use the GetUnfilledNeighbors function to find a list of unfill pixels
    [Pixelr Pixelc]= GetUnfilledNeighbors(Currentfill, WindowSize);
    
    for i=1:length(Pixelr)
        Pixel(1) = Pixelr(i);
        Pixel(2) = Pixelc(i);
        [Template ValidMask]= GetNeighborhoodWindow(newImage, Pixel, WindowSize,newImageRow,Currentfill);
        [BestMatches SSD]= FindMatches(Template,sample,WindowSize,ValidMask);
        BestMatch = RandomPick(BestMatches);
        BestMatch_Err = SSD(BestMatch);
        
        if BestMatch_Err < MaxErrThreshold
            [BestMatchR, BestMatchC] = ind2sub(windowlessSize, BestMatch);
            
            % we get the upper-left corner location of the best match
            % window, so we should retrive the center of that window
            BestMatchR = BestMatchR + half;
            BestMatchC = BestMatchC + half;
            
            temprow = Pixel(1);
            tempcol = Pixel(2);
            newImage(temprow,tempcol) = sample(BestMatchR,BestMatchC);
            % mark the current pixel in Currentfill matrix to be filled
            Currentfill(temprow,tempcol) = 1;
            progress = 1;
            fillCounter = fillCounter + 1;
        end
    end
    % show the processing progress
    disp(sprintf('Pixels filling process: %d', fillCounter/TotalPixels));
    
    if (progress==0)
        MaxErrThreshold = MaxErrThreshold * 1.1;
    end
end

figure();
imshow(newImage);

