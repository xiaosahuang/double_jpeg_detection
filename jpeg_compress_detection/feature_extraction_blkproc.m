function feature=feature_extraction_blkproc(err_img,quantable)
%extract 13 features for SVM
%load ('ucid1.mat');
%a mat file which contain a error image named err_img
dct_err_img=cellfun(@dct2,err_img,'UniformOutput',false);
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

blkproc(err_img,[8,8],funcmean);
blkproc(err_img,[8,8],funcvar);

meanR = summean/(64*Lr);
meanRt = summeant/(64*Lt);
meanDc = summeanDc/Lr;
meantDc = summeantDc/Lt;
meanAc = summeanAc/(63*Lr);
meantAc = summeantAc/(63*Lt);

varR=sumvar/(64*Lr);
varDc=sumvarDc/Lr;
varAc=sumvarAc/(63*Lr);
varRt=sumvart/(64*Lt);
vartDc=sumvartDc/Lt;
vartAc=sumvartAc/(63*Lt);
ratio = Lr/L;

feature = [meanR,meanDc,meanAc,meanRt,meantDc,meantAc,varR,varDc,varAc,varRt,vartDc,vartAc,ratio]
end


function funcmean(block_img)
	for t=1:3
        	if t==1
                	P=Q{1};
             	else
                   	P=Q{2};
                end
                w_img=(block_img{t}./P).*P;
                dct_img=dct2(block_img{t});
	        if round(dct_img./P) ~= 0
	        	L=L+1;
	                if abs(block_img{t}) <= 0.5
	                	summean = summean + sum(sum(abs(block_img{t})));
	                        summeanDc=summeanDc+abs(w_img(1,1));
	                        summeanAc=summeanAc+sum(sum(abs(w_img)))-abs(w_img(1,1));
	                        Lr=Lr+1;
	                else
		                summeant= summeant+sum(sum(abs(block_img{t})));
		                summeantDc=summeantDc+abs(w_img(1,1));
		                summeantAc=summeantAc+sum(sum(abs(w_img)))-abs(w_img(1,1));
		                Lt=Lt+1;
		        end
		 end
	end
end

function funcvar(block_img)
	for t=1:3
        	if t==1
                	P=Q{1};
                else
                        P=Q{2};
                end
                w_img=(block_img{t}./P).*P;
	        dct_img=dct2(block_img{t});
	        if round(block_dct_err_img./R) ~= 0
	        	if abs(block_err_img) <= 0.5
	                	sumvar = sumvar + sum(sum((abs(block_err_img)-meanR)^2));
	                        sumvarDc = sumvarDc+(abs(w_block_err_img(1,1))-meanDc)^2;
	                        sumvarAc = sumvarAc + sum(sum((abs(w_block_err_img)-meanAc)^2))-(abs(w_block_err_img(1,1))-meanAc)^2;
	                else
	                        sumvart = sumvart + sum(sum((abs(block_err_img)-meanRt)^2));
		                sumvartDc = sumvartDc+(abs(w_block_err_img(1,1))-meantDc)^2;
		                sumvartAc = sumvartAc + sum(sum((abs(w_block_err_img)-meantAc)^2))-(abs(w_block_err_img(1,1))-meantAc)^    2;
		        end
		end
	end
end

