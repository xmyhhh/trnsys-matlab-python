%***********************************************************************
% ����:  y= DL_DX_New( x,xset,alpha)
% ���ܣ�����ָ�꺯��L��״̬����x��
%       x:����������-״̬������
%       xset:����������-�趨ֵ��
%       y�����dl_dx
%       �޶����ڣ�2017-07-14
%       ���ߣ�Yibing Ran
function y= DL_DX_New( x,xset,alpha)
len=length(x);
dL_dx=zeros(1,len);
for i=1:len
dL_dx(i)=((x(i)-xset(i))^2)*alpha(i);
end
y=dL_dx;
