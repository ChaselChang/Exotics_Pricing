function [v, se] = mc_barrier_rebate(s0, r, q, sigma, T, m, K, n, H, cp, io, ud, rb, repay)

% european standard barier with a rebate plain monte carlo.
% s0 - initial stock price; r - risk-free interest rate; q - dividend rate
% sigma - volatility; T - terminal time; m - number of monitor dates;
% K - strike price;
% n - sample size; H - barrier; cp - 'c' for call, 'p' for put;
% io - 'i' for knock in, 'o' for knock out;
% ud - 'u' for up barrier, 'd' for down barrier;
% rb - rebate value;
% repay - string: 'imm' - immediate or 'def' - deferred, for rebate repayment time.

t=[0: 1/m: 1] * T;  % m monitoring dates 

s(1) = s0; % initial stock price
if cp == 'c' % call option
	if io == 'o' % knock out
        if ud == 'u' % upper barrier
            for k=1:n    % loops to generate n sample paths and payoffs
                status = 1; % stay in before get knocked out
                for i=2:m+1   % generate the k-th path and payoff  
                    z=randn;  % generate a sample from N(0,1)
                    s(i) = s(i-1)*exp(((r - q)-0.5*sigma^2)*(t(i)-t(i-1))+sigma*sqrt(t(i)-t(i-1))*z);% stock price change
                    if s(i) >= H % if goes over the barrier
                        status = 0; % knock out
                        imdis = exp(-r*t(i)); % record knocking out time discounting factor for rebate payment
                        break
                    end
                end

                if status == 1 % if did not get knocked out
                    x(k)=exp(-r*T)*max(s(m+1) -K,0); % payoff for the k-th path
                elseif status == 0 % if got knocked out
                    if repay == 'def'
                        x(k)=exp(-r*T) * rb; % deferred rebate payment
                    elseif repay == 'imm'
                        x(k)=imdis * rb; % immediate rebate patment
                    end
                end
            end
            v=sum(x)/n;

            se = sqrt((sum(x.^2) - n*v^2)/n/(n-1));  % estimate of the standard error

            fprintf('\n v=%8.4e, se=%8.4e\n',v, se);
            
        elseif ud == 'd'
            for k=1:n    % loops to generate n sample paths and payoffs
                status = 1;
                for i=2:m+1   % generate the k-th path and payoff  
                    z=randn;  % generate a sample from N(0,1)
                    s(i) = s(i-1)*exp(((r - q)-0.5*sigma^2)*(t(i)-t(i-1))+sigma*sqrt(t(i)-t(i-1))*z);
                    if s(i) <= H
                        status = 0; % knock out
                        imdis = exp(-r*t(i)); % record knocking out time discounting factor for rebate payment
                        break
                    end
                end

                if status == 1
                    x(k)=exp(-r*T)*max(s(m+1) -K,0); % payoff for the k-th path
                elseif status == 0
                    if repay == 'def'
                        x(k)=exp(-r*T) * rb; % deferred rebate payment
                    elseif repay == 'imm'
                        x(k)=imdis * rb; % immediate rebate patment
                    end
                end
            end
            v=sum(x)/n;

            se = sqrt((sum(x.^2) - n*v^2)/n/(n-1));  % estimate of the standard error

            fprintf('\n v=%8.4e, se=%8.4e\n',v, se);
        end
    elseif io == 'i'
        if ud == 'u'
            for k=1:n    % loops to generate n sample paths and payoffs
                status = 0;
                for i=2:m+1   % generate the k-th path and payoff  
                    z=randn;  % generate a sample from N(0,1)
                    s(i) = s(i-1)*exp(((r - q)-0.5*sigma^2)*(t(i)-t(i-1))+sigma*sqrt(t(i)-t(i-1))*z);
                    if s(i) >= H
                        status = 1; % knock in
                    end
                end

            if status == 1
                x(k)=exp(-r*T)*max(s(m+1) -K,0); % payoff for the k-th path
            elseif status == 0
                x(k)=exp(-r*T)*rb; % pay a deferred rebate if did not knock in
            end
            end
            v=sum(x)/n;

            se = sqrt((sum(x.^2) - n*v^2)/n/(n-1));  % estimate of the standard error

            fprintf('\n v=%8.4e, se=%8.4e\n',v, se);
            
        elseif ud == 'd'
            for k=1:n    % loops to generate n sample paths and payoffs
                status = 0;
                for i=2:m+1   % generate the k-th path and payoff  
                    z=randn;  % generate a sample from N(0,1)
                    s(i) = s(i-1)*exp(((r - q)-0.5*sigma^2)*(t(i)-t(i-1))+sigma*sqrt(t(i)-t(i-1))*z);
                    if s(i) <= H
                        status = 1; % knock in
                    end
                end

            if status == 1
                x(k)=exp(-r*T)*max(s(m+1) -K,0); % payoff for the k-th path
            elseif status == 0
                x(k)=exp(-r*T)*rb; % pay a deferred rebate if did not knock in
            end
            end
            v=sum(x)/n;

            se = sqrt((sum(x.^2) - n*v^2)/n/(n-1));  % estimate of the standard error

            fprintf('\n v=%8.4e, se=%8.4e\n',v, se);
        end
	end
elseif cp == 'p'
    if io == 'o'
        if ud == 'u'
            for k=1:n    % loops to generate n sample paths and payoffs
                status = 1;
                for i=2:m+1   % generate the k-th path and payoff  
                    z=randn;  % generate a sample from N(0,1)
                    s(i) = s(i-1)*exp(((r - q)-0.5*sigma^2)*(t(i)-t(i-1))+sigma*sqrt(t(i)-t(i-1))*z);
                    if s(i) >= H
                        status = 0; % knock out
                        imdis = exp(-r*t(i)); % record knocking out time discounting factor for rebate payment
                        break
                    end
                end

                if status == 1
                    x(k)=exp(-r*T)*max(-s(m+1) +K,0); % payoff for the k-th path
                elseif status == 0
                    if repay == 'def'
                        x(k)=exp(-r*T)*rb; % deferred rebate payment
                    elseif repay == 'imm'
                        x(k)=imdis * rb; % immediate rebate patment
                    end
                end
            end
            v=sum(x)/n;

            se = sqrt((sum(x.^2) - n*v^2)/n/(n-1));  % estimate of the standard error

            fprintf('\n v=%8.4e, se=%8.4e\n',v, se);
            
        elseif ud == 'd'
            for k=1:n    % loops to generate n sample paths and payoffs
                status = 1;
                for i=2:m+1   % generate the k-th path and payoff  
                    z=randn;  % generate a sample from N(0,1)
                    s(i) = s(i-1)*exp(((r - q)-0.5*sigma^2)*(t(i)-t(i-1))+sigma*sqrt(t(i)-t(i-1))*z);
                    if s(i) <= H
                        status = 0; % knock out
                        imdis = exp(-r*t(i)); % record knocking out time discounting factor for rebate payment
                        break
                    end
                end

                if status == 1
                    x(k)=exp(-r*T)*max(-s(m+1) +K,0); % payoff for the k-th path
                elseif status == 0
                    if repay == 'def'
                        x(k)=exp(-r*T)*rb; % deferred rebate payment
                    elseif repay == 'imm'
                        x(k)=imdis * rb; % immediate rebate patment
                    end
                end
            end
            v=sum(x)/n;

            se = sqrt((sum(x.^2) - n*v^2)/n/(n-1));  % estimate of the standard error

            fprintf('\n v=%8.4e, se=%8.4e\n',v, se);
        end
    elseif io == 'i'
        if ud == 'u'
            for k=1:n    % loops to generate n sample paths and payoffs
                status = 0;
                for i=2:m+1   % generate the k-th path and payoff  
                    z=randn;  % generate a sample from N(0,1)
                    s(i) = s(i-1)*exp(((r - q)-0.5*sigma^2)*(t(i)-t(i-1))+sigma*sqrt(t(i)-t(i-1))*z);
                     if s(i) >= H
                         status = 1; % knock in
                     end
                end

            if status == 1
                x(k)=exp(-r*T)*max(-s(m+1) +K,0); % payoff for the k-th path
            elseif status == 0
                x(k)=exp(-r*T)*rb;
            end
            end
            v=sum(x)/n;

            se = sqrt((sum(x.^2) - n*v^2)/n/(n-1));  % estimate of the standard error

            fprintf('\n v=%8.4e, se=%8.4e\n',v, se);
            
        elseif ud == 'd'
            for k=1:n    % loops to generate n sample paths and payoffs
                status = 0;
                for i=2:m+1   % generate the k-th path and payoff  
                    z=randn;  % generate a sample from N(0,1)
                    s(i) = s(i-1)*exp(((r - q)-0.5*sigma^2)*(t(i)-t(i-1))+sigma*sqrt(t(i)-t(i-1))*z);
                     if s(i) <= H
                         status = 1; % knock in
                     end
                end

            if status == 1
                x(k)=exp(-r*T)*max(-s(m+1) +K,0); % payoff for the k-th path
            elseif status == 0
                x(k)=exp(-r*T)*rb;
            end
            end
            v=sum(x)/n;

            se = sqrt((sum(x.^2) - n*v^2)/n/(n-1));  % estimate of the standard error

            fprintf('\n v=%8.4e, se=%8.4e\n',v, se);
        end
    end
end
