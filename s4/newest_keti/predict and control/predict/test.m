P_test = X(:,R(train_number+1:D));
t_real = T(:,R(train_number+1:D));
%网络测试
% P_test=X(:,(size(B,2))*0.8+1:size(B,2));
t_test=sim(net,P_test);  
% t_real=T(:,(size(b,2))*0.8+1:size(b,2));
Error1=t_test(1,:)-t_real(1,:);
rmse = sqrt(mean((t_test-t_real).^2));
meap = mean(abs((t_real - t_test)./t_real));

%Error2=t_test(2,:)-t_real(2,:);


E11=0;
for j=1:size(t_test,1)
    E1(j,1)=0;
    E11(j,1)=0;
    for i=1:size(t_test,2)
        Relative_error(j,i)=abs((t_test(j,i)-t_real(j,i))/t_real(j,i));
        E1(j)=E1(j)+abs((t_test(j,i)-t_real(j,i))/t_real(j,i));
        E11(j)=E11(j)+(t_test(j,i)-t_real(j,i))^2;
    end
end
RMSE=sqrt(E11/size(t_test,1));
MEAP=E1/size(t_test,1);



% figure(1);
% plot(Error1);
% title('PUE output error');
% xlabel('number)');
% ylabel('Error');

% figure(2);
% plot(Error2);
% title('Tsf output error');
% xlabel('number)');
% ylabel('Error');

%反归一化处理
for i=1:size(t_test,1)
    T_test(i,:)=t_test(i,:)*(max(b(i,:))-min(b(i,:)))+min(b(i,:));
    T_real(i,:)=t_real(i,:)*(max(b(i,:))-min(b(i,:)))+min(b(i,:));
end    
% xlswrite('test301.xlsx',T_test);
%其中“训练_42.xlsx”为另存为文件的名称，sounds_y2为原mat格式的数据
% test30=xlsread('C:\Users\YJT\Desktop\PUE预测及负荷预测程序\负荷预测\test301.xlsx');

% disp(rmse)
% disp(meap)
% disp(RMSE)
% disp(MEAP)
figure;
plot(T_real(2,:),'-b')
%title('PUE test output compare');
xlabel('测试数据组数');
ylabel('PUE');
hold on
plot(T_test(2,:),'r');
legend('PUE实际输出','PUE预测输出')

figure;
plot(T_real(1,:),'-b')
%title('PUE test output compare');
xlabel('测试数据组数');
ylabel('送风温度/°C');
hold on
plot(T_test(1,:),'r');
legend('送风温度实际输出','送风温度预测输出')

figure;
plot(Relative_error(2,:),'-b')
%title('PUE test output compare');
xlabel('测试数据组数');
ylabel('相对误差/%');
hold on
plot(Relative_error(1,:),'r');
legend('PUE相对误差','送风温度相对误差')
% hold off   
% axis([-25,250 -500,5000])%坐标轴设置好像放在后面才起作用，放在plot前面好像不起作用
% figure(4);
% plot(T_real(2,:));
% title('Tsftest output compare');
% xlabel('number');
% ylabel('Tsf');
% hold on
% plot(T_test(2,:),'r+');
% hold off   
% %训练完成后取权值
