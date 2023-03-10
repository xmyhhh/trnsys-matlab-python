
%***********************************************************************
% 函数： f = DF_DU_New(x,u,v,W1,W2)
% 功能：神经网络预测模型
%       x:模型输入状态变量；
%       u:模型输入控制量；
%       v:模型输入扰动变量
%       W1：模型隐层到输入层权值矩阵（含阈值）；
%       W2：模型输出层到隐层层权值矩阵（含阈值）；
%       修订日期：2017-07-14
%       作者：Yibing Ran
% ------------------修订---------------------------------------
%-       修订日期：2017-08-17
%        作者：冉义兵
%        功能：激活函数purelin该为logsig

function f = MODEL_FORWARD_New( x,u,v,W1,W2 )
  A=cat(1,x,u,v,1);        %输入
  B=tansig(W1*A);              %隐层输出
  [q,p]=size(W2);
  B(p)=1;                      %神经网络工具箱训的偏置关系为+
  f=logsig(W2*B);             %输出层层输出
