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

%% ����
param.P=6;                  %����
param.maxEpoch=60000;    %����������
param.ep=1.0e-12;          %Ŀ�꾫��
param.alpha=[0.5,0.5]';          %״̬Ȩ��ϵ��
param.gamma=0.9;          %��������
param.lr=0.0001;               %ѧϰ��

k=fix(size(disturbance,2)*0.001);
%     k=size(disturbance);
eerrc = [2;20];       %EER,��������ʼֵ
uc = [1;1];  %��������ʼֵ
base(1,1:k) = 1;


%�����趨ֵ������ֵ��
PUEset = (1.1-min(B(1,:)))/(max(B(1,:))-min(B(1,:)));
% Tsf_set = (20-min(B(2,:)))/(max(B(2,:))-min(B(2,:)));
Tsf_set = (21-min(B(2,:)))/(23-min(B(2,:)));

Xsim = [eerrc,zeros(2,k)];
usim = [uc,zeros(2,k)];

% Ԥ��ģ��
b1 = predict_net.net.b{1};%��ֵ
IW1_1 = predict_net.net.iw{1};%Ȩֵ
W1_M = [IW1_1,b1];% ��һ��
b2 = predict_net.net.b{2};
LW2_1 = predict_net.net.lw{2};
W2_M = [LW2_1,b2];% �ڶ���
% ������g
W1_C = rands(20,13)*1;  %���� 
W2_C = rands(2,21)*1;
 
%  �Ŷ���һ��
for i=1:size(disturbance,1)
    Dis(i,:)=(disturbance(i,:)-min(disturbance(i,:)))/(max(disturbance(i,:))-min(disturbance(i,:)));
end
for i=1:size(C,1)
    x_c(i,:)=(C(i,:)-min(C(i,:)))/(max(C(i,:))-min(C(i,:)));
end
% 
% [ndata, D] = size(disturbance);            % ndata������(����)��Dά��������ά�ȣ�
% R = randperm(D);             % 1��n��Щ��������ҵõ���һ���������������Ϊ����
% Dis = Dis(:,R(1:k)); % ��������ǰ1000�����ݵ���Ϊ��������Xtest 
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
xlabel('���ݵ�')
ylabel('PUE')

figure
plot(Xsim(2,2:k)*(23-min(B(2,:)))+min(B(2,:)),'b')
% title('�ͷ��¶�')
xlabel('���ݵ�')
ylabel('�ͷ��¶�/��C')
hold on
plot(21*base(1,1:k),'r')
axis([0 k, 15 25])


figure
plot(usim(1,2:k),'r')
% title('��ȴˮ������')
xlabel('���ݵ�')
ylabel('��ȴˮ������')


figure
plot(usim(2,2:k),'r')%'LineWidth',1)
% title('�䶳ˮ������')
xlabel('���ݵ�')
ylabel('�䶳ˮ������')





    
    