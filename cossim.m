function sim = cossim(a,b)
%�����������ƶ�
%a��bΪ�ȳ�������
%�������ƶȹ�ʽ�������Ϊ����������cos�нǣ�
% ���ӣ�a������b�������
% ��ĸ��a������ģ����b������ģ


numerator = a*b';
denominator = sqrt(a*a')*sqrt(b*b');

sim = numerator/denominator;

end