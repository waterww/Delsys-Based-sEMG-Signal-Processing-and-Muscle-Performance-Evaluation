function [filter_signal]=notchfilter(data,f0)
Fs=2000;
M=2;
lamda=0.90;
L=length(data);
I=eye(M);
c=0.01;
y_out=zeros(L,1);
filter_signal=zeros(L,1);
w_out=zeros(L,M);
% n=(f0/50)*2;
for i=1:L
    if i==1
        P_last=I/c;
        w_last=zeros(M,1);
    end
    d=data(i);
    x=[sin(2*pi*f0*(i-1)/Fs)
        cos(2*pi*f0*(i-1)/Fs)];
    K=(P_last * x)/(lamda + x'* P_last * x);   %计算增益矢量
    y = x'* w_last;                          %计算FIR滤波器输出
    Eta = d - y;                             %计算估计的误差
    w = w_last + K * Eta;                    %计算滤波器系数矢量
    P = (I - K * x')* P_last/lamda;          %计算误差相关矩阵
    %变量更替
    P_last = P;
    w_last = w;
    y_out(i) = y;
    filter_signal(i) = Eta;
    w_out(i,:) = w';
end
end

