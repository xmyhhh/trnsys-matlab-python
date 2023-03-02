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
figure(1);
plot(T_real(1,:),'-b')
%title('PUE test output compare');
xlabel('测试数据组数');
ylabel('PUE');
hold on
plot(T_test(1,:),'r');
legend('PUE实际输出','PUE预测输出')

figure(2);
plot(T_real(2,:),'-b')
%title('PUE test output compare');
xlabel('测试数据组数');
ylabel('送风温度/°C');
hold on
plot(T_test(2,:),'r');
legend('送风温度实际输出','送风温度预测输出')

figure(3);
plot(Relative_error(1,:),'-b')
%title('PUE test output compare');
xlabel('测试数据组数');
ylabel('相对误差/%');
hold on
plot(Relative_error(2,:),'r');
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
% W1=net.iw{1}
% bias1=net.b{1}
% W2=net.lw{2}
% bias2=net.b{2}
% maxMin_x

% save EERnet
% W1 =
% 
%     0.6033    0.0945   -0.0997    0.0320    0.5594   -0.6425   -0.1442   -0.4451
%     1.3075   -0.7558    0.1353    0.0535    0.4874   -0.5271   -0.1003    0.3605
%     0.8832    2.5973    0.3836    0.0450    0.0186   -1.8551   -0.1812   -0.7167
%     1.8989   -0.6160    0.1617   -0.0638    0.8173    0.6712   -1.2436   -0.7578
%    -0.9270    1.8328   -0.5683   -0.4744    0.6098    0.0963    3.7499   -1.4951
%     2.2281   -0.4138   -0.7802   -0.1629    1.8548   -0.0686   -2.0057   -0.6228
%    -1.4364   -0.0872    0.0984   -0.0668   -1.1944    0.6347    0.7011    0.5922
%    -0.7476   -1.2027    0.7557    0.6200   -0.5189    0.4229   -0.5830    0.6639
%    -0.0980    1.6366    0.2065    0.0849   -0.2369   -0.8558   -0.4547   -0.7721
%     1.3535   -0.3873    0.0767   -0.0036    0.7766    0.0934   -0.3917   -0.5978
%     0.2479   -0.2327   -0.1527   -0.0367    0.3717   -0.3517    0.4666    0.6468
% 
% 
% bias1 =
% 
%     0.7047
%    -0.9425
%     1.0772
%    -1.0229
%    -1.4186
%    -0.2396
%     0.3124
%    -0.3129
%    -0.2331
%    -0.7299
%    -0.5104
% 
% 
% W2 =
% 
%    -1.4155    1.8817   -0.5299    0.9102    0.3651   -0.4689   -2.2505   -0.3120   -0.8699   -3.2793   -1.6357
%    -2.2165   -0.0833    0.2837    0.0398   -0.0949   -0.0093   -0.4247    0.0100    0.2685   -0.0681    1.1755
% 
% 
% bias2 =
% 
%     1.3289
%     1.6609
% 
% 
% maxMin_x =
% 
%    37.1700   14.5000
%    15.4100   14.3700
%    21.6300   20.0800
%     1.0000    0.6000
%     1.0000    0.5200
%    28.9100    5.3500
%     1.3100    1.1700
%   136.7500   85.5900