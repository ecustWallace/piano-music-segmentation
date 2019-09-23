function node = optsimfilter( y,fs,speed,bias,musicscorename )
%----��������Ӧ�㷨---- 
%******ֻ��Ҫ��֪���ټ������¼����Ƶ�Ķ˵���
%   ��ȡ����������Ϣ
%musicscore = load(musicscorename,'-mat');
musicscore = musicscorename;

%   ����������������ѧϰ������۳�ʼ��
Elimit = 0.7;
simlimit = 1;
cost = 0
time = 10;
alpha = 0.0005;
flag = 1;
%   ÿ�ε����ļ�¼����
cost_record = ones(1,time+1);
Elimit_record = ones(1,time+1);
simlimit_record = ones(1,time+1);
%   ��ʼ����
    n = simfilter_GUI(y,fs,speed,4,bias,Elimit,simlimit);
    cost = match(n,musicscore,fs,speed);
    cost_record(time+1) = cost;
    Elimit_record(time+1) = Elimit;
    simlimit_record(time+1) = simlimit;
while(time)
    simlimitdelta = alpha * cost * cos(0:2*pi/16:30*pi/16); %16��Ѱ��
    Elimitdelta = alpha * cost * sin(0:2*pi/16:30*pi/16); %16��Ѱ��
    sim_temp = simlimit + simlimitdelta;
    e_temp = Elimit + Elimitdelta;
    if(flag) %�ж��Ƿ�Ϊ��һ��
    for(i=1:16) %���ε�������ȡ16�������·��
        n = simfilter_GUI(y,fs,speed,4,bias,e_temp(i),sim_temp(i));
        cost_temp(i) = match(n,musicscore,fs,speed);%��ȡ16��Ĵ���
        %clear n;
    end
    flag=0;
    else
        for(i=index-2:index+2)
            if(i<=0) temp=i+16; else temp=i; end %��ε�������ȡ5�������·��
            n = simfilter_GUI(y,fs,speed,4,bias,e_temp(rem(temp,16)+1),sim_temp(rem(temp,16)+1));
            cost_temp(i-(index-3)) = match(n,musicscore,fs,speed);%��ȡ5��Ĵ���
            %clear n;
        end
    end
    [cost,index] = min(cost_temp); %��ȡ��С�����뷽��
    cost_record(time) = cost;
    simlimit = simlimit + simlimitdelta(index);%����Ѱ��
    Elimit = Elimit + Elimitdelta(index);%����Ѱ��
    simlimit_record(time) = simlimit;
    Elimit_record(time) = Elimit;
    %cost_temp=;
    
if(cost==0)  %������Ϊ0������ֹͣ����
    break; end

time=time-1
end

node = simfilter_GUI(y,fs,speed,4,bias,Elimit,simlimit);

%��ͼ���
subplot(1,4,1); plot(cost_record(end:-1:1));
subplot(1,4,2); plot(Elimit_record(end:-1:1));
subplot(1,4,3); plot(simlimit_record(end:-1:1));
subplot(1,4,4); plot(y); hold on;
o = ones(1,length(node)); stem(node,o.*(max(y)*1.1)); 
hold off;

end



