# Exotics_Pricing


---

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

	

##**1. mc_double_barrier.m：**

此函数是对于多次观察的双鲨期权（欧式带rebate）的蒙特卡洛模拟定价；
    
双鲨期权即收益结构为下图的期权：
					                
						  \				/
						   \           /
	    Rebate1 ----------  \____0____/  ---------- Rebate2
				         H1  K1      K2  H2
	
观察次数为m，每当观察时标的物现价St小于等于H1或大于等于H2时，该期权敲出；
如果直至maturity date该期权都未敲出，则按图中收益曲线偿付。
如想定价只带一个行权价K1或K2的双障碍期权，即收益结构形如：
					                
						  \			
						   \          
	    Rebate1 ----------  \____0____---------- Rebate2
				         H1  K1       H2
						 
或
						                
						   				/
						               /
	    Rebate1 ------------ ____0____/  ---------- Rebate2
				         H1        K2  H2
						
的标准双障碍期权，则将K2设置为大于H2使其失效；或将K1设置为小于H1使其失效即可。

Rebate偿付时间可选敲出时立即偿付与延时偿付（即在原先约定的maturity时偿付）。
    
##**2. mc_barrier_rebate.m**

此函数是对于多次观察的带rebate的标准障碍期权（欧式）的蒙特卡洛模拟定价；
    
即当为"call-out-up"（向上敲出的看涨期权）时收益结构如下图的：
    
						   				/
						               /
	           0 _____________________/  ---------- Rebate
				                     K   H
    
观察次数为m，每当观察时标的物现价St小于等于H1或大于等于H2时，该期权敲出；
如果直至maturity date该期权都未敲出，则按图中收益曲线偿付。
对于观察次数m，如想对于一个maturity为 61/244 的期权daily观察，则使 m = 61，其余以此类推；
如想定价一个只在到期时观察一次的期权，则使 m = 1。

Rebate偿付时间可选敲出时立即偿付与延时偿付（即在原先约定的maturity时偿付）。
    
##**3. mc_american_con.m**
    
此函数是对于多次观察的现金偿付美式二元期权（ameriacan cash-or-nothing）的蒙特卡洛模拟定价；
包含有'call'与'put'两种偿付形式。
    
'call'指代有以下收益结构的期权：
    
	           0 _____________________---------- Cash_Payment
				                      K
    
'put'则指代有以下收益结构的期权：
    
              Cash_Payment -----------___________________ 0
                                      K
    
Cash偿付时间可选敲出时立即偿付与延时偿付（即在原先约定的maturity时偿付）。
    
##**4. CRR_Vanilla_Euro&Ameri.py**

此函数是对于香草的欧式与美式期权使用Cox-Ross-Rubinstein理论的二叉树模拟定价；
使用math与numpy包裹。

##**5. CRR_Vanilla_Delta.py**

此函数是使用上面CRR_Vanilla_Euro&Ameri.py中函数定价欧式与美式香草后；
使用有限差分计算delta值的函数；
使用math与numpy包裹；可以脱离CRR_Vanilla_Euro&Ameri.py独立运行。

##**6. CRR_Maturity_Barrier&Delta.py**

此函数是对于到期观察一次的欧式障碍期权使用Cox-Ross-Rubinstein理论的二叉树模拟定价并有限差分计算其delta；
到期观察一次，指对于2中同样的收益结构的，观察在且仅在maturity时进行一次，敲出则偿付Rebate，未敲出则欧式结算。
使用math与numpy包裹。
    
##**7. Discussion on closed-form formulae of exotics mentioned above**

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




