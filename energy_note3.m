function energy = energy_note3(a,fs)
%������Ƶ�и�����Ƶ�ʶΰ�������������������ʽ����

nfft = 2^nextpow2(length(a));
a = hamming(length(a)).*a;%�Ӵ�
a_ft = fft(a,nfft);%Ƶ����Ϣ

%------------------------------
%������Ƶ�ʿ�
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
%�������ж�Ƶ��
bias = 3; %Ƶ������ƫ��ֵ
          %��ֵԽ��������ӦƵ�ʷ�ΧԽ��
freq_notemin = [do,do_up,re,mi_down,mi,...
    fa,fa_up,so,so_up,la,si_down,si] - bias;%����Ƶ������ֵ
%freq_notemin = [257,272,289,306,325,344,365,387,410,435,461,489,519,549,583,...
%     617,655,693,735,779,826,875,983,1041,1103,1169,1239,1314,1392,1475,1563,...  
% 1656,1755,1860,1971,2088,2212,2344,2484,2632,2789,2955,3130,3317,3515,3724,...
% 3946,4181];
freq_notemax = [do,do_up,re,mi_down,mi,...
    fa,fa_up,so,so_up,la,si_down,si] + bias ;%����Ƶ������ֵ
%----------------------------------
%matlab��Ƶ�ʶ�Ӧλ��
loc_notemin = round(freq_notemin*nfft/fs);
loc_notemax = round(freq_notemax*nfft/fs);
%---------------------------------
%�������������
len = length(freq_notemin)/2;%��������
abs_a = abs(a_ft);
energy = zeros(1,len);  %����������ʼ��
for i=1:len;
    energy(i) = sum(abs_a(loc_notemin(i):loc_notemax(i)).^2)+...
        sum(abs_a(loc_notemin(i+len):loc_notemax(i+len)).^2);
end
%-----------------------------------

end