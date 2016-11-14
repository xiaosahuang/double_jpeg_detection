function feature=feature_extraction(err_img,quantable)
%extract 13 features for SVM
%load ('ucid1.mat');
%a mat file which contain a error image named err_img
%dct_err_img=cellfun(@dct2,err_img,'UniformOutput',false);
Q = quantable;
%block_size=8;

L=0;
summean=0;
summeant=0;
sumvar=0;
sumvart=0;
summeanDc=0;
summeantDc=0;
sumvarDc=0;
sumvartDc=0;
summeanAc=0;
summeantAc=0;
sumvarAc=0;
sumvartAc=0;
Lr=0;
Lt=0;
ratio=0;
varR=0;
varAc=0;
varRt=0;
vartAc=0;
vartDc=0;
varDc=0;
meanR=0;
meanAc=0;
meanDc=0;
meanRt=0;
meantDc=0;
meantAc=0;
ci=1;
cj=1;
for t = 1:3
    msize = size(err_img{t});
for i=1:(round(msize(1)/8))
    for j=1:(round(msize(2)/8))
	if i~=1
        	ci=(i-1)*8+1;
	end
	if j~=1
        	cj=(j-1)*8+1;
	end
        block_err_img = err_img{t}(ci:(ci+7),cj:(cj+7));
        block_dct_err_img = dct2(block_err_img);
        if t==1
		P=Q{1};
        else
		P=Q{2};
	end
        w_block_err_img=round(block_dct_err_img./P).*P;
	M=round(block_dct_err_img./P);
        if any(M(:))
            L=L+1;
            if abs(block_err_img) <= 0.5
                summean = summean + sum(sum(abs(block_err_img)));
                summeanDc=summeanDc+abs(w_block_err_img(1,1));
                summeanAc=summeanAc+sum(sum(abs(w_block_err_img)))-abs(w_block_err_img(1,1));
                Lr=Lr+1;
            else
                summeant= summeant+sum(sum(abs(block_err_img)));
                summeantDc=summeantDc+abs(w_block_err_img(1,1));
                summeantAc=summeantAc+sum(sum(abs(w_block_err_img)))-abs(w_block_err_img(1,1));
                Lt=Lt+1;
            end
        end
    end
end
end
if Lr~=0
	meanR = summean/(64*Lr);
	meanDc = summeanDc/Lr;
	meanAc = summeanAc/(63*Lr);
end
if Lt~=0
	meantAc = summeantAc/(63*Lt);
	meanRt = summeant/(64*Lt);
	meantDc = summeantDc/Lt;
end
ci=1;
cj=1;
for t = 1:3
    msize = size(err_img{t});
for i=1:(round(msize(1)/8))
    for j=1:(round(msize(2)/8))
        if i~=1
		ci=(i-1)*8+1;
	end
	if j~=1
		cj=(j-1)*8+1;
	end

        block_err_img=err_img{t}(ci:(ci+7),cj:(cj+7));
        block_dct_err_img = dct2(block_err_img);
	if t==1
		R=Q{1};
	else
		R=Q{2};
	end
        w_block_err_img=round(block_dct_err_img./R).*R;
	M=round(block_dct_err_img./R);
        if any(M(:))
            if abs(block_err_img) <= 0.5
                sumvar = sumvar + sum(sum((abs(block_err_img)-meanR).^2));
                sumvarDc = sumvarDc+(abs(w_block_err_img(1,1))-meanDc).^2;
                sumvarAc = sumvarAc + sum(sum((abs(w_block_err_img)-meanAc).^2))-(abs(w_block_err_img(1,1))-meanAc).^2;
            else
                sumvart = sumvart + sum(sum((abs(block_err_img)-meanRt).^2));
                sumvartDc = sumvartDc+(abs(w_block_err_img(1,1))-meantDc).^2;
                sumvartAc = sumvartAc + sum(sum((abs(w_block_err_img)-meantAc).^2))-(abs(w_block_err_img(1,1))-meantAc).^2;
            end
        end
    end
end
end
if Lr~=0
	varR=sumvar/(64*Lr);
	varDc=sumvarDc/Lr;
	varAc=sumvarAc/(63*Lr);
	ratio = Lr/L;
end
if Lt~=0
	varRt=sumvart/(64*Lt);
	vartDc=sumvartDc/Lt;
	vartAc=sumvartAc/(63*Lt);
end

feature = [meanR,meanDc,meanAc,meanRt,meantDc,meantAc,varR,varDc,varAc,varRt,vartDc,vartAc,ratio]
















