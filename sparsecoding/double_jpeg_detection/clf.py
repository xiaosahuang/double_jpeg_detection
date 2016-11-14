import numpy as np
from sklearn import grid_search
import os,sys,string
import scipy.io as sio
from scipy.sparse import csc_matrix
from sklearn import cross_validation
from sklearn import svm
from sklearn.decomposition import PCA
src = '/data/tmp/xiaosahuang/final_features90.mat'

x = []
y = 201*[1]+201*[2]
q=90
print 'quality:', q
x = sio.loadmat(src)['all_feature']
x = x.T
#g = g.toarray()

#x = g.T.reshape(196,512*512)

print 'x size',np.shape(x)
print 'y size',np.shape(y)

max_score = 0

print 'start SVC*********'
for m in range(0,20):
    for n in range(-15,3):
        c = 2**m
        r = 2**n
        model = svm.SVC(gamma=r, C=c)
        scores = cross_validation.cross_val_score(model, x, y,cv=5)
        print 'scores :',np.mean(scores)
        if np.mean(scores) > max_score:
            max_score = np.mean(scores)
print max_score

