function [ bestchrom ] = GA(  )
%遗传算法
% 适应度函数suf(x,y)没有确定(可以写进参数，或者在下面加入一个函数处理)
% 种群两个参数的范围未确定

%进化代数30代、种群大小100、交叉概率0.6、变异概率0.01
maxgen=30; sizepop=100; pcross=0.6; pmutation=0.01;
%每个变量字符串的长度为1，范围在0~0.9pi
lenchrom = [1 1];
bound=[0 pi;0 pi];  

%个体初始化 
Individuals = struct('fitness',zeros(1,sizepop), 'chrom',[]);  %定义种群结构

%种群平均适应度、种群的最佳适应度、适应度最好的染色体
avgfitness=[];   bestfitness=[];  bestchrom=[]; 

%初始化种群
for i=1:sizepop   %随机产生染色体
    individuals.chrom(i,:)= Code(lenchrom,bound);   
    x=individuals.chrom(i,:);
    individuals.fitness(i) = suf(x);%计算染色体适应度
end
                                                                                                                                                                                                                                                                                                                                                 
%找适应度最优的染色体
[bestfitness bestindex]=min(individuals.fitness);
%提取最好的染色体
bestchrom=individuals.chrom(bestindex,:);  
%记录每一代进化过程中最优适应度和平均适应度值
trace=[]; 

for i=1:maxgen   
     individuals=Select(individuals,sizepop); 
     individuals.chrom = Cross(pcross,lenchrom,individuals.chrom,sizepop,bound);
     individuals.chrom=Mutation(pmutation,lenchrom,individuals.chrom,sizepop,[i maxgen],bound);
    
    for j=1:sizepop %计算适应度
        x=individuals.chrom(j,:);
        individuals.fitness(j)=suf(x);
    end
    %寻找最优染色体和最劣质染色体及其在群中的位置   
    [newbestfitness,newbestindex]=min(individuals.fitness);
    [~,wrostindex]=max(individuals.fitness);    %-------英文应该为wrost...写成worest
    
    if bestfitness>newbestfitness
        bestfitness=newbestfitness;
        bestchrom=individuals.chrom(newbestindex,:);
    end

    individuals.chrom(wrostindex,:)=bestchrom;
    individuals.fitness(wrostindex)=bestfitness;
    
    %求解染色体的平均适应度
    avgfitness=sum(individuals.fitness)/sizepop;
    trace=[trace;avgfitness bestfitness]; 
end
return 

function ret=Select(individuals,sizepop)
individuals.fitness= 1./(individuals.fitness);
sumfitness=sum(individuals.fitness);
sumf=individuals.fitness./sumfitness;
index=[];
for i=1:sizepop  
    pick=rand;
    while pick==0
        pick=rand;
    end
    for j=1:sizepop
        pick=pick-sumf(j);
        if pick<0
            index=[index j];
            break; 
        end
    end
end
individuals.chrom=individuals.chrom(index,:);
individuals.fitness=individuals.fitness(index);
ret=individuals;
end
     
function ret = Code(lenchrom,bound)
%本函数将变量编码成染色体，用于随机初始化一个种群
% lenchrom   input : 染色体长度
% bound      input : 变量取值范围
% ret        output: 染色体编码值
flag=0;
while flag==0
    pick=rand(1,length(lenchrom)); %产生lenchrom个随机数
    %将pick:(0~1) 转换成规定的变量范围的ret:(0~0.9pi)
    ret=bound(:,1)'+(bound(:,2)-bound(:,1))'.*pick; 
    %检验染色体的可行性
    flag=test(bound,ret); 
end
end

function flag = test(bound,code) 
%ppt上原程序参数为（lenchrom,bound,code）,这里改为两个 
%检测函数
flag=1;
[n,m]=size(code);

for i=1:n  %检验所有随机产生的染色体的值域范围是否正确
    if code(i)<bound(i,1) || code(i)>bound(i,2)
        flag=0;
    end
end
end

function ret=Cross(pcross,lenchrom,chrom,sizepop,bound)
for i=1:sizepop 
    
    %随机选择两个染色体进行交叉
    pick=rand(1,2);
    while prod(pick)==0
        pick=rand(1,2);
    end
    index=ceil(pick.*sizepop); 

    pick=rand;
    while pick==0
        pick=rand;
    end
    if pick>pcross
        continue;
    end
end
flag=0;
    while flag==0
        pick=rand;
        while pick==0
            pick=rand;
        end
        pos=ceil(pick.*sum(lenchrom)); 
        pick=rand; 
        v1=chrom(index(1),pos);
        v2=chrom(index(2),pos);
        chrom(index(1),pos)=pick*v2+(1-pick)*v1;
        chrom(index(2),pos)=pick*v1+(1-pick)*v2; 
        flag1=test(bound,chrom(index(1),:));  
        flag2=test(bound,chrom(index(2),:));  
        if   flag1*flag2==0
            flag=0;
        else flag=1;
        end
    end
ret=chrom;
return
end

function ret = Mutation(pmutation,lenchrom,chrom,sizepop,pop,bound)
for i=1:sizepop  
 %种群每个染色体进行可能变异操作
 %由变异概率决定是否变异
    pick=rand;
    if pick>pmutation
        continue;
    end
    
flag=0;
    while flag==0
        pick=rand;
        while pick==0
            pick=rand;
        end
        pos=ceil(pick*sum(lenchrom)); 
        v=chrom(i,pos);
        minv=bound(pos,1);
        maxv=bound(pos,2);
        pick1=rand; pick2=rand;
        if pick1>=0.5
          delta=(maxv-v)*(pick2*((1-pop(1)/pop(2))^2));
        else
          delta=(minv-v)*(pick2*((1-pop(1)/pop(2))^2));
        end
        chrom(i,pos)=v+delta; 
        flag=test(bound,chrom(i,:));     
    end
end
 ret=chrom;
end

    function y=suf(chrom)
        y=sin(chrom(1))+sin(chrom(2));
    end
end
