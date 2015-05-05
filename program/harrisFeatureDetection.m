function [featureX, featureY, neighbourInt, fnum, R] = harrisFeatureDetection(Images, filtersize, sigma, k)

    [row, col, channel] = size(Images);
    
    images = rgb2gray(Images);
    %imshow(images);
    
    % Compute x and y derivatives of image
    % using G of RGB
    fx = [-1 0 1; -1 0 1; -1 0 1];
    Ix = filter2(fx, images);
    
    fy = [-1 -1 -1; 0 0 0; 1 1 1];
    Iy = filter2(fy, images);
    
    % Compute products of derivatives at every pixel
    Ix2 = Ix .* Ix;
    Iy2 = Iy .* Iy;
    Ixy = Ix .* Iy;
    
    % Compute the sums of the products of derivatives at each pixel
    fg = fspecial('gaussian', filtersize, sigma);
    Sx2 = filter2(fg, Ix2);
    Sy2 = filter2(fg, Iy2);
    Sxy = filter2(fg, Ixy);
    
    % Measure of corner response: R = detM - k(traceM)^2
    R = (Sx2 .* Sy2 - Sxy .^2) - k*(Sx2 + Sy2).^2;  
    
    % Threshold on R
    threshold = mean(R(:));
    map = zeros(row, col);
    map(R > threshold*1.2) = 1;
    
    % Compute local maximum of R
    wsize = 17;
    fnum = 1;
    for i = ceil(wsize/2) : wsize : row-floor(wsize/2)
        for j = ceil(wsize/2) : wsize : col-floor(wsize/2)
            window = R(i-floor(wsize/2) : i+floor(wsize/2), j-floor(wsize/2) : j+floor(wsize/2));
            [mr,mi] = max(window(:));
            [M I] = max(mr);
            x = mi(I);
            y = I;
            xpos = i - floor(wsize/2) + x - 1;
            ypos = j - floor(wsize/2) + y - 1;
%             if(xpos == 0 || ypos == 0)
%                 disp('bug!!!');
%                 disp('xpos=');disp(xpos);
%                 disp('ypos=');disp(ypos);
%             end
            if(xpos <= row && ypos <= col)
                if(map(xpos, ypos) == 1)
                    featureX(fnum) = xpos;
                    featureY(fnum) = ypos;
                    fnum = fnum + 1;
                end
            end
            neighbourNum = 1;
            for m = i-floor(wsize/2) : i+floor(wsize/2)
                for n = j-floor(wsize/2) : j+floor(wsize/2)
                    if(xpos <= row && ypos <= col)
                        if(map(xpos, ypos) == 1)
                            neighbourInt(fnum-1, neighbourNum) = images(m,n);
                            neighbourNum = neighbourNum + 1;
                        end
                    end
                    if( m~=xpos || n~=ypos )
                        map(m,n) = 0;
                    end
                end
            end
        end
    end
    fnum = fnum - 1;
    imshow(map);
    %{
    disp(fnum);
    disp(numel(featureX));
    disp(numel(featureY));
    disp(size(neighbourInt));disp('------------');
    %}
end