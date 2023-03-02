clear all
clc
%从Excel文件导入样本数据
A=xlsread('x.xlsx');          
B=A';
% B = smoothdata(B,'gaussian',10);
a=xlsread('nextmoment_y.xlsx');             
b=a';
% b = smoothdata(b,'gaussian',10);
%数据归一化处理
%对不同的影响因子分别归一化处理，因同一类影响因子位于B矩阵的同一行
for i=1:size(B,1)
    X(i,:)=(B(i,:)-min(B(i,:)))/(max(B(i,:))-min(B(i,:)));
    maxMin_x(i,1)=max(B(i,:));
    maxMin_x(i,2)=min(B(i,:));
end

% maxMin_x(i:1)=max(B(i,:))
% maxMin_x(i:2)=min(B(i,:))

%对不同的目标样本分别归一化处理，因同一类目标位于b矩阵的同一行
for i=1:size(b,1)
    T(i,:)=(b(i,:)-min(b(i,:)))/(max(b(i,:))-min(b(i,:)));
end

%训练BP网络
train_number=size(B,2)*0.8;
[ndata, D] = size(B);            % ndata样本数(行数)，D维数（特征维度）
R = randperm(D);             % 1到n这些数随机打乱得到的一个随机数字序列作为索引

P_train = X(:,R(1:train_number)); % 以索引的前1000个数据点作为测试样本Xtest 
T_train = T(:,R(1:train_number));


% P_train=X(:,1:(size(B,2))*0.8);
% T_train=T(:,1:(size(b,2))*0.8);

%建立BP网络，设定网络参数
net=newff(minmax(P_train),[12,2],{'tansig' 'purelin'},'trainbr','learngdm','msereg');
% net=newff(minmax(P_train),[10,2],{'tansig' 'purelin'},'trainbr','learngdm','msereg');

%训练参数的设定 
% net.trainParam.epochs = 5000;          % Maximum number of epochs to train 
% net.trainParam.goal = 0;               % 0 Performance goal 
net.layers{1}.initFcn='initnw';                       %权值初始化方法（Nguyen - Widrow）
net.layers{2}.initFcn='initnw';
net.inputWeights{1,1}.initFcn='rands';               %权值初始化方法（常数区间随机型）
net.layerWeights{2,1}.initFcn='rands';
net.biases{1}.initFcn='rands';
net.biases{2}.initFcn='rands';
net=init(net);              %在训练前必须初始化权重和偏置

net.trainFcn='trainbr';                              %训练算法（贝叶斯正规化法）

%训练参数的设定 
net.trainParam.epochs = 500;          % Maximum number of epochs to train 
net.trainParam.goal = 0;            % 0 Performance goal 
net.trainParam.max_fail = 5;            % Maximum validation failures 
net.trainParam.mem_reduc = 1;           % Factor to use for memory/speed trade off. 
net.trainParam.min_grad = 1e-10;        % Minimum performance gradient 
net.trainParam.mu = 0.001;              % Initial Mu 
net.trainParam.mu_dec = 0.1;            % Mu decrease factor 
net.trainParam.mu_inc = 10;             % Mu increase factor 
net.trainParam.mu_max = 1e10;          % Maximum Mu 
net.trainParam.show =25;                % 25 Epochs between displays (NaN for no displays) 
net.trainParam.time = inf;               % Maximum time to train in seconds 

LP.lr = 0.01;                          % 0.05 Learning rate 

%网络训练
net=train(net,P_train,T_train);                     
