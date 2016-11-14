function dict = create_patch_features() 
errimgpath = 'data/tmp/klaus/jpeg_compression_detection/ucid/gray/mat'
%srr = '/data/tmp/klaus/jpeg_compression_detection/ucid/gray/jpeg'
dst = '/data/tmp/xiaosahuang/patch_features'

q = 90;
allpatchfeature = [];
for i=1:2
	srcDir = [errimgpath, '/', num2str(q), '/', num2str(i)]
%	dstDir = [dst, '/', num2str(q), '/', num2str(i)];
%	mkdir(dstDir);
	files = dir(srcDir);
	n = length(files);
	for j=1:100
		file = files(j);
		if ~file.isdir && length(strfind(file.name, 'txt')) == 0
			filename = file.name;
			srcPath = [srcDir,'/', filename];
			tic
			patch_feature = get_patch_feature(srcPath);
			if i == 1 && j == 1
				all_patch_feature = patch_feature;
			else
				all_patch_feature = [all_patch_feature,patchfeature];
			end
		%	savepath = [dstDir,'/',savename];
			t = toc;
			disp([srcPath, ' spend: ', num2str(t), ' s' ]);
		end
	end
save(dst,'all_patch_feature');
end

disp([srcDir, 'process finished']);
end
function return_feature = get_patch_feature(path)
	err_img = imread(path);
	tmp_feature  = blkproc(err_img,[8 8],@func);
	tmp_feature = tmp_feature';
	patch_feature = reshape(tmp_feature,64,3072);
	return_feature = patch_feature(:,randperm(3072, 800));

end
function x = func(block);
	x = reshape(block,1,64);
end


