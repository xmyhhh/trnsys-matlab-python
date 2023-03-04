close all
A=xlsread('x.xlsx');          
B=A';

n=10; % n为模板长度，值可以改变
% y = smooth(B(11,:),n);
% g= medfilt1(B(12,:),n);

theta = 0.5; 
len = size(B,2); 
a=B(11,:);
a1 = a;
for it = 2 : len - 1
     if abs((a(it) - a(it-1))) > theta || abs((a(it+1) - a(it))) > theta 
        a1(it) = (a(it-1) + a(it+1)) * 0.5;
     end
end
figure;
plot(a,'-b')
xlabel('测试数据组数');
ylabel('PUE');
hold on
plot(a1,'-r')
legend('滤波后','滤波前')

% figure;
% plot(y,'-b')
% %title('PUE test output compare');
% xlabel('测试数据组数');
% ylabel('送风温度');
% hold on
% plot(B(11,:),'-r')
% legend('滤波后','滤波前')

