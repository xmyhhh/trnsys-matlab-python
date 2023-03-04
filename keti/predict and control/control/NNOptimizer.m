%***********************************************************************
% 函数: [u,xpre,W1,W2]= NNOptimizer(x,xset,v,param,W1_M,W2_M,W1_C,W2_C)
% 输入参数：
%   x 表示当前状态
%   xset 表示状态设定
%   v 表示扰动变量
%   param表示优化参数结构体
%   W1_M 模型权值矩阵1
%   W2_M 模型权值矩阵2
%   W1_C 控制器权值矩阵1
%   W2_C 控制器权值矩阵2
% 返回参数：
%   u：计算后优化控制量（0-1）
%   xpre 表示状态变量预测值， 
%   xpre(:,1)表示当前时刻，xpre(:,2：P+1)表:1~P步预测
%   W1,控制器更新后权值1
%   W2,控制器更新后权值2
%**********************************************************************
%   param:优化参数结构体
    %--------------------------------------------------------
    %             P             |   预测步数
    %--------------------------------------------------------
    %             maxEpoch      |   最大迭代次数
    %--------------------------------------------------------
    %             ep            |   精度
    %--------------------------------------------------------
    %             alpha         |   性能指标权系数
    %--------------------------------------------------------
    %             gamma         |   动量因子
    %--------------------------------------------------------
    %              lr           |    学习率
    %--------------------------------------------------------

    

function [u,xpre,W1,W2]= NNOptimizer(x,xset,v,param,W1_M,W2_M,W1_C,W2_C)

    %% 参数
    P=param.P;                  %步长
    maxEpoch=param.maxEpoch;    %最大迭代步数
    ep=param.ep;                %目标精度
    alpha=param.alpha;          %状态权重系数
    gamma=param.gamma;          %动量因子
    lr=param.lr;                %学习率
    
    %% 初始化
%     global xpre  
    dim_x=length(x);                %dim_x，状态变量数目
    [dim_u,p]=size(W2_C);           %dim_u，控制变量数目
    xpre=zeros(dim_x,P+1);          %xpre， 状态预测
    xpre(:,1)=x;                    %xpre(:,1)表示当前反馈值
    upre=zeros(dim_u,P);            %控制量预测
    dw1_k_1=0;                      
    dw2_k_1=0;
    check=1;                        %停止学习标志
    loop=0;
   while check==1
         loop=loop+1;
    
        %% 预测P步
         for i=1:P
              upre(:,i)=CONTROLLER_FORWARD_New(xpre(:,i),xset,v,W1_C,W2_C);      
              xpre(:,i+1)=MODEL_FORWARD_New(xpre(:,i),upre(:,i),v,W1_M,W2_M);                      
         end


         %% 反向计算中间变量
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

        %% 更新权值
        dw1=-Sigma_dw1*lr+gamma*dw1_k_1;
        dw2=-Sigma_dw2*lr+gamma*dw2_k_1;
        W1_C=W1_C+dw1;
        W2_C=W2_C+dw2;
        dw1_k_1=dw1;
        dw2_k_1=dw2;

        %% 终止条件
        flag_dw1=sum(abs(dw1(:)));
        flag_dw2=sum(abs(dw2(:)));
        if((abs(flag_dw1)>ep)||(abs(flag_dw2)>ep))&&(loop<maxEpoch)
                check=1;
          else
                check=0;
        end
        
    
   end
  %% 返回
  u=CONTROLLER_FORWARD_New(x,xset,v,W1_C,W2_C); 
  W1 =W1_C;
  W2 =W2_C;
  

  
