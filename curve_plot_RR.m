clear
clc
close all
set(0, 'DefaultAxesFontSize', 20);
set(0, 'DefaultTextFontSize', 22);
set(0, 'DefaultAxesFontName', 'Times New Roman');
set(0, 'DefaultTextFontName', 'Times New Roman');
% 指定存储.mat文件的文件夹路径
input_folder ='';

% 获取文件夹中的所有.mat文件
mat_files = dir(fullfile(input_folder, '*.mat'));
fengdu=zeros(length(mat_files),1)
figure
% 遍历每个.mat文件
for i = 1:3:length(mat_files)
    mat_file_path = fullfile(input_folder, mat_files(i).name);
    % 读取.mat文件内容
    mat_data = load(mat_file_path);
    cell_array=mat_data.Pinsan_1;
    % for j=1:length(cell_array)
    for j=1:2
        % plot(cell_array{1,j}(:,1),cell_array{1,j}(:,2),'b');
        plot(cell_array{1,j}(:,1), cell_array{1,j}(:,2), 'LineWidth', 3, 'Color', 'k');
        hold on
        plot(cell_array{1,j}(:,1), cell_array{1,j}(:,2), 'LineWidth', 2, 'Color', [214/255, 39/255, 40/255]);
        hold on
        % plot(cell_array{1,j}(:,1),cell_array{1,j}(:,2),'LineWidth',2);
        % scatter(cell_array{1,j}(:,1),cell_array{1,j}(:,2), 12, 'filled', 'MarkerFaceColor', [214/255, 39/255, 40/255] ,'MarkerEdgeColor', 'k')
        % hold on
        fengdu(i)=fengdu(i)+length(cell_array{1,j}(:,1));
    end
    hold on
    xlim([0.25,0.8])
    ylim([1500,4500])
    xlabel('Frequency (Hz)');
    ylabel('Phase velocity (m/s)');
    grid on
    
end