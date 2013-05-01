function scaled_image = scaleimg ( image, x_scale, y_scale )
% expects double image
    if nargin==2
        y_scale = x_scale;
    end
    [r,c] = size(image);
    [xi,yi] = meshgrid(1:c*x_scale,1:r*y_scale);
    scaled_image = interp2(image,xi/x_scale,yi/y_scale);
end