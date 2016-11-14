function [dict,g,label] = create_large_dict()
src = '/data/tmp/klaus/jpeg_compression_detection/ucid/gray/jpeg';
quality = 90;
count = 0;
imgs=[];
label=[];
for n = 1:2
	srcdir = [src,'/',num2str(quality),'/',num2str(n)];
	files = dir(srcdir);
	for i = 1:100
		file = files(i);
		if ~file.isdir && length(strfind(file.name,'txt'))==0
			count = count+1;
			filename = file.name;
			srcpath = [srcdir,'/',filename];
			img = imread(srcpath);
			img = double(img);
			imgsize = size(img);
			if imgsize(1,1) > imgsize(1,2)
				img = img';
			end
			if n == 1 && i == 1
				imgs = img;
				label = [n];
			else
				imgs = [imgs,img];
				label = [label,[n]];
			end
		end
	end
end
disp(size(imgs));
dictrows = 384;
dictcols = 512;
k = 3;
D = normcols(randn(dictrows,dictcols));

params.data = imgs;
params.Tdata = k;
params.dictsize = dictcols;
params.memusage = 'high';

[dict,g] = ksvd(params,'');
save('/data/tmp/xiaosahuang/sparse','dict','g','label')
end



