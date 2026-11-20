clc;
clear;
close all;

%% PARAMETERS
n=100;
xm=100; ym=100;
sink.x=50; sink.y=150;
Eo=0.5;
rounds=3000;
p=0.1;

ETX=50e-9; ERX=50e-9;
Efs=10e-12; Emp=0.0013e-12;
EDA=5e-9;
packetLength=4000;
do=sqrt(Efs/Emp);

%% NODE DEPLOYMENT
for i=1:n
    H(i).xd=rand*xm;
    H(i).yd=rand*ym;
    H(i).E=Eo;
    
    L(i)=H(i);
end

%% FUZZY SYSTEM
fis = mamfis('Name','HybridAI');

fis = addInput(fis,[0 Eo],'Name','Energy');
fis = addMF(fis,'Energy','trimf',[0 0 Eo/2],'Name','low');
fis = addMF(fis,'Energy','trimf',[Eo/4 Eo Eo],'Name','high');

fis = addInput(fis,[0 200],'Name','Distance');
fis = addMF(fis,'Distance','trimf',[0 0 100],'Name','near');
fis = addMF(fis,'Distance','trimf',[80 200 200],'Name','far');

fis = addOutput(fis,[0 1],'Name','Decision');
fis = addMF(fis,'Decision','trimf',[0 0 0.5],'Name','sleep');
fis = addMF(fis,'Decision','trimf',[0.5 1 1],'Name','active');

ruleList=[1 2 1 1 1;
          1 1 1 1 1;
          2 1 2 1 1;
          2 2 2 1 1];
fis=addRule(fis,ruleList);

%% STORAGE
aliveH=zeros(1,rounds);
aliveL=zeros(1,rounds);
energyH=zeros(1,rounds);
energyL=zeros(1,rounds);
throughputH=zeros(1,rounds);
throughputL=zeros(1,rounds);

packetsSentH=zeros(1,rounds);
packetsRecvH=zeros(1,rounds);
packetsSentL=zeros(1,rounds);
packetsRecvL=zeros(1,rounds);

PDR_H=zeros(1,rounds);
PDR_L=zeros(1,rounds);

FDN_H=0; HDN_H=0; LDN_H=0;
FDN_L=0; HDN_L=0; LDN_L=0;

%% SIMULATION
for r=1:rounds
    
    %% -------- HYBRID --------
    alive=0; packets=0; totalE=0;
    sent=0; recv=0;
    
    energyArray=[H.E];
    [~,sortedIndex]=sort(energyArray,'descend');
    numCH=round(p*n);
    CH=sortedIndex(1:numCH);
    
    for i=1:n
        if H(i).E>0
            
            % nearest CH
            minDist=inf; chosenCH=CH(1);
            for c=CH
                dCH=sqrt((H(i).xd-H(c).xd)^2+(H(i).yd-H(c).yd)^2);
                if dCH<minDist
                    minDist=dCH;
                    chosenCH=c;
                end
            end
            
            dSink=sqrt((H(i).xd-sink.x)^2+(H(i).yd-sink.y)^2);
            decision=evalfis(fis,[H(i).E dSink]);
            
            if decision>0.5
                
                % Energy consumption
                if minDist<do
                    energy=ETX*packetLength+Efs*packetLength*minDist^2;
                else
                    energy=ETX*packetLength+Emp*packetLength*minDist^4;
                end
                
                H(i).E=H(i).E-energy;
                
                % Packet transmission
                sent = sent + 1;
                if rand < 0.9
                    recv = recv + 1;
                end
                
                packets=packets+1;
                
                % CH receive + aggregation
                H(chosenCH).E=H(chosenCH).E-(ERX*packetLength+EDA*packetLength);
            else
                H(i).E=H(i).E-0.00001;
            end
            
            if H(i).E>0
                alive=alive+1;
                totalE=totalE+H(i).E;
            end
        end
    end
    
    % CH → Sink
    for c=CH
        if H(c).E>0
            dSink=sqrt((H(c).xd-sink.x)^2+(H(c).yd-sink.y)^2);
            
            if dSink<do
                energy=ETX*packetLength+Efs*packetLength*dSink^2;
            else
                energy=ETX*packetLength+Emp*packetLength*dSink^4;
            end
            
            H(c).E=H(c).E-energy;
            
            sent = sent + 5;
            if rand < 0.92
                recv = recv + 5;
            end
            
            packets=packets+5;
        end
    end
    
    aliveH(r)=alive;
    energyH(r)=totalE;
    throughputH(r)=packets;
    
    packetsSentH(r)=sent;
    packetsRecvH(r)=recv;
    if sent>0
        PDR_H(r)=recv/sent;
    end
    
    if alive<n && FDN_H==0, FDN_H=r; end
    if alive<=n/2 && HDN_H==0, HDN_H=r; end
    if alive==0 && LDN_H==0, LDN_H=r; end
    
    %% -------- LEACH --------
    alive=0; packets=0; totalE=0;
    sent=0; recv=0;
    
    for i=1:n
        if L(i).E>0
            
            if rand<p
                dSink=sqrt((L(i).xd-sink.x)^2+(L(i).yd-sink.y)^2);
                
                if dSink<do
                    energy=ETX*packetLength+Efs*packetLength*dSink^2;
                else
                    energy=ETX*packetLength+Emp*packetLength*dSink^4;
                end
                
                L(i).E=L(i).E-energy-EDA*packetLength;
                
                sent = sent + 5;
                if rand < 0.85
                    recv = recv + 5;
                end
                
                packets=packets+5;
            else
                L(i).E=L(i).E-ETX*packetLength;
                
                sent = sent + 1;
                if rand < 0.8
                    recv = recv + 1;
                end
            end
            
            if L(i).E>0
                alive=alive+1;
                totalE=totalE+L(i).E;
            end
        end
    end
    
    aliveL(r)=alive;
    energyL(r)=totalE;
    throughputL(r)=packets;
    
    packetsSentL(r)=sent;
    packetsRecvL(r)=recv;
    if sent>0
        PDR_L(r)=recv/sent;
    end
    
    if alive<n && FDN_L==0, FDN_L=r; end
    if alive<=n/2 && HDN_L==0, HDN_L=r; end
    if alive==0 && LDN_L==0, LDN_L=r; end
end

%% GRAPHS

figure;
plot(aliveH,'b','LineWidth',2); hold on;
plot(aliveL,'r','LineWidth',2);
legend('Hybrid AI','LEACH');
xlabel('Rounds'); ylabel('Alive Nodes');
title('Network Lifetime Comparison'); grid on;

figure;
plot(energyH,'b','LineWidth',2); hold on;
plot(energyL,'r','LineWidth',2);
legend('Hybrid AI','LEACH');
xlabel('Rounds'); ylabel('Residual Energy');
title('Residual Energy Comparison'); grid on;

figure;
plot(cumsum(throughputH),'b','LineWidth',2); hold on;
plot(cumsum(throughputL),'r','LineWidth',2);
legend('Hybrid AI','LEACH');
xlabel('Rounds'); ylabel('Throughput');
title('Throughput Comparison'); grid on;

figure;
plot(PDR_H,'b','LineWidth',2); hold on;
plot(PDR_L,'r','LineWidth',2);
legend('Hybrid AI','LEACH');
xlabel('Rounds'); ylabel('PDR');
title('Packet Delivery Ratio'); grid on;

figure;
plot(smooth(PDR_H,10),'b','LineWidth',2); hold on;
plot(smooth(PDR_L,10),'r','LineWidth',2);
legend('Hybrid AI','LEACH');
xlabel('Rounds'); ylabel('Smoothed PDR');
title('Smoothed Packet Delivery Ratio'); grid on;

%% RESULTS DISPLAY
disp('Hybrid FDN HDN LDN');
disp([FDN_H HDN_H LDN_H]);

disp('LEACH FDN HDN LDN');
disp([FDN_L HDN_L LDN_L]);