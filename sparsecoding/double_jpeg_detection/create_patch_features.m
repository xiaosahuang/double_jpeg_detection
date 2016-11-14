function create_patch_features() 
errimgpath = '/data/tmp/klaus/jpeg_compression_detection/ucid/gray/mat'
imgpath  = '/data/tmp/klaus/jpeg_compression_detection/ucid/gray/jpeg'
dst = '/data/tmp/xiaosahuang/patch_features90'

q = 90;
all_patch_feature = [];
for i=1:2
	srcDir = [errimgpath, '/', num2str(q), '/', num2str(i)]
%	imgDir = [imgpath,'/',num2str(q),'/',num2str(i)];

	files = dir(srcDir);
	n = length(files);
	for j=1:300
		file = files(j);
		if ~file.isdir && length(strfind(file.name, 'txt')) == 0
			filename = file.name;
			srcPath = [srcDir,'/', filename];
			tic	
			patch_feature = get_patch_feature(srcPath);
            disp(size(patch_feature));
			if i == 1 && j == 1
				all_patch_feature = patch_feature;
			else
				all_patch_feature = [all_patch_feature,patch_feature];
			end
			t = toc;
			disp([srcPath, ' spend: ', num2str(t), ' s' ]);
		end
	end
save(dst,'all_patch_feature');
end

disp([srcDir, 'process finished']);
end
function return_feature = get_patch_feature(path)
    global return_feature;
    return_feature=[];
	imgpath = strrep(path,'mat','jpeg');
	imgobj = jpeg_read(imgpath);
	quantable = imgobj.quant_tables;
	quantable = cell2mat(quantable);
	for i = 1:8
		for j = 1:8

			a(i,j) = quantable(i,j);
		end
	end
    load(path);
	blkproc(err_img,[8 8],@func,a);
end
function block = func(block,a);
   global return_feature;
    x=dct2(block);
	M=round(x./a);
	x = reshape(x,64,1);
	if any(M(:))
		if isempty(return_feature)
			return_feature = x;
        else
			return_feature = [return_feature x];
		end
    end
end

