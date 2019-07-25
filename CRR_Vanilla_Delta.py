import math
import numpy as np

def CRR_european_option_value(S0, K, T, r, sigma, otype, M=4):
    ''' Cox-Ross-Rubinstein European option valuation.
    Parameters
    ==========
    S0 : float
        stock/index level at time 0
    K : float
        strike price
    T : float
        date of maturity
    r : float
        constant, risk-less short rate
    sigma : float
        volatility
    otype : string
        either 'call' or 'put'
    M : int
        number of time intervals
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

    if otype == 'call':
        V = np.maximum(S - K, 0)  # inner values for European call option
    elif otype == 'put':
        V = np.maximum(K - S, 0)  # inner values for European put option

    for z in range(0, M):  # backwards iteration
        V[0:M - z, M - z - 1] = (q * V[0:M - z, M - z] +
                         (1 - q) * V[1:M - z + 1, M - z]) * df
    return V[0, 0]

def CRR_american_option_value(S0, K, T, r, sigma, otype, M=4):
    ''' Cox-Ross-Rubinstein American option valuation.
    Parameters
    ==========
    S0 : float
        stock/index level at time 0
    K : float
        strike price
    T : float
        date of maturity
    r : float
        constant, risk-less short rate
    sigma : float
        volatility
    otype : string
        either 'call' or 'put'
    M : int
        number of time intervals
    '''
    
    dt = T / M  # length of time interval
    df = math.exp(-r * dt)  # discount per interval
    inf = math.exp(r * dt)  # discount per interval

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

    if otype == 'call':
        V = np.maximum(S - K, 0)     
        oreturn = S - K
    elif otype == 'put':
        V = np.maximum(K - S, 0)       
        oreturn = K - S

    for z in range(0, M):  # backwards iteration
        ovalue = (q * V[0:M - z, M - z] +
                         (1 - q) * V[1:M - z + 1, M - z]) * df
        V[0:M - z, M - z - 1] = np.maximum(ovalue, oreturn[0:M - z, M - z - 1])
        
    return V[0, 0]

def CRR_american_option_delta(S0, K, T, r, sigma, otype, M=4):
    dt = T / M  # length of time interval
    u = math.exp(sigma * math.sqrt(dt))  # up movement
    d = 1 / u  # down movement
    S1 = S0 * u
    S2 = S0 * d
    fS1 = CRR_american_option_value(S1, K, T, r, sigma, otype, M)
    fS2 = CRR_american_option_value(S2, K, T, r, sigma, otype, M)
    delta = (fS1-fS2)/(S1-S2)
    return delta

def CRR_european_option_delta(S0, K, T, r, sigma, otype, M=4):
    dt = T / M  # length of time interval
    u = math.exp(sigma * math.sqrt(dt))  # up movement
    d = 1 / u  # down movement
    S1 = S0 * u
    S2 = S0 * d
    fS1 = CRR_european_option_value(S1, K, T, r, sigma, otype, M)
    fS2 = CRR_european_option_value(S2, K, T, r, sigma, otype, M)
    delta = (fS1-fS2)/(S1-S2)
    return delta


# input here
S0 = 3926  # index level
K = 3926  # option strike
T = 0.258196721  # maturity date
r = 0.02  # risk-less short rate
sigma = 0.1  # volatility
otype = 'put' # put or call
M = 1000 # number of steps

print('the american option delta is ' + str(CRR_american_option_delta(S0, K, T, r, sigma, otype, M)))
print('the european option delta is ' + str(CRR_european_option_delta(S0, K, T, r, sigma, otype, M)))