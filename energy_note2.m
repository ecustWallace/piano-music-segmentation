function energy = energy_note2(a,fs)
%计算音频中各音符频率段包含的能量，以向量形式返回

nfft = 2^nextpow2(length(a));
a_ft = fft(a,nfft);%频域信息

%------------------------------
%各音符频率库
do=[131,262,524,1047];
do_up=[139,277,554,1109];
re=[147,294,588,1175];
mi_down=[156,311,622,1245];
mi=[165,330,660,1319];
fa=[175,349,698,1397];
fa_up=[185,370,740,1480];
so=[196,392,784,1568];
so_up=[208,415,831,1661];
la=[220,440,880,1760];
si_down=[233,466,932,1864];
si=[246,494,988,1976];
%----------------------------------
%各音符判定频段
bias = 3; %频率上下偏移值
          %该值越大，音符对应频率范围越大
freq_notemin = [do;do_up;re;mi_down;mi;...
    fa;fa_up;so;so_up;la;si_down;si] - bias;%音符频率下限值
%freq_notemin = [257,272,289,306,325,344,365,387,410,435,461,489,519,549,583,...
%     617,655,693,735,779,826,875,983,1041,1103,1169,1239,1314,1392,1475,1563,...  
% 1656,1755,1860,1971,2088,2212,2344,2484,2632,2789,2955,3130,3317,3515,3724,...
% 3946,4181];
freq_notemax = [do;do_up;re;mi_down;mi;...
    fa;fa_up;so;so_up;la;si_down;si] + bias ;%音符频率上限值
%----------------------------------
%matlab中频率对应位置
loc_notemin = round(freq_notemin*nfft/fs);
loc_notemax = round(freq_notemax*nfft/fs);
%---------------------------------
%计算各音符能量
len = size(freq_notemin,1);%数组长度
wid = size(freq_notemin,2);%数组宽度
abs_a = abs(a_ft);
energy = zeros(len,wid);  %音符能量初始化
for j=1:wid;
    for i=1:len;
       energy(i,j) = sum(abs_a(loc_notemin(i,j):loc_notemax(i,j)).^2);
    end
end
%-----------------------------------

end