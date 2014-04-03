function [BestMatches SSD]= FindMatches(Template,samplevector,WindowSize,ValidMask)
% set threshold and sigma
ErrThreshold = 0.1;
Sigma = WindowSize/6.4;
% build GaussMask for later use
GaussMask = fspecial('gaussian',WindowSize,Sigma);

% vectorized calculation to computer the best match

% calculating total weight
TotWeight = sum(sum(GaussMask .* ValidMask));
% get number of rows and columns of sample vector
[pixelsperwindow, numwindows] = size(samplevector); 

% reshape the Template to a column vector
templateunit = reshape(Template,pixelsperwindow,1);
% copy and compose the templatevector to match the columns of samplevector,
% then we can vectorize the calculation
templatevector = repmat(templateunit, 1, numwindows);
% calculate the distance
dist = (templatevector - samplevector).^2;

temp = (GaussMask .* ValidMask);
temp2 = reshape(temp,1,pixelsperwindow);
SSD = (temp2 * dist)/TotWeight;
SSD2 = SSD(SSD>0);
result = SSD2 <= (min(SSD2) * (1 + ErrThreshold));

BestMatches = result;
end