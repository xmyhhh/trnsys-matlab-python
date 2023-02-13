function outputArg = HeatPump_Init(inputArg)
    %disp('call HeatPump_Init')

    assignin('base','tcw12',70);
    assignin('base','tc',50);
    assignin('base','h3',260);
    assignin('base','tew12',20);
    assignin('base','te',5);
    assignin('base','h1',410);

    assignin('base','Te_in',12);   %蒸发器进水温度
    assignin('base','Ge_in',14);   %蒸发器进水流量 = 蒸发器出水流量
    assignin('base','Tc_in',35);   %冷凝器进水温度
    assignin('base','Gc_in',8);    %冷凝器进水流量 = 冷凝器出水流量

    assignin('base','compressor_wc', 0.0001);

    options = simset('SrcWorkspace','base','Solver','ode45');
    out = sim('H_P.slx',[0, 0.001], options);


    outputArg(1) = getdatasamples(out.pc, [get(out.tcw12).Length]);
    outputArg(2) = getdatasamples(out.tcw2, [get(out.tcw12).Length]);
    outputArg(3) = getdatasamples(out.h3, [get(out.tcw12).Length]);
    outputArg(4) = getdatasamples(out.Qc, [get(out.tcw12).Length]);
    outputArg(5) = getdatasamples(out.tew2, [get(out.tcw12).Length]);
    outputArg(6) = getdatasamples(out.pe, [get(out.tcw12).Length]);
    outputArg(7) = getdatasamples(out.h1, [get(out.tcw12).Length]);
    outputArg(8) = getdatasamples(out.vd, [get(out.tcw12).Length]);
    outputArg(9) = getdatasamples(out.Qe, [get(out.tcw12).Length]);

end

