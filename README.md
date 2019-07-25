# Exotics_Pricing  


Matlab:  
&#160;&#160;&#160;&#160;1. mc_double_barrier.m  
&#160;&#160;&#160;&#160;2. mc_barrier_rebate.m  
&#160;&#160;&#160;&#160;3. mc_american_con.m  
Python:  
&#160;&#160;&#160;&#160;4. CRR_Vanilla_Euro&Ameri.py  
&#160;&#160;&#160;&#160;5. CRR_Vanilla_Delta.py  
&#160;&#160;&#160;&#160;6. CRR_Maturity_Barrier&Delta.py  
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
    
## **4. CRR_Vanilla_Euro&Ameri.py**

This function is a Cox-Ross-Rubinstein Binomial Tree Simulation on American Vanilla Option using math and numpy package.  

## **5. CRR_Vanilla_Delta.py**

This function calculates Greeks of American vanilla by Finite Difference after Cox-Ross-Rubinstein Binomial Tree Simulation pricing;  
It uses math and numpy packages and works independently to 4. CRR_Vanilla_Euro&Ameri.py.  

## **6. CRR_Maturity_Barrier&Delta.py**

This function calculates prices Maturity-Monitor Barrier Option (European) with Cox-Ross-Rubinstein Binomial Tree Simulation;  
And it calculates its Greeks by Finite Difference.  
A Maturity-Monitor Barrier Option refers to a Barrier Option structured like section 2 while it is observed only once at its maturity day;  
If it does not get knocked out, it will be payed as European Vanilla option.  
It uses math and numpy packages.  
    
## **7. Discussion on closed-form formulae of exotics mentioned above**

### &#160;&#160;&#160;&#160; **7.1 double barrier:**  
&#160;&#160;&#160;&#160; It could be structured by two Standard Double Barrier Options with single strike price (put and call) together with two (Double Barrier) American cash-or-nothing Binary Options with strike prices equal to barriers of original option.  
&#160;&#160;&#160;&#160; For single strike price Standard Double Barrier Option pricing see Ed. Haug, 'The Complete Guide to Option Pricing Formulas (2006 2nd edition)', 4.17.3；  
&#160;&#160;&#160;&#160; American cash-or-nothing Binary Option see 7.3.  
        
	
### &#160;&#160;&#160;&#160; **7.2 standard barrier with rebate:**
&#160;&#160;&#160;&#160; Knocking out rebate payment can be made immediately or deferred (at maturity day).  
&#160;&#160;&#160;&#160; For immediate payment, see Ed. Haug, 'The Complete Guide to Option Pricing Formulas (2006 2nd edition)', 4.17.1；  
&#160;&#160;&#160;&#160; For deferred payment, it can be seen as a deferred-payment American cash-or-nothing Binary Option. See 7.3.
        
### &#160;&#160;&#160;&#160; **7.3 american cash or nothing:**
&#160;&#160;&#160;&#160; The cash payment can be made immediatly at trigerring or deferred to maturity day.  
#### &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; **7.3.1 Immediate Payment**
&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; See Ed. Haug, 'The Complete Guide to Option Pricing Formulas (2006 2nd edition)', 4.17.1, P.152, Formula F.
#### &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; **7.3.2 Deferred Payment**
&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; See 7.3.2.Implicit_Formulae_for_Rebate_and_American_Cash_or_Nothing_Pricing.pdf；  
&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; This report calculates the pdf and then cdf of stock price goes over barrier level in a particular time period by using Girsanov Theorem to transfer probability measures.



