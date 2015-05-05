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
    
    % display feature matching
    disp('Display feature matching.');
    i = 1;
        mstr = sprintf('match_%02d', i);
        mfile = matfile(mstr);
        match = mfile.match;
        [row, col] = size(match);
        
        filename = [folder, '/', files(i).name];
        img = cylindricalProjection(imread(filename), 700);
        
        filename2 = [folder, '/', files(i+1).name];
        img2 = cylindricalProjection(imread(filename2), 700);
        imshow([img img2]); 
        [row1, col1] = size(img);
        hold on; 
        
        for j = 1:row
            mstr1 = sprintf('mat_%02d', i);
            mstr2 = sprintf('mat_%02d', i+1);
            mfile1 = matfile(mstr1);
            mfile2 = matfile(mstr2);
            idx1 = match(j,1);
            idx2 = match(j,2);
            fx1 = mfile1.featureX;
            fx2 = mfile2.featureX;
            
            fy1 = mfile1.featureY;
            fy2 = mfile2.featureY;
            
            x1 = fx1(idx1);
            x2 = fx2(idx2);
            
            y1 = fy1(idx1);
            y2 = fy2(idx2);
            disp('~~~~~~~~~~~~~~~~~~~~~~~');
            disp(x1);
            disp(x2);
            disp(y1);
            disp(y2);
            disp('~~~~~~~~~~~~~~~~~~~~~~~');
            
            line ([y1, col1+y2],[x1, x2]);
            hold on; 
        end
    
    disp('done!');
end