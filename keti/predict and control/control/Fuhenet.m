clear all
clc
%从Excel文件导入样本数据     +数字滤波
A=xlsread('D:\研究生\研二\项目资料\程序\XZM 扬州智谷\控制算法\jiaNNPOC _logsig版\Fuhe input.xlsx');
A=smoothdata(A,'gaussian',30)
%A=smoothts(A,'b',30);
C=A';%转置
%C = smoothdata(C)
%C=smoothts(B,'b',20)
a=xlsread('D:\研究生\研二\项目资料\程序\XZM 扬州智谷\控制算法\jiaNNPOC _logsig版\Fuhe output.xlsx');   
a=smoothdata(a,'gaussian',30) 

%a=smoothts(a,'b',30);
c=a';
%c = smoothdata(c)
%c=smoothts(b,'b',20)


%数据归一化处理
%对不同的影响因子分别归一化处理，因同一类影响因子位于B矩阵的同一行
for i=1:6;
    X(i,:)=(C(i,:)-min(C(i,:)))/(max(C(i,:))-min(C(i,:)));
    maxMin_x(i,1)=max(C(i,:));
    maxMin_x(i,2)=min(C(i,:));

end

% maxMin_x(i:1)=max(B(i,:))
% maxMin_x(i:2)=min(B(i,:))

%对不同的目标样本分别归一化处理，因同一类目标位于b矩阵的同一行
for i=1
    T(i,:)=(c(i,:)-min(c(i,:)))/(max(c(i,:))-min(c(i,:)));
end

%训练BP网络

P_train=X(:,1:4050);             %%训练样本的输入向量
T_train=T(:,1:4050);

%建立BP网络，设定网络参数
net=newff(minmax(P_train),[12,1],{'tansig' 'purelin'},'trainbr','learngdm','msereg');
% net=newff(minmax(P_train),[10,2],{'tansig' 'purelin'},'trainbr','learngdm','msereg');

%训练参数的设定 
net.trainParam.epochs = 5000        % Maximum number of epochs to train 5000次

net.trainParam.goal = 0               % 0 Performance goal 
net.layers{1}.initFcn='initnw';                      %权值初始化方法（Nguyen - Widrow）
net.layers{2}.initFcn='initnw';
net.inputWeights{1,1}.initFcn='rands';               %权值初始化方法（常数区间随机型）
net.layerWeights{2,1}.initFcn='rands';
net.biases{1}.initFcn='rands';
net.biases{2}.initFcn='rands';
net=init(net);              %在训练前必须初始化权重和偏置

net.trainFcn='trainbr';                              %训练算法（贝叶斯正规化法）

%训练参数的设定 
net.trainParam.epochs = 5000           % Maximum number of epochs to train 最大训练单元 5000
net.trainParam.goal = 0                % 0 Performance goal 操作目标 0
net.trainParam.max_fail = 5            % Maximum validation failures 最大验证失败 5
net.trainParam.mem_reduc = 3           % Factor to use for memory/speed trade off. 用于记忆/速度权衡的因素 1/2/5/4/3
net.trainParam.min_grad = 2e-10        % Minimum performance gradient 最低性能梯度 1e-10/2e-10
net.trainParam.mu = 0.5                % Initial Mu 0.001/0.1/0.2
net.trainParam.mu_dec = 0.5            % Mu decrease factor 下降因子 0.1/0.25/0.75/0.01
net.trainParam.mu_inc = 28             % Mu increase factor 10/30
net.trainParam.mu_max = 1e10           % Maximum Mu 1e10/2e10/0.5e10/1e10
net.trainParam.show = 25                % 25 Epochs between displays (NaN for no displays) 25
net.trainParam.time = inf              % Maximum time to train in seconds以秒为单位的最大训练时间 inf

LP.lr = 0.05                           % 0.05 Learning rate 

%网络训练
net=train(net,P_train,T_train);   %  net是带训练的神网。P是网络的输入信号，T是网络目标       

%网络测试
P_test=X(:,3650:4050);
t_test=sim(net,P_test);  
t_real=T(:,3650:4050);

% figure(2);
% plot(Error2);
% title('Qfuhe output error');
% xlabel('number)');
% ylabel('Error');

%反归一化处理
for i=1
    T_test(i,:)=t_test(i,:)*(max(c(i,:))-min(c(i,:)))+min(c(i,:));
    T_real(i,:)=t_real(i,:)*(max(c(i,:))-min(c(i,:)))+min(c(i,:));
end
Error1=T_test(1,:)-T_real(1,:);%神经网络输出-实际
figure(1);
plot(Error1);
title('制冷量误差');
xlabel('number)');
ylabel('Error');

figure(2);
plot(T_real(1,:));
title('制冷量对比');
xlabel('number');
ylabel('制冷量');
hold on
plot(T_test(1,:),'r+');
hold off   
save Fuhenet net