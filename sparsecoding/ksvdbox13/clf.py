import numpy as np
from sklearn import grid_search
import os,sys,string
import scipy.io as sio
from scipy.sparse import csc_matrix
from sklearn import cross_validation
from sklearn import svm
from sklearn.decomposition import PCA
src = '/data/tmp/xiaosahuang/sparse.mat'

x = []
y = []
q=90
print 'quality:', q
g = sio.loadmat(src)['g']
y = sio.loadmat(src)['label']
print 'y shape',np.shape(y)
print 'y type',type(y)
y = y.reshape(-1)
g = g.toarray()
print 'y after shape',np.shape(y)
samplenum = np.shape(y)[0];
print 'samplenum',samplenum

#x = [g[:,0:512].reshape(-1)]
#for i in range(1,samplenum):
#    xi = g[:,512*(i):512*(i+1)]
#    feature = xi.reshape(-1)
#    x = np.append(x, [feature],axis=0)
#    print x.shape
x = g.T.reshape(196,512*512)

print 'x size',np.shape(x)
print 'y size',np.shape(y)

pca =PCA(n_components=256)
newx = pca.fit_transform(x)
print "newx.shape:",np.shape(newx)
print 'y:', y
#print 'label size',np.shape(y)
#print type(y)
max_score = 0

print 'start SVC*********'
m = 17
n = -2
c = 2**m
r = 2**n
model = svm.SVC(gamma=r, C=c)
scores = cross_validation.cross_val_score(model, newx, y,cv=5)
print 'scores :',np.mean(scores)
