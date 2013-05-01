function is_minmax = is_extrema ( im1,im2,im3, r, c )
% if anyone knows a better way to pass in 3 images from a slice of the
% pyramid cell, hoooooolllaaaaaaaaaa
    images = cell(3);
    images{1} = im1;
    images{2} = im2;
    images{3} = im3;
    isnot_min = false;
    isnot_max = false;
    val = images{2}(r,c);
    for x = -1:1:1
        for y = -1:1:1
            for z = 1:3
                if images{z}(r+x,c+y) > val
                    isnot_max = true;
                elseif images{z}(r+x,c+y) < val
                    isnot_min = true;
                end
                if isnot_max && isnot_min
                    break
                end
            end
            if isnot_max && isnot_min
                break
            end
        end
        if isnot_max && isnot_min
            break
        end
    end
    is_minmax = ~(isnot_max && isnot_min);
end