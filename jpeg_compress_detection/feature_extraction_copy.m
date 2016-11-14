function feature=feature_extraction_gray(err_img,Q)

global meanR meanRt meanDc meantDc meanAc meantAc summean summeant summeanDc summeantDc summeanAc summeantAc L Lr Lt sumvar sumvarDc sumvarAc sumvart sumvartDc sumvartAc;
size1 = size(err_img);
if(size1(1)>384 && size1(2) > 512)
	err_img=err_img(1:384,1:512)
end
if isempty(L)
	L=0;
end
if isempty(meanR)
	meanR=0;
end
if isempty(meanRt)
	meanRt=0;
end
if isempty(meanDc)
	meanDc=0;
end
if isempty(meantDc)
	meantDc=0;
end 
if isempty(meanAc)
	meanAc=0;
end
if isempty(meantAc)
	meantAc=0;
end
if isempty(summean)
	summean=0;
end
if isempty(summeant)
	summeant=0;
end
if isempty(summeanDc)
	summeanDc=0;
end
if isempty(summeanAc)
	summeanAc=0;
end
if isempty(summeantDc)
	summeantDc=0;
end
if isempty(summeantAc)
	summeantAc=0;
end
if isempty(Lr)
	Lr=0;
end
if isempty(Lt)
	Lt=0;
end
if isempty(sumvar)
	sumvar=0;
end
if isempty(sumvart)
	sumvart=0;
end
if isempty(sumvarDc)
	sumvarDc=0;
end
if isempty(sumvarAc)
	sumvarAc=0;
end
if isempty(sumvartDc)
	sumvartDc=0;
end
if isempty(sumvartAc)
	sumvartAc=0;
end
%[meanR,meanDc,meanAc,meanRt,meantDc,meantAc,varR,varDc,varAc,varRt,vartDc,vartAc,ratio] = [0]*13;
varR =0;
varDc = 0;
varAc = 0;
varRt = 0;
vartDc = 0;
vartAc = 0;
ratio = 0;
blkproc(err_img,[8 8],@calmean,Q);
if Lr~=0
	meanR = summean/(64*Lr);
	meanDc = summeanDc/Lr;
	meanAc = summeanAc/(63*Lr);
end
if Lt~=0
	meanRt = summeant/(64*Lt);
	meantDc = summeantDc/Lt;
	meantAc = summeantAc/(63*Lt);
end


blkproc(err_img,[8 8],@calvar,Q);

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

feature = [meanR,meanDc,meanAc,meanRt,meantDc,meantAc,varR,varDc,varAc,varRt,vartDc,vartAc,ratio];
%save(['/home/xiaosahuang/jpeg_compress_detection/ucid90_1.mat'],'feature')
end

function block_img=calvar(block_img,Q)

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


function block_img=calmean(block_img,Q)

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
