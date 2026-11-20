clc;
clear;
close all;

%% ================= PARAMETERS =================
n=100;
xm=100; 
ym=100;

sink.x=50; 
sink.y=150;

Eo=0.5;
p=0.1;

ETX=50e-9; 
ERX=50e-9;

Efs=10e-12; 
Emp=0.0013e-12;

EDA=5e-9;

packetLength=4000;

do=sqrt(Efs/Emp);

%% ================= NODE DEPLOYMENT =================
for i=1:n
    
    H(i).xd=rand*xm;
    H(i).yd=rand*ym;
    
    H(i).E=Eo;
    H(i).cluster=0;
    
end

%% ================= FUZZY AI SYSTEM =================
fis = mamfis('Name','HybridAI');

% Energy input
fis = addInput(fis,[0 Eo],'Name','Energy');
fis = addMF(fis,'Energy','trimf',[0 0 Eo/2],'Name','low');
fis = addMF(fis,'Energy','trimf',[Eo/4 Eo Eo],'Name','high');

% Distance input
fis = addInput(fis,[0 200],'Name','Distance');
fis = addMF(fis,'Distance','trimf',[0 0 100],'Name','near');
fis = addMF(fis,'Distance','trimf',[80 200 200],'Name','far');

% Output
fis = addOutput(fis,[0 1],'Name','Decision');
fis = addMF(fis,'Decision','trimf',[0 0 0.5],'Name','sleep');
fis = addMF(fis,'Decision','trimf',[0.5 1 1],'Name','active');

ruleList=[ ...
    1 2 1 1 1;
    1 1 1 1 1;
    2 1 2 1 1;
    2 2 2 1 1];

fis=addRule(fis,ruleList);

%% ================= AI BASED CH SELECTION =================
decisionScore=zeros(1,n);

for i=1:n

    dSink=sqrt((H(i).xd-sink.x)^2 + (H(i).yd-sink.y)^2);

    % Normalize distance (important)
    dNorm=dSink/200;

    decisionScore(i)=evalfis(fis,[H(i).E dNorm*200]);

end

[~,index]=sort(decisionScore,'descend');

numCH=round(p*n);

CH=index(1:numCH);

%% ================= CLUSTER FORMATION =================
for i=1:n
    
    if any(i==CH)
        continue
    end
    
    minDist=inf;
    
    for j=1:length(CH)
        
        c=CH(j);
        
        d=sqrt((H(i).xd-H(c).xd)^2 + (H(i).yd-H(c).yd)^2);
        
        if d<minDist
            
            minDist=d;
            H(i).cluster=c;
            
        end
        
    end
    
end

%% ================= NODE → CH ENERGY =================
for i=1:n
    
    if any(i==CH)
        continue
    end
    
    dCH=sqrt((H(i).xd-H(H(i).cluster).xd)^2 + ...
             (H(i).yd-H(H(i).cluster).yd)^2);
         
    if dCH<do
        
        energy=ETX*packetLength + Efs*packetLength*dCH^2;
        
    else
        
        energy=ETX*packetLength + Emp*packetLength*dCH^4;
        
    end
    
    H(i).E=H(i).E-energy;
    
end

%% ================= MULTI HOP ROUTING =================
CH_links=[];

for j=1:length(CH)
    
    id=CH(j);
    
    dSink=sqrt((H(id).xd-sink.x)^2 + (H(id).yd-sink.y)^2);
    
    minDist=dSink;
    
    nextHop=0;
    
    for k=1:length(CH)
        
        if j==k
            continue
        end
        
        otherID=CH(k);
        
        dCH=sqrt((H(id).xd-H(otherID).xd)^2 + ...
                 (H(id).yd-H(otherID).yd)^2);
             
        dOtherSink=sqrt((H(otherID).xd-sink.x)^2 + ...
                        (H(otherID).yd-sink.y)^2);
        
        if dOtherSink<dSink && dCH<minDist
            
            minDist=dCH;
            nextHop=otherID;
            
        end
        
    end
    
    if nextHop==0
        
        CH_links=[CH_links; id -1];
        
    else
        
        CH_links=[CH_links; id nextHop];
        
    end
    
end

%% ================= VISUALIZATION =================
figure;
hold on;

% Plot Nodes
xNodes=[H.xd];
yNodes=[H.yd];

h1=plot(xNodes,yNodes,'bo');

% Plot Cluster Heads
for j=1:length(CH)
    
    id=CH(j);
    
    h2=plot(H(id).xd,H(id).yd,'r*','MarkerSize',12);
    
end

% Plot Sink
h3=plot(sink.x,sink.y,'ks','MarkerSize',14,'MarkerFaceColor','k');

% Node → CH links
for i=1:n
    
    if H(i).cluster>0
        
        plot([H(i).xd H(H(i).cluster).xd], ...
             [H(i).yd H(H(i).cluster).yd],'b-');
        
    end
    
end

% CH → CH / Sink links
for i=1:size(CH_links,1)
    
    from=CH_links(i,1);
    to=CH_links(i,2);
    
    if to==-1
        
        plot([H(from).xd sink.x], ...
             [H(from).yd sink.y],'g--','LineWidth',2);
         
    else
        
        plot([H(from).xd H(to).xd], ...
             [H(from).yd H(to).yd],'g--','LineWidth',2);
         
    end
    
end

title(['AI CH Scheduling']);

xlabel('X (m)');
ylabel('Y (m)');

legend([h1 h2 h3],'Nodes','Cluster Heads','Sink');

grid on;