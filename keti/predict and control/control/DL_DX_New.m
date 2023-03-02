%***********************************************************************
% 函数:  y= DL_DX_New( x,xset,alpha)
% 功能：性能指标函数L对状态变量x求导
%       x:控制器输入-状态变量；
%       xset:控制器输入-设定值；
%       y：输出dl_dx
%       修订日期：2017-07-14
%       作者：Yibing Ran
function y= DL_DX_New( x,xset,alpha)
len=length(x);
dL_dx=zeros(1,len);
for i=1:len
dL_dx(i)=((x(i)-xset(i))^2)*alpha(i);
end
y=dL_dx;
