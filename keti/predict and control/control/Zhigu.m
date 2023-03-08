clear all
close all
clc

predict_net = load('predict_net.mat');

A = xlsread('x.xlsx');
A = A';
B = xlsread('nextmoment_x.xlsx');
B = B';
disturbance=xlsread('disturbance.xlsx');          
disturbance=disturbance';
C = xlsread('themoment_x.xlsx');
C = C';

%% 参数
param.P=6;                  %步长
param.maxEpoch=60000;    %最大迭代步数
param.ep=1.0e-12;          %目标精度
param.alpha=[0.5,0.5]';          %状态权重系数
param.gamma=0.9;          %动量因子
param.lr=0.0001;               %学习率

k=fix(size(disturbance,2)*0.001);
%     k=size(disturbance);
eerrc = [2;20];       %EER,制冷量初始值
uc = [1;1];  %控制量初始值
base(1,1:k) = 1;


%两个设定值（期望值）
PUEset = (1.1-min(B(1,:)))/(max(B(1,:))-min(B(1,:)));
% Tsf_set = (20-min(B(2,:)))/(max(B(2,:))-min(B(2,:)));
Tsf_set = (21-min(B(2,:)))/(23-min(B(2,:)));

Xsim = [eerrc,zeros(2,k)];
usim = [uc,zeros(2,k)];

% 预测模型
b1 = predict_net.net.b{1};%阈值
IW1_1 = predict_net.net.iw{1};%权值
W1_M = [IW1_1,b1];% 第一层
b2 = predict_net.net.b{2};
LW2_1 = predict_net.net.lw{2};
W2_M = [LW2_1,b2];% 第二层
% 控制器g
W1_C = rands(20,13)*1;  %隐层 
W2_C = rands(2,21)*1;
 
%  扰动归一化
for i=1:size(disturbance,1)
    Dis(i,:)=(disturbance(i,:)-min(disturbance(i,:)))/(max(disturbance(i,:))-min(disturbance(i,:)));
end
for i=1:size(C,1)
    x_c(i,:)=(C(i,:)-min(C(i,:)))/(max(C(i,:))-min(C(i,:)));
end
% 
% [ndata, D] = size(disturbance);            % ndata样本数(行数)，D维数（特征维度）
% R = randperm(D);             % 1到n这些数随机打乱得到的一个随机数字序列作为索引
% Dis = Dis(:,R(1:k)); % 以索引的前1000个数据点作为测试样本Xtest 
% x_c =x_c(:,R(1:k)) ;
x=x_c(:,1);
for n=1:k
    disp(n);
    v(:,1) =Dis(:,n);
    xset = [PUEset;Tsf_set];
    [u,xpre,W1,W2]= NNOptimizer(x,xset,v,param,W1_M,W2_M,W1_C,W2_C);
    x = MODEL_FORWARD_New(x,u,v,W1_M,W2_M);    
    Xsim(:,n+1) = x;
    usim(:,n+1) = u; 
end
for n=1:k
    Xfinal=Xsim(1,2:k)*(max(B(1,:))-min(B(1,:)))+min(B(1,:));
end

figure
plot(Xsim(1,2:k)*(max(B(1,:))-min(B(1,:)))+min(B(1,:)),'b')
% title('PUE')
hold on
plot(1.08*base(1,1:k),'r')
axis([0 k,1 1.5])
xlabel('数据点')
ylabel('PUE')

figure
plot(Xsim(2,2:k)*(23-min(B(2,:)))+min(B(2,:)),'b')
% title('送风温度')
xlabel('数据点')
ylabel('送风温度/°C')
hold on
plot(21*base(1,1:k),'r')
axis([0 k, 15 25])


figure
plot(usim(1,2:k),'r')
% title('冷却水流量比')
xlabel('数据点')
ylabel('冷却水流量比')


figure
plot(usim(2,2:k),'r')%'LineWidth',1)
% title('冷冻水流量比')
xlabel('数据点')
ylabel('冷冻水流量比')





    
    