clear
clc
close all

% Load the frequency and velocity data
f = readmatrix('f.txt');
v = readmatrix('v.txt');
f_min = min(f);
f_max = max(f);
v_min = min(v);
v_max = max(v);
f=f(21:end)
% Define the file paths for the RR and ZZ files (modify with actual paths)
RR_folder = '';  % Replace with your actual RR folder path
ZZ_folder = '';  % Replace with your actual ZZ folder path

% Create a directory for saving the results (if it doesn't exist)
output_folder = 'E:\本科毕设\for kxj\output_ecjl_RRback2';  % Specify your desired output folder name
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% Initialize a variable to store the lengths of matrices
matrix_lengths = zeros(204, 1);

% Loop through the RR and ZZ files (assuming they are named RR_1.txt, ZZ_1.txt, ..., RR_204.txt, ZZ_204.txt)
for idx = 1:204
    try
        % Load the current RR and ZZ matrices
        RR1 = readmatrix(fullfile(RR_folder, sprintf('RR_%d.txt', idx)));
        ZZ1 = readmatrix(fullfile(ZZ_folder, sprintf('ZZ_%d.txt', idx)));
        RR1=RR1(1:end,21:end);
        ZZ1=ZZ1(1:end,21:end);
        % Compute P and Q values (based on your formula)
        for i = 1:length(f)
            P(i) = (f(i) + f_min - 2*f_max) / (f_min - f_max);
            Q(i) = (f(i) + f_min - f_max) / (f_min - f_max);
        end

        % Weighted superposition (fusion of RR and ZZ)
        RR = (P'.*RR1')';
        ZZ = (P'.*ZZ1')';
        SS = RR + ZZ;
        [Pinsan_R, Pinsan_Rs] = first_cluster(f, v, RR, 3, 37);
        [Pinsan_Z, Pinsan_Zs] = first_cluster(f, v, ZZ, 3, 55);

        % Combine the results from both RR and ZZ clusters
        combinedMatrix = vertcat(vertcat(Pinsan_R{:}), vertcat(Pinsan_Z{:}));
        combinedMatrix_s = vertcat(vertcat(Pinsan_Rs{:}), vertcat(Pinsan_Zs{:}));
        result = Over_scatter(combinedMatrix);
        result_s = Over_scatter(combinedMatrix_s);

        % Perform DBSCAN clustering
        IDX = DBSCAN(result_s(:,1:2), 3, 15);

        % Save the result plot (without showing it)
        figure('Visible', 'off');
        PlotClusterinResultEnhanced(result(:,1:2), IDX, f_min, f_max, v_min, v_max);
        
        % Pick the clusters and denoise the results
        [pinsan, ~, e_location] = PICK(IDX, [result(:,1:2), result(:,4)], 0.85);
        Pinsan = denoise_shice(e_location, pinsan, 0.2, abs(f(2) - f(1)));
        figure('Visible', 'off');
        imagesc([f_min,f_max],[v_min,v_max],RR1);
        hold on
        for i=1:length(Pinsan)
            % Pinsan{i}=pinsan_1{i};
            Pinsan_1{i}=smooth_curve(Pinsan{i},0.5);
            % plot(Pinsan{i}(:,1),Pinsan{i}(:,2)+ymin*ones(length(Pinsan{i}(:,2)),1),'w','MarkerSize',3,'LineWidth',1)
            scatter(Pinsan_1{i}(:,1),Pinsan_1{i}(:,2),12,'black','filled');
            xlim([f_min,f_max]);
            ylim([v_min,v_max]);
            hold on
        end
        hh=colorbar;
        set(gca,'Ydir','normal');
        xlabel('Frequency (Hz)','FontSize',15);
        ylabel('Phase velocity (m/s)','FontSize',15);
        saveas(gcf, fullfile(output_folder, sprintf('ecjl_RZ_%d.png', idx)));
        close;
        % Initialize coordinates matrix for DBSCAN
        row_counts = cellfun(@(x) size(x, 1), Pinsan);
        matrix_lengths(idx) = sum(row_counts);  % Store the length of the current Pinsan matrix

        % Save the Pinsan result to a .mat file
        save(fullfile(output_folder, sprintf('Pinsan_result_%d.mat', idx)), 'Pinsan_1');

    catch ME
        % Catch any error and skip the current iteration
        fprintf('Error processing file %d: %s\n', idx, ME.message);
        continue;  % Skip to the next iteration
    end
end

% Save the lengths of all matrices to fengdu.txt
writematrix(matrix_lengths, fullfile(output_folder, 'fengdu.txt'), 'Delimiter', 'tab');

disp('Processing complete. Images and matrices saved in the "processed_results" folder.');
