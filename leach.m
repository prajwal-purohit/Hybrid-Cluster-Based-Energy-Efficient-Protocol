clc; clear; close all;

%% PARAMETERS
n = 100;                  % number of nodes
xm = 100; ym = 100;       % field size
sink.x = 50; sink.y = 175;% base station location
p = 0.1;                  % desired CH probability
rounds = 1000;             % number of rounds

E0 = 0.5;                 % initial energy (J)
ETX = 50e-9; ERX = 50e-9; % Tx/Rx energy
Efs = 10e-12; Emp = 0.0013e-12;
EDA = 5e-9;

do = sqrt(Efs/Emp);

%% NODE DEPLOYMENT
for i = 1:n
    S(i).x = rand * xm;
    S(i).y = rand * ym;
    S(i).E = E0;
    S(i).type = 'N';
    S(i).G = 0;   % ✅ Added: Eligibility flag for CH selection
end


dead = 0; CH_history = zeros(1,rounds); alive_nodes = zeros(1,rounds);

%% MAIN LEACH LOOP
for r = 1:rounds
    
    % Reset G every 1/p rounds (eligible to be CH)
    if mod(r, round(1/p)) == 0
        for i = 1:n, S(i).G = 0; end
    end
    
    % CH Selection
    CH = [];
    for i = 1:n
        if S(i).E > 0 && S(i).G == 0
            threshold = p / (1 - p * mod(r, round(1/p)));
            if rand <= threshold
                S(i).type = 'CH';
                S(i).G = 1;
                CH = [CH i];
            end
        end
    end
    
    CH_history(r) = length(CH);
    
    % Assign nodes to nearest CH
    for i = 1:n
        if S(i).E > 0 && ~strcmp(S(i).type,'CH')
            min_dist = inf;
            for j = CH
                temp = sqrt((S(i).x - S(j).x)^2 + (S(i).y - S(j).y)^2);
                if temp < min_dist
                    min_dist = temp; ch_id = j;
                end
            end
            
            % energy consume
            if min_dist > do
                S(i).E = S(i).E - (ETX*4000 + Emp*4000*(min_dist^4));
            else
                S(i).E = S(i).E - (ETX*4000 + Efs*4000*(min_dist^2));
            end
            
            % CH receives + aggregates
            S(ch_id).E = S(ch_id).E - (ERX*4000 + EDA*4000);
        end
    end
    
    % CH → Sink
    for j = CH
        distBS = sqrt((S(j).x - sink.x)^2 + (S(j).y - sink.y)^2);
        if distBS > do
            S(j).E = S(j).E - (ETX*4000 + Emp*4000*(distBS^4));
        else
            S(j).E = S(j).E - (ETX*4000 + Efs*4000*(distBS^2));
        end
    end
    
    %% Count alive nodes
    dead = sum([S.E] <= 0);
    alive_nodes(r) = n - dead;

    %% Plot
    clf; hold on;
    for i = 1:n
        if S(i).E > 0
            plot(S(i).x, S(i).y, 'go', 'MarkerSize',4,'MarkerFaceColor','g');
        else
            plot(S(i).x, S(i).y, 'rx','MarkerSize',6,'LineWidth',2);
        end
    end
    for j = CH
        plot(S(j).x, S(j).y,'bo','MarkerSize',8,'MarkerFaceColor','b');
    end
    plot(sink.x, sink.y,'ks','MarkerSize',10,'MarkerFaceColor','k');
    title(sprintf('LEACH Simulation – Round %d | Alive Nodes = %d', r, alive_nodes(r)));
    drawnow;
end

%% Plot Results
figure;
plot(alive_nodes,'LineWidth',2); grid on;
xlabel('Rounds'); ylabel('Alive Nodes');
title('Network Lifetime');

figure;
plot(CH_history,'LineWidth',2); grid on;
xlabel('Rounds'); ylabel('CH Count');
title('Cluster Heads per Round');