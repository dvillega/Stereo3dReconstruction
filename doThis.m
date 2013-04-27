pathToImg1 = ' .JPG';
pathToImg2 = ' .JPG';

Img1 = imread(pathToImg1);
Img2 = imread(pathToImg2);

%get the exif data from the pictures
exif1 = imfinfo(pathToImg1);
exif2 = imfinfo(pathToImg2);

[x1 y1 z1] = size(Img1);
[x2 y2 z2] = size(Img2);

%get focal length camera used for pictures 
focalLength1 = exif1.DigitalCamera.FocalLength;
focalLength2 = exif2.DigitalCamera.FocalLength;

%calculate the focal ratio R
R = focalLength1/focalLength2;

%our shit has the same focal length right now so moving on

%then zero pad here to make the images the same

%run Harris corner detection here
%[R,rowMax,colMax] = harrisCorners(path2img,gaussRad,responseFunc,varargin)
[R1,rowMax1,colMax1] = harrisCorners(pathToImg1, 6, somethingHere, 10);
[R2,rowMax2,colMax2] = harrisCorners(pathToImg2, 6, somethingHere, 10);

%calculate homogrephy
%http://www.mathworks.com/matlabcentral/answers/26141