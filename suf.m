function s =suf(x,y,a)
%类梯度寻优

%参数设置
step=100;  %最大步数

%初始化参数, 八方向为相同路径辐射
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

%开始寻优
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





