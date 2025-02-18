function PlotClusterinResultEnhanced3(X, IDX, f_min, f_max, v_min, ymax)
    k = max(IDX);
    Colors = lines(k); % Use MATLAB's high-contrast colors
    Legends = {};
    for i = 1:k  % Start from 1 to exclude noise (i = 0)
        Xi = X(IDX == i, :);
        if ~isempty(Xi)
            Style = 's'; % Shape set to square
            MarkerSize = 4; % Marker size
            Color = Colors(i, :); % Assign color from colormap
            Legends{end + 1} = ['Cluster #' num2str(i)];
            plot(Xi(:, 1), Xi(:, 2), Style, 'MarkerSize', MarkerSize, 'MarkerFaceColor', Color, 'Color', Color); % Filled color
            hold on;
        end
    end
    hold off;
    grid on;
    xlim([f_min, f_max]);
    ylim([v_min, ymax]);
    xlabel('Frequency (Hz)'); % Add axis labels
    ylabel('Phase velocity (m/s)');
end
