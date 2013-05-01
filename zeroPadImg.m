function [ fixedImg1, fixedImg2 ] = zeroPadImg( img1,img2 )
%take two images, zero pad the smaller picture so they both have the same
%width and hight

[x1 y1 z1] = size(img1);
[x2 y2 z2] = size(img2);

nRows = x1-x2;
nCols = y1-y2;

if nRows > 0 && nCols > 0
    temp = zeros(x1,y1,z1);
    fixedImg2 = insertMatrix(temp,img2);
    fixedImg1 = img1;
else
    temp = zeros(x2,y2,z2);
    fixedImg1 = insertMatrix(temp,img1);
    fixedImg2 = img2;
end
end

