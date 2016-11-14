function create_new_feature() 
errimgpath = '/data/tmp/klaus/jpeg_compression_detection/ucid/gray/mat'
dictpath = '/data/tmp/xiaosahuang/patch_dict90.mat'
dst = '/data/tmp/xiaosahuang/final_features90'

q = 90;
all_feature = [];
y = [];
load(dictpath);
global dictionary;
dictionary = dict;
for i=1:2
	srcDir = [errimgpath, '/', num2str(q), '/', num2str(i)]
	files = dir(srcDir);
	n = length(files);
	for j=1000:1200
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
end
save(dst,'all_feature');
disp([srcDir, 'process finished']);
end

function feature = get_feature(path)
%	err_img = imread(path);
    global feature;
    feature = [];
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
	blkproc(err_img,[8 8],@create_cof,a);
   if isempty(feature)
       feature = zeros(1024,1);
   end
%	feature=reshape(feature,1024,[]);
end

function block = create_cof(block,a);
	global dictionary;
    global feature;
	dctcol = dct2(block);
 	M=round(dctcol./a);
        if any(M(:))
		    x = reshape(dctcol,64,1);
		    cof = omp(dictionary'*x,dictionary'*dictionary,5);
            if isempty(feature)
                feature = cof;
            else
                feature = [feature,cof];
            end
	    end
%	tic 
	%求block在dictionary下的系数cof ???
%	x = reshape(block,64,1);
%	cof = dictionary\x;
%	g = dictionary\x;
%	t=toc;
%	disp(['each block', num2str(t)]);
%	cof = omp(dictionary'*x,dictionary'*dictionary,5);

end

function poolfeature = pooling(feature)
	%feature 1024*5072
	%max-pooling to get a 1*2048 feature
	[maxfeature,index1]=max(feature,[],2);
	[minfeature,index2]=min(feature,[],2);
    meanfeature = mean(feature,2);
    [h,l]=size(feature);
    for i = 1:l
        tagmax = index1(i);
        tagmin = index2(i);
        feature(i,tagmax) = 0;
        feature(i,tagmin) = 0;
    end
    [maxfeature2,index11]=max(feature,[],2);
    [minfeature2,index22]=min(feature,[],2);
	poolfeature = [maxfeature;minfeature;maxfeature2;minfeature2;meanfeature];
end

