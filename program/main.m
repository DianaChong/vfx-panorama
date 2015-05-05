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
        [featureX, featureY, neighbourInt, fnum, R] = harrisFeatureDetection(img, filtersize, sigma, k);
        %{
        for j = 1:fnum
            fprintf('%d,%d: fx=%d ,fy=%d\n', i, j, featureX(j), featureY(j));
            fprintf([repmat('%f\t', 1, size(neighbourInt, 2)) '\n'], neighbourInt');
        end
        fprintf('---------------------------------------------------\n');
        %}
    end
    
    disp('done!');
end