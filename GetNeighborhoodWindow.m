function [Template validmask] = GetNeighborhoodWindow(newImage, Pixel, WindowSize,Currentfill)
        % get the row number and column number of that pixel
        pixelRow = Pixel(1);
        pixelCol = Pixel(2);
        half = (WindowSize-1)/2;
        % get the range of neighbor window
        winrow = (pixelRow - half):(pixelRow + half);
        wincol = (pixelCol - half):(pixelCol + half);
        
        Imsize = size(newImage);
        newImageR = Imsize(1);
        newImageC = Imsize(2);
        % to decide whether it has reached the edge of the image
        edgeR = (winrow < 1) | (winrow > newImageR);
        edgeC = (wincol < 1) | (wincol > newImageC); 
        
        % if any element in edgeR is 1, it indicates that the
        % neighborwindow has reached the edge of the image
        if ((sum(edgeR) + sum(edgeC)) > 0) 
            newR = winrow(~edgeR); 
            newC = wincol(~edgeC); 

            template = zeros(WindowSize, WindowSize); 
            template(~edgeR, ~edgeC) = newImage(newR, newC);
            
            validmask = repmat(false,[WindowSize WindowSize]);
            validmask(~edgeR,~edgeC) = Currentfill(newR,newC);
        else
            template = newImage(winrow, wincol);
            validmask = Currentfill(winrow,wincol);
        end
        Template = template;

end