function n = simfilter_GUI(y,fs,speed,precision,bias,Elimit,simlimit,N)
%“突变”过滤算法
% 1、先通过能量得到初步的检测点。
% 2、假定1000个采样点为1帧，取每个初步的检测点的“后1帧及前n-1帧”，对这n帧求其
%   “各音节上”的能量。（假定某个音节是250Hz，那就将245-255Hz中所有的能量相
%    加作为该音节的能量，所以单段音频运算后，结果是个一维向量，存放了各个音节的能量）
% 3、对这n帧依次相邻两两求余弦相似度，得到n-1个相似度数据。
% 4、对余弦相似度设阈值，只要n-1个数据中存在某个低于该阈值的，认为该点正确。
% speed = 115; %音乐节拍大小
% 
% precision = 1; %检测点精度
%                %精度越高，检测点点数越多
%                %一般取决于乐谱的最小节拍，如：最小拍为四分之一拍，则该值为4。
%                
% bias = 15; %拍速偏移量
%            %音乐节拍不会严格精确，因此使“采样点最小间隔”略小于“相邻音符最小间隔”
%            %偏移量越大，间隔差值越大
%            
% Elimit = 0.7*precision; %检测点能量门限

y = y(1:floor(length(y)/1000)*1000);%音频采样点去除末尾冗余

%---------------------------------------
%基于能量初步检测

Y=EDF3(y,N);%返回各帧能量差值
     
%[~,n_pro]=findpeaks(Y,'minpeakheight',Elimit,...,
%    'minpeakdistance',fs*60/N/(speed+bias)/precision); %寻找极值位置，返回到n_pro数组中。
                                             %该位置表征的是“段”的位置，而非“点”的位置。
[~,n_pro]=findpeaks(Y,'minpeakheight',Elimit,...,
    'minpeakdistance',fs*60/N/(speed+bias)/precision); %寻找极值位置，返回到n_pro数组中。
                                             %该位置表征的是“段”的位置，而非“点”的位置。                                             

%-----------------------------------------------
n_loc = n_pro.*N; %返回到“点”的位置

a=1; %过滤后采样点数组下标

%-----------------------------------------------
% 旧版本：通过前amount-1帧及当前帧判定相似度
%   for i=1:length(n_pro);
% 
%     %计算每一检测点的后一帧及其相邻前n-1帧的各音符的能量，每一帧帧长为Fr
%     num_ideal = fs*60/(speed+bias)/precision;
%     Fr=1000;%帧长
%     rep=0;
%     %amount=8;   %帧数 
%     amount=round(num_ideal/Fr);
%     %帧长越大则频域信息越精确，但节奏过快时会出现问题。
%     y_sim = zeros(1,amount-1); %存放相邻两段帧能量的余弦相似度
%     
%     
%     
%     for b=1:amount;
%         y_energy(b,:)=energy_note(y(n_loc(i)+(b-amount)*(Fr-rep):n_loc(i)+...
%             (b-amount)*(Fr-rep)+Fr),fs);
%     end
%----------------------------------------
%     %计算相邻帧的相似度
%     extra=0;
%     %y_energy = log10(y_energy);
%     %mean(abs(y).^2);
%     for c=1:amount-1;
%         y_sim(c) = cossim(y_energy(c,:)+extra,y_energy(c+1,:)+extra);
%     end
% %----------------------------------------
%   %相似度过滤
%    % simlimit = 0.96;%相似度门限，该值越低，检测点越少
%     if min(y_sim)<simlimit;
%     n(a)=n_pro(i);
%     a=a+1;
%     end
%   end
%-----------------------------------------------

%新版本：只考虑前帧与后帧的突变程度，并通过短时过零率来进行窗口修正
    %Fr=1000;%帧长
    for i=1:length(n_loc) %遍历所有检测点
        if(abs(zcr(y(n_loc(i)-N:n_loc(i)-0.25*N)) - zcr(y(n_loc(i)-0.25*N:n_loc(i))))>...
                0.2*zcr(y(n_loc(i)-N:n_loc(i)-0.25*N)))
            n_loc(i)=n_loc(i)-0.25*N;
        end
%         y_energy(1,:) = energy_note(y(n_loc(i)-N+1:n_loc(i)),fs);
%         y_energy(2,:) = energy_note(y(n_loc(i)+1:n_loc(i)+N),fs);
%         sim = cossim(y_energy(1,:),y_energy(2,:));
%        if(sim<simlimit)
%            n(a) = n_pro(i);
%            a=a+1;
%        end
        y_energy(1,:) = energy_note3(y(n_loc(i)-N+1:n_loc(i)),fs);
        y_energy(2,:) = energy_note3(y(n_loc(i)+1:n_loc(i)+N),fs);
        sim(i) = cossim(y_energy(1,:),y_energy(2,:));
        distance(i) = sum(abs(y_energy(1,:)-y_energy(2,:))) / N;
        dislimit = 10;
       if(sim(i)<simlimit || distance(i)>dislimit)
           n(a) = n_pro(i);
           a=a+1;
       end
    end

end