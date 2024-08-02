///2016 election and authoritarianism over time dynamic analysis
use "2016 panel study"

///Table 1
svyset [pw=weight2]
svy: reg w2trumpft w1trumpft w1authoritarianism educ01 income01 age white black sex
outreg2 using Model_1, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word replace
svyset [pw=weight3]
svy: reg w3trumpft w2trumpft w2authoritarianism  educ01 income01 age white black sex
outreg2 using Model_1, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word append

svyset [pw=weight2]
svy: reg w2repft w1authoritarianism w1repft educ01 income01 age white black sex
outreg2 using Model_1, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word append
svyset [pw=weight3]
svy: reg w3repft w2authoritarianism w2repft educ01 income01 age white black sex
outreg2 using Model_1, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word append


///Appendix
svyset [pw=weight2]
svy: reg w2trumpft w1trumpft w1authoritarianism educ01 income01 age white black sex if white==1
svyset [pw=weight3]
svy: reg w3trumpft w2trumpft w2authoritarianism  educ01 income01 age white black sex if white==1

svyset [pw=weight2]
svy: reg w2repft w1authoritarianism w1repft educ01 income01 age white black sex if white==1
svyset [pw=weight3]
svy: reg w3repft w2authoritarianism w2repft educ01 income01 age white black sex if white==1

//Each component item
svyset [pw=weight2]
svy: reg w2trumpft w1trumpft w1auth101 educ01 income01 age white black sex
outreg2 using Model_1, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word replace
svy: reg w2trumpft w1trumpft w1auth201 educ01 income01 age white black sex
outreg2 using Model_1, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word append
svy: reg w2trumpft w1trumpft w1auth301 educ01 income01 age white black sex
outreg2 using Model_1, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word append
svy: reg w2trumpft w1trumpft w1auth401 educ01 income01 age white black sex
outreg2 using Model_1, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word append

svyset [pw=weight3]
svy: reg w3trumpft w2trumpft w2auth101  educ01 income01 age white black sex
outreg2 using Model_1, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word append
svy: reg w3trumpft w2trumpft w2auth201  educ01 income01 age white black sex
outreg2 using Model_1, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word append
svy: reg w3trumpft w2trumpft w2auth301  educ01 income01 age white black sex
outreg2 using Model_1, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word append
svy: reg w3trumpft w2trumpft w2auth401  educ01 income01 age white black sex
outreg2 using Model_1, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word append


svy: reg w2repft w1auth101 w1repft educ01 income01 age white black sex
svy: reg w2repft w1auth201 w1repft educ01 income01 age white black sex
svy: reg w2repft w1auth301 w1repft educ01 income01 age white black sex
svy: reg w2repft w1auth401 w1repft educ01 income01 age white black sex

svy: reg w3repft w2auth101 w2repft educ01 income01 age white black sex
svy: reg w3repft w2auth201 w2repft educ01 income01 age white black sex
svy: reg w3repft w2auth301 w2repft educ01 income01 age white black sex
svy: reg w3repft w2auth401 w2repft educ01 income01 age white black sex


svyset [pw=weight2]
svy: reg w2trumpft w1trumpft w1auth101 w1auth201 w1auth301 w1auth401 educ01 income01 age white black sex
outreg2 using Model_1, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word replace
svy: reg w2repft w1repft w1auth101 w1auth201 w1auth301 w1auth401 educ01 income01 age white black sex
outreg2 using Model_1, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word append

svyset [pw=weight3]
svy: reg w3trumpft w2trumpft w2auth101 w2auth201 w2auth301 w2auth401 educ01 income01 age white black sex
outreg2 using Model_1, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word append
svy: reg w3repft w2repft w2auth101 w2auth201 w2auth301 w2auth401 educ01 income01 age white black sex
outreg2 using Model_1, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word append


///Table 2
svyset [pw=weight2]
svy: reg w2authoritarianism c.w1authoritarianism w1trumpft educ01 income01 age white black sex
outreg2 using Model_2, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word replace
svy: reg w2authoritarianism c.w1authoritarianism w1repft educ01 income01 age white black sex
outreg2 using Model_2, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word append

///Appendix
svyset [pw=weight2]
svy: reg w2authoritarianism c.w1authoritarianism w1trumpft educ01 income01 age white black sex if white==1
svy: reg w2authoritarianism c.w1authoritarianism w1repft educ01 income01 age white black sex if white==1


svy: reg w2auth101 c.w1auth101 w1trumpft educ01 income01 age white black sex
outreg2 using Model_2, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word replace
svy: reg w2auth201 c.w1auth201 w1trumpft educ01 income01 age white black sex
outreg2 using Model_2, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word append
svy: reg w2auth301 c.w1auth301 w1trumpft educ01 income01 age white black sex
outreg2 using Model_2, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word append
svy: reg w2auth401 c.w1auth401 w1trumpft educ01 income01 age white black sex
outreg2 using Model_2, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word append

svy: reg w2auth101 c.w1auth101 w1repft educ01 income01 age white black sex
outreg2 using Model_3, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word replace
svy: reg w2auth201 c.w1auth201 w1repft educ01 income01 age white black sex
outreg2 using Model_3, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word append
svy: reg w2auth301 c.w1auth301 w1repft educ01 income01 age white black sex
outreg2 using Model_3, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word append
svy: reg w2auth401 c.w1auth401 w1repft educ01 income01 age white black sex
outreg2 using Model_3, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word append


///reviewer tests

///no control variables

svyset [pw=weight2]
svy: reg w2trumpft w1trumpft w1authoritarianism 
outreg2 using Model_c, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word replace
svyset [pw=weight3]
svy: reg w3trumpft w2trumpft w2authoritarianism 
outreg2 using Model_c, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word append

svyset [pw=weight2]
svy: reg w2repft w1authoritarianism w1repft 
outreg2 using Model_c, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word append
svyset [pw=weight3]
svy: reg w3repft w2authoritarianism w2repft 
outreg2 using Model_c, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word append


svyset [pw=weight2]
svy: reg w2authoritarianism c.w1authoritarianism w1trumpft 
outreg2 using Model_d, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word replace
svy: reg w2authoritarianism c.w1authoritarianism w1repft 
outreg2 using Model_d, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word append


///Controlling for PID7

///Table 1
svyset [pw=weight2]
svy: reg w2trumpft w1trumpft w1authoritarianism educ01 income01 age white black sex w1pid7
outreg2 using Model_e, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word replace
svyset [pw=weight3]
svy: reg w3trumpft w2trumpft w2authoritarianism  educ01 income01 age white black sex w2pid7
outreg2 using Model_e, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word append

svyset [pw=weight2]
svy: reg w2repft w1authoritarianism w1repft educ01 income01 age white black sex w1pid7
outreg2 using Model_e, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word append
svyset [pw=weight3]
svy: reg w3repft w2authoritarianism w2repft educ01 income01 age white black sex w2pid7
outreg2 using Model_e, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word append

///Table 2
svyset [pw=weight2]
svy: reg w2authoritarianism c.w1authoritarianism w1trumpft educ01 income01 age white black sex w1pid7
outreg2 using Model_f, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word replace
svy: reg w2authoritarianism c.w1authoritarianism w1repft educ01 income01 age white black sex w1pid7
outreg2 using Model_f, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word append


///2012-13 ANES

use "merge201213nes"


///Does authoritarianism move in response to Republican feelings?
svyset [pw=c5_weight]
svy: reg romneyft13 w1authoritarianism romneyft12 age educ01 income01 white black sex
outreg2 using Model_3, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word replace
svy: reg w2authoritarianism w1authoritarianism romneyft12 age educ01 white black sex
outreg2 using Model_3, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word append
svy: reg w2authoritarianism w1authoritarianism ft_rep12 age educ01 income01 white black sex
outreg2 using Model_3, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word append

1 - independence or respect for elders
2 - self-reliance or obedience
3 - curiosity or good manners
4 - considerate or well behaved

///Appendix
svy: reg romneyft13 w1authoritarianism romneyft12 age educ01 income01 white black sex if white==1
svy: reg w2authoritarianism w1authoritarianism romneyft12 age educ01 white black sex if white==1
svy: reg w2authoritarianism w1authoritarianism ft_rep12 age educ01 income01 white black sex if white==1

svy: reg romneyft13 romneyft12 w1auth1 w1auth2 w1auth3 w1auth4 age educ01 income01 white black sex
outreg2 using Model_4, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word replace

svy: reg w2auth1 w1auth1 romneyft12 age educ01 white black sex
outreg2 using Model_4, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word append
svy: reg w2auth2 w1auth3 romneyft12 age educ01 white black sex
outreg2 using Model_4, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word append
svy: reg w2auth3 w1auth2 romneyft12 age educ01 white black sex
outreg2 using Model_4, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word append
svy: reg w2auth4 w1auth4 romneyft12 age educ01 white black sex
outreg2 using Model_4, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word append

svy: reg w2auth1 w1auth1 ft_rep12 age educ01 income01 white black sex
outreg2 using Model_5, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word append
svy: reg w2auth2 w1auth3 ft_rep12 age educ01 income01 white black sex
outreg2 using Model_5, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word append
svy: reg w2auth3 w1auth2 ft_rep12 age educ01 income01 white black sex
outreg2 using Model_5, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word append
svy: reg w2auth4 w1auth4 ft_rep12 age educ01 income01 white black sex
outreg2 using Model_5, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word append

///Reviewer tests (response memo)

///No control variables
svy: reg romneyft13 romneyft12 w1authoritarianism
outreg2 using Model_a, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word replace
svy: reg w2authoritarianism w1authoritarianism romneyft12 
outreg2 using Model_a, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word append
svy: reg w2authoritarianism w1authoritarianism ft_rep12 
outreg2 using Model_a, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word append


///Control for party id (7-point)
svy: reg romneyft13 romneyft12 w1authoritarianism age educ01 income01 white black sex pid7
outreg2 using Model_b, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word replace
svy: reg w2authoritarianism w1authoritarianism romneyft12 age educ01 white black sex pid7
outreg2 using Model_b, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word append
svy: reg w2authoritarianism w1authoritarianism ft_rep12 age educ01 income01 white black sex pid7
outreg2 using Model_b, bdec(2) tdec(2) rdec(2) adec(2) alpha(.05, .10) addstat(Adj. R-squared, e(r2_a)) word append
