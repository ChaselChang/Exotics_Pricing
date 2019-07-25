function [v, se] = mc_double_barrier(s0, r, q, sigma, T, m, K1, K2, n, H1, H2, rb1, rb2, repay)

% european double barrier with call & put strikes plain monte carlo.
% s0 - initial stock price; r - risk-free interest rate; q - dividend rate
% sigma - volatility; T - terminal time; m - number of monitor dates;
% K1 < K2 - strike prices, where K1 for put, K2 for call;
% when there is only K1, set the call strike K2 > H2 to make it null;
% when there is only K2, set the put strike K1 < H1 to make it null;
% n - sample size; H1 < H2 - barriers, where H1 < K1 < S < K2 < H2;
% rb1, rb2 - rebate values, where rb1 for knock out from H1, rb2 for H2;
% repay - string: 'imm' - immediate or 'def' - deferred, for rebate repayment time.

t=[0: 1/m: 1] * T;  % m monitoring dates 

s(1) = s0; % initial stock price

for k=1:n    % loops to generate n sample paths and payoffs
    status = 0; % stay in before get knocked out
    for i = 2:m+1   % generate the k-th path and payoff  
        z = randn;  % generate a sample from N(0,1)
        s(i) = s(i-1)*exp(((r - q)-0.5*sigma^2)*(t(i)-t(i-1))+sigma*sqrt(t(i)-t(i-1))*z);% stock price change
        if s(i) <= H1 % if Si goes lower than left barrier
            status = 1; % knock out from left
            imdis = exp(-r*t(i)); % record knocking out time discounting factor for rebate payment
            break
        elseif s(i) >= H2 % if Si goes higher than right barrier
            status = 2; % knock out from right
            imdis = exp(-r*t(i)); % record knocking out time discounting facotr for rebate payment
            break
        end
    end

if status == 0 % if did not get knocked out
    x(k)=exp(-r*T)*max([K1 - s(m+1), s(m+1) - K2,0]); % payoff for the k-th path
    elseif status == 1 % if got knocked out from left
        if repay == 'def'
            x(k)=exp(-r*T)*rb1; % deferred rebate payment 1
        elseif repay == 'imm'
            x(k)=imdis * rb1; % immediate rebate patment 1
        end
    elseif status == 2 % if got knocked out from right
        if repay == 'def'
            x(k)=exp(-r*T)*rb2; % deferred rebate payment 2
        elseif repay == 'imm'
            x(k)=imdis * rb2; % immediate rebate patment 2
        end
    end
end
v=sum(x)/n;

se = sqrt((sum(x.^2) - n*v^2)/n/(n-1));  % estimate of the standard error

fprintf('\n v=%8.4e, se=%8.4e\n',v, se);