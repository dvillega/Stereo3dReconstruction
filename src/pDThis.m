% Proper do this
pathToImg1 = '../testImages/starsL.JPG';
pathToImg2 = '../testImages/starsRZ.JPG';
[R,img1,img2] = focalFix(pathToImg1,pathToImg2);
gray1 = rgb2gray(img1); gray2 = rgb2gray(img2);
im1surf = detectSURFFeatures(gray1);
im2surf = detectSURFFeatures(gray2);
[f1, vpts1] = extractFeatures(gray1,im1surf);
[f2, vpts2] = extractFeatures(gray2,im2surf);
indexPairs = matchFeatures(f1, f2);
mpts1 = vpts1(indexPairs(:,1));
mpts2 = vpts2(indexPairs(:,2));
m1 = mpts1.Location;
m2 = mpts2.Location;
[F, inliers] = ransacfitfundmatrix(m1',m2',.01);