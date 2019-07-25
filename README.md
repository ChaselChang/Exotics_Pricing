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
    
此函数是对于多次观察的现金偿付美式二元期权（ameriacan cash-or-nothing）的蒙特卡洛模拟定价；
包含有'call'与'put'两种偿付形式。
    
'call'指代有以下收益结构的期权：
    
	           0 _____________________---------- Cash_Payment
			                  K
    
'put'则指代有以下收益结构的期权：
    
              Cash_Payment -----------___________________ 0
                                      K
    
Cash偿付时间可选敲出时立即偿付与延时偿付（即在原先约定的maturity时偿付）。
    
## **4. CRR_Vanilla_Euro&Ameri.py**

此函数是对于香草的欧式与美式期权使用Cox-Ross-Rubinstein理论的二叉树模拟定价；
使用math与numpy包裹。

## **5. CRR_Vanilla_Delta.py**

此函数是使用上面CRR_Vanilla_Euro&Ameri.py中函数定价欧式与美式香草后；
使用有限差分计算delta值的函数；
使用math与numpy包裹；可以脱离CRR_Vanilla_Euro&Ameri.py独立运行。

## **6. CRR_Maturity_Barrier&Delta.py**

此函数是对于到期观察一次的欧式障碍期权使用Cox-Ross-Rubinstein理论的二叉树模拟定价并有限差分计算其delta；
到期观察一次，指对于2中同样的收益结构的，观察在且仅在maturity时进行一次，敲出则偿付Rebate，未敲出则欧式结算。
使用math与numpy包裹。
    
## **7. Discussion on closed-form formulae of exotics mentioned above**

###**&#160;&#160;&#160;&#160;7.1 double barrier:** 
&#160;&#160;&#160;&#160;可以由两个单行权价的标准双障碍期权与两个行权价分别等于两边障碍的看涨与看跌美式二元期权（cash or nothing）组合成；
&#160;&#160;&#160;&#160;单行权价的标准双障碍期权价格参见Ed. Haug, 'The Complete Guide to Option Pricing Formulas (2006 2nd edition)', 4.17.3；
&#160;&#160;&#160;&#160;美式二元期权（cash or nothing）参见下文。
        
&#160;&#160;&#160;&#160;注：实际使用这个结构定价双鲨期权时，daily观察的情况下会与1中蒙特卡洛方法定价的结果有一定出入（差异2%~0.5%）；
&#160;&#160;&#160;&#160;具体原因仍在探究。
        
###**&#160;&#160;&#160;&#160;7.2 standard barrier with rebate:**
&#160;&#160;&#160;&#160;分敲出时立即偿付与敲出后延期到maturity再偿付两种情况；
&#160;&#160;&#160;&#160;立即偿付的情况参见Ed. Haug, 'The Complete Guide to Option Pricing Formulas (2006 2nd edition)', 4.17.1；
&#160;&#160;&#160;&#160;延期偿付的情况等同于一个延期偿付的美式二元期权，参见下文。
        
###**&#160;&#160;&#160;&#160;7.3 american cash or nothing:**
&#160;&#160;&#160;&#160;分达到行权价时立即偿付与达到行权价后延期到maturity再偿付两种情况；
####**&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;7.3.1 到行权价时立即偿付：**
&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;参见Ed. Haug, 'The Complete Guide to Option Pricing Formulas (2006 2nd edition)', 4.17.1, P.152 上 F 式。
####**&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;7.3.2 达到行权价后延期到maturity再偿付：**
&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;参见7.3.2.Implicit_formula_of_rebate_pricing.pdf文件；
&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;（通过使用 Girsanov Theorem 转换测度来求解标的物价格越过障碍水平的累积分布函数）




