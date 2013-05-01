function diff_pyramid = doG ( image )
    num_octaves = 4;
    num_img_per_octave = 6;
    window_size = 33;
    pyramid = cell(num_octaves,num_img_per_octave);
    for scale = 1:num_img_per_octave
        sigma = 2^((scale-2)/2)
        gaussian = fspecial('gaussian',window_size,sigma);
        for octave = 0:num_octaves-1      
            pyramid{octave+1,scale} = scaleimg(conv2(image,gaussian,'same'),1/2^octave);
        end
    end

    diff_pyramid = cell(num_octaves,num_img_per_octave-1);
    for i = 1:num_octaves
        for j = 1:num_img_per_octave-1
            diff_pyramid{i,j} = pyramid{i,j} - pyramid{i,j+1};
        end
    end
end