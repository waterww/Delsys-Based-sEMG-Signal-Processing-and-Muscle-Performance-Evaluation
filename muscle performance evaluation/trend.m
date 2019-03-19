function [n] = trend(data)
%UNTITLED3 此处显示有关此函数的摘要
%   n=1上升趋势，n=0既不上升也不下降，n=-1下降趋势
L=length(data);
S=0;
%保证数据量充足
if L<=3
    n=0;
    return;
end

%判断是否单调
for i=1:(L-1)
    S=S+abs(data(i+1)-data(i));
end
m=abs(data(end)-data(1));
z=m/S;%震荡程度，z=1代表单调
if z<0.2%调整
    n=0;
    return;
end

%判断趋势
x=1:L;
p=polyfit(x,data,1);
if p(1)>0.2
    n=1;
else
    if p(1)<-0.2
        n=-1;
    else
        n=0;
    end
end

end

