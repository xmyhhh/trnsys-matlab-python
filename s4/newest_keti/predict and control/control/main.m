clear all
close all
clc

predict_net = load('predict_net.mat');
B = xlsread('nextmoment_x.xlsx');
B = B';
disturbance=xlsread('disturbance.xlsx');          
disturbance=disturbance';
C = xlsread('themoment_x.xlsx');
C = C';


%% 参数
param.P=6;                  %步长
param.maxEpoch=20000;    %最大迭代步数
param.ep=1.0e-12;          %目标精度
param.alpha=[0.5,0.5]';          %状态权重系数
param.gamma=0.5;          %动量因子
param.lr=0.02;               %学习率

k=fix(size(disturbance,2)*0.0006);

x1=1.15;
x2=25;
x11 = (x1-min(B(1,:)))/(max(B(1,:))-min(B(1,:)));
x22 = (x2-min(B(2,:)))/(27-min(B(2,:)));
x_ini = [x11;x22]; %EER,制冷量初始值

uc = [1;1];  %控制量初始值
base(1,1:k) = 1;

Xsim = [x_ini,zeros(2,k)];
usim = [uc,zeros(2,k)];

% 预测模型
b1 = predict_net.net.b{1};%阈值
IW1_1 = predict_net.net.iw{1};%权值
W1_M = [IW1_1,b1];% 第一层
b2 = predict_net.net.b{2};
LW2_1 = predict_net.net.lw{2};
W2_M = [LW2_1,b2];% 第二层
% 控制器g
W1_C = rands(25,13)*1;  %隐层 
W2_C = rands(2,26)*1;

%  扰动归一化
for i=1:size(disturbance,1)
    Dis(i,:)=(disturbance(i,:)-min(disturbance(i,:)))/(max(disturbance(i,:))-min(disturbance(i,:)));
end
% for i=1:size(C(:,11111:33333),1)
% %     x_c(i,:)=(C(i,:)-min(C(i,:)))/(max(C(i,:))-min(C(i,:)));
%     x_c(i,:)=(C(i,:)-min(C(i,:)))/(max(C(i,:))-min(C(i,:)));
% end
x_c(1,:)=(C(1,:)-min(C(1,:)))/(max(C(1,:))-min(C(1,:)));
x_c(2,:)=(C(2,:)-min(C(2,:)))/(27-min(C(2,:)));
x=x_c(:,1);
Tsf_set = zeros(1,k);
for n=1:k
    disp(n);
    %两个设定值（期望值）
    PUE=1.08;
%     Tsf=21;
    PUEset = (PUE-min(B(1,:)))/(max(B(1,:))-min(B(1,:)));
%     Tsf_set = (Tsf-min(B(2,:)))/(27-min(B(2,:)));
    
    if(n<30)
        Tsf(:,n)=21;
        Tsf_set(:,n) = (Tsf(:,n)-min(B(2,:)))/(27-min(B(2,:)));
    else 
        Tsf(:,n)=23;
        Tsf_set (:,n)= (Tsf(:,n)-min(B(2,:)))/(27-min(B(2,:)));
    end 
    v(:,1) =Dis(:,n);
    xset = [PUEset;Tsf_set(i)];
    [u,xpre,W1,W2]= NNOptimizer(x,xset,v,param,W1_M,W2_M,W1_C,W2_C);
    x = MODEL_FORWARD_New(x,u,v,W1_M,W2_M);    
    Xsim(:,n+1) = x;
    usim(:,n+1) = u; 
end


figure
plot(Xsim(1,1:k)*(max(B(1,:))-min(B(1,:)))+min(B(1,:)),'b')
% title('PUE')
hold on
plot(PUE*base(1,1:k),'r')
axis([1 k,0.5 1.5])
xlabel('数据点')
ylabel('PUE')

figure
plot(Xsim(2,1:k)*(27-min(B(2,:)))+min(B(2,:)),'b')
% title('送风温度')
xlabel('数据点')
ylabel('送风温度/°C')
hold on
plot(Tsf,'r')
axis([1 k, 14 34])


figure
plot(usim(1,1:k),'r')
% title('冷却水流量比')
xlabel('数据点')
ylabel('冷却水流量比')


figure
plot(usim(2,1:k),'r')
% title('冷冻水流量比')
xlabel('数据点')
ylabel('冷冻水流量比')





    
    