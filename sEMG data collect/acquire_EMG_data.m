function acquire_EMG_data

clear
close all force

% HOST_IP=input('Please enter ip of the computer:');%输入电脑IP
HOST_IP='101.6.56.58';
global ch;
% ch=input('Enter the chanel you use:');
ch=2;
global plotHandles;%曲线句柄

%判断肌肉疲劳的变量
global ch_MPF;%存储所有通道平均功率频率数据
global ch_RMS;%存储所有通道均方根数据
ch_MPF=[];
ch_RMS=[];

%评估肌肉力的变量
global restState;
global inti;%判断是否初始化,若为1，需要初始化；为任何其它数则直接读取文件中记录的肌肉放松状态数据
inti=0;
if inti==1
    restState=[];
else
    restState=xlsread('restState.xlsx','A:A');%读取静息状态数据
end

interfaceObjectEMG = tcpip(HOST_IP,50041);%创建EMGtcpip对象
interfaceObjectEMG.InputBufferSize = 6400;%创建缓存区

commObject = tcpip(HOST_IP,50040);%创建命令接口tcpip对象

t = timer('Period', 0.5, 'ExecutionMode', 'fixedSpacing', 'TimerFcn', {@updatePlots,plotHandles});%定时器，每0.5秒更新图片

global data_arrayEMG;
data_arrayEMG=[];%存储EMG数据
global rateAdjustedEmgBytesToRead;%调整读取EMGbytes速度的变量

%创建图片显示
figureHandles=zeros(length(ch),1);
plotHandles=zeros(length(ch),2);
axesHandles=zeros(length(ch),2);

for i=1:length(ch)
    figureHandles(i)=figure('Name',['Sensor' num2str(ch(i))],'Numbertitle',...
        'off');
    
    axesHandles(i,1)=subplot(2,1,1);
    plotHandles(i,1)=plot(axesHandles(i,1),0,'b','LineWidth',1);
    set(axesHandles(i,1),'XGrid','on','YGrid','on','XLimMode', 'manual','YLimMode', 'manual');
    set(axesHandles(i,1),'XLim', [0 500],'YLim', [-.00005 .00005]); 
    title('original signal');
    
    axesHandles(i,2)=subplot(2,1,2);
    plotHandles(i,2)=plot(axesHandles(i,2),0,'b','LineWidth',1);
    set(axesHandles(i,2),'XGrid','on','YGrid','on','XLimMode', 'manual','YLimMode', 'manual');
    set(axesHandles(i,2),'XLim', [0 500],'YLim', [-.00005 .00005]);

    title('filtered signal');
end

fopen(commObject);%打开命令接口

pause(1);%暂停1秒
fread(commObject,commObject.BytesAvailable);%读取全部命令
fprintf(commObject, sprintf(['RATE 2000\r\n\r']));%写入str'Rate 2000    '
pause(1);%暂停1秒
fread(commObject,commObject.BytesAvailable);%读取全部命令
fprintf(commObject, sprintf(['RATE?\r\n\r']));%写入str'Rate?     '
pause(1);%暂停1秒
data = fread(commObject,commObject.BytesAvailable);%读取全部命令到data

emgRate = strtrim(char(data'));%将date转换为字符数组并删除前导和尾随空白存储在emgRate
if(strcmp(emgRate, '1925.926'))%比较emgRate和'1925.926'
    rateAdjustedEmgBytesToRead=1664;
else 
    rateAdjustedEmgBytesToRead=1728;
end%设置读取速度1664

 bytesToReadEMG = rateAdjustedEmgBytesToRead;
 interfaceObjectEMG.BytesAvailableFcn = {@localReadAndPlotMultiplexedEMG,interfaceObjectEMG};
 interfaceObjectEMG.BytesAvailableFcnMode = 'byte';
 interfaceObjectEMG.BytesAvailableFcnCount = bytesToReadEMG;
 %设置读取，当有bytesToReadEMG（等于调整速度）1664个字节在缓冲区时，自动回调函数localReadAndPlotMultiplexedEMG
 
 drawnow
 start(t);
 
 try
    fopen(interfaceObjectEMG);%打开对象
catch
%     localCloseFigure(t);
    delete(figureHandles);
    error('CONNECTION ERROR: Please start the Delsys Trigno Control Application and try again');
 end

 fprintf(commObject, sprintf(['START\r\n\r']));%写入'START    '命令
end


function localReadAndPlotMultiplexedEMG(interfaceObjectEMG,~, ~)
global rateAdjustedEmgBytesToRead;
% global counter;
% global ch;

bytesReady = interfaceObjectEMG.BytesAvailable;
bytesReady = bytesReady - mod(bytesReady, rateAdjustedEmgBytesToRead);%%1664
%取byteReady可以整除rateAdjustEmgBytesToRead的部分，即n1664
if (bytesReady == 0)
    return
end%bytesReady不够整除rateAdjustEmgBytesToRead则返回调用函数的部分

global data_arrayEMG
data = cast(fread(interfaceObjectEMG,bytesReady), 'uint8');%将读取到的字节转换为unit8数据类型，存为data
data = typecast(data, 'single');%将date转换为single数据类


if(size(data_arrayEMG, 1) < rateAdjustedEmgBytesToRead*19)%date_arrayEMG元素个数与rateAdjustedEmgBytesToRead1664*19比较
    data_arrayEMG = [data_arrayEMG; data];%date加到date_arrayEMG的后面
else
    data_arrayEMG = [data_arrayEMG(size(data,1) + 1:size(data_arrayEMG, 1));data];%将data放在data_arrrayEMG的前面，并把前面的数据向后移
end

end


function updatePlots(obj, Event,  tmp)
global data_arrayEMG;
global plotHandles;
global ch;
global ch_MPF;
global ch_RMS;
global restState;
global inti;

MPF=zeros(length(ch),1);
RMS=zeros(length(ch),1);


for i = 1:length(ch)
    data_ch = data_arrayEMG(ch(i):16:8000);%从data_arrayEMG数组中取出一个通道的数据
    data_filter=process(data_ch,ch(i));%将数据滤波
    set(plotHandles(i,1),'YData',data_ch);
    set(plotHandles(i,2),'YData',data_filter);
    drawnow
    
    %肌力评估
    muscleForceRMS(inti,restState,data_filter);
     
    %当前窗口的MPF和RMS
    MPF(i)=meanPowerFrequency(data_filter);
    RMS(i)=rootMeanSquare(data_filter); 
    
end

%判断肌肉是否疲劳
fatigue(MPF,RMS);

    
end 

% function localCloseFigure(t)
% % interfaceObject1, commObject,
% 
% %% 
% % Clean up the network objects
% % if isvalid(interfaceObject1)
%     fclose(interfaceObject1);
%     delete(interfaceObject1);
%     clear interfaceObject1;
% % end
% 
% % if isvalid(t)
%    stop(t);
%    delete(t);
% % end
% 
% % if isvalid(commObject)
%     fclose(commObject);
%     delete(commObject);
%     clear commObject;
% % end
% 
% %% 
% % Close the figure window
% % delete(figureHandle);
% end
