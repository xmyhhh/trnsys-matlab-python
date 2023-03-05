%***********************************************************************
% 函数:  y= DL_DU_New( x,xset,alpha)
% 功能：性能指标函数L对状态变量u求导
%       u:控制器输出-控制变量；
%       修订日期：2017-07-14
%       作者：Yibing Ran
function y = DL_DU_New( u )
nu=length(u);
y=zeros(1,nu);