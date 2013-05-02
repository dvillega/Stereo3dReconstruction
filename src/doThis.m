% Add the src and all directories under it to the path
addpath(genpath('.'));

pathToImg1 = '../testImages/corner1.JPG';
pathToImg2 = '../testImages/corner2.JPG';
% 
% Img1 = imread(pathToImg1);
% Img2 = imread(pathToImg2);
% 
% %get the exif data from the pictures
% exif1 = imfinfo(pathToImg1);
% exif2 = imfinfo(pathToImg2);
% 
% [x1 y1 z1] = size(Img1);
% [x2 y2 z2] = size(Img2);
% 
% %get focal length camera used for pictures 
% focalLength1 = exif1.DigitalCamera.FocalLength;
% focalLength2 = exif2.DigitalCamera.FocalLength;
% 
% %calculate the focal ratio R
% R = focalLength1/focalLength2;

[R,img1,img2] = focalFix(pathToImg1,pathToImg2);

gray1 = rgb2gray(img1); gray2 = rgb2gray(img2);

%our shit has the same focal length right now so moving on

%then zero pad here to make the images the same
response = @(x) det(x)/trace(x);
%run Harris corner detection here
%[R,rowMax,colMax] = harrisCorners(path2img,gaussRad,responseFunc,varargin)
%[R1,rowMax1,colMax1] = harrisCorners(img1, 5, response, 100);
%[R2,rowMax2,colMax2] = harrisCorners(img2, 5, response, 100);

[R1,pyramid,dpyramid] = SIFT(gray1);
[R2,pyramid,dpyramid] = SIFT(gray2);

[im1ptsx im1ptsy] = ind2sub(size(img1),find(R1>1));
[im2ptsx im2ptsy] = ind2sub(size(img2),find(R2>1));
[fim1,fim2,rOff,cOff] = zeroPadImg(img1,img2);
pts1 = [im1ptsx+rOff im1ptsy+cOff]'; pts2 = [im2ptsx im2ptsy]';



im_g1 = rgb2gray(fim1); im_g2 = rgb2gray(fim2);
[m1, m2, p1ind,p2ind,cormat]=matchbycorrellation(im_g1,pts1,im_g2,pts2,15);

% for v=m1
% foo(v(1),v(2)) = 1;
% end

%calculating the fundamental matrix
%http://www-misa.cs.ucl.ac.uk/staff/S.Prince/4C75/hartley.pdf 8 point
%example matlab code
%http://feelmare.blogspot.com/2011/11/8-point-algorithm-matlab-source-code.html
%more example matlab code
%http://www.csse.uwa.edu.au/~pk/Research/MatlabFns/Projective/fundmatrix.m
%good slide set on 8 point fundamental matrix computation
%http://ece631web.groups.et.byu.net/Lectures/ECEn631%2013%20-%208%20Point%20Algorithm.pdf
%if the 8 point isnt giving good results, use this paper to take the 8point
%and make it better
%http://research.microsoft.com/en-us/um/people/cloop/ZhangLoopCVIU-01.pdf

%some comments on 8 point ive found. 

%calculate homography matrix using using homography_solve func
%http://www.mathworks.com/matlabcentral/answers/26141

%generate H' with homography_transform func


%Jacobian built in matlab function jacobian(f,v)
%http://math.stackexchange.com/questions/14952/what-is-jacobian-matrix

%http://people.duke.edu/~hpgavin/ce281/lm.pdf Explains Levenberg-Marquardt
