function [accuracy]=BPN(TrainInput,TrainOutput,TestInput,TestOutput)

[row,column]=size(TrainInput');

hidden_node = round((row+1)/2); 

%hidden_node = 2;
net.trainParam.epochs=1000;
net.trainParam.lr=0.05;
net.trainParam.mc=0.05;
net = newff(TrainInput,TrainOutput,hidden_node);
net.trainParam.showWindow=0; 

net = train(net,TrainInput,TrainOutput);

Sim_TestOutput = sim(net,TestInput);

ceil_Sim_TestOutput=round(Sim_TestOutput);
corr_count=0;
for kk=1:length(Sim_TestOutput)
    if ceil_Sim_TestOutput(kk)==TestOutput(kk)
        corr_count=corr_count+1;
    end
end

accuracy=corr_count/length(Sim_TestOutput);

