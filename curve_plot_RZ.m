clear
clc
close all
set(0, 'DefaultAxesFontSize', 20);
set(0, 'DefaultTextFontSize', 22);
set(0, 'DefaultAxesFontName', 'Times New Roman');
set(0, 'DefaultTextFontName', 'Times New Roman');
% 指定存储.mat文件的文件夹路径
input_folder = '';

% 获取文件夹中的所有.mat文件
mat_files = dir(fullfile(input_folder, '*.mat'));

% 创建图形窗口
figure
hold on

% 设置好看的基础颜色，例如柔和的蓝色
base_color = [0.2, 0.6, 1]; % 柔和的蓝色

% 遍历每个.mat文件
for i = 1:2:length(mat_files)
    mat_file_path = fullfile(input_folder, mat_files(i).name);
    
    % 读取.mat文件内容
    mat_data = load(mat_file_path);
    cell_array = mat_data.Pinsan;
    
    for j = 1:length(cell_array)
        % 提取线条数据
        x = cell_array{1, j}(:, 1);
        y = cell_array{1, j}(:, 2);
        
        % 绘制线条并设置颜色和透明度
        plot(x, y, 'Color', [base_color, 0.4], 'LineWidth', 1.5); % 设置透明度为0.4，线条宽度为1.5
    end
end

hold off

fengdu=zeros(length(mat_files),1)

figure
% 遍历每个.mat文件
for i = 1:3:length(mat_files)
    mat_file_path = fullfile(input_folder, mat_files(i).name);
    % 读取.mat文件内容
    mat_data = load(mat_file_path);
    cell_array=mat_data.Pinsan;
    % for j=1:length(cell_array)
    for j=1
        % % plot(cell_array{1,j}(:,1),cell_array{1,j}(:,2),'b');
        cell_array{1,j}=smooth_curve(cell_array{1,j},0.5);
        plot(cell_array{1,j}(:,1), cell_array{1,j}(:,2), 'LineWidth', 3, 'Color', 'k');
        hold on
        plot(cell_array{1,j}(:,1), cell_array{1,j}(:,2), 'LineWidth', 2, 'Color', [255/255, 127/255, 14/255]);
        hold on
        % plot(cell_array{1,j}(:,1),cell_array{1,j}(:,2),'LineWidth',2);
        % % scatter(cell_array{1,j}(:,1),cell_array{1,j}(:,2), 12, 'filled', 'MarkerFaceColor', [255/255, 127/255, 14/255] ,'MarkerEdgeColor', 'k')
        % hold on
    end
    hold on
    xlim([0.25,0.8])
    ylim([1500,4500])
    xlabel('Frequency (Hz)');
    ylabel('Phase velocity (m/s)');
    grid on
    fengdu(i)=length(cell_array{1,j}(:,1));
end
