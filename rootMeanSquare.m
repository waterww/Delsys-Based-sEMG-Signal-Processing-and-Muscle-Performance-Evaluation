function [RMS] = rootMeanSquare(data)
%计算均方根
%   此处显示详细说明
a=sum(data.^2);
RMS=sqrt(a/length(data));
end

