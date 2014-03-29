function Template = GetNeighborhoodWindow(Image, Pixel, WindowSize)
        % get the row number and column number of that pixel
        pixelRow = Pixel(1);
        pixelCol = Pixel(2);
        temp = (WindowSize-1)/2;
        % get the range of neighbor window
        winrow = (pixelRow - temp):(pixelRow + temp);
        wincol = (pixelCol - temp):(pixelCol + temp);
        
        % to decide whether it has reached the edge of the image
        edgeR = (winrow < 1) || (winrow > 200);
        edgeC = (wincol < 1) || (wincol > 200); 
        
        % if any element in edgeR is 1, it indicates that the
        % neighborwindow has reached the edge of the image
        if ((sum(edgeR) >0) || (sum(edgeC) > 0)) 
            newR = winrow(~edgeR); 
            newC = wincol(~edgeC); 

            template = zeros(WindowSize, WindowSize); 
            template(~edgeR, ~edgeC) = Image(newR, newC); 

            validMask = repmat(false, [WindowSize WindowSize]); 
            validMask(~edgeR, ~edgeC) = filled(newR, newC); 
        else
            template = Image(winrow, wincol);
            validMask = filled(winrow, wincol); 
        end
        Template = template;

end