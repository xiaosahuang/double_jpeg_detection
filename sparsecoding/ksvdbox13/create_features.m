function create_features() 

src = '/data/tmp/klaus/jpeg_compression_detection/ucid/gray/jpeg'
dst = '/data/tmp/xiaosahuang/sparsecoding/feature'

q = 90;

for i=1:2
	srcDir = [src, '/', num2str(q), '/', num2str(i)]
	dstDir = [dst, '/', num2str(q), '/', num2str(i)];
	mkdir(dstDir);
	files = dir(srcDir);
	n = length(files);
	for j=1:100
		file = files(j);
		if ~file.isdir && length(strfind(file.name, 'txt')) == 0
			filename = file.name;
			srcPath = [srcDir,'/', filename];
			tic

			[dict,g]=create_feature(srcPath);
			
			savename = strrep(filename,'jpeg','mat');
			savepath = [dstDir,'/',savename];
			save(savepath,'dict','g','i');
			t = toc;
			disp([srcPath, ' spend: ', num2str(t), ' s' ]);
		end
	end
end
disp([srcDir, 'process finished']);
end
