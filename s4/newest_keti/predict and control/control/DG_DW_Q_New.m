%***********************************************************************
% 函数:function[dg_dw1_q,dg_dw2_q] = DG_DW_Q_New(x,xset,v,W1,W2,Q)
%       x:控制器输入-状态变量；
%       xset:控制器输入-设定值；
%       v:控制器输入-扰动变量；
%       W1：控制器隐层到输入层权值矩阵（含阈值）；
%       W2：控制器输出层到隐层层权值矩阵（含阈值）；
%       Q:拉格朗日乘子
%       dg_dw1_q：
%       dg_dw2_q：
%       修订日期：2017-07-14
%       作者：Yibing Ran

function[dg_dw1_q,dg_dw2_q] = DG_DW_Q_New(x,xset,v,W1,W2,Q)
    A=cat(1,x,xset,v,-1);        %输入
    S1=W1*A;                     %隐层-输入线性求和
    B=tansig(S1);                %第一层(隐藏)神经元的输出
    [q,p]=size(W2);              %求隐层节点数  
    B(p)=-1;                     %隐层阈值
    S2=W2*B;                     %输出-隐层线性求和
    
    dB_dS1=4*exp(-2*S1)./(1+exp(-2*S1)).^2;
    dg_dS2=exp(-S2)./(1+exp(-S2)).^2;
    dg_dW2=dg_dS2*B';
    dg_dw2_q=diag(Q)*dg_dW2;
    W2=W2(:,1:p-1);
    dg_dw1_q=diag(Q'*(diag(dg_dS2)*W2))*(dB_dS1*A');





