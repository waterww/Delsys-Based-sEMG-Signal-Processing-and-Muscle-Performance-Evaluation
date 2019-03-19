function [filtered_signal] = process(data,channel)
%1.带通滤波 2.陷波滤波
%   此处显示详细说明
filtered_signal=[];
if ~isempty(data)
    %     data1=bandpass(data,10,500);
%     savepath='data\';
%     dlmwrite([savepath,'rawdata_channel',num2str(channel)], data);
    
    dim=1;
    wl=10;
    wh=500;
    samplingRate=2000;
    data1= ideal_bandpassing(data, dim, wl, wh, samplingRate);
    
%     dlmwrite([savepath,'AFBandPass_channel',num2str(channel)], data1);
    
    Fs=2000;
    
    %     f0=100;
    %     Q=100;%品质因数
    %     wo=f0/(Fs/2);
    %     bw=wo/Q;
    %     [b1,a1]=iirnotch(wo,bw);%设计100赫兹陷波滤波器
    %     data2=filter(b1,a1,data1);%100赫兹过滤信号
    
    data2=notchfilter(data1,50);
    
%     dlmwrite([savepath,'AFBPand50HzNF_channel',num2str(channel)], data2);
    
    %     f01=50;
    %     Q=100;
    %     wo=f01/(Fs/2);
    %     bw=wo/Q;
    %     [b2,a2]=iirnotch(wo,bw);%设计50赫兹陷波滤波器
    %     filtered_signal=filter(b2,a2,data2);%50赫兹过滤信号
    
    filtered_signal=notchfilter(data2,100);
    
%     dlmwrite([savepath,'filtereddata_channel',num2str(channel)], filtered_signal);
    
    
    
    if  0
        L=length(data);%信号长度
        Fs=1000;%采样频率
        T=1/Fs;%采样时间
        t=(0:L-1)*T;%时间
        N=2^nextpow2(L);%采样点数，点数越大幅值越精确
        
        offt=fft(data,N)/N*2;%真实幅值
        offt=abs(offt);
        
        yfft=fft(filtered_signal,N)/N*2;%真实幅值
        yfft=abs(yfft);
        
        f=Fs/N*(0:N-1);%频率
        
        figure(2)
        subplot(2,1,1)
        plot(f(1:N/2),offt(1:N/2));%fft返回的数据结构具有对称性因此只取一半
        grid;
        ylim([0 0.00005]);
        xlabel('Frequency(Hz)');
        ylabel('Magnitude(dB)');
        title('Input signal');%原始信号傅里叶变换
        
        subplot(2,1,2);
        plot(f(1:N/2),yfft(1:N/2));
        grid;
        ylim([0 0.00005]);
        xlabel('Frequency (Hz)');
        ylabel('Magnitude (dB)');
        title('Filter output');%滤波后信号的傅里叶变换
        
        
        
        offt=fft(data1,N)/N*2;%真实幅值
        offt=abs(offt);
        
        yfft=fft(data2,N)/N*2;%真实幅值
        yfft=abs(yfft);
        
        figure(3)
        subplot(2,1,1)
        plot(f(1:N/2),offt(1:N/2));%fft返回的数据结构具有对称性因此只取一半
        grid;
        ylim([0 0.00005]);
        xlabel('Frequency(Hz)');
        ylabel('Magnitude(dB)');
        title('After Bandpass filter');%原始信号傅里叶变换
        
        subplot(2,1,2);
        plot(f(1:N/2),yfft(1:N/2));
        grid;
        ylim([0 0.00005]);
        xlabel('Frequency (Hz)');
        ylabel('Magnitude (dB)');
        title('After Bandpass filter and 100Hz notch filter');%滤波后信号的傅里叶变换
    end
    
end
end

