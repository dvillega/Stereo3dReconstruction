function features = SIFT(image)
% expects image to be grayscale image
    image = im2double(image);
    pyramid = doG(image);
    [num_octaves, num_scales] = size(pyramid);
    [r,c] = size(image);
    cumresult = zeros(r,c);
    for octave = 1:num_octaves
        [r,c] = size(pyramid{octave,1})
        result = zeros(r,c);
        for scale = 2:num_scales-1
            for x = 2:r-1
                for y = 2:c-1
                    result(x,y) = is_extrema(pyramid{octave,scale-1},pyramid{octave,scale},pyramid{octave,scale+1},x,y);
                end
            end
        end
        cumresult = cumresult + scaleimg(result,2^(octave-1));
    end
    features = cumresult;
end
