function [] = muscleForceRMS(inti,restState,data_filter)
%计算肌肉紧张状态的窗口均方根值，评估肌肉表现
%   inti=1，初始化肌肉放松状态；restState记录肌肉放松状态的均方根值，data_filter
%滤波处理后的信号；motionState为肌肉紧张状态的均方根值，与标准值比较评估肌肉表现
 
if inti==1
    restState=windowRMS(data_filter); %记录静息状态下的肌电信号均方根
    xlswrite('restState.xlsx',restState);
else
    motionState=windowRMS(data_filter)-restState;%运动状态减去静息状态
        
    figure(2);
    subplot(211)
    plot(restState);
    axis([1 46 -6e-6 6e-6]);
    title('肌肉放松状态');
    subplot(212)
    plot(motionState);
    axis([1 46 -6e-6 6e-6]);
    title('肌肉用力状态');
        
    muscleForceEvaluation(motionState);%根据肌力评估动作
end

end

