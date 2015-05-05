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
        % create a matfile for each image
        mstr = sprintf('mat_%02d.mat', i);
        mfile = matfile(mstr, 'Writable', true);
        
        filename = [folder, '/', files(i).name];
        img = cylindricalProjection(imread(filename), 700);
        [featureX, featureY, neighbourInt, R] = harrisFeatureDetection(img, filtersize, sigma, k);
        
        mfile.featureX = featureX;
        mfile.featureY = featureY;
        mfile.neighbourInt = neighbourInt;
    end
    
    % feature matching
    disp('Feature matching.');
    for i = 1:number-1
        % open matfile
        mstr = sprintf('mat_%02d', i);
        mfile = matfile(mstr);
        fx1 = mfile.featureX;
        fy1 = mfile.featureY;
        intensity1 = mfile.neighbourInt;

        mstr = sprintf('mat_%02d', i+1);
        mfile = matfile(mstr);
        fx2 = mfile.featureX;
        fy2 = mfile.featureY;
        intensity2 = mfile.neighbourInt;
        
        
        match = featureMatching(fx1, fy1, intensity1, fx2, fy2, intensity2);
        
        % create a matfile for each image
        mstr = sprintf('match_%02d', i);
        mfile = matfile(mstr, 'Writable', true);
        % do ransac here

        % store in matfile
        mfile.match = match;
    end
    
    disp('done!');
end