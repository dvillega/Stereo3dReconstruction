function disparityMap = ssd( I1, I2, windowSize, dispMax)
%%ssd Returns the disparity mapping of two images via Sum of Squared
%   Differences
%   I1, I2 are grayscale images
%   windowSize is the size of the window we are convolving for SSD


[I1r,I1c] = size(I1);
[I2r,I2c] = size(I2);

if (I1r~=I2r) && (I1c ~= I2c)
    error('Left and right images are not the same size')
end

if mod(windowSize,2) == 0
    error('Window size must be odd')
end

disparityMap = zeros(I1r,I1c);

win = (windowSize-1) / 2;
dispMin = 0; 

if nargin == 3
    dispMax = 15;
end

for i = (1+win:1:I1r-win)
    for j = (1+win:1:I1c-win-dispMax)
        pSSD = inf;
        bestMatch = dispMin;
        for dispRange = dispMin:1:dispMax
            ssd = 0.0;
            for a = -win:1:win 
                for b = -win:1:win 
                    ssd = ssd + (I2(i+a,j+b) - I1(i+a,j+b+dispRange)).^2;
                end
            end
            if pSSD > ssd;
                pSSD = ssd;
                bestMatch = dispRange;
            end
        end
        disparityMap(i,j) = bestMatch;
    end
end

end
