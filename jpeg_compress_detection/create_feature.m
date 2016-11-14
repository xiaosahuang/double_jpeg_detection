function create_feature()
%输入图像 获得特征 将一个目录下的所有图像的特征写入一个大feature并保存
src = '/data/tmp/klaus/jpeg_compression_detection/ucid/gray/jpeg'; 
%从该路径获取nrcs/ucid各质量因子下压缩1次2次后的JPEG图像
dst = '/data/tmp/xiaosahuang/featurecor200.mat'; 
%将整个目录图像特征写入allfeatre 写入该路径
quality= 80;
allfeature=[];
global quantable;
for n = 1:2
	srcDir = [src,'/',num2str(quality),'/',num2str(n)];
	files = dir(srcDir);
	l=length(files);
	for i=1:10
		file=files(i);
		if ~file.isdir && length(strfind(file.name,'txt'))==0
			filename = file.name;
			srcPath = [srcDir,'/',filename];
			tic
			err_img = create_error_image(srcPath); %获取err_img
			save('/data/tmp/xiaosahuang/testcor.mat','err_img');
			feature = feature_extraction(err_img);%获取特征
			disp(feature);
			feature = [feature,n];
			t = toc
			disp([srcPath, ' spend: ', num2str(t), ' s' ]);
			if i == 1 && n == 1
				allfeature = feature;
			else
				allfeature = [allfeature;feature];
			end
		end
	end
end
save(dst,'allfeature');
end

function err_img=create_error_image(path)
global quantable;

imgobj = jpeg_read(path);
quantable = cell2mat(imgobj.quant_tables);
quanted_dct_coefs = cell2mat(imgobj.coef_arrays);
imgsize = size(quanted_dct_coefs);
quantable_overall = repmat(quantable,round(imgsize(1)/8),round(imgsize(2)/8));
unquanted_dct_coefs = quanted_dct_coefs.*quantable_overall;
idct = mat2cell(unquanted_dct_coefs,ones(1,imgsize(1)/8)*8,ones(1,imgsize(2)/8)*8);
idct = cellfun(@idct2,idct,'UniformOutput',false);
idct = cell2mat(idct);
reconst_img = idct;
reconst_img = round(reconst_img);
reconst_img(reconst_img<-127) = -127;
reconst_img(reconst_img>127) = 127;
err_img = reconst_img-idct;
end

function feature = feature_extraction(err_img)
%feature: [meanR,meanDc,meanAc,meanRt,meanDct,meanAct,varR,varDc,varAc,varRt,varDct,varAct,ration]
%feature_tmp: [summeanR,summeanDc,summeanAc,summeanRt,summeanDct,summeanAct,sumvarR,sumvarDc,sumvarAc,sumvarRt,sumvarDct,sumvarAct,L,Lr,Lt]
global feature feature_tmp quantable;
for i = 1:13
	feature(i) = 0;
end
for i = 1:15
	feature_tmp(i)= 0;
end

sizeerr_img = size(err_img)
if(sizeerr_img(1)>384 && sizeerr_img(2) > 512)
	err_img=err_img(1:384,1:512)
end

blkproc(err_img,[8 8],@calmean);
if feature_tmp(14)~=0 %unstable rounding error blocks
	feature(1) = feature_tmp(1)/(64*feature_tmp(14));  
	feature(2) = feature_tmp(2)/feature_tmp(14);       
	feature(3) = feature_tmp(3)/(63*feature_tmp(14));
end

if feature_tmp(15)~=0 %unstable truncation error blocks
	feature(4) = feature_tmp(4)/(64*feature_tmp(15));
	feature(5) = feature_tmp(5)/feature_tmp(15);
	feature(6) = feature_tmp(6)/(63*feature_tmp(15));
end

blkproc(err_img,[8 8],@calvar);

if feature_tmp(14)~=0
	feature(7) = feature_tmp(7)/(64*feature_tmp(14));
	feature(8) = feature_tmp(8)/feature_tmp(14);
	feature(9) = feature_tmp(9)/(63*feature_tmp(14));
end

if feature_tmp(15)~=0
	feature(10) = feature_tmp(10)/(64*feature_tmp(15));
	feature(11) = feature_tmp(11)/feature_tmp(15);
	feature(12) = feature_tmp(12)/(63*feature_tmp(15));
end
if feature_tmp(13)~=0 %unstable error blocks
	feature(13)= feature_tmp(14)/feature_tmp(13);
end

end

function block_img = calmean(block_img)
global feature feature_tmp quantable;
dct_img = dct2(block_img);
w_img = round(dct_img./quantable).*quantable;
M=round(dct_img./quantable);
if any(M(:))
	feature_tmp(13)=feature_tmp(13)+1;
	if abs(block_img) <= 0.5
		feature_tmp(1) = feature_tmp(1) + sum(sum(abs(block_img)));
	        feature_tmp(2) = feature_tmp(2) + abs(w_img(1,1));
	        feature_tmp(3) = feature_tmp(3) + sum(sum(abs(w_img)))-abs(w_img(1,1));
	        feature_tmp(14) = feature_tmp(14)+1;
	else
		
		feature_tmp(4) = feature_tmp(4) + sum(sum(abs(block_img)));
	        feature_tmp(5) = feature_tmp(5) + abs(w_img(1,1));
	        feature_tmp(6) = feature_tmp(6) + sum(sum(abs(w_img)))-abs(w_img(1,1));
	        feature_tmp(15) = feature_tmp(15)+1;
	end
end
end

function block_img=calvar(block_img)

global feature feature_tmp quantable;
dct_img=dct2(block_img);
w_img=round(dct_img./quantable).*quantable;
M=round(dct_img./quantable);
if any(M(:))
	if abs(block_img) <= 0.5
		feature_tmp(7) = feature_tmp(7) + sum(sum((abs(block_img)-feature(1)).^2));
	        feature_tmp(8) = feature_tmp(8)+(abs(w_img(1,1))-feature(2)).^2;
	        feature_tmp(9) = feature_tmp(9) + sum(sum((abs(w_img)-feature(3)).^2))-(abs(w_img(1,1))-feature(3)).^2;
	else
	        feature_tmp(10) = feature_tmp(10) + sum(sum((abs(block_img)-feature(4)).^2));
		feature_tmp(11) = feature_tmp(11)+(abs(w_img(1,1))-feature(5)).^2;
		feature_tmp(12) = feature_tmp(12) + sum(sum((abs(w_img)-feature(6)).^2))-(abs(w_img(1,1))-feature(6)).^2;
	end
end
end
