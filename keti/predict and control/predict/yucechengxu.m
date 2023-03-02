clear all
clc
%��Excel�ļ�������������
A=xlsread('x.xlsx');          
B=A';
% B = smoothdata(B,'gaussian',10);
a=xlsread('nextmoment_y.xlsx');             
b=a';
% b = smoothdata(b,'gaussian',10);
%���ݹ�һ������
%�Բ�ͬ��Ӱ�����ӷֱ��һ��������ͬһ��Ӱ������λ��B�����ͬһ��
for i=1:size(B,1)
    X(i,:)=(B(i,:)-min(B(i,:)))/(max(B(i,:))-min(B(i,:)));
    maxMin_x(i,1)=max(B(i,:));
    maxMin_x(i,2)=min(B(i,:));
end

% maxMin_x(i:1)=max(B(i,:))
% maxMin_x(i:2)=min(B(i,:))

%�Բ�ͬ��Ŀ�������ֱ��һ��������ͬһ��Ŀ��λ��b�����ͬһ��
for i=1:size(b,1)
    T(i,:)=(b(i,:)-min(b(i,:)))/(max(b(i,:))-min(b(i,:)));
end

%ѵ��BP����
train_number=size(B,2)*0.8;
[ndata, D] = size(B);            % ndata������(����)��Dά��������ά�ȣ�
R = randperm(D);             % 1��n��Щ��������ҵõ���һ���������������Ϊ����

P_train = X(:,R(1:train_number)); % ��������ǰ1000�����ݵ���Ϊ��������Xtest 
T_train = T(:,R(1:train_number));


% P_train=X(:,1:(size(B,2))*0.8);
% T_train=T(:,1:(size(b,2))*0.8);

%����BP���磬�趨�������
net=newff(minmax(P_train),[12,2],{'tansig' 'purelin'},'trainbr','learngdm','msereg');
% net=newff(minmax(P_train),[10,2],{'tansig' 'purelin'},'trainbr','learngdm','msereg');

%ѵ���������趨 
% net.trainParam.epochs = 5000;          % Maximum number of epochs to train 
% net.trainParam.goal = 0;               % 0 Performance goal 
net.layers{1}.initFcn='initnw';                       %Ȩֵ��ʼ��������Nguyen - Widrow��
net.layers{2}.initFcn='initnw';
net.inputWeights{1,1}.initFcn='rands';               %Ȩֵ��ʼ��������������������ͣ�
net.layerWeights{2,1}.initFcn='rands';
net.biases{1}.initFcn='rands';
net.biases{2}.initFcn='rands';
net=init(net);              %��ѵ��ǰ�����ʼ��Ȩ�غ�ƫ��

net.trainFcn='trainbr';                              %ѵ���㷨����Ҷ˹���滯����

%ѵ���������趨 
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

%����ѵ��
net=train(net,P_train,T_train);                     
