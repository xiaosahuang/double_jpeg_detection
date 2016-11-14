function trueDstDir = compress_once(srcDir, dstDir, quality, i)
        trueDstDir = [dstDir,'/',num2str(quality),'/',num2str(i)];
	mkdir(trueDstDir);
	files = dir(srcDir);
	n = length(files);
	for i=1:n
		file = files(i);
		if ~file.isdir && length(strfind(file.name, 'txt')) == 0
			filename = file.name;
			srcPath = [srcDir,'/' ,filename];
			im = imread(srcPath);
			%to gray image
			im = rgb2gray(im);
			dstFilename = strrep(filename, 'tif','jpeg');
			dstPath = [trueDstDir,'/',dstFilename]
			imwrite(im, dstPath, 'jpeg', 'Quality', quality);
		end
	end
end
