% Add the src and all directories under it to the path
addpath(genpath('.'));

% Tweak these paths to update what we're running the process on
pathToImg1 = '../testImages/starsL.JPG';
pathToImg2 = '../testImages/starsRZ.JPG';
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
[gr1,gc1] = size(gray1); [gr2,gc2] = size(gray2);
while mod(gr1,16) ~= 0
    gray1(1,:) = [];
    img1(1,:,:) = [];
    gr1 = gr1-1;
    display('Gray 1 row del');
end

while mod(gc1,16) ~= 0
    gray1(:,1) = [];
    img1(:,1,:) = [];
    gc1 = gc1-1;
    display('Gray 1 col del');
end

while mod(gr2,16) ~= 0
    gray2(1,:) = [];
    img2(1,:,:) = [];
    gr2 = gr2-1;
    display('Gray 2 row del');
end

while mod(gc2,16) ~= 0
    gray2(:,1) = [];
    img2(:,1,:) = [];
    gc2 = gc2-1;
    display('Gray 2 col del');
end


%then zero pad here to make the images the same

% If we want to use built ins
%   R1 = SIFT(gray1);
%   SURFPoints
%   im1surf = detectSURFFeatures(img1);
%   im1surf = detectSURFFeatures(gray1);
%   im2surf = detectSURFFeatures(gray2);
%   im2surf = detectSURFFeatures(gray22);
%   im1surf(1)
%   matchFeatures(im1surf,im2surf);
%   im1surf(1).SURFPoints
%   imshow(img1); hold on; plot(im1surf.selectStrongest(30));
%   imshow(img2); hold on; plot(im2surf.selectStrongest(30));
%   [f1, vpts1] = extractFeatures(img1,im1surf);
%   [f1, vpts1] = extractFeatures(gray1,im1surf);
%   [f2, vpts2] = extractFeatures(gray2,im2surf);
%   [f2, vpts2] = extractFeatures(gray22,im2surf);
%   indexPairs = matchFeatures(f1, f2, 'Prenormalized' true) ;
%   ndxPairs = matchFeatures(f1,f2);
%   indexPairs = matchFeatures(f1, f2, 'Prenormalized', true) ;
%   matched_pts1 = vpts1(indexPairs(:, 1));
%   matched_pts2 = vpts2(indexPairs(:, 2));
%   figure; showMatchedFeatures(img1,img2,matched_pts1,matched_pts2);
%   legend('matched points 1','matched points 2');
%   figure; showMatchedFeatures(img1,img2,matched_pts1,matched_pts2);
%   legend('matched points 1','matched points 2');

% If we want to run harris corners then use the below code
%response = @(x) det(x)/trace(x);
%run Harris corner detection here
%[R,rowMax,colMax] = harrisCorners(path2img,gaussRad,responseFunc,varargin)
% [R1,rowMax1,colMax1] = harrisCorners(img1, 5, response, 100);
% [R2,rowMax2,colMax2] = harrisCorners(img2, 5, response, 100);

[R1,pyramid,dpyramid] = SIFT(gray1);
[R2,pyramid,dpyramid] = SIFT(gray2);

[im1ptsx im1ptsy] = ind2sub(size(img1),find(R1>2));
[im2ptsx im2ptsy] = ind2sub(size(img2),find(R2>2));
[fim1,fim2,rOff,cOff] = zeroPadImg(img1,img2);
if size(img2) < size(img1)
    pts1 = [im1ptsx+rOff im1ptsy+cOff]'; pts2 = [im2ptsx im2ptsy]';
else
    pts1 = [im1ptsx im1ptsy]'; pts2 = [im2ptsx+rOff im2ptsy+cOff]';
end


im_g1 = rgb2gray(fim1); im_g2 = rgb2gray(fim2);
[m1, m2, p1ind,p2ind,cormat]=matchbycorrellation(im_g1,pts1,im_g2,pts2,9);

% for v=m1
% foo(v(1),v(2)) = 1;
% end

foo = zeros(size(fim1));
bar = zeros(size(fim2));
for v = m1
foo(v(1),v(2)) = 1;
end
for v = m2
bar(v(1),v(2)) = 1;
end

[f1, vpts1] = extractFeatures(rgb2gray(fim1),m1');
[f2, vpts2] = extractFeatures(rgb2gray(fim2),m2');
indexPairs = matchFeatures(f1, f2);
matched_pts1 = vpts1(indexPairs(:, 1));
matched_pts2 = vpts2(indexPairs(:, 2));
[F,inliers] = ransacfitfundmatrix(m1,m2,.01);
subplot(1,2,1); imshow(fim1); hold on; plot(m1(1,inliers),m1(2,inliers),'rx');
subplot(1,2,2); imshow(fim2); hold on; plot(m2(1,inliers),m2(2,inliers),'gx');


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
