function disparityMap = ncc( I1,I2, windowSize, dispMax)
%%ncc Returns the disparity mapping of two images via Normalized Cross
%   Correlation
%   I1,I2 are grayscale images
%   windowSize is the size of the window we are convolving for NCC
%
%

[I1r,I1c] = size(I1);
[I2r,I2c] = size(I2);

if nargin==3
    dispMax = 16;
end

if(I1r~=I2r) && (I1c ~= I2c)
    error('Left and right images are not the same size')
end

if mod(windowSize,2) == 0
    error('Window size must be odd')
end

disparityMap = zeros(I1r,I2c);

win = (windowSize-1)/2;
dispMin = 0;

for i = (1+win:1:I1r-win)
    for j = (1+win:1:I1c-win-dispMax)
        pNCC = 0.0;
        bestMatch = dispMin;
        for dispRange = dispMin:1:dispMax
            nccVal = 0.0;
            nccNum = 0.0;
            nccDenom = 0.0;
            nccDenomR = 0.0;
            nccDenomL = 0.0;
            for a = -win:1:win 
                for b = -win:1:win 
                    nccNum = nccNum + (I2(i+a,j+b)*I1(i+a,j+b+dispRange));
                    nccDenomR = nccDenomR + (I2(i+a,j+b)*I2(i+a,j+b));
                    nccDenomL = nccDenomL + (I1(i+a,j+b+dispRange)*I1(i+a,j+b+dispRange));
                end
            end
            nccDenom = sqrt(nccDenomR * nccDenomL);
            nccVal = nccNum / nccDenom;
            if pNCC < nccVal
                pNCC = nccVal;
                bestMatch = dispRange;
            end
        end
        disparityMap(i,j) = bestMatch;
    end
end

end

