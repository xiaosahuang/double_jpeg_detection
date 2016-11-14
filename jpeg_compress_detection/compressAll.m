function compressAll()
	srcDir = '/data/uncompressed_image_databases/ucid';
	dstDir = '/data/tmp/xiaosahuang/test';
	compress(srcDir, dstDir);
end

function compress(srcDir, dstDir)
	parfor i = 10:20
		q = i*5
		onceDir = compress_once(srcDir, dstDir, q, 1);
		twiceDir = compress_once(onceDir, dstDir, q, 2);
		thirdDir = compress_once(twiceDir, dstDir, q, 3);
	end
end

