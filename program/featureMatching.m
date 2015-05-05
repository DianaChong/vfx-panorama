%open mat file
for i = 1:file_number-1 %find out
	mstr = sprintf('mat_%02d', i);
	mfile = matfile(mstr);
	fx1 = mfile.featureX;
	fy1 = mfile.featureY;
	intensity1 = mfile.neighbourInt;
	
	mstr = sprintf('mat_%02d', i+1);
	mfile = matfile(mstr);
	fx2 = mfile.featureX;
	fy2= mfile.featureY;
	intensity2 = mfile.neighbourInt;
	
	% create a matfile for each image
    mstr = sprintf('match_%02d.mat', i);
    mfile = matfile(mstr, 'Writable', true);
	
	match = [];
%create k-d tree

%find distance
	for j = 1:feature_number %find out
		distance = [distance; find_distance(intensity1(j), fx2, fy2, intensity2)];
		[match1, index1] = min(distance);
		distance(index1) = [];
		[match2, index2] = min(distance);
	
		if((match1 / match2) < 0.8)
			match = [match; [j, index1]];
		end
	end
	
	%do ransac here
	
	%store in mat file
	mfile.match = match;
end	

%{
%find distance
function distance = find_distance(intensity_cmp, fx, fy, intensity)

distance = [];
for i = 1:size(fx)
		distance(i) = sqrt(sum((intensity_cmp - intensity).^2));
end
%}