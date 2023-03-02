
%***********************************************************************
% 函数: g = CONTROLLER_FORWARD_New( x,xset,v,W1,W2 )
% 功能：控制器神经网络
%       x:控制器输入-状态变量；
%       xset:控制器输入-设定值；
%       v:控制器输入-扰动变量；
%       W1：控制器隐层到输入层权值矩阵（含阈值）；
%       W2：控制器输出层到隐层层权值矩阵（含阈值）；
%       修订日期：2017-07-14
%       作者：Yibing Ran

function g = CONTROLLER_FORWARD_New( x,xset,v,W1,W2 )
  A=cat(1,x,xset,v,-1);           %输入
  B=tansig(W1*A);                 %隐层输出
  [q,p]=size(W2);                 %求隐层节点数  
  B(p)=-1;                        %隐层阈值
  g=logsig(W2*B);                 %输出层层输出






 