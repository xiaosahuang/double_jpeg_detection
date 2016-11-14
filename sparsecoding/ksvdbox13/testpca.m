function [a,b,c]=testpca()

x=[1,2,3,4,5,6,7,8,9,10,11,12]
[a,b]=pca(x,'NumComponents',6);

