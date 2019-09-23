function [ y ] = EDF( x,N)
%Energy Detection Function对音频信号进行预处理（局部能量法），化成检测函数
%z注意N不能设置比n1长度小，否则报错
%  x为音频函数(注意为列向量)，n1为其自变量

L=length(x);         

Y=abs(x).^2;

y=zeros(1,L);          %；列向量

for n=N/2+1:L-N/2+1   %舍去音频前半窗数据和后半窗数据
    y(n)=1/N*SUM(Y,n-N/2,n+N/2-1);
end
        


end

