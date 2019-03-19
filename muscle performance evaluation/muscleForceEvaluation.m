function [] = muscleForceEvaluation(RMS)
%根据肌力评估动作
%   RMS为运动状态和静息状态均方根差值，DRMS为当前实验者与标准值差值
%standard为标准值
DRMS=abs(RMS-standard)./standard;%与标准值差的绝对值除以标准值
k=-1;%调整k，使得y值在0到1内
y=1+k*(DRMS.^2);%评估曲线（可修改），0《y《1值越大代表动作越好
z=mean(y);%取均值

if z>0.8
    printf('good\n');
    if (z<=0.8)&&(z>0.6)
        printf('okay\n');
    else
        printf('bad\n');
    end
end
end

