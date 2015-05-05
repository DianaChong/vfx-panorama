function main(folder)
    
    % handling default parameters
    if( ~exist('folder') )
        folder = '../image/grail';
    end
    filtersize = [5 5];
    sigma = 2;
    k = 0.06;
    
    % load images
    disp('Loading images.');
    files = dir([folder, '/*.', 'jpg']);
    number = length(files);

    % feature detection
    disp('Feature detection: Harris corner detection.');
    for i = 1:number
        filename = [folder, '/', files(i).name];
        img = cylindricalProjection(imread(filename), 800);
        harrisFeatureDetection(img, filtersize, sigma, k);
    end
    
    disp('done!');
end