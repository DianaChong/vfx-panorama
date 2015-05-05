function match = featureMatching(fx1, fy1, intensity1, fx2, fy2, intensity2)

    match = [];
    
    for j = 1:numel(fx1)
        
        dist = findDistance(intensity1(j, :), numel(fx2), intensity2);
        [match1, index1] = min(dist);
        dist(index1) = [];
        match2 = min(dist);
        
        if((match1 / match2) < 0.8)
            match = [match; [j, index1]];
        end
    end
end
