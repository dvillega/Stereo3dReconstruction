function [R,rowMax,colMax] = harrisCorners(img,gaussRad,responseFunc,varargin)
% harrisCorners - calculate harris corners of an image
%   Takes the path to the image, radius of the gaussian window, as well as the
%   function to utilize in the Harris response
%   resonable func example
%       responseFunc = @(x) det(x) - .04*trace(x)^2;
%   returns the responses and row/col indices of maximums

numPts = 4; %default
if nargin == 4
    % Select # of points for adaptive suppression
    numPts = varargin{1};
end

% Passing the radius of the Gaussian Window - 
gaussSize = gaussRad*2 + 1;

% img = rgb2gray(im2double(imread(path2img)));
[M,N] = size(img);

% Blur the image with appropriate sized gaussian - also blurring values of
% the Harris matrix as per 
% increases size of output file
h = fspecial('gaussian',[gaussSize gaussSize]);
foo = conv2(img,h);

% Calculate Gradients
[gradX, gradY] = imgradientxy(foo);
r = floor(gaussSize/2);
gradX = padarray(gradX,[r r]);
gradY = padarray(gradY,[r r]);

% Precalculate X2/Y2/XY for use in response functions
gradX2 = gradX.^2;
gradY2 = gradY.^2;
gradXY = gradX.*gradY;

% Prevent divide by zero if we use harmonic mean
eps = 2^-52;
R = zeros(size(img));

% Should use a variable for window here - another day perhaps
for i = 1+r:M+r
    for j = 1+r:N+r
        tempIx = gradX2(i-r:i+r,j-r:j+r);
        tempIy = gradY2(i-r:i+r,j-r:j+r);
        tempIxy = gradXY(i-r:i+r,j-r:j+r);
        Sx = mean(mean(h.*(gradX(i-r:i+r,j-r:j+r))));
        Sy = mean(mean(h.*(gradY(i-r:i+r,j-r:j+r))));
        Sx2 = mean(mean(h.*tempIx));
        Sy2 = mean(mean(h.*tempIy));
        Sxy = mean(mean(h.*tempIxy));
        H = [Sx2 Sxy; Sxy Sy2];
        % Pham paper corner response function
         if ischar(responseFunc)
           R(i-r:i+r,j-r:j+r) = (Sx2*Sy2-(Sxy)^2)/(Sx2+Sy2+eps);        
         else
          R(i-r:i+r,j-r:j+r) = responseFunc(H);
         end
    end
end

rowMax = [];
colMax = [];

% Adaptive non-maximal suppression
count = 0;
neighborhoodSize = min(M,N); % min radius - max length radius breaks
% the suppression code we are using, and on our test set a radius of 256
% didn't supply anything anyway
while (count < numPts) && (neighborhoodSize ~= 0)
    % Pham - nonmaxSuppression technique
    foo = nonmaxSuppression_qb(R,neighborhoodSize);
    [rowMax,colMax] = find(foo);
    count = length(rowMax);
    neighborhoodSize = neighborhoodSize - 1;
end

% Remove padding
for i = 1:gaussRad
    foo(1,:) = []; foo(end,:) = []; foo(:,1) = []; foo(:,end) = [];
end
R = foo;
[rowMax,colMax] = find(R);
end
