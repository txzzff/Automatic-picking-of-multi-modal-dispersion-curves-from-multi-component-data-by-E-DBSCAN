function result = Over_scatter(data)
    % 从矩阵中提取 x, y, z 列
    x = data(:, 1);
    y = data(:, 2);
    z = data(:, 3);
    
    % 组合 x 和 y 为一个二维数组 [x, y]
    xy = [x, y];
    
    % 找到唯一的 (x, y) 组合及其对应的索引
    [unique_xy, ~, idx] = unique(xy, 'rows');
    
    % 使用 accumarray 将相同 (x, y) 对应的 z 值进行累加
    z_sum = accumarray(idx, z);
    
    % 使用 accumarray 计算每个 (x, y) 对应的 z 值的平均值
    z_mean = accumarray(idx, z, [], @mean);
    
    % 使用 accumarray 统计每个 (x, y) 组合出现的次数
    count = accumarray(idx, 1);
    
    % 输出结果，包括唯一的 x 和 y 组合，z 的累加和，以及每个组合出现的次数
    result = [unique_xy, z_sum, z_mean, count];
end