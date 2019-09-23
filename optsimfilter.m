function node = optsimfilter( y,fs,speed,bias,musicscorename )
%----参数自适应算法---- 
%******只需要已知拍速即可完成录入音频的端点检测
%   读取乐谱音符信息
%musicscore = load(musicscorename,'-mat');
musicscore = musicscorename;

%   参数，迭代次数，学习率与代价初始化
Elimit = 0.7;
simlimit = 1;
cost = 0
time = 10;
alpha = 0.0005;
flag = 1;
%   每次迭代的记录变量
cost_record = ones(1,time+1);
Elimit_record = ones(1,time+1);
simlimit_record = ones(1,time+1);
%   开始迭代
    n = simfilter_GUI(y,fs,speed,4,bias,Elimit,simlimit);
    cost = match(n,musicscore,fs,speed);
    cost_record(time+1) = cost;
    Elimit_record(time+1) = Elimit;
    simlimit_record(time+1) = simlimit;
while(time)
    simlimitdelta = alpha * cost * cos(0:2*pi/16:30*pi/16); %16向寻优
    Elimitdelta = alpha * cost * sin(0:2*pi/16:30*pi/16); %16向寻优
    sim_temp = simlimit + simlimitdelta;
    e_temp = Elimit + Elimitdelta;
    if(flag) %判断是否为第一次
    for(i=1:16) %初次迭代，获取16向的最优路径
        n = simfilter_GUI(y,fs,speed,4,bias,e_temp(i),sim_temp(i));
        cost_temp(i) = match(n,musicscore,fs,speed);%获取16向的代价
        %clear n;
    end
    flag=0;
    else
        for(i=index-2:index+2)
            if(i<=0) temp=i+16; else temp=i; end %多次迭代，获取5向的最优路径
            n = simfilter_GUI(y,fs,speed,4,bias,e_temp(rem(temp,16)+1),sim_temp(rem(temp,16)+1));
            cost_temp(i-(index-3)) = match(n,musicscore,fs,speed);%获取5向的代价
            %clear n;
        end
    end
    [cost,index] = min(cost_temp); %获取最小代价与方向
    cost_record(time) = cost;
    simlimit = simlimit + simlimitdelta(index);%参数寻优
    Elimit = Elimit + Elimitdelta(index);%参数寻优
    simlimit_record(time) = simlimit;
    Elimit_record(time) = Elimit;
    %cost_temp=;
    
if(cost==0)  %若代价为0则立即停止迭代
    break; end

time=time-1
end

node = simfilter_GUI(y,fs,speed,4,bias,Elimit,simlimit);

%绘图相关
subplot(1,4,1); plot(cost_record(end:-1:1));
subplot(1,4,2); plot(Elimit_record(end:-1:1));
subplot(1,4,3); plot(simlimit_record(end:-1:1));
subplot(1,4,4); plot(y); hold on;
o = ones(1,length(node)); stem(node,o.*(max(y)*1.1)); 
hold off;

end



