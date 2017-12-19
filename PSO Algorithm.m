clc
clear
close all
load 'IR_DATASET'
%sim('test_16a.slx');
New_IR_Change(1)=IR(1);
Time_Change(1)=TI(1);
aa=2;
for ii=1:length(IR)-1
    if ((IR(ii+1)-IR(ii))~=0)
        New_IR_Change(aa)=IR(ii+1);
        Time_Change(aa)=TI(ii+1);
        aa=aa+1;
    end
end
for ii=1:length(New_IR_Change)
    set_param('test_16a/Constant','Value',num2str(New_IR_Change(ii)));     
    par=20:10:60;
    for jj=1:length(par)
        set_param('test_16a/Pulse Generator','PulseWidth',num2str(par(jj)));
        sim('test_16a.slx');
        Final_Cost(jj)=max(cost);
    end
    Global_Cost=max(Final_Cost);
    Global_Duty=find(Global_Cost==Final_Cost);
    Duty_Cycle=par(Global_Duty);
    UpDate_DC=(Duty_Cycle-4:Duty_Cycle+4);
    ou=sprintf('The Initial Duty Cycle is %d \n',Duty_Cycle);
    mydialog(ou)
    
    %   UpDate_DC=(Duty_Cycle-9:Duty_Cycle+9);
    for jj=1:length(UpDate_DC)
        set_param('test_16a/Pulse Generator','PulseWidth',num2str(UpDate_DC(jj)));
        sim('test_16a.slx');
        New_Final_Cost(jj)=max(cost);
    end
    New_Global_Cost=max(New_Final_Cost);
New_Global_Cost_Final(ii)=max(New_Final_Cost);
    New_Global_Duty=find(New_Global_Cost==New_Final_Cost);
    New_Duty_Cycle=UpDate_DC(New_Global_Duty);
    ou1=sprintf('The Exact Duty Cycle at Maximum Power is %d \n',New_Duty_Cycle)
    mydialog(ou1)
end

%for ll=1:length(New_Global_Cost)
    %stairs(Time_Change,New_Global_Cost)
    NEW_POW=zeros(size(IR));
for pp=1:length(New_IR_Change)
    AN=New_IR_Change(pp)==IR;
    NEW_POW(AN)=New_Global_Cost_Final(pp);
end
%figure;plot(TI,NEW_POW)
figure;stairs(TI,NEW_POW)
figure;stem(TI,NEW_POW)