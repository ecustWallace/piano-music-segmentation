function cost = match(node,musicscore,fs,speed)
%评估端点与乐谱的匹配程度
%speed为每分钟的拍数

%将曲谱转化为点位置期望
note_expect = ones(1,length(musicscore));
note_range = ones(round(fs/(speed/60)/8),length(musicscore));
note_expect(1) = node(1);
note_range(:,1) = node(1)-round(fs/(speed/60)/16)+1:(node(1)+round(fs/(speed/60)/8)-round(fs/(speed/60)/16));
for(i=2:length(musicscore))
    note_expect(i) = note_expect(1)+sum(musicscore(2:i))*fs*speed/60;
    note_range(:,i) = note_expect(i)-round(fs/(speed/60)/16)+1:(note_expect(i)+round(fs/(speed/60)/8)-round(fs/(speed/60)/16));
end

%判断冗余点数和缺失点数

for(i=2:length(node))
    for(j=1:length(musicscore))
        if(any(node(i)==note_range(:,j)))
            note_range(:,j)=0; note_expect(j)=0; %已匹配的期望点置零
            node(i)=0; %已匹配的实际点置零
        end
    end
end

node(1)=0; note_expect(1)=0; %将已匹配的第一个点置零

remnant = length(find(node));
lack = length(find(note_expect));

cost = sqrt(remnant^2 + lack^2);

end

