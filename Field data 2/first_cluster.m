function [Pinsan,Pinsan_1,row,row_1] = first_cluster(f,v,SS,epsilon,MinEnergy)
[h,w]=size(SS);
coordinate=[];   % 初始化存储坐标矩阵
coordinatee=[];  % 初始化存储坐标矩阵
for i=1:1:h
    for j=1:1:w
        if  SS(i,j)>0
            coordinate=[coordinate;j,i,SS(i,j);];
            coordinatee=[coordinatee;f(j),v(i),SS(i,j);];
        end
    end
end
coordinate_1=coordinatee(:,1:2);      % 取坐标列作为DBSCAN的输入数据

IDX=EDBSCAN(coordinate,epsilon,MinEnergy);         % 传入参数运行函数EDBSCAN

[row,Pinsan,e_location] = PICK(IDX,coordinatee,0.7);%实际坐标 row为坐标 pinsan为能量团
[row_1,Pinsan_1,e_location] = PICK(IDX,coordinate,0.7); %索引坐标
end