function y = EDF2( x,N)
%����Ƶ�ֶΣ������������

x = x(1:floor(length(x)/N)*N);%ȥ�������
L = length(x);

Y = abs(x).^2;

y = zeros(1,L/N);

for(i = 1:L/N);
    y(i) = sum(Y(N*(i-1)+1:N*i));
end

end
