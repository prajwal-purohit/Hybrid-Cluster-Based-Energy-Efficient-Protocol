clc;
clear;
close all;

%% ---------------- NETWORK PARAMETERS ----------------
n = 100;              % Number of nodes
field_x = 100;
field_y = 100;
sink.x = 50;          % Base station position
sink.y = 120;

p = 0.1;              % CH probability
k = round(n*p);       % Number of clusters

Eo = 0.5;             % Initial Energy (J)
Eelec = 50e-9;
Efs = 10e-12;
Emp = 0.0013e-12;
EDA = 5e-9;
packetLength = 4000;

do = sqrt(Efs/Emp);

rmax = 1000;           % Total rounds

%% ---------------- NODE DEPLOYMENT ----------------
for i = 1:n
    S(i).x = rand * field_x;
    S(i).y = rand * field_y;
    S(i).E = Eo;
    S(i).type = 'N';
    S(i).G = 0;
end

alive_nodes = zeros(1,rmax);

%% ================= MAIN LOOP =================
for r = 1:rmax

    % Reset CH eligibility every epoch
    if mod(r, round(1/p)) == 0
        for i = 1:n
            S(i).G = 0;
        end
    end

    %% --------- K-MEANS CLUSTERING ---------
    positions = [];
    alive_index = [];

    for i = 1:n
        if S(i).E > 0
            positions = [positions; S(i).x S(i).y];
            alive_index = [alive_index i];
        end
    end

    if size(positions,1) < k
        k = size(positions,1);
    end

    if k > 0
        [idx, C] = kmeans(positions, k);
    end

    % Reset types
    for i = 1:n
        S(i).type = 'N';
    end

    CH = [];
    ch_count = 0;

    %% --------- SELECT CH (Highest Energy in Cluster) ---------
    for cluster_id = 1:k
        cluster_nodes = alive_index(idx == cluster_id);

        if isempty(cluster_nodes)
            continue;
        end

        energies = [S(cluster_nodes).E];
        [~, max_index] = max(energies);
        ch_node = cluster_nodes(max_index);

        S(ch_node).type = 'C';
        CH = [CH ch_node];
        ch_count = ch_count + 1;
    end

    %% --------- ENERGY DISSIPATION ---------
    for i = 1:n
        if S(i).E <= 0
            continue;
        end

        if S(i).type == 'N'
            % Find nearest CH
            min_dist = inf;
            chosenCH = -1;

            for c = 1:length(CH)
                dist = sqrt((S(i).x - S(CH(c)).x)^2 + ...
                            (S(i).y - S(CH(c)).y)^2);
                if dist < min_dist
                    min_dist = dist;
                    chosenCH = CH(c);
                end
            end

            if chosenCH == -1
                continue;
            end

            d = min_dist;

            if d < do
                S(i).E = S(i).E - ...
                    (packetLength*(Eelec + Efs*d^2));
            else
                S(i).E = S(i).E - ...
                    (packetLength*(Eelec + Emp*d^4));
            end

        elseif S(i).type == 'C'
            % Receive data from members
            member_count = sum(idx == find(CH==i));

            S(i).E = S(i).E - ...
                (member_count * packetLength * (Eelec + EDA));

            % Send to Base Station
            dBS = sqrt((S(i).x - sink.x)^2 + ...
                       (S(i).y - sink.y)^2);

            if dBS < do
                S(i).E = S(i).E - ...
                    (packetLength*(Eelec + Efs*dBS^2));
            else
                S(i).E = S(i).E - ...
                    (packetLength*(Eelec + Emp*dBS^4));
            end
        end
    end

    %% --------- COUNT ALIVE NODES ---------
    alive = 0;
    for i = 1:n
        if S(i).E > 0
            alive = alive + 1;
        end
    end

    alive_nodes(r) = alive;

    %% ================= VISUALIZATION =================
    figure(1);
    clf;
    hold on;

    % Plot alive nodes
    for i = 1:n
        if S(i).E > 0 && S(i).type == 'N'
            plot(S(i).x, S(i).y, 'go','MarkerSize',5,...
                'HandleVisibility','off');
        end
    end

    % Plot CHs
    for c = 1:length(CH)
        if S(CH(c)).E > 0
            plot(S(CH(c)).x, S(CH(c)).y, 'r*',...
                'MarkerSize',10,'LineWidth',2,...
                'HandleVisibility','off');
        end
    end

    % Plot Dead Nodes
    for i = 1:n
        if S(i).E <= 0
            plot(S(i).x, S(i).y, 'kx','MarkerSize',8,...
                'LineWidth',2,'HandleVisibility','off');
        end
    end

    % Plot Base Station
    plot(sink.x, sink.y, 'bs','MarkerSize',12,...
        'MarkerFaceColor','b');

    % Draw ONLY CH → BS arrows
    for c = 1:length(CH)
        if S(CH(c)).E > 0
            plot([S(CH(c)).x sink.x],...
                 [S(CH(c)).y sink.y],...
                 'b','LineWidth',2,...
                 'HandleVisibility','off');
        end
    end

    title(['K-Means LEACH - Round ', num2str(r), ...
           ' | Alive Nodes: ', num2str(alive)]);
    xlim([0 field_x]);
    ylim([0 140]);
    grid on;
    drawnow;

end

%% ================= NETWORK LIFETIME GRAPH =================
figure;
plot(1:rmax, alive_nodes,'LineWidth',2);
xlabel('Round');
ylabel('Alive Nodes');
title('Network Lifetime');
grid on;