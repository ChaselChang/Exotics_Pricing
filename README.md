# Exotics_Pricing  

+ This repository is created and updated by [Tianshu Zhang](https://www.linkedin.com/in/tianshu-zhang-chasel/).

+ Please feel free to contact me via LinkedIn or by email: tz2437@columbia.edu.

Matlab:  
&#160;&#160;&#160;&#160;1. mc_double_barrier.m  
&#160;&#160;&#160;&#160;2. mc_barrier_rebate.m  
&#160;&#160;&#160;&#160;3. mc_american_con.m  
Python:  
&#160;&#160;&#160;&#160;4. CRR_Vanilla_Euro_Ameri.py  
&#160;&#160;&#160;&#160;5. CRR_Vanilla_Delta.py  
&#160;&#160;&#160;&#160;6. CRR_Maturity_Barrier_Delta.py  
Closed Formulae:  
&#160;&#160;&#160;&#160;7. Discussion on closed-form formulae of exotics mentioned above  

Here is some independent work of mine on option prcing and greeks calculation for dynamic hedge.  
These functions are **numerical pricing methods** employed to review and validate the closed-form formulae and models used in dynamic hedging system.  
More discussion on closed-form pricing formulae is being organized and will be updated.

## **1. mc_double_barrier.m：**

This function is a Monte-Carlo simulation pricing on multiple times monitoring Double Shark Option (european with rebate):  
    
Double Shark Option (DSO) is an option structured like this:  
					                
			      \	            /  
			       \           /  
	    Rebate1 ----------  \____0____/  ---------- Rebate2  
			     H1  K1      K2  H2  
	
monitored m times; when it is observed that <img src="https://latex.codecogs.com/gif.latex?S_t&space;\leq&space;H_1\&space;or\&space;S_t&space;\geq&space;H_2" title="S_t \leq H_1\ or\ S_t \geq H_2" />, the option gets knocked out;  
If the option did not get knocked untill maturirty date, the payment will ba made according to the structure graph.  
To price a standard double barrier option with single strike price, which is structured like:  
					                
			      \			
			       \          
	    Rebate1 ----------  \____0____---------- Rebate2  
			     H1  K1       H2  
						 
or  
						                
					    /  
					   /  
	    Rebate1 ------------ ____0____/  ---------- Rebate2  
			       H1        K2  H2  
						
Set <img src="https://latex.codecogs.com/gif.latex?K_2&space;\geq&space;H_2\&space;or\&space;K_1&space;\leq&space;H_1" title="K_2 \geq H_2\ or\ K_1 \leq H_1" /> to nullify them.  

Rebate payment time can be opted as "immediate" or "deferred" (immediate means pay as knocked; deferred means pay at maturity day).  
    
## **2. mc_barrier_rebate.m**

This function is a Monte-Carlo simulation pricing on multiple times monitoring Standard Barrier Option (european with rebate):  
    
Standard Barrier Option (SBO) is an option structured like this:  
    
					    /  
				           /  
	           0 _____________________/  ---------- Rebate  
				         K   H  
    
monitored m times; when it is observed that <img src="https://latex.codecogs.com/gif.latex?S_t&space;\leq&space;H_1\&space;or\&space;S_t&space;\geq&space;H_2" title="S_t \leq H_1\ or\ S_t \geq H_2" />, the option gets knocked out;  
If the option did not get knocked untill maturirty date, the payment will ba made according to the structure graph;  
For monitoring times m, for example, to daily observe an option with time to maturity = 61/244 (years), set m = 61;  
To only observe on maturity day, set m = 1.  

Rebate payment time can be opted as "immediate" or "deferred" (immediate means pay as knocked; deferred means pay at maturity day).  

## **3. mc_american_con.m**
    
This function is a Monte-Carlo simulation pricing on multiple times monitoring American cash-or-nothing Binary Option ("call" or "put"):  
    
"call" refers to options structured like this:  
    
	           0 _____________________---------- Cash_Payment  
			                  K  
    
"put" refers to options structured like this:  
    
              Cash_Payment -----------___________________ 0  
                                      K  
    
Rebate payment time can be opted as "immediate" or "deferred" (immediate means pay as knocked; deferred means pay at maturity day).  
    
## **4. CRR_Vanilla_Euro_Ameri.py**

This function is a Cox-Ross-Rubinstein Binomial Tree Simulation on American Vanilla Option using math and numpy package.  

## **5. CRR_Vanilla_Delta.py**

This function calculates Greeks of American vanilla by Finite Difference after Cox-Ross-Rubinstein Binomial Tree Simulation pricing;  
It uses math and numpy packages and works independently to 4. CRR_Vanilla_Euro&Ameri.py.  

## **6. CRR_Maturity_Barrier_Delta.py**

This function calculates prices Maturity-Monitor Barrier Option (European) with Cox-Ross-Rubinstein Binomial Tree Simulation;  
And it calculates its Greeks by Finite Difference.  
A Maturity-Monitor Barrier Option refers to a Barrier Option structured like section 2 while it is observed only once at its maturity day;  
If it does not get knocked out, it will be payed as European Vanilla option.  
It uses math and numpy packages.  
    
## **7. Discussion on closed-form formulae of exotics mentioned above**
	
### &#160;&#160;&#160;&#160; **7.1 standard barrier with rebate:**
&#160;&#160;&#160;&#160; Knocking out rebate payment can be made immediately or deferred (at maturity day).  
&#160;&#160;&#160;&#160; For immediate payment, see Ed. Haug, 'The Complete Guide to Option Pricing Formulas (2006 2nd edition)', 4.17.1；  
&#160;&#160;&#160;&#160; For deferred payment, it can be seen as a deferred-payment American cash-or-nothing Binary Option. See 7.4.
        
### &#160;&#160;&#160;&#160; **7.2 maturity-monitor barrier option with rebate:**
&#160;&#160;&#160;&#160; A maturity-monitor barrier option can be structured by European Vanilla, European cash-or-nothing Binary and European asset-or-nothing options.  

matu-barrier type | * | * | * | * | *   
---- | ---- | ---- | ---- | ---- | ----   
Up-Out-Call(H>K)= | Call @K | - AoN Call @H | + CoN Call @H (K+R)
Up-Out-Call(H<K)= | CoN Call @H (R)
Up-Out-Put(H>K)= | Put @K | + CoN Call @H (R)
Up-Out-Put(H<K)= | Put @K | + AoN Call @H | - AoN Call @K | - CoN Call @H (K) | + CoN Call @K (K) | + CoN Call @H (R)
Up-In-Call(H>K)= | Call @K | - AoN Call @K | + AoN Call @H | + CoN Call @K (K) | - CoN Call @H (K) | + CoN Put @H (R)
Up-In-Call(H<K)= | Call @K | + CoN Put @H (R)
Up-In-Put(H>K) = | CoN Put @H (R)
Up-In-Put(H<K) = | Put @K | + AoN Put @H | - CoN Put @H (K) | + CoN Put @H (R)
Down-Out-Call(H>K) = | Up-In-Call(H>K)
Down-Out-Call(H<K) = | Up-In-Call(H<K)
Down-Out-Put(H>K) = | Up-In-Put(H>K)
Down-Out-Put(H<K) = | Up-In-Put(H<K)
Down-In-Call(H>K) = | Up-Out-Call(H>K)
Down-In-Call(H<K) = | Up-Out-Call(H<K)
Down-In-Put(H>K) = | UP-Out-Put(H>K)
Down-In-Put(H<K) = | Up-Out-Put(H<K)

&#160;&#160;&#160;&#160; Interpretation on notations: Call @K denotes European Call Vanilla with strike price at K; AoN Call @H denotes European Call asset-or-nothing Binary with strike price at H; CoN Call @H (K) denotes European Call cash-or-nothing Binary with strike price at H and cash payment of K.  

### &#160;&#160;&#160;&#160; **7.3 double-shark barrier option with rebate:**
&#160;&#160;&#160;&#160; A DSO can be priced by taking it apart into two standard double barrier options (call and put) with single strike price together with an exotic American cash-or-nothing Binary with two strike prices and rebates;  
&#160;&#160;&#160;&#160; For Standard double barrier option see Ed. Haug, 'The Complete Guide to Option Pricing Formulas (2006 2nd edition)', 4.17.3.  
&#160;&#160;&#160;&#160; For American cash-or-nothing Binary see 7.4.

### &#160;&#160;&#160;&#160; **7.4 american cash or nothing:**
&#160;&#160;&#160;&#160; The cash payment can be made immediatly at trigerring or deferred to maturity day.  
#### &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; **7.4.1 Immediate Payment**
&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; See Ed. Haug, 'The Complete Guide to Option Pricing Formulas (2006 2nd edition)', 4.17.1, P.152, Formula F.
#### &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; **7.4.2 Deferred Payment**
&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; See 7.4.2.Implicit_Formulae_for_Rebate_and_American_Cash_or_Nothing_Pricing.pdf；  
&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; In this report I calculated the pdf and then cdf of stock price goes over barrier level in a particular time period by using Girsanov Theorem to transfer probability measures.
#### &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; **7.4.3 American cash-or-nothing Binary with two strike prices and rebates**
&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; See 7.4.3.Implicit_Formulae_for_Rebate_Part_of_Double_Barrier_Option.pdf;
&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; In this report I priced an exotic American cash-or-nothing Binary looks like this:  

	Cash_Payment 1 ------------_________---------- Cash_Payment 2  
			          K1        K2 
&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; By solving the Kolmogorov Equations of the process density function through Laplace transformation. Both immediate-payment and deferred-payment formulae are provided.
