function [ bestchrom ] = GA(  )
%�Ŵ��㷨
% ��Ӧ�Ⱥ���suf(x,y)û��ȷ��(����д���������������������һ����������)
% ��Ⱥ���������ķ�Χδȷ��

%��������30������Ⱥ��С100���������0.6���������0.01
maxgen=30; sizepop=100; pcross=0.6; pmutation=0.01;
%ÿ�������ַ����ĳ���Ϊ1����Χ��0~0.9pi
lenchrom = [1 1];
bound=[0 pi;0 pi];  

%�����ʼ�� 
Individuals = struct('fitness',zeros(1,sizepop), 'chrom',[]);  %������Ⱥ�ṹ

%��Ⱥƽ����Ӧ�ȡ���Ⱥ�������Ӧ�ȡ���Ӧ����õ�Ⱦɫ��
avgfitness=[];   bestfitness=[];  bestchrom=[]; 

%��ʼ����Ⱥ
for i=1:sizepop   %�������Ⱦɫ��
    individuals.chrom(i,:)= Code(lenchrom,bound);   
    x=individuals.chrom(i,:);
    individuals.fitness(i) = suf(x);%����Ⱦɫ����Ӧ��
end
                                                                                                                                                                                                                                                                                                                                                 
%����Ӧ�����ŵ�Ⱦɫ��
[bestfitness bestindex]=min(individuals.fitness);
%��ȡ��õ�Ⱦɫ��
bestchrom=individuals.chrom(bestindex,:);  
%��¼ÿһ������������������Ӧ�Ⱥ�ƽ����Ӧ��ֵ
trace=[]; 

for i=1:maxgen   
     individuals=Select(individuals,sizepop); 
     individuals.chrom = Cross(pcross,lenchrom,individuals.chrom,sizepop,bound);
     individuals.chrom=Mutation(pmutation,lenchrom,individuals.chrom,sizepop,[i maxgen],bound);
    
    for j=1:sizepop %������Ӧ��
        x=individuals.chrom(j,:);
        individuals.fitness(j)=suf(x);
    end
    %Ѱ������Ⱦɫ���������Ⱦɫ�弰����Ⱥ�е�λ��   
    [newbestfitness,newbestindex]=min(individuals.fitness);
    [~,wrostindex]=max(individuals.fitness);    %-------Ӣ��Ӧ��Ϊwrost...д��worest
    
    if bestfitness>newbestfitness
        bestfitness=newbestfitness;
        bestchrom=individuals.chrom(newbestindex,:);
    end

    individuals.chrom(wrostindex,:)=bestchrom;
    individuals.fitness(wrostindex)=bestfitness;
    
    %���Ⱦɫ���ƽ����Ӧ��
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
%�����������������Ⱦɫ�壬���������ʼ��һ����Ⱥ
% lenchrom   input : Ⱦɫ�峤��
% bound      input : ����ȡֵ��Χ
% ret        output: Ⱦɫ�����ֵ
flag=0;
while flag==0
    pick=rand(1,length(lenchrom)); %����lenchrom�������
    %��pick:(0~1) ת���ɹ涨�ı�����Χ��ret:(0~0.9pi)
    ret=bound(:,1)'+(bound(:,2)-bound(:,1))'.*pick; 
    %����Ⱦɫ��Ŀ�����
    flag=test(bound,ret); 
end
end

function flag = test(bound,code) 
%ppt��ԭ�������Ϊ��lenchrom,bound,code��,�����Ϊ���� 
%��⺯��
flag=1;
[n,m]=size(code);

for i=1:n  %�����������������Ⱦɫ���ֵ��Χ�Ƿ���ȷ
    if code(i)<bound(i,1) || code(i)>bound(i,2)
        flag=0;
    end
end
end

function ret=Cross(pcross,lenchrom,chrom,sizepop,bound)
for i=1:sizepop 
    
    %���ѡ������Ⱦɫ����н���
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
 %��Ⱥÿ��Ⱦɫ����п��ܱ������
 %�ɱ�����ʾ����Ƿ����
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
