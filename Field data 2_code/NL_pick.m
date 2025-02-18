function coordinate = NL_pick(Threshold,allMatrices,txtFiles)
    coordinate=cell(length(txtFiles), 1);% 初始化存储坐标矩阵
    for k = 1:length(txtFiles)
        data = allMatrices{k};
        [h,w]=size(data);
        ave=mean(data(:));
        % 区分频散能量与背景噪声
        Threshold_1=1.0;
        % 输出频散能量点坐标与振幅
        coordinate_1=[];
        for i=1:1:h
            for j=1:1:w
                if  data(i,j)>Threshold_1*ave
                    coordinate_1=[coordinate_1;j,i,data(i,j);];
                end
            end
        end
        coordinate_1(all(coordinate_1==0,2),:)=[];    % 删除矩阵中的0元素
        coordinate{k}=coordinate_1;
    end
end