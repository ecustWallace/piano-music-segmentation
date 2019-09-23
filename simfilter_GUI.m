function n = simfilter_GUI(y,fs,speed,precision,bias,Elimit,simlimit,N)
%��ͻ�䡱�����㷨
% 1����ͨ�������õ������ļ��㡣
% 2���ٶ�1000��������Ϊ1֡��ȡÿ�������ļ���ġ���1֡��ǰn-1֡��������n֡����
%   ���������ϡ������������ٶ�ĳ��������250Hz���Ǿͽ�245-255Hz�����е�������
%    ����Ϊ�����ڵ����������Ե�����Ƶ����󣬽���Ǹ�һά����������˸������ڵ�������
% 3������n֡���������������������ƶȣ��õ�n-1�����ƶ����ݡ�
% 4�����������ƶ�����ֵ��ֻҪn-1�������д���ĳ�����ڸ���ֵ�ģ���Ϊ�õ���ȷ��
% speed = 115; %���ֽ��Ĵ�С
% 
% precision = 1; %���㾫��
%                %����Խ�ߣ��������Խ��
%                %һ��ȡ�������׵���С���ģ��磺��С��Ϊ�ķ�֮һ�ģ����ֵΪ4��
%                
% bias = 15; %����ƫ����
%            %���ֽ��Ĳ����ϸ�ȷ�����ʹ����������С�������С�ڡ�����������С�����
%            %ƫ����Խ�󣬼����ֵԽ��
%            
% Elimit = 0.7*precision; %������������

y = y(1:floor(length(y)/1000)*1000);%��Ƶ������ȥ��ĩβ����

%---------------------------------------
%���������������

Y=EDF3(y,N);%���ظ�֡������ֵ
     
%[~,n_pro]=findpeaks(Y,'minpeakheight',Elimit,...,
%    'minpeakdistance',fs*60/N/(speed+bias)/precision); %Ѱ�Ҽ�ֵλ�ã����ص�n_pro�����С�
                                             %��λ�ñ������ǡ��Ρ���λ�ã����ǡ��㡱��λ�á�
[~,n_pro]=findpeaks(Y,'minpeakheight',Elimit,...,
    'minpeakdistance',fs*60/N/(speed+bias)/precision); %Ѱ�Ҽ�ֵλ�ã����ص�n_pro�����С�
                                             %��λ�ñ������ǡ��Ρ���λ�ã����ǡ��㡱��λ�á�                                             

%-----------------------------------------------
n_loc = n_pro.*N; %���ص����㡱��λ��

a=1; %���˺�����������±�

%-----------------------------------------------
% �ɰ汾��ͨ��ǰamount-1֡����ǰ֡�ж����ƶ�
%   for i=1:length(n_pro);
% 
%     %����ÿһ����ĺ�һ֡��������ǰn-1֡�ĸ�������������ÿһ֡֡��ΪFr
%     num_ideal = fs*60/(speed+bias)/precision;
%     Fr=1000;%֡��
%     rep=0;
%     %amount=8;   %֡�� 
%     amount=round(num_ideal/Fr);
%     %֡��Խ����Ƶ����ϢԽ��ȷ�����������ʱ��������⡣
%     y_sim = zeros(1,amount-1); %�����������֡�������������ƶ�
%     
%     
%     
%     for b=1:amount;
%         y_energy(b,:)=energy_note(y(n_loc(i)+(b-amount)*(Fr-rep):n_loc(i)+...
%             (b-amount)*(Fr-rep)+Fr),fs);
%     end
%----------------------------------------
%     %��������֡�����ƶ�
%     extra=0;
%     %y_energy = log10(y_energy);
%     %mean(abs(y).^2);
%     for c=1:amount-1;
%         y_sim(c) = cossim(y_energy(c,:)+extra,y_energy(c+1,:)+extra);
%     end
% %----------------------------------------
%   %���ƶȹ���
%    % simlimit = 0.96;%���ƶ����ޣ���ֵԽ�ͣ�����Խ��
%     if min(y_sim)<simlimit;
%     n(a)=n_pro(i);
%     a=a+1;
%     end
%   end
%-----------------------------------------------

%�°汾��ֻ����ǰ֡���֡��ͻ��̶ȣ���ͨ����ʱ�����������д�������
    %Fr=1000;%֡��
    for i=1:length(n_loc) %�������м���
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