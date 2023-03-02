clear all
clc

predict_net = load('predict_net.mat');

A = xlsread('x.xlsx');
A = A';
B = xlsread('nextmoment_x.xlsx');
B = B';
disturbance=xlsread('disturbance.xlsx');          
disturbance=disturbance';


%% ����
    param.P=6;                  %����
    param.maxEpoch=2000;    %����������
    param.ep=1.0e-12;          %Ŀ�꾫��
    param.alpha=[0.5,0.5]';          %״̬Ȩ��ϵ��
    param.gamma=0.5;          %��������
    param.lr=0.002;               %ѧϰ��

    PUEguiyi = (1.15-min(B(1,:)))/(max(B(1,:))-min(B(1,:)));
    Tsf_guiyi = (18.3-min(B(2,:)))/(max(B(2,:))-min(B(2,:)));
    x = [PUEguiyi;Tsf_guiyi];  %EER,��������ʼֵ
    
    k=fix(size(disturbance,2)*0.0015);
    v(:,1) = disturbance(:,1);  %�¶ȣ�ʪ�ȳ�ʼֵ
    eerrc = [2;20];       %EER,��������ʼֵ
    uc = [1;1];  %��������ʼֵ
    base(1,1:k) = 1;
 

    %�����趨ֵ������ֵ��
    PUEset = (1.1-min(B(1,:)))/(max(B(1,:))-min(B(1,:)));
    Tsf_set = (20-min(B(2,:)))/(max(B(2,:))-min(B(2,:)));
    xset(2,1:k) = 0;

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
    W1_C = rands(12,13)*1;  %���� 
    W2_C = rands(2,13)*1;
 
%  �Ŷ���һ��
for i=1:size(disturbance,1)
    Dis(i,:)=(disturbance(i,:)-min(disturbance(i,:)))/(max(disturbance(i,:))-min(disturbance(i,:)));
end

[ndata, D] = size(disturbance);            % ndata������(����)��Dά��������ά�ȣ�
R = randperm(D);             % 1��n��Щ��������ҵõ���һ���������������Ϊ����
Dis = Dis(:,R(1:k)); % ��������ǰ1000�����ݵ���Ϊ��������Xtest 

for n=1:k
    disp(n);
    v(:,1) =Dis(:,n);
    xset(:,n) = [PUEset,Tsf_set];
    [u,xpre,W1,W2]= NNOptimizer(x,xset(:,n),v,param,W1_M,W2_M,W1_C,W2_C);
    x = MODEL_FORWARD_New(x,u,v,W1_M,W2_M);    
    Xsim(:,n+1) = x;
    usim(:,n+1) = u;
end

figure(1)
plot(Xsim(1,2:k)*(max(B(1,:))-min(B(1,:)))+min(B(1,:)),'b')
% title('PUE')
xlabel('���ݵ�')
ylabel('PUE')
hold on
plot(1.1*base(1,1:k),'r')
hold off

figure(2)
plot(Xsim(2,2:k)*(max(B(2,:))-min(B(2,:)))+min(B(2,:)),'b')
% title('�ͷ��¶�')
xlabel('���ݵ�')
ylabel('�ͷ��¶�/��C')
hold on
plot(20*base(1,1:k),'r')
grid on

figure(3)
plot(usim(1,2:k),'r')%'LineWidth',1)
% title('��ȴˮ������')
xlabel('���ݵ�')
ylabel('��ȴˮ������')
hold on
grid on

figure(4)
plot(usim(2,2:k),'r')%'LineWidth',1)
% title('�䶳ˮ������')
xlabel('���ݵ�')
ylabel('�䶳ˮ������')
hold on
grid on

% figure(5)
% plot(usim(3,2:120)*(max(A(5,:))-min(A(5,:)))+min(A(5,:)),'r')%'LineWidth',1)
% title('�䶳ˮ����')
% xlabel('k')
% ylabel('m3/h')
% hold on
% grid on
% 
% figure(6)
% plot(usim(4,2:120)*40,'r')
% %plot(usim(4,2:120)*(max(A(6,:))-min(A(6,:)))+min(A(6,:)),'r')%'LineWidth',1)
% title('��ȴ���������')
% xlabel('k')
% ylabel('Kw')
% hold on
% grid on


    
    