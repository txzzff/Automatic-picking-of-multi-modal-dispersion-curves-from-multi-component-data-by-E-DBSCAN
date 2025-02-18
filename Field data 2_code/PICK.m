function  [row,rowz,e_location] = PICK(IDX,coordinate,threshold_temp)
% 将DBSCAN聚类结果的每一类分开，将坐标数值索引存放在元胞数组IDX_1中
for i=1:1:length(IDX)      % 循环中产生多余0元素
    for j=1:1:max(IDX)
        if IDX(i)==j
            IDX_1{j}(i)=i;
        end
    end
end
for i=1:1:max(IDX)
    IDX_1{1,i}(IDX_1{1,i}==0)=[];  % 删除元胞数组中所有的0元素
end
% 对DBSCAN遗漏的噪声进一步去除
DBSCAN_length=zeros(1,max(IDX));      % 比较每一类的频散能量点个数
for i=1:1:max(IDX)
    DBSCAN_length(i)=length(IDX_1{1,i});
end
DBSCAN_lct=zeros(1,max(IDX));
% 去噪阈值参数
Threshold_2=0.05;% （[0.01,0.05]，对DBSCAN遗漏的噪声进行去除）
for i=1:1:length(DBSCAN_length)      % 设置频散能量投影点个数阈值消除噪声
    if DBSCAN_length(i)>=Threshold_2*mean(DBSCAN_length(:))
        DBSCAN_lct(i)=(i);
    end
    DBSCAN_lct(DBSCAN_lct==0)=[];
end
% 补零并合并频散能量点坐标序号
for i=1:1:max(IDX)
    IDX_1{1,i}=[IDX_1{1,i},zeros(1,max(DBSCAN_length)-length(IDX_1{1,i}))];
end
e_location=[];      % 初始化矩阵
for i=1:1:length(DBSCAN_lct)
    e_location=[e_location;IDX_1{1,DBSCAN_lct(i)}];    % 得到有效坐标索引矩阵
end
for i=1:1:size(e_location,1)
    e=e_location(i,:);
    e=e(e~=0);
    x1=coordinate(e,1);y1=coordinate(e,2);z1=coordinate(e,3);
    data_shunxu=sortrows([x1,y1,z1],1);      % 将数据按x坐标的大小顺序排列
    x=data_shunxu(:,1);y=data_shunxu(:,2);z=data_shunxu(:,3);
    unique_x=unique(x);       % 取x所有的唯一值
    logic_effectz=[];
    for j=1:length(unique_x)
        logic=x==unique_x(j);
        temp_x=x(logic);temp_y=y(logic);temp_z=z(logic);
        % threshold_temp=0.8;    %设置最大振幅值的阈值
        logic_1=temp_z>=threshold_temp*max(temp_z);
        logic_effectz=[logic_effectz;logic_1];
    end
    logic_effectz=logical(logic_effectz);
    % 取峰值
    % for j=1:length(unique_x)
    %     idx=(x==unique_x(j));      % 获取当前x值的索引
    %     [max_z(j),idz(j)]=max(z(idx));      % 获取当前x值对应的最大z值
    %     if j>=2&&j<=length(unique_x)
    %         idz(j)=length(x(x<=unique_x(j-1)))+idz(j);    % 获取z值在原坐标矩阵中的索引
    %     end
    % end
    rowz{i}=data_shunxu(logic_effectz,:);
    % varName=sprintf('rowz_%d', i);      % 创建变量名
    % eval([varName '=data_shunxu(logic_effectz,:)']);      % 创建并赋值坐标
%     % 得到最终的坐标索引矩阵
end
row=cell(size(e_location,1), 1);
for i=1:1:size(e_location,1)
    % varName_11=sprintf('rowz_%d', i);
    % value=eval(varName_11);
    value=rowz{i};
    data_shunxu=sortrows([value(:,1),value(:,2),value(:,3)],1);      % 将数据按x坐标的大小顺序排列
    x=data_shunxu(:,1);y=data_shunxu(:,2);z=data_shunxu(:,3);
    data_1=data_shunxu;
    % 取中值
    unique_xx=unique(x);
    coordinate_final=[];
    for j=1:length(unique_xx)
        logic=data_1(:,1)==unique_xx(j);
        yy=(max(data_1(logic,2))+min(data_1(logic,2)))/2;
        coordinate_final=[coordinate_final;unique_xx(j),yy];
    end
    row{i}=coordinate_final(:,1:2);
    % varName=sprintf('row_%d', i);      % 创建变量名
    % eval([varName '=coordinate_final(:,1:2)']);      % 创建并赋值坐标
end
end