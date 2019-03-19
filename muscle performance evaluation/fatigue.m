function [] = fatigue(MPF,RMS)
%判断肌肉疲劳，MPF值下降，RMS值上升则判断肌肉疲劳
%  MPF记录所有通道当前窗口的平均功率频率；RMS记录所有通道当前窗口的均方根；
%ch_MPF记录所有通道所有窗口的MPF值；ch_RMS记录所有通道所有窗口的RMS值
global ch_MPF;
global ch_RMS;
global ch;

for i=1:length(ch)
    ch_MPF=[ch_MPF MPF];
    ch_RMS=[ch_RMS RMS];
    
    m=trend(ch_MPF(i,:));
    n=trend(ch_RMS(i,:));
    if (m==-1)&&(n==1)
        printf('Muscle is fatugued at %s\n',datastr(now,13));
        ch_MPF=[];
        ch_RMS=[];%达到疲劳点后重置数组
    end
end

end

