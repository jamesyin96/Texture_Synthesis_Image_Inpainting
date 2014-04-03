% this function is the image impainting function.
% inputs are: image with gap to be filled, window size
function image = image_impainting(filename, WindowSize)
Imagein = imread(filename);

% must convert pixel values into 0~1 format
newImage = im2double(Imagein);
% get the size of sample image
Imsize = size(newImage);
newImageRow = Imsize(1);
newImageCol = Imsize(2);

% we make the sample of input image to be the image itself.
sample = newImage;
% get the size of sample image
samplesize = size(sample);
samplerow = samplesize(1);
samplecol = samplesize(2);
% vectorize the sample image
originalsamplevector = im2col(sample,[WindowSize,WindowSize],'sliding');
K = length(originalsamplevector);
% incase of very big sample vector, we set a up limit=5000, such that when
% sample vactor is bigger than 5000, we randomly pick 5000 elements from
% the original sample vector and form the new sample vector.
if K < 5000
    samplevector = originalsamplevector;
else
    samplevector = originalsamplevector(:,randsample(K,5000));
end

% initial setting according to the requirements
ErrThreshold = 0.1;
MaxErrThreshold = 0.3;
Sigma = WindowSize/6.4;

TotalPixels = newImageRow * newImageCol; 

% we need to find which part of the input image needs to be filled.
% We should build a filling state matrix to the filling state of the image.
Currentfill = ones(newImageRow,newImageCol);
temp = (newImage==0);
Currentfill = Currentfill - temp;

% to conter how many pixels have been filled, initial value = 9;
fillCounter = sum(sum(Currentfill));

half = (WindowSize - 1)/2;
templocation = [(samplerow - WindowSize + 1) (samplecol - WindowSize + 1)];
while fillCounter < TotalPixels
    % set the progress flag to 0 at the start of each outer loop
    progress = 0;
    % use the GetUnfilledNeighbors function to find a list of unfill pixels
    [Pixelr Pixelc]= GetUnfilledNeighbors(Currentfill, WindowSize);
    
    for i=1:length(Pixelr)
        Pixel(1) = Pixelr(i);
        Pixel(2) = Pixelc(i);
        [Template ValidMask]= GetNeighborhoodWindow(newImage, Pixel, WindowSize,Currentfill);
        [BestMatches SSD]= FindMatches(Template,samplevector,WindowSize,ValidMask);
        BestMatch = RandomPick(BestMatches);
        BestMatch_Err = SSD(BestMatch);
        
        if BestMatch_Err < MaxErrThreshold
            [BestMatchR, BestMatchC] = ind2sub(templocation, BestMatch);
            
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
    sprintf('Pixels filling process: %d', fillCounter);
    
    if (progress==0)
        MaxErrThreshold = MaxErrThreshold * 1.1;
    end
end

figure();
imshow(newImage);
