function s =suf(x,y,a)
%���ݶ�Ѱ��

%��������
step=100;  %�����

%��ʼ������, �˷���Ϊ��ͬ·������
dir=[a,0;
    0.7071*a,0.7071*a;
    0,a;
    -0.7071*a,0.7071*a;
    -a,0;
    -0.7071*a,-0.7071*a;
    0,-a
    0.7071*a,-0.7071*a];
b=[ x,y;
    x,y;
    x,y;
    x,y;
    x,y;
    x,y;
    x,y;
    x,y;];

%��ʼѰ��
bestfitness =su(x,y);
b=b+dir;
for i=1:step
    for j=1:8
        c(j)=su(b(j,1),b(j,2));
    end
    [fitness,index]=min(c);
    if(fitness<bestfitness)
        bestfitness= fitness;
        x=x+dir(index,1);
        y=y+dir(index,2);
        b=[ x,y;
         x,y;
         x,y;
         x,y;
         x,y;
         x,y;
         x,y;
         x,y;];
    else
        s=[x,y];
        return 
    end
end
end





