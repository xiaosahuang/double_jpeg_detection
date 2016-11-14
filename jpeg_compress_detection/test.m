function test()
%img = imread('ucid90_2.jpeg');
img = rand(20);
%disp(img);
a = blkproc(img,[4 4],@func);
disp(a);

end
function b = func(block)
	if sum(sum(block))>7
		b=[1];
	else
		b=[];
	end
end

