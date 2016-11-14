function [x,y] = create_gray_error_image(img_path)

imgobj = jpeg_read(img_path);
[x,y] = idct_image(imgobj);

end

function [err_img,quantable] = idct_image(jpegobj)
	DCT_SIZE = 8;
	quantable = cell2mat(jpegobj.quant_tables);
	quanted_dct_coefs = cell2mat(jpegobj.coef_arrays);
	dctsize = size(quanted_dct_coefs);

	
	quantable_new = repmat(quantable, round(dctsize(1)/DCT_SIZE), round(dctsize(2)/DCT_SIZE));	
	unquanted_dct_coefs = quanted_dct_coefs.*quantable_new;
	idct = mat2cell(unquanted_dct_coefs, ones(1,dctsize(1)/DCT_SIZE)*8, ones(1,dctsize(2)/DCT_SIZE)*8);
	idct = cellfun(@idct2, idct, 'UniformOutput', false);
	idct = cell2mat(idct);

	%{
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
	%}

		reconst = idct;
		reconst=round(reconst);
		reconst(reconst<-127)=-127;
		reconst(reconst>127)=127;

	err_img = reconst-idct;
	
end

