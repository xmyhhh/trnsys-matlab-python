clear all
clc
%��Excel�ļ�������������     +�����˲�
A=xlsread('D:\�о���\�ж�\��Ŀ����\����\XZM �����ǹ�\�����㷨\jiaNNPOC _logsig��\Fuhe input.xlsx');
A=smoothdata(A,'gaussian',30)
%A=smoothts(A,'b',30);
C=A';%ת��
%C = smoothdata(C)
%C=smoothts(B,'b',20)
a=xlsread('D:\�о���\�ж�\��Ŀ����\����\XZM �����ǹ�\�����㷨\jiaNNPOC _logsig��\Fuhe output.xlsx');   
a=smoothdata(a,'gaussian',30) 

%a=smoothts(a,'b',30);
c=a';
%c = smoothdata(c)
%c=smoothts(b,'b',20)


%���ݹ�һ������
%�Բ�ͬ��Ӱ�����ӷֱ��һ��������ͬһ��Ӱ������λ��B�����ͬһ��
for i=1:6;
    X(i,:)=(C(i,:)-min(C(i,:)))/(max(C(i,:))-min(C(i,:)));
    maxMin_x(i,1)=max(C(i,:));
    maxMin_x(i,2)=min(C(i,:));

end

% maxMin_x(i:1)=max(B(i,:))
% maxMin_x(i:2)=min(B(i,:))

%�Բ�ͬ��Ŀ�������ֱ��һ��������ͬһ��Ŀ��λ��b�����ͬһ��
for i=1
    T(i,:)=(c(i,:)-min(c(i,:)))/(max(c(i,:))-min(c(i,:)));
end

%ѵ��BP����

P_train=X(:,1:4050);             %%ѵ����������������
T_train=T(:,1:4050);

%����BP���磬�趨�������
net=newff(minmax(P_train),[12,1],{'tansig' 'purelin'},'trainbr','learngdm','msereg');
% net=newff(minmax(P_train),[10,2],{'tansig' 'purelin'},'trainbr','learngdm','msereg');

%ѵ���������趨 
net.trainParam.epochs = 5000        % Maximum number of epochs to train 5000��

net.trainParam.goal = 0               % 0 Performance goal 
net.layers{1}.initFcn='initnw';                      %Ȩֵ��ʼ��������Nguyen - Widrow��
net.layers{2}.initFcn='initnw';
net.inputWeights{1,1}.initFcn='rands';               %Ȩֵ��ʼ��������������������ͣ�
net.layerWeights{2,1}.initFcn='rands';
net.biases{1}.initFcn='rands';
net.biases{2}.initFcn='rands';
net=init(net);              %��ѵ��ǰ�����ʼ��Ȩ�غ�ƫ��

net.trainFcn='trainbr';                              %ѵ���㷨����Ҷ˹���滯����

%ѵ���������趨 
net.trainParam.epochs = 5000           % Maximum number of epochs to train ���ѵ����Ԫ 5000
net.trainParam.goal = 0                % 0 Performance goal ����Ŀ�� 0
net.trainParam.max_fail = 5            % Maximum validation failures �����֤ʧ�� 5
net.trainParam.mem_reduc = 3           % Factor to use for memory/speed trade off. ���ڼ���/�ٶ�Ȩ������� 1/2/5/4/3
net.trainParam.min_grad = 2e-10        % Minimum performance gradient ��������ݶ� 1e-10/2e-10
net.trainParam.mu = 0.5                % Initial Mu 0.001/0.1/0.2
net.trainParam.mu_dec = 0.5            % Mu decrease factor �½����� 0.1/0.25/0.75/0.01
net.trainParam.mu_inc = 28             % Mu increase factor 10/30
net.trainParam.mu_max = 1e10           % Maximum Mu 1e10/2e10/0.5e10/1e10
net.trainParam.show = 25                % 25 Epochs between displays (NaN for no displays) 25
net.trainParam.time = inf              % Maximum time to train in seconds����Ϊ��λ�����ѵ��ʱ�� inf

LP.lr = 0.05                           % 0.05 Learning rate 

%����ѵ��
net=train(net,P_train,T_train);   %  net�Ǵ�ѵ����������P������������źţ�T������Ŀ��       

%�������
P_test=X(:,3650:4050);
t_test=sim(net,P_test);  
t_real=T(:,3650:4050);

% figure(2);
% plot(Error2);
% title('Qfuhe output error');
% xlabel('number)');
% ylabel('Error');

%����һ������
for i=1
    T_test(i,:)=t_test(i,:)*(max(c(i,:))-min(c(i,:)))+min(c(i,:));
    T_real(i,:)=t_real(i,:)*(max(c(i,:))-min(c(i,:)))+min(c(i,:));
end
Error1=T_test(1,:)-T_real(1,:);%���������-ʵ��
figure(1);
plot(Error1);
title('���������');
xlabel('number)');
ylabel('Error');

figure(2);
plot(T_real(1,:));
title('�������Ա�');
xlabel('number');
ylabel('������');
hold on
plot(T_test(1,:),'r+');
hold off   
save Fuhenet net