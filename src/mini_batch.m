function [ WP, WB, WC, xcd, hck ] = mini_batch( data, T, B, C, K, alpha, lambda )
%MINI_BATCH Summary of this function goes here
%   Detailed explanation goes here
    D = size(data, 2);
    hck = rand(C, K);
    xcd = ones(C, D);    
    WB = normrnd(0, 0.01, 1, K);
    WC = normrnd(0, 0.01, 1, D);
    WP = normrnd(0, 0.01, D, K);
    data_size = size(data, 1);
    NB = floor(data_size / B);
    
    for i = 1:T
        t0 = clock;
        for b = 1:B
%            disp(b)
%            t1 = clock;
            gWC = zeros(1, D);
            gWB = zeros(1, K);
            gWP = zeros(D, K); 
            
            batch_index = 1+(b-1)*NB:b*NB;
            xd_b = data(batch_index, :);
            
            pk1 = 1 - 1.0 ./ (1+exp(ones(NB, 1) * WB + (WP' * xd_b')')); % NB * K
            gWC = gWC + sum(xd_b, 1);
            gWB = gWB + sum(pk1, 1);
            gWP = gWP + xd_b' * pk1;
            
            gWC2 = zeros(1, D);
            gWB2 = zeros(1, K);
            gWP2 = zeros(D, K);
            
            pk1_h_array = zeros(C, K);
            for c = 1:C
                pk0_x = 1.0 ./ (1+exp(WC + (WP*hck(c, :)')'));
                xcd(c, :) = ones(1, D);
                xcd(c, rand(1, D) < pk0_x) = 0;
                
                pk0_h = 1.0 ./ (1+exp(WB + (WP'*xcd(c, :)')'));
                hck(c, :) = ones(1, K);
                hck(c, rand(1, K) < pk0_h) = 0;
                
                pk1_h_array(c, :) = 1 -  pk0_h;                              
            end
            gWC2 = gWC2 + sum(xcd, 1);
            gWB2 = gWB2 + sum(pk1_h_array, 1);
            gWP2 = gWP2 + xcd' * pk1_h_array;
            
            WC = WC + alpha * (gWC/NB - gWC2/C - lambda * WC);
            WB = WB + alpha * (gWB/NB - gWB2/C - lambda * WB);
            WP = WP + alpha * (gWP/NB - gWP2/C - lambda * WP);
 %           disp(etime(clock, t1))
        end
        disp('New iteration:')
        disp(i)
        disp('One iteration time is:')
        disp(etime(clock, t0))
        
    end
end