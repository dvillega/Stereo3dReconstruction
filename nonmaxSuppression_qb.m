function [ mask ] = nonmaxSuppression_qb( img,n )
%% nonmaxSuppression_qb NonMaximum Suppression - Highly Efficient
%   Non-maximum Suppression Using Fewer than Two Comparisons per Pixel
%   http://dx.doi.org/10.1007/978-3-642-17688-3_41
%   Pham, Tuan Q.

[h, w] = size(img);
mask = false([h w]);
m = floor((n+1)/2);
hh = floor(h/m);
ww = floor(w/m);

val = img(1:hh*m,1:ww*m);
[val,R] = max(reshape(val,[m hh*ww*m]),[],1);
val = reshape(reshape(val,[hh ww*m])',[m ww hh]);
R = reshape(reshape(R,[hh ww*m])',[m ww*hh]);
[val,C] = max(val,[],1);
R = reshape(R(sub2ind([m ww*hh],C(:)',1:ww*hh)),[ww hh])';
val= squeeze(val)'; C = squeeze(C)';

%% compare each candidate to its (2n+1)x(2n+1) neighborhood
mask0 = nonmaxsupp3x3(val);
for I=find(mask0)'
    [ii,jj] = ind2sub([hh ww],I);
    r = (ii-1)*m + R(ii,jj);
    c = (jj-1)*m + C(ii,jj);
    if r<=n||c<=n||r>h-n||c>w-n, continue; end %out of bound
    
    % compare to full (2n+1) x (2n+1) block for code simplicity
    %     if sum2(img(r+(-n:n),c+(-n:n)) >= val(ii,jj))==1,
    A = img(r+(-n:n),c+(-n:n))>=val(ii,jj);

    if sum(A(:))==1
        mask(r,c) = 1;
    end
end
end

function [ mask ] = nonmaxsupp3x3(img)
%% Non-max suppression - 3x3 area
[h, w] = size(img);
mask = false([h w]);
skip = false(h,2);
cur = 1;
next = 2;

for c=2:w-1
    r = 2;
    while r < h
        if skip(r,cur), r=r+1; continue; end;
        
        if img(r,c) <= img(r+1,c)
            r = r+1;
            while r<h && img(r,c) <= img(r+1,c), r = r+1; end
            if r==h,break;end
        else
            if img(r,c) <= img(r-1,c), r = r+1; continue; end
        end
        skip(r+1,cur) = 1;
        
        % compare to 3 future then 3 past neighbors
        if img(r,c) <= img(r-1,c+1), r = r+1; continue; end
        skip(r-1,next) = 1;
        if img(r,c) <= img(r  ,c+1), r = r+1; continue; end
        skip(r,next) = 1;
        if img(r,c) <= img(r+1,c+1), r = r+1; continue; end
        skip(r+1,next) = 1;
        if img(r,c) <= img(r-1,c-1), r = r+1; continue; end
        if img(r,c) <= img(r  ,c-1), r = r+1; continue; end
        if img(r,c) <= img(r+1,c-1), r = r+1; continue; end
        
        mask(r,c) = 1; r = r+1;
    end
    tmp = cur; cur = next; next = tmp;
    skip(:,next) = 0;
end
end