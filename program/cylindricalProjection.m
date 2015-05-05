function img_out = cylindricalProjection(img, focal_length)

    %read image
    [row, col, channel] = size(img);

    img_out = zeros(size(img), 'uint8');
    s = focal_length;

    for i = 1:row
        for j = 1:col
            x = i - row/2;
            y = j - col/2;
            
            theta = atan(x/focal_length);
            h = y / sqrt(x^2 + focal_length^2);

            xx = round(s*theta, 0) + row/2;
            yy = round(s*h, 0) + col/2;
            
            img_out(xx, yy, :) = img(i, j, :); 
        end
    end
end