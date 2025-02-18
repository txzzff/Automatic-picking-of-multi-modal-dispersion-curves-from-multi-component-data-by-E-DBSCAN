function [IDX, isnoise] = EDBSCAN(X, epsilon, MinEnergy)    
    % DBSCAN 聚类函数，基于邻域内点的能量值和判断核心点

    C = 0;  % 统计簇类个数，初始化为0
    n = size(X, 1);  % 数据点数量
    IDX = zeros(n, 1);  % 存储每个点的簇号
    visited = false(n, 1);  % 标记是否访问
    isnoise = false(n, 1);  % 标记是否为噪声点
    
    for i = 1:n  % 遍历每个点
        if ~visited(i)
            visited(i) = true;  % 标记为已访问
            Neighbors = RegionQuery(i);  % 找到邻域内的点
            
            % 计算邻域中点的能量总和
            energy_sum = sum(X(Neighbors, 3));
            if energy_sum < MinEnergy  % 如果能量总和小于 MinEnergy
                isnoise(i) = true;  % 该点标记为噪声点
            else  % 如果能量总和大于 MinEnergy
                C = C + 1;  % 簇类计数+1
                ExpandCluster(i, Neighbors, C);  % 扩展簇
            end
        end
    end

    function ExpandCluster(i, Neighbors, C)
        IDX(i) = C;  % 为当前点分配簇号
        
        k = 1;
        while true
            j = Neighbors(k);  % 选择邻域中的一个点
            if ~visited(j)  % 如果该点未被访问
                visited(j) = true;
                Neighbors2 = RegionQuery(j);  % 查询该点的邻域
                energy_sum = sum(X(Neighbors2, 3));  % 计算邻域能量和
                if energy_sum >= MinEnergy  % 如果邻域能量和满足条件
                    Neighbors = [Neighbors; Neighbors2];  % 扩展邻域
                end
            end
            if IDX(j) == 0  % 如果该点未分配簇
                IDX(j) = C;  % 将点分配到当前簇
            end
            
            k = k + 1;
            if k > numel(Neighbors)  % 若已遍历完所有邻域点
                break;
            end
        end
    end

    function Neighbors = RegionQuery(i)
        % 按需计算距离并找到邻域内的点
        dists = sqrt(sum((X(:, 1:2) - X(i, 1:2)).^2, 2));  % 计算每个点到第 i 点的距离
        Neighbors = find(dists <= epsilon);  % 返回距离小于等于 epsilon 的点的索引
    end
end
