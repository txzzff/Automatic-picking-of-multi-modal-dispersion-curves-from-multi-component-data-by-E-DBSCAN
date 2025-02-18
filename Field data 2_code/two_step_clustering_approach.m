clear
clc
close all
f = readmatrix('f.txt');
v = readmatrix('v.txt');
RR = readmatrix('RR_68.txt');
ZZ = readmatrix('ZZ_68.txt');
f=f(21:end);
f_min = min(f);
f_max = max(f);
v_min = min(v);
v_max = max(v);
set(0, 'DefaultAxesFontSize', 20);
set(0, 'DefaultTextFontSize', 22);
set(0, 'DefaultAxesFontName', 'Times New Roman');
set(0, 'DefaultTextFontName', 'Times New Roman');
for i=1:1:length(f)
    P(i)=(f(i)+f_min-2*f_max)/(f_min-f_max);
    Q(i)=(f(i)+f_min-1*f_max)/(f_min-f_max);
end
RR=RR(1:end,21:end);
ZZ=ZZ(1:end,21:end);
% RR = (P'.*RR')';
% ZZ = (P'.*ZZ')';
SS=RR+ZZ;
% [Pinsan_R,Pinsan_Rs] = first_cluster(f,v,RR,3,33);
% [Pinsan_Z,Pinsan_Zs] = first_cluster(f,v,ZZ,3,44);
[Pinsan_R,Pinsan_Rs] = first_cluster(f,v,RR,2,10);
[Pinsan_Z,Pinsan_Zs] = first_cluster(f,v,ZZ,2,11);
[Pinsan_e,Pinsan_es] = first_cluster_e(f,v,RR,2,12.3);
% [~,~,IDX] = first_cluster(f,v,RR,2,12.3);
% Pinsan_e{1}=[Pinsan_e{1}(:,1)-10*abs(f(2)-f(1))*ones(length(Pinsan_e{1}(:,1)),1),Pinsan_e{1}(:,2:end)];
% Pinsan_es{1}=[Pinsan_es{1}(:,1)-10*ones(length(Pinsan_es{1}(:,1)),1),Pinsan_es{1}(:,2:end)];
Pinsan_e{1,1}(:,3)=0.15*Pinsan_e{1,1}(:,3);
figure
imagesc([f_min,f_max],[v_min,v_max],RR);
set(gca,'Ydir','normal');
xlabel('Frequency (Hz)');
ylabel('Phase velocity (m/s)');
hh=colorbar;
figure
imagesc([f_min,f_max],[v_min,v_max],ZZ);
set(gca,'Ydir','normal');
xlabel('Frequency (Hz)');
ylabel('Phase velocity (m/s)');
hh=colorbar;

combinedMatrix = vertcat(vertcat(Pinsan_R{:}),vertcat(Pinsan_Z{:}),vertcat(Pinsan_e{:}));
combinedMatrix_s = vertcat(vertcat(Pinsan_Rs{:}),vertcat(Pinsan_Zs{:}),vertcat(Pinsan_es{:}));
result = Over_scatter(combinedMatrix);
result_s = Over_scatter(combinedMatrix_s);
result = result(1:end,:);
result_s = result_s(1:end,:);
figure
scatter(result(:,1),result(:,2),4,result(:,3),"filled")
xlabel('Frequency (Hz)');
ylabel('Phase velocity (m/s)');
h=colorbar
% colormap jet
grid on

IDX=EDBSCAN(result_s(1:end,1:3),4,50);
% IDX=DBSCAN(result_s(1:end,1:2),3,15);
figure
PlotClusterinResultEnhanced3(result(1:end,1:2), IDX, f_min,f_max, v_min,v_max); % 传入参数，绘制图像 

[pinsan,~,e_location] = PICK(IDX,[result(:,1:2),result(:,4)],0.85);

Pinsan = denoise_shice(e_location,pinsan,0.25,abs(f(2)-f(1)));

figure
imagesc([f_min,f_max],[v_min,v_max],RR);
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
xlabel('Frequency (Hz)');
ylabel('Phase velocity (m/s)');

figure
% PlotClusterinResultEnhanced(result(:,1:2), IDX, f_min,f_max, v_min,v_max); % 传入参数，绘制图像
hold on
for i=1:length(Pinsan)
    % Pinsan{i}=pinsan_1{i};
    Pinsan_1{i}=smooth_curve(Pinsan{i},0.5);
    % plot(Pinsan{i}(:,1),Pinsan{i}(:,2)+ymin*ones(length(Pinsan{i}(:,2)),1),'w','MarkerSize',3,'LineWidth',1)
    scatter(Pinsan_1{i}(:,1),Pinsan_1{i}(:,2),12,[0.7,0,0],'filled');
    xlim([f_min,f_max]);
    ylim([v_min,v_max]);
    hold on
    grid on
end
xlabel('Frequency (Hz)');
ylabel('Phase velocity (m/s)');