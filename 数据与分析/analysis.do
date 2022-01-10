* Nemo's standardized stata program
* Version control
version 13
* Dont' Stop one page
set more off 
* Delete all program
clear all
* Increase 
set matsize 600
timer on 1 

/**************************************************************************
This do file contain all the compulation of a journal
Nemo initiated 2021/12/8, last revised 2021/12/8
***************************************************************************/
*unicode encoding set gb18030
*unicode translate "emprical_crim_963_2021.12.26.dta"

/*baseline*/
*local site="D:\OneDrive\Teaching\犯罪学\犯罪学实践课\code\"
*cd `site'
use "emprical_crim_963_2021.12.26.dta", clear


/**************************************************************************
part 2 数据处理
***************************************************************************/

*sample size related variables
gen d_size_log=log(d_size)
gen d_sizeuse_log=log(d_sizeuse)
gen frac=d_sizeuse/d_size

gen report_size=!missing(d_size)

*gen two dummy variable on method
gen method_desc=(m_frq+m_mean+m_sd+m_corstab+m_meancomp)>0
gen method_infr=(m_chi+m_t_anova+m_cor+m_reg+m_adv)>0

gen method_desc_only=(method_desc==1) & (method_infr==0)
*only one variable
gen univariate=(m_frq+m_mean+m_sd)>0 & (m_corstab+m_meancomp+m_chi+m_t_anova+m_cor+m_reg+m_adv+m_gis)==0

gen des_freq=(m_frq)>0 & (m_mean+m_sd+m_corstab+m_meancomp+m_chi+m_t_anova+m_cor+m_reg+m_adv+m_gis)==0


*是否适用理论
gen r_theory_t=( subinstr(r_theory," ","",.))
gen theory_bin=(r_theory_t!="0" & r_theory_t!="00" )

/**************************************************************************
part 3 删除不合适文献
***************************************************************************/

*drop missing
tab  screen
drop if screen!=4
drop m_gis r_stat_err r_type_err r_concept


/**************************************************************************
part 3 analysis
***************************************************************************/


				
	
*1.研究框架

*主要指标的描述性统计
tab1 d_source d_unit d_design d_time d_sampling d_range 

tab  d_source year, column /*数据来源的逐年变化趋势*/

*是否汇报样本量
tab  d_source report_size if d_unit!=3, chi2 row
tab  d_design report_size if d_unit!=3, chi2 row
tab  d_unit report_size if d_unit!=3, chi2 row
tab  d_range report_size if d_unit!=3, chi2 row

*样本量描述性统计
sum d_size d_sizeuse frac,d

set scheme lean1
hist d_size if d_size<10000, freq width(100)  kdensity ytitle("") xtitle("")  xlab(0(1000)10000)
hist d_sizeuse if d_sizeuse<10000, freq width(100)  kdensity  ytitle("") xtitle("") xlab(0(1000)10000)

*2.量化方法使用

*主要量化分析方法的使用

tab1 m_frq m_mean m_sd m_corstab m_meancomp m_chi m_t_anova m_cor m_reg m_adv  
tab1 des_freq univariate method_infr

tab method_desc method_infr,cell

*推论统计和抽样
tab d_sampling method_desc_only, row chi2

*tool
tab t1_software

*3.论文撰写
tab1 r_datasource r_hyo theory_bin r_measure r_limitation

tab r_theory if theory_bin	
			
/**************************************************************************
Tail
***************************************************************************/
timer off  1 
timer list 1
