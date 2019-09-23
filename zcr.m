function a_zcr = zcr(a)
%¼ÆËãÒôÆµÖ¡¹ıÁãÂÊ
n=length(a);
a_zcr=0;
for i=1:n-1;
    a_zcr = a_zcr + 1/(2*n)*abs(sign(a(i+1))-sign(a(i)));
end

end