function y = EDF3(x,N)
%����Ƶ�ֶΣ���������֡��������ֵ

x = x(1:floor(length(x)/N)*N);%ȥ�������
L = length(x);

Y = abs(x).^2;
%Y = abs(x);

y = zeros(1,L/N-1);

for(i = 1:L/N-1);
    %�ж������ֲ���������������ں��֡���򽫾��δ�ƽ��
    if(i~=1)
    if( sum(Y(N*(i-1)+1: N*(i-0.25)) )<0.6*sum(Y(N*(i-1)+1:N*i)) )
        y(i) = sum(Y(N*i+1- 0.25*N : N*(i+1)- 0.25*N)) - sum(Y(N*(i-1)+1- 0.25*N : N*i - 0.25*N));
    else
        y(i) = sum(Y(N*i+1:N*(i+1)))-sum(Y(N*(i-1)+1:N*i));
    end
    end
end


end
