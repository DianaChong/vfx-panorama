function distance = findDistance(intensity_cmp, fx, fy, intensity)
    distance = [];
    for i = 1:size(fx)
            distance(i) = sqrt(sum((intensity_cmp - intensity).^2));
    end
end