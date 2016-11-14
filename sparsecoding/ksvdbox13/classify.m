function classify()
[dict,g,y] = create_large_dict();
sizey = size(y);
sampleNum = sizey(1,2);
x = [];
for i = 1:sampleNum
	xi = g(:,(512*(i-1)+1):(512*i));
	sizexi = size(xi);
	col = sizexi(1,1)*sizexi(1,2);
	xi = reshape(xi,1,col);
%	xi = double(xi);
	disp(class(xi))
	disp(size(xi))
	[cof,s] = pca(xi,'Algorithm','als','NumComponents',20);
	if i == 1
		x = s;
	else
		x = [x;s];
	end
end
sizex = size(x);
if sizex(1,1) ~= sampleNum
	disp('the num of x is error');
end

%{
%(调用第三方库libsvm) ucid一半为训练集，一半为测试集，输出最优C gamma下的准确率
bestscore = 0;
for m=0:21
  for n=-15:4
  c0=2.^m;
  g0=2.^n;
  cmd = ['-c ',num2str(c0),' -g ',num2str(g0), '-t','2'];
  model = svmtrain(Y(P.training),X(P.training,:),cmd);
  [predict_label, accuracy, dec_values] = svmpredict(Y(P.test),X(P.test,:), model);
  if accuracy(1) > bestscore
    bestmodel = model;
    bestscore= accuracy(1);
    bestm = m;
    bestn = n;
  end
end

end
%}


%(调用第三方库libsvm) 直接令参数最优，以ucid训练，输出以ucid和nrcs测试的准确率
P = cvpartition(y,'Holdout',0.50);
m=19;
n = -7;
c0=2.^m;
g0=2.^n;
cmd = ['-c ',num2str(c0),' -g ',num2str(g0), '-t','2'];
bestmodel = svmtrain(y(P.training),x(P.training,:),cmd);
[predict_label, accuracy, dec_values] = svmpredict(y(P.test),x(P.test,:), bestmodel);
disp(['best accuracy is ',num2str(accuracy(1))]);
%[predict_label, accuracy, dec_values] = svmpredict(nrcsy,nrcsx, bestmodel);
%disp(['nrcs accuracy is ',num2str(accuracy(1))]);



%{
%利用matlab自带svm,ucid一半训练，一半测试
n = size(allfeature,1);
r = randperm(n);
feature = allfeature(r,:);
x_train = feature(1:round(n/2),1:13);
y_train = feature(1:round(n/2),14);
x_val = feature(round(n/2):end,1:13);
y_val = feature(round(n/2):end,14);
svmStruct = svmtrain(x_train,y_train)
classes = svmclassify(svmStruct,x_val);
correctrate = sum(classes == y_val)/length(y_val);
disp(correctrate)
%}

end
