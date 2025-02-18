function Pinsan = denoise_shice(e_location,row,lenn,df)
    POL=0;      % 初始化索引
    for i=1:1:size(e_location,1)
        % varName_1=sprintf('row_%d', i);      % 读取数据
        value=row{i};
        if max(value(:,1))-min(value(:,1))>=lenn&&length(value(:,1))>=(4*(max(value(:,1))-min(value(:,1)))/5*df) % 频率范围
            suo=[];        % 异常值索引变量
            suo_1=[];      % p导波索引变量
            suo_2=[];      % 频率异常值索引变量
            for j=2:1:length(value(:,2))-1      % 对除去两端的所有点进行遍历
                if abs(value(j-1,2)+value(j+1,2)-2*value(j,2))>=80    % 根据斜率差绝对值值剔除异常跳动的噪声值
                    suo(j)=j;     % 输出异常值索引
                end
            end
            suo(suo==0)=[];
            value(suo,:)=[];      % 对异常值清零
            if ~isempty(value)
                POL=POL+1;      % 索引+1
                row2{POL}=value(:,1:2);
                % varName_n=sprintf('row2_%d', POL);      % 创建变量名
                % eval([varName_n '=value(:,1:2)']);      % 创建并赋值坐标
            end
        end
    end
    POM=0;
    for i=1:1:POL
        % varName_z_n=sprintf('row2_%d', i);
        % value=eval(varName_z_n);
        value=row2{i};
        if max(value(:,1))-min(value(:,1))>=lenn&&length(value(:,1))>=(3*(max(value(:,1))-min(value(:,1)))/4*df)
            POM=POM+1;
            Pinsan{POM}=value(:,1:2);
        end
    end
end