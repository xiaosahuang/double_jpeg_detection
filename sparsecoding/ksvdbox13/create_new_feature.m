function create_new_feature() 
errimgpath = '/data/tmp/klaus/jpeg_compression_detection/ucid/gray/mat'
dictpath = '/data/tmp/xiaosahuang/patch_dict'
dst = '/data/tmp/xiaosahuang/test_final_features'

q = 90;
all_feature = [];
load(dictpath);
global dictionary;
%global allcof;
dictionary = dict;
for i=1:2
	srcDir = [errimgpath, '/', num2str(q), '/', num2str(i)]
	files = dir(srcDir);
	n = length(files);
	for j=1:100
		file = files(j);
		if ~file.isdir && length(strfind(file.name, 'txt')) == 0
			filename = file.name;
			srcPath = [srcDir,'/', filename];
			
			tic
			%to get global allcof
			feature = get_feature(srcPath);

			poolfeature = pooling(feature);
			if i == 1 && j == 1
				all_feature = poolfeature;
			else
				all_feature = [all_feature poolfeature];
			end
		%	savepath = [dstDir,'/',savename];
			t = toc;
			disp([srcPath, ' spend: ', num2str(t), ' s' ]);
		end
	end
save(dst,'all_feature');
end

disp([srcDir, 'process finished']);
end
function feature = get_feature(path)
%	err_img = imread(path);
        load(path);
	feature = blkproc(err_img,[8 8],@create_cof);
	feature=reshape(feature,1024,3072);


end
function cof = create_cof(block);
	global dictionary;
	%求block在dictionary下的系数cof ???
	x = reshape(block,64,1);
	g = dictionary\x;
	cof = omp(dictionary'*x,dictionary'*dictionary,nnz(g));

end

function poolfeature = pooling(feature)
	%feature 1024*3072
	%max-pooling to get a 1*2048 feature
	disp('feature size!!!!1')
	disp(size(feature))
	[maxfeature,index]=max(feature,[],2);
	[minfeature,index]=min(feature,[],2);
	poolfeature = [maxfeature,minfeature];
end

