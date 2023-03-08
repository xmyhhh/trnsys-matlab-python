close all
a=xlsread('all_nextmoment_y.xlsx');             
b=a';
% span=10;
% B = (smooth(b(1,:),span))';%medfilt1(b,n);
theta = 27.03; 

len = length(b); 
a1 = b;
for it = 2 : len - 1
     if a(it)> theta ||  a(it) < 16 
        a1(it) = (a(it-1) + a(it+1)) * 0.5;
     end
end
figure
% plot(B,'-b')
% hold on
plot(a1(1,:),'-r')
xlabel('测试数据组数');
ylabel('PUE');

% figure
% plot(B(2,:),'r');
% xlabel('测试数据组数');
% ylabel('送风温度');
