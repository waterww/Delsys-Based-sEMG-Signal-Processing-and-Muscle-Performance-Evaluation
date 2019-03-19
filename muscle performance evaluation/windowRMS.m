function [RS] = windowRMS(data)
%求肌电信号的均方根值，窗口大小为50，重合40
%   此处显示详细说明
n=(length(data)-50)/10+1;
n=floor(n);%窗口的数量
RS=zeros(n,1);
for i=1:n
    data_window=data((10*(i-1)+1):(10*(i-1)+50));
    RS(i)=rootMeanSquare(data_window);
end
end

