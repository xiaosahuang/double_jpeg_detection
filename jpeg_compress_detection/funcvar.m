function block_img=funcvar(block_img,Q)

global sumvar sumvart sumvarDc sumvartDc sumvarAc sumvartAc meanR meanDc meanAc meanRt meantDc meantAc;

%w_img=(block_img/Q)*Q;
dct_img=dct2(block_img);

w_img=round(dct_img./Q).*Q;
M=round(dct_img./Q);
if any(M(:))
	if abs(block_img) <= 0.5
		sumvar = sumvar + sum(sum((abs(block_img)-meanR).^2));
	        sumvarDc = sumvarDc+(abs(w_img(1,1))-meanDc).^2;
	        sumvarAc = sumvarAc + sum(sum((abs(w_img)-meanAc).^2))-(abs(w_img(1,1))-meanAc).^2;
	else
	        sumvart = sumvart + sum(sum((abs(block_img)-meanRt).^2));
		sumvartDc = sumvartDc+(abs(w_img(1,1))-meantDc).^2;
		sumvartAc = sumvartAc + sum(sum((abs(w_img)-meantAc).^2))-(abs(w_img(1,1))-meantAc).^2;
	end
end
end
