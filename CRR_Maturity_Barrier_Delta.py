import math
import numpy as np

def CRR_european_option_value(S0, K, H, T, r, sigma, rb, cp, ud, io, M=4):
    ''' Cox-Ross-Rubinstein European option valuation.
    Parameters
    ==========
    S0 : float
        stock/index level at time 0
    K : float
        strike price
    H : float
        barrier level
    T : float
        date of maturity
    r : float
        constant, risk-less short rate
    sigma : float
        volatility
    rb : float
        rebate payment amount
    cp : string
        either 'call' or 'put'
    ud : string
        either 'up' or 'down'
    io : string
        either 'in' or 'out'
    M : int
        number of time intervals
    '''

    ''' Observed only once at its maturity day; If does not get knocked out, it will be payed as European Vanilla option.
    '''
    dt = T / M  # length of time interval
    df = math.exp(-r * dt)  # discount per interval


    u = math.exp(sigma * math.sqrt(dt))  # up movement
    d = 1 / u  # down movement
    q = (math.exp(r * dt) - d) / (u - d)  # martingale branch probability

    #initialization
    mu = np.arange(M + 1)
    mu = np.resize(mu, (M + 1, M + 1))

    md = np.transpose(mu)

    mu = u ** (mu - md)
    md = d ** md

    S = S0 * mu * md

    if cp == 'call':
        V = np.maximum(S - K, 0)  # inner values for European call option
        if ud == 'up':
            if io == 'in':
                for i in range(0, M):
                    if S[i,M] < H:
                        V[i,M] = rb
            elif io == 'out':
                for i in range(0, M):
                    if S[i,M] >= H:
                        V[i,M] = rb
        elif ud == 'down':
            if io == 'in':
                for i in range(0, M):
                    if S[i,M] > H:
                        V[i,M] = rb
            elif io == 'out':
                for i in range(0, M):
                    if S[i,M] <= H:
                        V[i,M] = rb
            
    elif cp == 'put':
        V = np.maximum(K - S, 0)  # inner values for European put option
        if ud == 'up':
            if io == 'in':
                for i in range(0, M):
                    if S[i,M] < H:
                        V[i,M] = rb
            elif io == 'out':
                for i in range(0, M):
                    if S[i,M] >= H:
                        V[i,M] = rb
        elif ud == 'down':
            if io == 'in':
                for i in range(0, M):
                    if S[i,M] > H:
                        V[i,M] = rb
            elif io == 'out':
                for i in range(0, M):
                    if S[i,M] <= H:
                        V[i,M] = rb
                        
    for z in range(0, M):  # backwards iteration
        V[0:M - z, M - z - 1] = (q * V[0:M - z, M - z] +
                         (1 - q) * V[1:M - z + 1, M - z]) * df
    return V[0, 0]

def CRR_european_option_delta(S0, K, H, T, r, sigma, rb, cp, ud, io, M=4):
    dt = T / M  # length of time interval
    u = math.exp(sigma * math.sqrt(dt))  # up movement
    d = 1 / u  # down movement
    S1 = S0 * u
    S2 = S0 * d
    fS1 = CRR_european_option_value(S1, K, H, T, r, sigma, rb, cp, ud, io, M)
    fS2 = CRR_european_option_value(S2, K, H, T, r, sigma, rb, cp, ud, io, M)
    delta = (fS1-fS2)/(S1-S2)
    return delta


# input here
S0 = 3926  # index level
K = 4000  # option strike
H = 4000 # barrier level
T = 0.180327869  # maturity date
r = 0.02  # risk-less short rate
sigma = 0.1  # volatility
rb = 0 # rebate payment
cp = 'put' # put or call
ud = 'up'
io = 'out'
M = 10000 # number of steps

print('option premium is ' + str(CRR_european_option_value(S0, K, H, T, r, sigma, rb, cp, ud, io, M)))
print('option delta is ' + str(CRR_european_option_delta(S0, K, H, T, r, sigma, rb, cp, ud, io, M)))