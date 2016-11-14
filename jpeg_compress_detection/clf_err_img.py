import numpy as np
from sklearn import grid_search
import os,sys,string
import scipy.io as sio
from sklearn import cross_validation
from sklearn import svm
src = '/data/tmp/xiaosahuang/feature_ucid_2'
src2 = '/data/tmp/xiaosahuang/feature_nrcs_2'
#inputdata1 = sio.loadmat('/home/xiaosahuang/jpeg_compress_detection/ucid90_1.mat')['feature']
#inputdata2 = sio.loadmat('/home/xiaosahuang/jpeg_compress_detection/ucid90_2.mat')['feature']
X = []
y = []
q=60
print 'quality:',q
total2=0
count2=0
j=0
k=0
for i in range(1,3):
    srcDir = src+'/'+str(q)+'/'+str(i)
    matfiles = os.listdir(srcDir)
    for name in matfiles:
        k=k+1
#        if k == 200:
 #           break
        srcPath = os.path.join(srcDir,name)
        arr = sio.loadmat(srcPath)['feature']
        feat = np.array(arr)
        feat = np.c_[feat,[i]][0]
        if i==1:
            count2=count2+1
        total2=total2+1
        X.append(feat)
  #  k=0
print 'rate of jpeg once in ucid',float(count2)/total2
nrcs=[]
count1 = 0
#count2=0
total=0

for i in range(1,3):
    srcdir = src2+'/'+str(q)+'/'+str(i)
    files = os.listdir(srcdir)
    for name in files:
        j = j + 1
        if j == 150:
            break
        srcpath = os.path.join(srcdir,name)
#        print srcpath
        arr=sio.loadmat(srcpath)['feature']
        feature=[0]*14
        for l in range(13):
            feature[l] = arr[0][l]
        feature[13]=i
        if i==1:
            count1 = count1 + 1
        total = total +1
        nrcs.append(feature)
    j=0

print 'rate of jpeg once in nrcs', float(count1) / total
X = np.array(X)
max_score=0
np.random.shuffle(X)
x,y = X[:,0:13],X[:,13]
print type(x)
print np.shape(x)
print type(y)
print np.shape(y)
X_train = x[1:1338,:]
X_val = x[1338:,:]
Y_train = y[1:1338]
Y_val = y[1338:]

for m in range(21):
    for n in range(-15,4):
        c = 2**m
        r = 2**n
        model = svm.SVC(gamma=r, C=c)
       # model.fit(X_train,Y_train)
        #score = model.score(X_val,Y_val)
        #mean_scores = np.mean(score)
        scores = cross_validation.cross_val_score(model, x, y,cv=5)
#        print 'scores :',np.mean(scores)
        mean_scores = np.mean(scores)
        if mean_scores > max_score:
            max_score = mean_scores
            print max_score,'|m=',m,',n=',n

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

