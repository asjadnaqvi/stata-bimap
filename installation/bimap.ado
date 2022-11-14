*! bimap v1.51 (5 Nov 2022)
*! Asjad Naqvi (asjadnaqvi@gmail.com)

* v1.51 (14 Nov 2022): Minor legend fixes
* v1.5  (05 Nov 2022): 3 new colors: rgb, gscale, viridis. arrow, scalebar, diagram passthrus added.
* v1.4  (02 Oct 2022): custom cut-off points added. cut'offs can be formatted. spmap legend passthru.
* v1.33 (29 Sep 2022): Passthru options fixed.
* v1.32 (19 Aug 2022): Fixed a bug in variable comparisons
* v1.31 (20 Jun 2022): Fixed a floating point error and issue with color assignments.
* v1.3  (26 May 2022): added percent option. Color range fixes. New schemes. label fixes
* v1.2  (05 May 2022): Category cut-offs, counts, error checks, bug fixes, new palettes
* v1.1  (14 Apr 2022): Stable release

**********************************
* Step-by-step guide on Medium   *
**********************************

// if you want to go for even more customization, you can read this guide:

* Stata graphs: Bi-variate maps (07 Dec, 2021)
* https://medium.com/the-stata-guide/stata-graphs-bi-variate-maps-b1e96dd4c2be


cap program drop bimap


program bimap, sortpreserve

version 15
 
	syntax varlist(min=2 max=2 numeric) [if] [in] using/ , ///
		cut(string) palette(string)  ///
		[ count percent BOXsize(real 8) textx(string) texty(string) formatx(string) formaty(string) TEXTGap(real 2) xscale(real 30) yscale(real 100) TEXTLABSize(real 2) TEXTSize(real 2.5) values ] ///
		[ polygon(passthru) line(passthru) point(passthru) label(passthru) ] ///
		[ ocolor(string) osize(string) ]   ///
		[ ndocolor(string) ndsize(string) ndfcolor(string) ]   ///
		[ title(passthru) subtitle(passthru) note(passthru) name(passthru)  ] ///
		[ cutx(numlist min=2 max=2)  cuty(numlist min=2 max=2) SHOWLEGend  ] ///  // 1.4 updates
		[ LEGend(passthru) legenda(passthru) LEGStyle(passthru) LEGJunction(passthru) LEGCount(passthru) LEGOrder(passthru) LEGTitle(passthru)  ] ///  // 1.4 legend controls as passthru
		[ arrow(passthru) diagram(passthru) scalebar(passthru) ]  // 1.5
		
		if (substr(reverse("`using'"),1,4) != "atd.") local using "`using'.dta"  // from spmap to check for extension
		
		capture confirm file "`using'"   
		if _rc {
			di as err "{p}File {bf:`using'} not found{p_end}"
			exit 601
		}
	
	
	// check dependencies
		capture findfile spmap.ado
		if _rc != 0 {
			di as error "spmap package is missing. Click here to install {stata ssc install spmap, replace:spmap}."
			exit
		}

		capture findfile colorpalette.ado
		if _rc != 0 {
			di as error "palettes package is missing. Click here to install {stata ssc install palettes, replace:palettes} and {stata ssc install colrspace, replace:colrspace}."
			exit
		}	
	
		marksample touse, strok
		gettoken var2 var1 : varlist   // var1 = x, var2 = y
	
	
	// errors checks
	
		if "`var1'" == "`var2'" {
			di as error "Both variables are the same. Please choose different variables."
			exit
		}
	
		if "`count'" != "" & "`percent'" != "" {
			di as error "Please specify either {it:count} or {it:percent}. See {stata help bimap:help file}."
			exit 
		}	
		
		if "`cut'" == "custom" & "`cutx'"=="" & "`cuty'"=="" {
			di as error "With {it:cut(custom)}, either {it:cutx(val1 val2)} or {it:cuty(val1 val2)}, or both need to be specified. See {stata help bimap:help file}."
			exit
		}
		
	
	
		***** Get the cuts

	
qui {
		
	preserve	
		keep if `touse'
		tempvar cat_`var1' cat_`var2'
		
		if "`cut'" == "pctile" {
			xtile `cat_`var1'' = `var1', n(3)
			xtile `cat_`var2'' = `var2', n(3)
		}
		
		if "`cut'" == "equal" {
			
			summ `var1', meanonly
			local interv = (r(max) - r(min)) / 3
							
				local cutx0 = r(min)
				local cutx1 = `cutx0' + `interv'
				local cutx2 = `cutx1' + `interv'
				local cutx3 = r(max) + 1   
			
			egen `cat_`var1'' = cut(`var1'), at(`cutx0', `cutx1' , `cutx2', `cutx3') icodes
			replace `cat_`var1'' = `cat_`var1'' + 1 
			
			summ `var2', meanonly
			local interv = (r(max) - r(min)) / 3
							
				local cuty0 = r(min)
				local cuty1 = `cuty0' + `interv'
				local cuty2 = `cuty1' + `interv'
				local cuty3 = r(max) + 1		// floating point fix	
			
			egen `cat_`var2'' = cut(`var2'), at(`cuty0', `cuty1' , `cuty2', `cuty3') icodes
			replace `cat_`var2'' = `cat_`var2'' + 1
		}	
	
		if "`cut'" == "custom" {
			
			if "`cutx'" != "" {
				summ `var1', meanonly
					local cutx0 = r(min)
					local cutx3 = r(max)
				
				tokenize `cutx'
					local cutx1 = `1'
					local cutx2 = `2'
					
				egen `cat_`var1'' = cut(`var1'), at(`cutx0', `cutx1' , `cutx2', `cutx3') icodes
				replace `cat_`var1'' = `cat_`var1'' + 1 
			}
			else {
				xtile `cat_`var1'' = `var1', n(3)
			}
		
		
			if "`cuty'" != "" {
				summ `var2', meanonly
					local cuty0 = r(min)
					local cuty3 = r(max)
				
				tokenize `cuty'
					local cuty1 = `1'
					local cuty2 = `2'
				
				egen `cat_`var2'' = cut(`var2'), at(`cuty0', `cuty1' , `cuty2', `cuty3') icodes
				replace `cat_`var2'' = `cat_`var2'' + 1
			}
			else {
				xtile `cat_`var2'' = `var2', n(3)
			}
		}
		

		
		sort `cat_`var1'' `cat_`var2''
		
		tempvar grp_cut
		gen `grp_cut' = .
		
		replace `grp_cut' = 1 if `cat_`var2''==1 & `cat_`var1''==1
		replace `grp_cut' = 2 if `cat_`var2''==2 & `cat_`var1''==1
		replace `grp_cut' = 3 if `cat_`var2''==3 & `cat_`var1''==1
		replace `grp_cut' = 4 if `cat_`var2''==1 & `cat_`var1''==2
		replace `grp_cut' = 5 if `cat_`var2''==2 & `cat_`var1''==2
		replace `grp_cut' = 6 if `cat_`var2''==3 & `cat_`var1''==2
		replace `grp_cut' = 7 if `cat_`var2''==1 & `cat_`var1''==3
		replace `grp_cut' = 8 if `cat_`var2''==2 & `cat_`var1''==3
		replace `grp_cut' = 9 if `cat_`var2''==3 & `cat_`var1''==3
		
		
	
		***** store the cut-offs for labels	
		
		if "`formatx'" =="" local formatx "%5.1f"
		if "`formaty'" =="" local formaty "%5.1f"
		
		
		summ `var1' if `cat_`var1'' == 1
		local var11 = r(max)
		local var11 : di `formatx' `var11'
		
		if ("`cut'" == "custom" & "`cutx'" != "") local var11 : di `formatx' `cutx1'
		
		summ `var1' if `cat_`var1'' == 2
		local var12 = r(max)
		local var12 : di `formatx' `var12'
		
		if ("`cut'" == "custom" & "`cutx'" != "") local var12 : di `formatx' `cutx2'
		
		summ `var1' if `cat_`var1'' == 3
		local var13 = r(max)
		local var13 : di `formatx' `var13'
		
		summ `var2' if `cat_`var2'' == 1
		local var21 = r(max)
		local var21 : di `formaty' `var21'
		
		if ("`cut'" == "custom" & "`cuty'" != "") local var21 : di `formaty' `cuty1'
		
		summ `var2' if `cat_`var2'' == 2
		local var22 = r(max)
		local var22 : di `formaty' `var22'
		
		if ("`cut'" == "custom" & "`cuty'" != "") local var22 : di `formaty' `cuty2'
		
		summ `var2' if `cat_`var2'' == 3
		local var23 = r(max)
		local var23 : di `formaty' `var23'
		
		
		// grp order: 1 = 1 1, 2 = 1 2, 3 = 1 3, 4 = 2 1, 5 = 2 2, 6 = 2 3, 7 = 3 1, 8 = 3 2, 9 = 3 3
		
	
		if "`count'" != "" {			

			forval i = 1/3 {
				forval j = 1/3 {
					count if `cat_`var1''==`j' & `cat_`var2''==`i' 
					local grsize`i'`j' = `r(N)'					
				}
			}
		}
	

		if "`percent'" != "" {	
	
		count if `cat_`var1''!=. & `cat_`var2''!=.
		local grsum = `r(N)'
	
			forval i = 1/3 {
				forval j = 1/3 {
					count if `cat_`var1''==`j' & `cat_`var2''==`i' 
					local grsize`i'`j' = (`r(N)'	/ `grsum') * 100
					local grsize`i'`j' : di %3.1f `grsize`i'`j''
				}
			}
	
	
		}
	
		// from spmap
   
		if "`palette'" != "" {
			local LIST "pinkgreen bluered greenblue purpleyellow yellowblue orangeblue brew1 brew2 brew3 census rgb viridis gscale"
			local LEN = length("`palette'")
			local check = 0
			foreach z of local LIST { 
				if ("`palette'" == substr("`z'", 1, `LEN')) {
					local check = 1
				}
			}
			
			if !`check' {
				di in yellow "Wrong palette specified. The supported palettes are {it:pinkgreen}, {it:bluered}, {it:greenblue}, {it:purpleyellow}, {it:yellowblue}, {it:orangeblue}, {it:brew1}, {it:brew2}, {it:brew3}, {it:census}, {it:rgb}, {it:viridis}, {it:gscale}."
				di in yellow "See {stata help bimap:help file}."
				exit 198
			}
		}

		** bottom left > top left, bottom middle > top middle, bottom right > top right

		if "`palette'" == "pinkgreen" {
			local color #e8e8e8 #dfb0d6 #be64ac #ace4e4 #a5add3 #8c62aa #5ac8c8 #5698b9 #3b4994
		}
		
		if "`palette'" == "bluered" {
			local color #e8e8e8 #b0d5df #64acbe #e4acac #ad9ea5 #627f8c #c85a5a #985356 #574249 
		}
		
		if "`palette'" == "greenblue" {
			local color #e8e8e8 #b8d6be #73ae80 #b5c0da #90b2b3 #5a9178 #6c83b5 #567994 #2a5a5b
		}	

		if "`palette'" == "purpleyellow" {
			local color #e8e8e8 #cbb8d7 #9972af #e4d9ac #c8ada0 #976b82 #c8b35a #af8e53 #804d36
		}
		
		if "`palette'" == "yellowblue" {   // from ArcGIS
			local color #e8e6f2 #f3d37a #f3b300 #a2c8db #8e916e #7a5a00 #509dc2 #284f61 #424035
		}		
		
		if "`palette'" == "orangeblue" {   // from ArcGIS
			local color #fef1e4 #97d0e7 #18aee5 #fab186 #b0988c #407b8f #f3742d #ab5f37 #5c473d
		}
		
		if "`palette'" == "brew1" {   
			local color #f37300 #fe9aa6 #f0047f #cce88b #e6e6e6 #cd9acc #008837 #9ac9d5 #5a4da4
		}	
		
		if "`palette'" == "brew2" {   
			local color #c3b3d8 #7b67ab #240d5e #e6e6e6 #bfbfbf #7f7f7f #ffcc80 #f35926 #b30000
		}
		
		if "`palette'" == "brew3" {   
			local color #cce8d7 #80c39b #008837 #cedced #85a8d0 #0a50a1 #fbb4d9 #f668b3 #d60066
		}
		
		if "`palette'" == "census" {   
			local color #fffdef #e6f1df #d2e4f6 #fef3a9 #bedebc #a1c8ea #efd100 #4eb87b #007fc4
		}
		
		if "`palette'" == "rgb" {   
			local color #F5F402 #8EBA13 #2A8F25 #FE870D #B8A5D2 #3092FA #FF4343 #D052EB #5148BA
		}

		
		if "`palette'" == "gscale" {   
			local color #e5e5e5 #d4d4d4 #bbbbbb #a2a2a2 #8a8a8a #727272 #5b5b5b #444444 #262626
		}				
		
		if "`palette'" == "viridis" {   
			local color #FDE724 #D2E11B #A5DA35 #35B778 #29788E #38568B #462F7C #48196B #440154
		}
		
		
		if "`polygon'" == "" {
			local polyadd 
		}
		else {
			local polyadd `polygon'
		}

	
		local lc = cond("`ocolor'" == "", "white", "`ocolor'")
		
		local lw = cond("`osize'" == "", "0.02", "`osize'")
	
		local ndo = cond("`ndocolor'" == "", "gs12", "`ndocolor'")
		
		local ndf = cond("`ndfcolor'" == "", "gs8", "`ndfcolor'")
		
		local leg = cond("`showlegend'"=="", "legend(off)", "`legend'")
		
		// finally the map!
		
		colorpalette `color', nograph 
		local colors `r(p)'

		spmap `grp_cut' using "`using'", ///
			id(_ID) clm(custom) clb(0 1 2 3 4 5 6 7 8 9) fcolor("`colors'") ///
				ocolor(`lc' ..) osize(`lw' ..) ///	
				ndocolor(`ndo' ..) ndsize(`lw' ..) ndfcolor(`ndf' ..)  ///
				`polygon' `line' `point' `label'  ///
				`leg' `legstyle' `legenda' `legendstyle' `legjunction' `legcount' `legorder' `legtitle'  ///  // v1.4 legend passthrus
				`arrow' `diagram' `scalebar' ///  // v1.5 passthrus
					name(_map, replace) nodraw
	

	
		**** add the legend
		
		clear
		set obs 9
		
		egen y = seq(), b(3)  
		egen x = seq(), t(3) 	
		
		
		if "`count'" != "" | "`percent'" != "" {
			gen mycount = .
		
			local x = 1
			forval i = 1/3 {
				forval j = 1/3 {				
					replace mycount = `grsize`i'`j'' in `x'		
					local x = `x' + 1
				}
			}
					
		local marksym mycount	
			
		}
	
		cap drop spike*
	
		if "`textx'" == "" 	local textx = "`var1'" 
		if "`texty'" == "" 	local texty = "`var2'"
		
	
	
		// arrows
		gen spike1_x1  = 0.35 		in 1
		gen spike1_x2  = 3.6 		in 1 
		gen spike1_y1  = 0.35 		in 1	
		gen spike1_y2  = 0.35 		in 1	
			
		gen spike2_y1  = 0.35 		in 1
		gen spike2_y2  = 3.6 		in 1 
		gen spike2_x1  = 0.35 		in 1		
		gen spike2_x2  = 0.35 		in 1		
		
		// ticks
		gen xvalx = .
		gen xvaly = .
		gen xvaln = .
	
		replace xvaly = 0.36 	in 1/3
		replace xvalx = 0.8 	in 1
		replace xvalx = 1.8 	in 2
		replace xvalx = 2.8 	in 3
		
		replace xvaln = `var11' in 1
		replace xvaln = `var12' in 2
		replace xvaln = `var13' in 3
		

		gen yvalx = .
		gen yvaly = .
		gen yvaln = .

		replace yvalx = 0.33 	in 1/3
		replace yvaly = 1.1 	in 1
		replace yvaly = 2.1 	in 2
		replace yvaly = 3.1 	in 3	
		
		replace yvaln = `var21' in 1
		replace yvaln = `var22' in 2
		replace yvaln = `var23' in 3
		
	
		// axis labels
		
		gen labx = .
		gen laby = .
		gen labn = ""
		
		replace labx = 2 		in 1
		replace laby = 0 		in 1
		replace labn = "`textx'" in 1
		
		replace labx = 0 		in 2
		replace laby = 3 		in 2
		replace labn = "`texty'" in 2
	
	
		// colors
		
		colorpalette `color', nograph 

			local color11 `r(p1)'
			local color12 `r(p2)'
			local color13 `r(p3)'

			local color21 `r(p4)'
			local color22 `r(p5)'
			local color23 `r(p6)'

			local color31 `r(p7)'
			local color32 `r(p8)'
			local color33 `r(p9)'	
					
			levelsof x, local(xlvl)	
			levelsof y, local(ylvl)

			

		local boxes

		foreach x of local xlvl {
			foreach y of local ylvl {
				
				if (`x'==3 & `y'==3)  {    
					local boxes `boxes' (scatter y x if x==`x' & y==`y', mlab("`marksym'") mlabpos(0) mlabc(gs13) msymbol(square) msize(`boxsize') mc("`color`x'`y''")) ///
					
				}					
				
				else {
					local boxes `boxes' (scatter y x if x==`x' & y==`y', mlab("`marksym'") mlabpos(0) mlabc(black) msymbol(square) msize(`boxsize') mc("`color`x'`y''")) ///
					
				}

			}
		}
	
	
		if "`values'" != "" {
			
			local xvals (scatter xvaly xvalx, mcolor(none) mlab(xvaln) mlabpos(4) mlabsize(`textlabsize'))
			
			local yvals (scatter yvaly yvalx, mcolor(none) mlab(yvaln) mlabpos(11) mlabsize(`textlabsize') mlabangle(90))
		
		}
	
  
		twoway ///
			`boxes' ///
			(pcarrow spike1_y1 spike1_x1 spike1_y2 spike1_x2, lcolor(gs6) mcolor(gs6) msize(0.8) ) ///
			(pcarrow spike2_y1 spike2_x1 spike2_y2 spike2_x2, lcolor(gs6) mcolor(gs6) msize(0.8) ) ///
			(scatter laby labx in 1, mcolor(none) mlab(labn) mlabsize(`textsize') mlabpos(6) mlabgap(`textgap')				 )  ///
			(scatter laby labx in 2, mcolor(none) mlab(labn) mlabsize(`textsize') mlabpos(9) mlabgap(`textgap') mlabangle(90))  ///
			`xvals' ///
			`yvals' ///
			, ///
				xlabel(, nogrid) ylabel(, nogrid) ///
				yscale(range(0 4) off) xscale(range(0 4) off) ///
				aspectratio(1) ///
				xsize(1) ysize(1) ///
				fxsize(`xscale') fysize(`yscale') ///
				legend(off)		///
				name(_legend, replace)  nodraw   


			
		restore			
	
	 **** combine the two	
	 
	  graph combine _map _legend, ///
		imargin(zero) ///
		`title' 	///
		`subtitle' ///
		`note' ///
		`name' 
	
	
}

end



*********************************
******** END OF PROGRAM *********
*********************************
