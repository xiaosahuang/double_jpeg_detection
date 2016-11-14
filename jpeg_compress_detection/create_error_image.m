function [err,q]=create_error_image(img_path)

imgobj = jpeg_read(img_path);
[err,q,reconst_img] = idct_image(imgobj);
%img_size = size(err_img(:,:,2));
%reconst_img
err_img=imread(img_path)-reconst_img;
%subplot(1,2,1),imshow(reconst_img);
%subplot(1,2,2),imshow(imread(img_path));
end

function [errorimg,quantable,reconst_img] = idct_image(jpegobj)
	DCT_SIZE = 8;
	%assert(jpegobj.jpeg_components == 3,'图片不是Jpeg格式') %YUV空间
	quantable = jpegobj.quant_tables;
	quanted_dct_coefs = jpegobj.coef_arrays;
%	disp(size(quanted_dct_coefs{1}));
%	disp(size(quanted_dct_coefs{2}));
%	disp(size(quanted_dct_coefs{3}));
	Y_size = size(quanted_dct_coefs{1});
	Cb_size = size(quanted_dct_coefs{2});
	quant_size = size(quantable);
	assert( quant_size(2) == 2, 'jpeg 量化表为亮度量化表和色度量化表');
	quantable_Y = repmat(quantable{1}, Y_size(1)/DCT_SIZE, Y_size(2)/DCT_SIZE);	
	quantable_Cb = repmat(quantable{2}, Cb_size(1)/ DCT_SIZE, Cb_size(2)/ DCT_SIZE);	
	unquanted_dct_coefs = cell(1,3);
	unquanted_dct_coefs{1} = quanted_dct_coefs{1} .* quantable_Y;
	unquanted_dct_coefs{2} = quanted_dct_coefs{2} .* quantable_Cb;
	unquanted_dct_coefs{3} = quanted_dct_coefs{3} .* quantable_Cb;

	row_expand = Y_size(1);
	col_expand = Y_size(2);

	idct = cell(1,3);
	%calculate idt
	idct{1} = mat2cell(unquanted_dct_coefs{1}, ones(1,Y_size(1)/DCT_SIZE)*8, ones(1,Y_size(2)/DCT_SIZE)*8);
	idct{2} = mat2cell(unquanted_dct_coefs{2}, ones(1,Cb_size(1)/DCT_SIZE)*8, ones(1,Cb_size(2)/DCT_SIZE)*8);
	idct{3} = mat2cell(unquanted_dct_coefs{3}, ones(1,Cb_size(1)/DCT_SIZE)*8, ones(1,Cb_size(2)/DCT_SIZE)*8);
	for i = 1:3
			idct{i} = cellfun(@idct2, idct{i}, 'UniformOutput', false);
			idct{i} = cell2mat(idct{i});
	end

%	tmp(:,:,1)=idct{1};
%	tmp(:,:,2)=idct{2};
%	tmp(:,:,3)=idct{3};
	for i = 1:3
		idct{i} = uint8(idct{i}+128);
	end
	 YCbCr_in_orig(:,:,1)=idct{1};
	 for i=1:row_expand/2
	 	for j=1:col_expand/2
			YCbCr_in_orig(2*i-1,2*j-1,2)=idct{2}(i,j);
			YCbCr_in_orig(2*i-1,2*j,2)=idct{2}(i,j);
			YCbCr_in_orig(2*i,2*j-1,2)=idct{2}(i,j);
			YCbCr_in_orig(2*i,2*j,2)=idct{2}(i,j);
			YCbCr_in_orig(2*i-1,2*j-1,3)=idct{3}(i,j);
			YCbCr_in_orig(2*i-1,2*j,3)=idct{3}(i,j);
			YCbCr_in_orig(2*i,2*j-1,3)=idct{3}(i,j);
		 	YCbCr_in_orig(2*i,2*j,3)=idct{3}(i,j);
		end
	end
	for i = 1:3
		idct{i}=round(idct{i});
		idct{i}(idct{i}<0)=0;
		idct{i}(idct{i}>255)=255;
	end

	 YCbCr_in(:,:,1)=idct{1};
	 for i=1:row_expand/2
	 	for j=1:col_expand/2
			YCbCr_in(2*i-1,2*j-1,2)=idct{2}(i,j);
			YCbCr_in(2*i-1,2*j,2)=idct{2}(i,j);
			YCbCr_in(2*i,2*j-1,2)=idct{2}(i,j);
			YCbCr_in(2*i,2*j,2)=idct{2}(i,j);
			YCbCr_in(2*i-1,2*j-1,3)=idct{3}(i,j);
			YCbCr_in(2*i-1,2*j,3)=idct{3}(i,j);
			YCbCr_in(2*i,2*j-1,3)=idct{3}(i,j);
		 	YCbCr_in(2*i,2*j,3)=idct{3}(i,j);
		end
	end
%	YCbCr_rt = round(YCbCr_in);
%	YCbCr_rt(YCbCr_rt < 0)=0;
%	YCbCr_rt(YCbCr_rt > 255)=255;
%{
	idct_round = cellfun(@round, idct, 'UniformOutput', false);
	idct_round{1}(idct_round{1}<0)=0;
	idct_round{1}(idct_round{1}>255)=255;
	idct_round{2}(idct_round{2}<0)=0;
	idct_round{2}(idct_round{2}>255)=255;
	idct_round{3}(idct_round{3}<0)=0;
	idct_round{3}(idct_round{3}>255)=255;
	%idct_round = cellfun(@round, idct, 'UniformOutput', false);
%}
	img_orig = ycbcr2rgb(YCbCr_in_orig);
	reconst_img = ycbcr2rgb(YCbCr_in);
%	disp(img_orig(1,1,1));
%	disp(reconst_img(1,1,1));
	
	err_img=double(img_orig)-double(reconst_img);
%	err_img = reconst_img-img_orig;
	%err_img=double(YCbCr_in)-YCbCr_in_orig;
	%err_img=mat2cell(err_img)
	
	errorimg=cell(1,3);
	errorimg{1}=err_img(:,:,1);
	errorimg{2}=err_img(:,:,2);
	errorimg{3}=err_img(:,:,3);
	%save('/home/xiaosahuang/jpeg_compress_detection/ucid1.mat','err_img','quantable');
end

