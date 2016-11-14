function compress_rgb(src,dst)
	parfor i = 10:20
		q=i*5;
		comp_1=compress(src,dst,q,1);
		comp_2=compress(comp_1,dst,q,2);
		comp_3=compress(comp_2,dst,q,3);
	end
end

function compress(srcDir,dstDir,quality,i)
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
	     		%im = rgb2gray(im);
			dstFilename = strrep(filename, 'tif','jpeg');
			dstPath = [trueDstDir,'/',dstFilename]
			imwrite(im, dstPath, 'jpeg', 'Quality', quality);
		end
	end
end

			       

