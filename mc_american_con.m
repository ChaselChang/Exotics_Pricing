function [v, se] = mc_american_con(s0, r, q, sigma, T, m, K, n, cp, cs)

% american binary: cash or nothing plain monte-carlo.
% s0 - initial stock price; r - risk-free interest rate; q - dividend rate;
% sigma - volatility; T - terminal time; m - number of monitor dates;
% K - strike price;
% n - sample size; H - barrier; cp - 'c' for call, 'p' for put;
% cs - payment cash value.

t=[0: 1/m: 1] * T;  % m monitoring dates 

s(1) = s0; % initial stock price

    if cp == 'c' % call option
        for k=1:n    % loops to generate n sample paths and payoffs
            status = 0;
            for i=1:m  % generate the k-th path and payoff
                if s(i) >= K % if goes over the strike price
                    status = 1; % pay cash
                    repay = cs * exp(-r*t(i)); % pay now
                    break
                end
                z=randn;  % generate a sample from N(0,1)
                s(i+1) = s(i)*exp(((r - q)-0.5*sigma^2)*(t(i+1)-t(i))+sigma*sqrt(t(i+1)-t(i))*z);% stock price change
            end
            if status == 1 % if goes over the strike price
                x(k)=repay; % payoff cash immediately
            elseif status == 0 % if does not
                x(k)=0; % zero
            end
        end
        v=sum(x)/n;

        se = sqrt((sum(x.^2) - n*v^2)/n/(n-1));  % estimate of the standard error

        fprintf('\n v=%8.4e, se=%8.4e\n',v, se);

    elseif cp == 'p'
        for k=1:n    % loops to generate n sample paths and payoffs
            status = 0;
            for i=1:m  % generate the k-th path and payoff
                if s(i) <= K % if goes over the strike price
                    status = 1; % pay cash
                    repay = cs * exp(-r*t(i)); % pay now
                    break
                end
                z=randn;  % generate a sample from N(0,1)
                s(i+1) = s(i)*exp(((r - q)-0.5*sigma^2)*(t(i+1)-t(i))+sigma*sqrt(t(i+1)-t(i))*z);% stock price change
            end
            if status == 1 % if goes over the strike price
                x(k)=repay; % payoff cash immediately
            elseif status == 0 % if does not
                x(k)=0; % zero
            end
        end
        v=sum(x)/n;

        se = sqrt((sum(x.^2) - n*v^2)/n/(n-1));  % estimate of the standard error

        fprintf('\n v=%8.4e, se=%8.4e\n',v, se);
    end
end