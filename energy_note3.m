function energy = energy_note3(a,fs)
%计算音频中各音符频率段包含的能量，以向量形式返回

nfft = 2^nextpow2(length(a));
a = hamming(length(a)).*a;%加窗
a_ft = fft(a,nfft);%频域信息

%------------------------------
%各音符频率库
do=[262,524];
do_up=[277,554];
re=[294,588];
mi_down=[311,622];
mi=[330,660];
fa=[349,698];
fa_up=[370,740];
so=[392,784];
so_up=[415,830];
la=[440,880];
si_down=[466,932];
si=[494,988];
%----------------------------------
%各音符判定频段
bias = 3; %频率上下偏移值
          %该值越大，音符对应频率范围越大
freq_notemin = [do,do_up,re,mi_down,mi,...
    fa,fa_up,so,so_up,la,si_down,si] - bias;%音符频率下限值
%freq_notemin = [257,272,289,306,325,344,365,387,410,435,461,489,519,549,583,...
%     617,655,693,735,779,826,875,983,1041,1103,1169,1239,1314,1392,1475,1563,...  
% 1656,1755,1860,1971,2088,2212,2344,2484,2632,2789,2955,3130,3317,3515,3724,...
% 3946,4181];
freq_notemax = [do,do_up,re,mi_down,mi,...
    fa,fa_up,so,so_up,la,si_down,si] + bias ;%音符频率上限值
%----------------------------------
%matlab中频率对应位置
loc_notemin = round(freq_notemin*nfft/fs);
loc_notemax = round(freq_notemax*nfft/fs);
%---------------------------------
%计算各音符能量
len = length(freq_notemin)/2;%音符数量
abs_a = abs(a_ft);
energy = zeros(1,len);  %音符能量初始化
for i=1:len;
    energy(i) = sum(abs_a(loc_notemin(i):loc_notemax(i)).^2)+...
        sum(abs_a(loc_notemin(i+len):loc_notemax(i+len)).^2);
end
%-----------------------------------

end