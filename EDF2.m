function y = EDF2( x,N)
%将音频分段，计算各段能量

x = x(1:floor(length(x)/N)*N);%去除冗余点
L = length(x);

Y = abs(x).^2;

y = zeros(1,L/N);

for(i = 1:L/N);
    y(i) = sum(Y(N*(i-1)+1:N*i));
end

end
