function [images] = readImages(folder, extension)
    images = [];
    if( ~exist('extension') )
            extension = 'jpg';
    end

    files = dir([folder, '/*.', extension]);
    filename = [folder, '/', files(1).name];
    info = imfinfo(filename);
    number = length(files);
    images = zeros(info.Height, info.Width, info.NumberOfSamples, number);

    for i = 1:number
        filename = [folder, '/', files(i).name];
        img = imread(filename);
        images(:,:,:,i) = img;
    end
end