function [Pinsan,Pinsan_1,IDX] = first_cluster_e(f,v,SS,epsilon,MinEnergy)
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

[~,Pinsan,e_location] = PICK(IDX==5,coordinatee,0.001);
[~,Pinsan_1,e_location] = PICK(IDX==5,coordinate,0.001);
end