function sim = cossim(a,b)
%计算余弦相似度
%a和b为等长行向量
%余弦相似度公式：（结果为两个向量的cos夹角）
% 分子：a向量和b向量点乘
% 分母：a向量的模乘以b向量的模


numerator = a*b';
denominator = sqrt(a*a')*sqrt(b*b');

sim = numerator/denominator;

end