function block_img=funcmean(block_img,Q)

global L summean summeant summeanDc summeantDc summeanAc summeantAc Lr Lt meanR meanRt meanDc meantDc meanAc meantAc;

%w_img=(block_img/Q)*Q;
dct_img=dct2(block_img);

w_img=round(dct_img./Q).*Q;
M=round(dct_img./Q);
if any(M(:))
	L=L+1;
	if abs(block_img) <= 0.5
		summean = summean + sum(sum(abs(block_img)));
	        summeanDc=summeanDc+abs(w_img(1,1));
	        summeanAc=summeanAc+sum(sum(abs(w_img)))-abs(w_img(1,1));
	        Lr=Lr+1;
	else
		summeant= summeant+sum(sum(abs(block_img)));
		summeantDc=summeantDc+abs(w_img(1,1));
		summeantAc=summeantAc+sum(sum(abs(w_img)))-abs(w_img(1,1));
		Lt=Lt+1;
	end
%disp(Lt)
end
end
