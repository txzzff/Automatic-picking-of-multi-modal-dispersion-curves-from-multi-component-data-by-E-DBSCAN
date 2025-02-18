function smoothed_data = smooth_curve(data,pinghua)
    x = data(:,1); % 提取x坐标
    y = data(:,2); % 提取y坐标
    % 使用smooth函数对y进行平滑处理
    smoothed_y = smooth(y, pinghua, 'sgolay'); %平滑参数可以由输入调整
    % 组合平滑后的数据
    smoothed_data = [x, smoothed_y];
end
