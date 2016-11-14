function [dict,g] = creatre_feature(path)

% dictionary dimensions
n = 384;
m = 512;

% number of examples
%L = 1500;

% sparsity of each example
k = 3;

%% generate random dictionary and data %%

D = normcols(randn(n,m));
img = imread(path);
img = double(img);
if size(img,1) > size(img,2)
	img = img';
end

%% run k-svd training %%

params.data = img;
params.Tdata = k;
params.dictsize = m;
params.iternum = 10;
params.memusage = 'high';

[dict,g] = ksvd(params,'');

end
