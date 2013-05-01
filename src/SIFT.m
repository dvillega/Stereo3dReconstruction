function features = SIFT(image)
% expects image to be grayscale image
    image = im2double(image);
    [Dx,Dy] = gradient(image);
    [Dxx,Dxy] = gradient(Dx);
    [Dyx,Dyy] = gradient(Dy);
    pyramid = doG(image);
    [num_octaves, num_scales] = size(pyramid);
    [r,c] = size(image);
    cumresult = zeros(r,c);
    Ro = 10;
    T = (Ro+1)^2/Ro;
    for octave = 1:num_octaves
        [r,c] = size(pyramid{octave,1})
        result = zeros(r,c);
        for scale = 2:num_scales-1
            for x = 2:r-1
                for y = 2:c-1
                    is_minmax = is_extrema(pyramid{octave,scale-1},pyramid{octave,scale},pyramid{octave,scale+1},x,y);
                    if is_minmax
                        doGVal = pyramid{octave,scale}(x,y);
                        if abs(image(x,y)-doGVal) >= 0.03
                            H = [Dxx(x,y),Dxy(x,y);Dyx(x,y),Dyy(x,y)];
                            t = trace(H)^2/det(H);
                            if t < T
                                result(x,y) = 1;
                            end
                        end
                    end
                end
            end
        end
        cumresult = cumresult + scaleimg(result,2^(octave-1));
    end
    features = cumresult;
end
