import numpy as np
from sklearn import grid_search
import os,sys,string
import scipy.io as sio
from scipy.sparse import csc_matrix
from sklearn import cross_validation
from sklearn import svm
from sklearn.decomposition import PCA
src = '/data/tmp/xiaosahuang/sparsecoding/feature'
#src2 = '/data/tmp/xiaosahuang/feature_nrcs_2'

x = []
y = []
q=90
print 'quality:', q

for i in range(1,3):
    srcDir = src+'/'+str(q)+'/'+str(i)
    matfiles = os.listdir(srcDir)
    for name in matfiles:
        srcPath = os.path.join(srcDir,name)
        g = sio.loadmat(srcPath)['g']
        label = sio.loadmat(srcPath)['i']
#        print type(g)
        g = g.toarray()
#        print type(g)
#        print np.shape(g)
#        label = np.array(label)
        col = np.shape(g)[1] * np.shape(g)[0]
#        print col
        feature = g.reshape((1,col))
#        feature[0].reshape(-1,1)
#        pca=PCA(n_components=20)
#        newfeature=pca.fit_transform(feature[0])
        
#        feature = np.c_[feature,[i]][0]
#        print np.shape(label)
#        print type(label)
#        print np.shape(feature)
#        print type(feature)
#        print feature[0]
#        print label[0][0]
#        for j in feature[0]:
#            if j!= 0:
#                print j
        x.append(feature[0])       
        y.append(label[0][0])
x=np.array(x)
y=np.array(y)
pca =PCA(n_components=20)
newx = pca.fit_transform(x)
print newx
print np.shape(newx)
#print 'data size',np.shape(x)
#print type(x)
#print 'label size',np.shape(y)
#print type(y)
max_score = 0

print 'start SVC*********'
#for m in range(21):
#    for n in range(-15,4):
m = 17
n = -2
c = 2**m
r = 2**n
model = svm.SVC(gamma=r, C=c)
       # model.fit(X_train,Y_train)
        #score = model.score(X_val,Y_val)
        #mean_scores = np.mean(score)
scores = cross_validation.cross_val_score(model, newx, y,cv=5)
print 'scores :',np.mean(scores)
   #     mean_scores = np.mean(scores)
       # if mean_scores > max_score:
        #    max_score = mean_scores
         #   print max_score,'|m=',m,',n=',n

'''
c=np.arange(0,21,1)
r=np.arange(-15,4,1)
param={'kernel':('linear','rbf'),'C':2**c,'gamma':2**r}
model =svm.SVC()

grid =grid_search.GridSearchCV(model,param)
print("gridsearchCV finished")
grid.fit(x,y)
print("fit finished")
print(grid)
print(grid.best_score_)
print(grid.best_params_)

'''
'''
max_score = 0
nrcs = np.array(nrcs)
np.random.shuffle(nrcs)

#bestmodel = model
for m in range(21):
    for n in range(-15,4):
        c=2**m
        r=2**n
        model = svm.SVC(gamma=r,C=c)
        #scores = cross_validation.cross_val_score(model, x, y,cv=2)
        #meanscore = np.mean(scores)
        #if meanscore > max_score:
        #    max_score = meanscore
        #    print 'score',meanscore,'c',m,'r',n
        #x_val_nrcs=nrcs[75:,0:13]
        #x_train_nrcs=nrcs[0:75,0:13]
        #y_train_nrcs=nrcs[0:75,13]
        #y_val_nrcs=nrcs[75:,13]

        model.fit(X_train,Y_train)
        #print np.where(X[:,13]==2)
        #X_test = X[np.where(X[:,13]==2)]
        #print X_test
#       score0 = model.score(nrcs[:,0:13],nrcs[:,13])
#        max_score = score0
        scores = model.score(X_val,Y_val)
        print 'score in nrcs','score in ucid',scores
#print 'data1',bestmodel.predict(inputdata1)

#print 'data2',bestmodel.predict(inputdata2)
'''

