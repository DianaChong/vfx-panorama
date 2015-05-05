function dist = findDistance(intensity_cmp, number, intensity)
    dist = [];
    for i = 1:number
        dist(i) = sqrt(sum((intensity_cmp - intensity(i, :)).^2));
    end
end