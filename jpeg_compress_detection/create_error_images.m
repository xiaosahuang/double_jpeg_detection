function create_error_images() 

src = '/data/tmp/klaus/jpeg_compression_detection/ucid/gray/jpeg'
%dst = '/data/tmp/xiaosahuang/feature_ucid_rgb'

%parfor quality = 10:20
%    q = quality * 5;
q = 60;
allfeature = [];
for i=1:2
	srcDir = [src, '/', num2str(q), '/', num2str(i)]
%	dstDir = [dst, '/', num2str(quality), '/', num2str(i)];
%	mkdir(dstDir);
	files = dir(srcDir);
	n = length(files);
	for j=1:400
		file = files(j);
		if ~file.isdir && length(strfind(file.name, 'txt')) == 0
			filename = file.name
			srcPath = [srcDir,'/', filename];
			tic
		%	load(srcPath);
		%	quantable=cell2mat(quantable);
%			[err_img,quantable]=create_gray_error_image(srcPath);

			[err_img,quantable]=create_gray_error_image(srcPath);
			save('/data/tmp/xiaosahuang/testerr.mat','err_img');

			feature=feature_extraction_gray(err_img,quantable);
			
			feature = [feature,i];
			if j == 1 && i == 1
				allfeature = feature;
			else
				allfeature = [allfeature;feature];
			end


%			feature = feature_extraction(err_img,quantable);

%			dstFilename = strrep(filename,'jpeg','mat');
%			save([dstDir, '/', dstFilename], 'err_img');
			%save([dstDir, '/', dstFilename], 'err_img');
			t = toc;
			disp([srcPath, ' spend: ', num2str(t), ' s' ]);
		end
	end
end
disp([srcDir, 'process finished']);
save('/data/tmp/xiaosahuang/featurehope.mat','allfeature');
end
