function outputArg = HeatPump_Step(inputArg)
    %disp('call HeatPump_Step')

    %type2：
    %assignin('base','compressor_wc', (inputArg + 1.0) / 2.0 * 130.0 + 0.01);
    %type3：
    new_compressor_wc = evalin('base', 'compressor_wc') + (inputArg) * 5.0;
    new_compressor_wc = max(new_compressor_wc, 0.01);
    new_compressor_wc = min(new_compressor_wc, 130);
    assignin('base','compressor_wc', new_compressor_wc);

    options = simset('SrcWorkspace','base','Solver','ode45');
    out = sim('H_P.slx',[0, 100], options);


    %disp('set compressor_wc')
    %disp(evalin('base', 'compressor_wc'));

    %update sim model state  积分
    assignin('base','tcw12',getdatasamples(out.tcw12, [get(out.tcw12).Length]));
    assignin('base','tc',getdatasamples(out.tc, [get(out.tcw12).Length]));
    assignin('base','h3',getdatasamples(out.h3, [get(out.tcw12).Length]));
    assignin('base','tew12',getdatasamples(out.tew12, [get(out.tcw12).Length]));
    assignin('base','te',getdatasamples(out.te, [get(out.tcw12).Length]));
    assignin('base','h1',getdatasamples(out.h1, [get(out.tcw12).Length]));
    
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

