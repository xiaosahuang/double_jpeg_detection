function classify()
src = '/data/tmp/xiaosahuang/feature90.mat'
load(src);

%{
r = randperm(size(allfeature,1));
feature = allfeature(r,:);
x_train = feature(1:1338,1:13);
y_train = feature(1:1338,14);
x_val = feature(1339:end,1:13);
y_val = feature(1339:end,14);
svmStruct = svmtrain(x_train,y_train,'kernel_function','rbf')
classes = svmclassify(svmStruct,x_val);
correctrate = sum(classes == y_val)/length(y_val);
disp(correctrate)
%}

X=allfeature(:,1:13);
Y=allfeature(:,14);
P = cvpartition(Y,'Holdout',0.50);
svmStruct = svmtrain(X(P.training,:),Y(P.training));
C = svmclassify(svmStruct,X(P.test,:));
corRate = sum(Y(P.test) == C)/P.TestSize;
disp(['corrate rate is: ' num2str(corRate)]);

end
