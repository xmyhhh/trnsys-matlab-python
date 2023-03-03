%***********************************************************************
% ����: [u,xpre,W1,W2]= NNOptimizer(x,xset,v,param,W1_M,W2_M,W1_C,W2_C)
% ���������
%   x ��ʾ��ǰ״̬
%   xset ��ʾ״̬�趨
%   v ��ʾ�Ŷ�����
%   param��ʾ�Ż������ṹ��
%   W1_M ģ��Ȩֵ����1
%   W2_M ģ��Ȩֵ����2
%   W1_C ������Ȩֵ����1
%   W2_C ������Ȩֵ����2
% ���ز�����
%   u��������Ż���������0-1��
%   xpre ��ʾ״̬����Ԥ��ֵ�� 
%   xpre(:,1)��ʾ��ǰʱ�̣�xpre(:,2��P+1)��:1~P��Ԥ��
%   W1,���������º�Ȩֵ1
%   W2,���������º�Ȩֵ2
%**********************************************************************
%   param:�Ż������ṹ��
    %--------------------------------------------------------
    %             P             |   Ԥ�ⲽ��
    %--------------------------------------------------------
    %             maxEpoch      |   ����������
    %--------------------------------------------------------
    %             ep            |   ����
    %--------------------------------------------------------
    %             alpha         |   ����ָ��Ȩϵ��
    %--------------------------------------------------------
    %             gamma         |   ��������
    %--------------------------------------------------------
    %              lr           |    ѧϰ��
    %--------------------------------------------------------

    

function [u,xpre,W1,W2]= NNOptimizer(x,xset,v,param,W1_M,W2_M,W1_C,W2_C)

    %% ����
    P=param.P;                  %����
    maxEpoch=param.maxEpoch;    %����������
    ep=param.ep;                %Ŀ�꾫��
    alpha=param.alpha;          %״̬Ȩ��ϵ��
    gamma=param.gamma;          %��������
    lr=param.lr;                %ѧϰ��
    
    %% ��ʼ��
%     global xpre  
    dim_x=length(x);                %dim_x��״̬������Ŀ
    [dim_u,p]=size(W2_C);           %dim_u�����Ʊ�����Ŀ
    xpre=zeros(dim_x,P+1);          %xpre�� ״̬Ԥ��
    xpre(:,1)=x;                    %xpre(:,1)��ʾ��ǰ����ֵ
    upre=zeros(dim_u,P);            %������Ԥ��
    dw1_k_1=0;                      
    dw2_k_1=0;
    check=1;                        %ֹͣѧϰ��־
    loop=0;
   while check==1
         loop=loop+1;
    
        %% Ԥ��P��
         for i=1:P
              upre(:,i)=CONTROLLER_FORWARD_New(xpre(:,i),xset,v,W1_C,W2_C);      
              xpre(:,i+1)=MODEL_FORWARD_New(xpre(:,i),upre(:,i),v,W1_M,W2_M);                      
         end


         %% ��������м����
         lamda=zeros(dim_x,P+1);
         Q=zeros(dim_u,P);
         [n2,m2]=size(W2_C);
         [n1,m1]=size(W1_C);
         Sigma_dw1=zeros(n1,m1);               
         Sigma_dw2=zeros(n2,m2);  
         for i=P:-1:1  
            df_du=DF_DU_New(xpre(:,i+1),upre(:,i),v,W1_M,W2_M); 
            df_dx=DF_DX_New(xpre(:,i+1),upre(:,i),v,W1_M,W2_M);                
            dl_du=DL_DU_New(upre(:,i));     
            dl_dx=DL_DX_New(xpre(:,i+1),xset,alpha);                      
            Q(:,i)=df_du'*lamda(:,i+1)+dl_du';
            dg_dx_q=DG_DX_Q_New(xpre(:,i),xset,v,W1_C,W2_C,Q(:,i));    
            lamda(:,i)=df_dx'*lamda(:,i+1)+dl_dx'+dg_dx_q;

            [dg_dw_q1,dg_dw_q2]=DG_DW_Q_New(xpre(:,i),xset,v,W1_C,W2_C,Q(:,i)); 
            Sigma_dw1=Sigma_dw1+dg_dw_q1;        
            Sigma_dw2=Sigma_dw2+dg_dw_q2;  

         end

        %% ����Ȩֵ
        dw1=-Sigma_dw1*lr+gamma*dw1_k_1;
        dw2=-Sigma_dw2*lr+gamma*dw2_k_1;
        W1_C=W1_C+dw1;
        W2_C=W2_C+dw2;
        dw1_k_1=dw1;
        dw2_k_1=dw2;

        %% ��ֹ����
        flag_dw1=sum(abs(dw1(:)));
        flag_dw2=sum(abs(dw2(:)));
        if((abs(flag_dw1)>ep)||(abs(flag_dw2)>ep))&&(loop<maxEpoch)
                check=1;
          else
                check=0;
        end
        
    
   end
  %% ����
  u=CONTROLLER_FORWARD_New(x,xset,v,W1_C,W2_C); 
  W1 =W1_C;
  W2 =W2_C;
  

  
