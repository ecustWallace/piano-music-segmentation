function [ y ] = EDF( x,N)
%Energy Detection Function����Ƶ�źŽ���Ԥ�����ֲ��������������ɼ�⺯��
%zע��N�������ñ�n1����С�����򱨴�
%  xΪ��Ƶ����(ע��Ϊ������)��n1Ϊ���Ա���

L=length(x);         

Y=abs(x).^2;

y=zeros(1,L);          %��������

for n=N/2+1:L-N/2+1   %��ȥ��Ƶǰ�봰���ݺͺ�봰����
    y(n)=1/N*SUM(Y,n-N/2,n+N/2-1);
end
        


end

