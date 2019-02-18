function [u, re] = kmeans(dataPath, N, eps)
% Aimed at clustering the data with K-Means
% -------------------------------------------------------------------------
% Input: 
% dataPath - the file path of data
% N - number of objects in a neighborhood of an object 
% eps - neighborhood radius, if not known avoid this parameter or put []
% -------------------------------------------------------------------------
% Output: 
% u - the center of each cluster
% re - the data with labels

datafile=[dataPath,'/points.mat'];
load(datafile);
data = points;

tic;
[m, n] = size(data);   %m�����ݸ�����n������ά��
ma = zeros(n);        %ÿһά������
mi = zeros(n);        %ÿһά��С����
u = zeros(N,n);       %�����ʼ�������յ�����ÿһ�������λ��
for i = 1 : n
    ma(i) = max(data(:,i));    %ÿһά������
    mi(i) = min(data(:,i));    %ÿһά��С����
    for j = 1 : N
        u(j,i) = ma(i) + (mi(i) - ma(i)) * rand();  %�����ʼ��������������ÿһά[min max]�г�ʼ����Щ
    end
end

while 1
    pre_u = u;            %��һ����õ�����λ��
    for i = 1 : N
        tmp{i} = [];      % ��ʽһ�е�x(i)-uj,Ϊ��ʽһʵ����׼��
        for j = 1 : m
            tmp{i} = [tmp{i}; data(j,:) - u(i,:)];
        end
    end
    
    quan = zeros(m,N);
    for i = 1 : m        %��ʽһ��ʵ��
        c = [];
        for j = 1 : N
            c = [c norm(tmp{j}(i,:))];
        end
        [junk, index] = min(c);
        quan(i, index) = norm(tmp{index}(i,:));
    end
    
    for i = 1 : N            %��ʽ����ʵ��
        for j = 1 : n
            u(i,j) = sum(quan(:,i) .* data(:,j)) / sum(quan(:,i));
        end
    end
    
    if norm(pre_u-u) < eps  %���ϵ���ֱ��λ�ò��ٱ仯
        break;
    end
end

re = [];
for i = 1 : m
    tmp = [];
    for j = 1 : N
        tmp = [tmp norm(data(i,:) - u(j,:))];
    end
    [junk, index]=min(tmp);
    re = [re;data(i,:) index];
end

%draw shapes
figure;
hold on;
title('K-MEANS')
drawshapes(data, re(:,3),m);
toc;
end
