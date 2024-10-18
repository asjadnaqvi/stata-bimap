*! bimap v2.1 (18 Oct 2024)
*! Asjad Naqvi (asjadnaqvi@gmail.com)

* v2.1	(18 Oct 2024): Better label wrapping
* v2.0	(22 Aug 2024): Port to geoplot for newer stata versions. frame() geo() geopost() added for geoplot. /using swapped with shp() for spmap.
* v1.9  (19 Jun 2024): Fixed some minor bugs. Nolegend option added. wrap() added for label wrapping.
* v1.82 (04 May 2024): textcolor() added for legend labels. updates to various defaults
* v1.81 (22 Aug 2023): Fixed a bug where missing data was getting dropped. ndsize() passthru fixed.
* v1.8  (26 Jun 2023): custom cuts now take on values given in list, textgap() removed, labxgap(), labygap() added. Legend label positions optimized.
* v1.7  (15 Jun 2023): added support for binary variables: xdiscrete, ydiscrete
* v1.62 (19 May 2023): Fix to legend labels and sizes. Minor improvements.
* v1.61 (12 Apr 2023): Fix to legend box and label rescaling.
* v1.6  (17 Mar 2023): Colors are now dynamically generated for any number of bins. several new options to control colors, bins, saturation, labels
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

*version 15
 
	syntax varlist(min=2 max=2 numeric) [if] [in]    ///
		[ ,  cut(string) palette(string) ]  ///
		[ count percent BOXsize(real 8) textx(string) texty(string) formatx(string) formaty(string) xscale(real 35) yscale(real 100) TEXTLABSize(string) TEXTSize(string) values ] ///
		[ polygon(passthru) line(passthru) point(passthru) label(passthru) ] ///
		[ ocolor(string) osize(string) ndocolor(string) ndsize(string) ndfcolor(string) ]   ///
		[ cutx(numlist min=1)  cuty(numlist min=1) SHOWLEGend  ] ///  // 1.4 updates
		[ LEGend(passthru) legenda(passthru) LEGStyle(passthru) LEGJunction(passthru) LEGCount(passthru) LEGOrder(passthru) LEGTitle(passthru)  ] ///  // 1.4 legend controls as passthru
		[ arrow(passthru) diagram(passthru) scalebar(passthru) ] ///  // 1.5
		[ bins(numlist min=1 >=2) binx(numlist min=1 >=2) biny(numlist min=1 >=2) reverse clr0(string) clrx(string) clry(string) CLRSATurate(real 6) binsproper FORMATVal(string) VALLABSize(string) ] /// // 1.6
		[ XDISCrete YDISCrete ] ///  // v1.7 options
		[ labxgap(real 0) labygap(real 0) ] ///  // v1.8 options
		[ TEXTColor(string) TEXTLABColor(string) VALLABColor(string) NOLEGend wrap(numlist >=0 max=1)  * ]	///		// v1.82, v1.9
		[ geo(string) geopost(string) frame(string) old shp(string) detail scheme(passthru) ]	// v2.0 -- stata 18+ options for geoplot
		
		
	local myver = `c(version)'
	
	
	// check dependencies
		
	if "`wrap'" != "" {
		cap findfile labsplit.ado
		if _rc != 0 {
			display as error "The {bf:graphfunctions} package is missing. Install the {stata ssc install graphfunctions, replace:graphfunctions}."
			exit
		}			
	}			
		
	if `myver' >= 17 & "`old'"=="" {
		
		if "`detail'" != "" {
			noi display in yellow "Stata `myver' detected. Using {stata help geoplot:geoplot} package."
		}
		
		if "`frame'" == "" {
			display as error "For calling geoplot, option {it:frame()} is required. See {stata help bimap:help}."
			exit
		}
		
		capture findfile geoplot.ado
		if _rc != 0 {
			di as error "geoplot package is missing. Click here to install {stata ssc install geoplot, replace:geoplot}."
			exit
		}	
		
		capture findfile colorpalette.ado
		if _rc != 0 {
			di as error "The {bf:palettes} package is missing. Click here to install {stata ssc install palettes, replace:palettes} and {stata ssc install colrspace, replace:colrspace}."
			exit
		}
		
			

	
	}
	else {
		
		if "`old'" != "" local oldtxt (but option old specified)
		
		if "`detail'" != "" {
			noi display in yellow "Stata `myver' detected `oldtxt'. Using {stata help spmap:spmap} package."
		}
		
		capture findfile spmap.ado
		if _rc != 0 {
			di as error "spmap package is missing. Click here to install {stata ssc install spmap, replace:spmap}."
			exit
		}

		capture findfile colorpalette.ado
		if _rc != 0 {
			di as error "The {bf:palettes} package is missing. Click here to install {stata ssc install palettes, replace:palettes} and {stata ssc install colrspace, replace:colrspace}."
			exit
		}	
		
		
		if "`shp'" == "" {
			display as error "For calling spmap, option {it:shp()} is required. See {stata help bimap:help} file."
			exit
		}
		
		if (substr(reverse("`shp'"),1,4) != "atd.") local shp "`shp'.dta"  // from spmap to check for extension
		
		capture confirm file "`shp'"   
		if _rc {
			di as err "{p}File {bf:`shp'} not found{p_end}"
			exit 601
		}
		
	}
		
		
	
		marksample touse, strok novarlist
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
		
		if !inlist("`cut'", "", "pctile", "equal") {
			di as error "Please specify either {it:pctile} or {it:equal} or {it:custom}. See {stata help bimap:help file}."
			exit 
		}			
		
		
	
		if "`bins'"=="" local bins 3 // default
	
		***** Get the cuts

	
quietly {
 	preserve	
		keep if `touse'
		keep `varlist' _ID
		
		tempvar cat_`var1' cat_`var2'
		
		summ `var1', meanonly
			local xmin = r(min)
			local xmax = r(max)

		summ `var2', meanonly
			local ymin = r(min)
			local ymax = r(max)
			
		// check palettes
   
		
		if "`palette'" == "" local palette = "pinkgreen"
		if "`cut'"     == "" local cut     = "pctile"
		
		
		local check = 0
		if inlist("`palette'", "pinkgreen0", "bluered0", "greenblue0", "purpleyellow0", "yellowblue0", "orangeblue0") 	local check = 1
		if inlist("`palette'", "brew1", "brew2", "brew3", "census", "rgb", "viridis", "gscale") 						local check = 1
	
		if `check'== 1 { // legacy palettes
			local binx = 3
			local biny = 3
		}


		// scalable schemes
		if "`palette'" == "pinkgreen0" {
			local color #e8e8e8 #dfb0d6 #be64ac #ace4e4 #a5add3 #8c62aa #5ac8c8 #5698b9 #3b4994
		}
		
		if "`palette'" == "pinkgreen" {
			local cl0 #e8e8e8 
			local clx #5ac8c8 
			local cly #be64ac
		}
		
		if "`palette'" == "bluered0" {
			local color #e8e8e8 #b0d5df #64acbe #e4acac #ad9ea5 #627f8c #c85a5a #985356 #574249 
		}
		
		if "`palette'" == "bluered" {
			local cl0 #e8e8e8 
			local clx #c85a5a
			local cly #64acbe 
		}		
		
		if "`palette'" == "greenblue0" {
			local color #e8e8e8 #b8d6be #73ae80 #b5c0da #90b2b3 #5a9178 #6c83b5 #567994 #2a5a5b
		}
		
		if "`palette'" == "greenblue" {
			local cl0 #e8e8e8 
			local clx #6c83b5
			local cly #73ae80 
		}		

		if "`palette'" == "purpleyellow0" {
			local color #e8e8e8 #cbb8d7 #9972af #e4d9ac #c8ada0 #976b82 #c8b35a #af8e53 #804d36
		}
		
		if "`palette'" == "purpleyellow" {
			local cl0 #e8e8e8 
			local clx #c8b35a
			local cly #9972af 
		}			
		
		if "`palette'" == "yellowblue0" {   // from ArcGIS
			local color #e8e6f2 #f3d37a #f3b300 #a2c8db #8e916e #7a5a00 #509dc2 #284f61 #424035
		}
		
		if "`palette'" == "yellowblue" {
			local cl0 #e8e8e8 
			local clx #509dc2
			local cly #f3b300 
		}			
		
		if "`palette'" == "orangeblue0" {   // from ArcGIS
			local color #fef1e4 #97d0e7 #18aee5 #fab186 #b0988c #407b8f #f3742d #ab5f37 #5c473d
		}
		
		if "`palette'" == "orangeblue" {
			local cl0 #e8e8e8 
			local clx #f3742d
			local cly #18aee5 
		}			
		
		// predefined schemes
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
			
			
		// if the specific is missing go for the generic	
		if "`binx'" == "" local binx = `bins'	
		if "`biny'" == "" local biny = `bins'
		
		
		if "`xdiscrete'" != "" {
			
			levelsof `var1'
			local xdiscli `r(levels)'
			
			egen `cat_`var1'' = group(`var1')
				
			levelsof `cat_`var1''
			
			if r(r) > 10 {
				di as err "Maximum 10 categories allowed. `var1' has `r(r)' categories."
				exit 198
			}
			
			local binx = r(r)
			local xlist 0 `r(levels)'
			
			local xlab: value label `var1'
		}
		
		if "`ydiscrete'" != "" {
			levelsof `var2'
			local ydiscli `r(levels)'
			
			egen `cat_`var2'' = group(`var2')
				
			levelsof `cat_`var2''

			if r(r) > 10 {
				di as err "Maximum 10 categories allowed. `var2' has `r(r)' categories."
				exit 198
			}			
			
			local biny = r(r)
			local ylist 0 `r(levels)'
			
			local ylab: value label `var2'
		}		
		

		
		if "`cut'" == "pctile" {
			if "`xdiscrete'" == "" {
				xtile `cat_`var1'' = `var1', n(`binx')	
				_pctile `var1', n(`binx')
				
				local binx0 = `binx' - 1
				
				
				forval i = 1/`binx0' {
					local xlist `xlist' `r(r`i')'
				}
				
				local xlist `xmin' `xlist' `xmax'
			}
			
			if "`ydiscrete'" == "" {
				xtile `cat_`var2'' = `var2', n(`biny')			
				_pctile `var2', n(`biny')
				local biny0 = `biny' - 1
				
				forval i = 1/`biny0' {
					local ylist `ylist' `r(r`i')'
				}	
				
				local ylist `ymin' `ylist' `ymax'
			}
			
		}
		
		if "`cut'" == "equal" {
			if "`xdiscrete'" == "" {
				local xint = (`xmax' - `xmin') / `binx'

				gen int `cat_`var1'' = .

				forval i = 1/`binx' {
						local xstart = `xmin' + (`i' - 1) * `xint'
						local xend   = `xstart' + `xint'

						replace `cat_`var1'' = `i' if inrange(`var1', `xstart', `xend')
				}	

				local xlist = `xmin'
				forval i = 1/`binx' {
					local newval = `xmin' + `i' * `xint'
					local xlist `xlist' `newval'  
				}
			}
			
			
			
			if "`ydiscrete'" == "" {
				local yint = (`ymax' - `ymin') / `biny'

				gen int `cat_`var2'' = .

				forval i = 1/`biny' {
						local ystart = `ymin' + (`i' - 1) * `yint'
						local yend   = `ystart' + `yint'

						replace `cat_`var2'' = `i' if inrange(`var2', `ystart', `yend')
				}	


				local ylist = `ymin'
				forval i = 1/`biny' {
					local newval = `ymin' + `i' * `yint'
					local ylist `ylist' `newval'  
				}
			}
			
		}	

		
			
		if "`cutx'" != "" & "`xdiscrete'"=="" {	
			local xlen : word count `cutx'
			
			if `xlen' < 3 {
				di as error "Please specify at least three elements in {opt cutx()}."
				exit 198
			}
			
			tokenize `cutx'

				forval i = 1/`xlen' {
					local x`i' = ``i''
				}

			local xlen1 = `xlen' - 1

			local xlist `cutx' 

			cap drop `cat_`var1''
			gen int `cat_`var1'' = .

			forval i = 1/`xlen1' {
				local j = `i' + 1	
						
				replace `cat_`var1'' = `i' if inrange(`var1', `x`i'', `x`j'')
			}	
			
			local binx = `xlen' - 1
		}

		if "`cuty'" != "" & "`ydiscrete'"=="" {	
			local ylen : word count `cuty'
		
			if `ylen' < 3 {
				di as error "Please specify at least three elements in {opt cuty()}."
				exit 198
			}
					
		
			tokenize `cuty'

				forval i = 1/`ylen' {
					local y`i' = ``i''
				}

			local ylen1 = `ylen' - 1

			local ylist `cuty'

			cap drop `cat_`var2''
			gen int `cat_`var2'' = .

			forval i = 1/`ylen1' {
				local j = `i' + 1	
				replace `cat_`var2'' = `i' if inrange(`var2', `y`i'', `y`j'')
			}

			// reset the bins
			local biny = `ylen' - 1
			
		}
		
		
		sort `cat_`var1'' `cat_`var2''
		
		tempvar grp_cut
		gen `grp_cut' = .
		
	
		// generate the groups
		
		levelsof `cat_`var1'', local(lvl1)
		levelsof `cat_`var2'', local(lvl2)
		
		local z = 1

		
		forval i = 1/`binx' {
			forval j = 1/`biny' {
				
				replace `grp_cut' = `z' if `cat_`var1''==`i' & `cat_`var2''==`j'
				
				local z = `z' + 1
			
			}
		}
		
		
		***** store the cut-offs for labels	
		

		
		if "`count'" != "" {			

			forval i = 1/`binx' {
				forval j = 1/`biny' {
					count if `cat_`var1''==`i' & `cat_`var2''==`j' 
					local grsize`i'`j' = `r(N)'					
				}
			}
		}
		

		if "`percent'" != "" {	
	
		count if `cat_`var1''!=. & `cat_`var2''!=.
		local grsum = `r(N)'
	
			forval i = 1/`binx' {
				forval j = 1/`biny' {
					count if `cat_`var1''==`i' & `cat_`var2''==`j' 
					local grsize`i'`j' = (`r(N)'	/ `grsum') * 100
					local grsize`i'`j' : di %3.1f `grsize`i'`j''
				}
			}
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

		local nds = cond("`ndsize'" == "", "`lw'", "`ndsize'")		
		
		local leg = cond("`showlegend'"=="", "legend(off)", "")
		
		
		if "`clr0'" != "" local cl0 `clr0'
		if "`clrx'" != "" local clx `clrx'
		if "`clry'" != "" local cly `clry'
		
		
		if "`reverse'" != "" {
			local tempx `clx'
			local tempy `cly'
			
			local clx `tempy'
			local cly `tempx'
		}
		
		gen cuts = `grp_cut'
		
		
		// finally the map
				
		if `check'==0 {
			local cutst = `binx' * `biny'
			
			bimap_clrs, cutx(`binx') cuty(`biny') clr0(`cl0') clrx(`clx') clry(`cly')
			mata: st_global("r(clrlist)", clrlist)
			
			local mycolors `r(clrlist)'
			colorpalette "`mycolors'", saturate(`clrsaturate')  nograph 
			local colors `r(p)'
			
		}
		else {
			colorpalette `color', nograph 
			local colors `r(p)'
			local cutst = 9
		}
		
		
		if `myver' >= 17 & "`old'"=="" {
			

			if "`nolegend'" != "" {
				geoplot ///
					(area `frame' `grp_cut', discrete cuts(1(1)`cutst') color("`colors'") lcolor(`lc') lwidth(`lw') missing(color(`ndf') lc(`ndo') lw(`nds')) nolegend )    ///
						`geo' ///
						, `leg' tight `geopost' `options' `scheme'
						
				exit		
							
			}
			else {
			
				geoplot ///
					(area `frame' `grp_cut', discrete cuts(1(1)`cutst') color("`colors'") lcolor(`lc') lwidth(`lw') missing(color(`ndf') lc(`ndo') lw(`nds')) nolegend )    ///
						`geo' ///
						, `leg' tight `geopost' name(_map, replace) nodraw  `scheme'
			}
			
		}
		else {
		
			if "`nolegend'" != "" {
			spmap `grp_cut' using "`shp'", ///
				id(_ID) clm(custom) clb(0(1)`cutst') fcolor("`colors'") ///
					ocolor(`lc' ..) osize(`lw' ..) ///	
					ndocolor(`ndo' ..) ndsize(`nds' ..) ndfcolor(`ndf' ..)  ///
					`polygon' `line' `point' `label'  ///
					`leg' `legstyle' `legenda' `legendstyle' `legjunction' `legcount' `legorder' `legtitle'  ///  // v1.4 legend passthrus
					`arrow' `diagram' `scalebar' `options'  `scheme'
				
				exit	
			}
			else {

				spmap `grp_cut' using "`shp'", ///
				id(_ID) clm(custom) clb(0(1)`cutst') fcolor("`colors'") ///
					ocolor(`lc' ..) osize(`lw' ..) ///	
					ndocolor(`ndo' ..) ndsize(`nds' ..) ndfcolor(`ndf' ..)  ///
					`polygon' `line' `point' `label'  ///
					`leg' `legstyle' `legenda' `legendstyle' `legjunction' `legcount' `legorder' `legtitle'  ///  // v1.4 legend passthrus
					`arrow' `diagram' `scalebar' ///  // v1.5 passthrus
					name(_map, replace) nodraw  `scheme'
			}
		}
	
		*/
		
		**************************
		**** 	  Legend 	 *****
		**************************

		
		keep `var1' `var2'
		ren `var2' ydot
		ren `var1' xdot
		
	
		// equal interval list (add option to bypass this and stick to the original distribution)
		
		if "`binsproper'" == "" {
			
			if "`xdiscrete'"=="" {
			
				local xint = (`xmax' - `xmin') / `binx'
				local xcats = `xmin'
				
				forval i = 1/`binx' {
					local newval = `xmin' + `i' * `xint'
					local xcats `xcats' `newval'  
				}
			}
			else {
				local xcats `xlist'
			}
			

			if "`ydiscrete'"=="" {			
				local yint = (`ymax' - `ymin') / `biny'
				local ycats = `ymin'
				
				forval i = 1/`biny' {
					local newval = `ymin' + `i' * `yint'
					local ycats `ycats' `newval'  
				}
			}
			else {
				local ycats `ylist'
			}
		}
		else {
			local xcats `xlist'
			local ycats `ylist'
		}
		
		/////
				
		local xlen : word count `xcats'
		local ylen : word count `ycats'	
			
		local xlen = `xlen' - 1	
		local ylen = `ylen' - 1
			
		
		local myobs = `xlen' * `ylen' * 5	
		
		if _N < `myobs' {
			set obs `myobs'	
		}

			
			egen box   = seq() in 1/`myobs', b(5) 		
			egen order = seq() in 1/`myobs', t(5)		 
			
			egen tag = tag(box)
			recode tag (0=.)
			
		// generate the boxes	

		gen double x = .
		gen double y = .
		
		
		gen double x_mark = .
		gen double x_val  = .
		
		gen double y_mark = .		
		gen double y_val  = .
		
		
		local z = 1

			forval i0 = 1/`xlen' {
				forval j0 = 1/`ylen' {
				
					local i1 = `i0' + 1
					local j1 = `j0' + 1
					
		
					// replace values	
					replace x = `: word `i0' of `xcats'' if box==`z' & order==1
					replace y = `: word `j0' of `ycats'' if box==`z' & order==1
					
					replace x = `: word `i0' of `xcats'' if box==`z' & order==2
					replace y = `: word `j1' of `ycats'' if box==`z' & order==2
					
					replace x = `: word `i1' of `xcats'' if box==`z' & order==3
					replace y = `: word `j1' of `ycats'' if box==`z' & order==3
					
					replace x = `: word `i1' of `xcats'' if box==`z' & order==4
					replace y = `: word `j0' of `ycats'' if box==`z' & order==4			
					
					local z = `z' + 1
				
				}
			}	

					
		bysort box: egen double x_mid = mean(x)	
		bysort box: egen double y_mid = mean(y)
		
		replace x_mid = . if tag!=1
		replace y_mid = . if tag!=1
		
		if "`count'" != "" | "`percent'" != "" {
			gen mycount = .
		
			local x = 1
			forval i = 1/`binx' {
				forval j = 1/`biny' {				
					replace mycount = `grsize`i'`j'' if box==`x' & tag==1
					local x = `x' + 1
				}
			}
		
			local marksym mycount		
		}
		
		
		if "`formatval'" =="" local formatval "%5.1f"
		
		if "`percent'" != ""  {
			gen mycount2 = string(mycount, "`formatval'") + "%" if mycount!=.
			local marksym mycount2	
		}

				
		// markers 


		// for x-axis

		if "`xdiscrete'"=="" {
			
			local xlen : word count `xcats'
			
			local z = 1
			forval i0 = 1/`xlen' {
				replace x_mark = `: word `i0' of `xcats''  in `z'
				replace x_val  = `: word `i0' of `xlist''  in `z'
				local z = `z' + 1
			}
		}
		else {
			local xlen : word count `xdiscli'
			
			local z = 1
			forval i0 = 1/`xlen' {
				replace x_mark = `: word `i0' of `xcats''   in `z'
				replace x_val  = `: word `i0' of `xdiscli'' in `z'
				local z = `z' + 1
			}	
			lab val x_val `xlab'
		}
	
		
		// for y-axis
		
		if "`ydiscrete'"=="" {	
			
			local ylen : word count `ycats'	
			
			local z = 1
			forval i0 = 1/`ylen' {
				replace y_mark = `: word `i0' of `ycats''  in `z'
				replace y_val  = `: word `i0' of `ylist'' in `z'
				local z = `z' + 1
			}		
		}
		else {
			local ylen : word count `ydiscli'
			
			local z = 1
			forval i0 = 1/`ylen' {
				replace y_mark = `: word `i0' of `ycats'' in `z'
				replace y_val  = `: word `i0' of `ydiscli'' in `z'
				local z = `z' + 1
			}	
			lab val y_val `ylab'
		}
		
		
		// rescale x and y (0-1)

		summ x, meanonly
		replace x      = (x      - r(min)) / (r(max) - r(min))
		replace x_mid  = (x_mid  - r(min)) / (r(max) - r(min))
		replace x_mark = (x_mark - r(min)) / (r(max) - r(min))
		
		summ y, meanonly
		replace y      = (y      - r(min)) / (r(max) - r(min))			
		replace y_mid  = (y_mid  - r(min)) / (r(max) - r(min))	
		replace y_mark = (y_mark - r(min)) / (r(max) - r(min))
		
		
		
		if "`xdiscrete'"!="" replace x_mark = x_mark + ((1/`xlen')/2)
		if "`ydiscrete'"!="" replace y_mark = y_mark + ((1/`ylen')/2)
		
		if "`formatx'"=="" & "`xdiscrete'"=="" local formatx "%5.1f"
		if "`formaty'"=="" & "`ydiscrete'"=="" local formaty "%5.1f"		

		
		format x_val `formatx'
		format y_val `formaty'
		
		gen x0 = -0.05 if y_mark!=.
		gen y0 = -0.05 if x_mark!=.
		
		
		// arrows
		gen spike1_x1  = -0.05 		in 1
		gen spike1_y1  = -0.05 		in 1	
		gen spike1_x2  =  1.05 		in 1 
		gen spike1_y2  = -0.05 		in 1	
			
		gen spike2_x1  = -0.05 		in 1		
		gen spike2_y1  = -0.05 		in 1
		gen spike2_x2  = -0.05 		in 1	
		gen spike2_y2  =  1.05 		in 1 
	
		if "`textx'" 	  == "" local textx = "`var1'" 
		if "`texty'" 	  == ""	local texty = "`var2'"
		
		
		if "`textcolor'"  	== "" 	local textcolor 	black
		if "`textlabcolor'" == "" 	local textlabcolor 	black
		if "`vallabcolor'"  == "" 	local vallabcolor 	black
		
		
		if "`textsize'"   	== "" 	local textsize  	3
		if "`textlabsize'"  == "" 	local textlabsize	2.2
		if "`vallabsize'" 	== ""	local vallabsize 	2.2
		
		// axis labels
		
		gen labx = .
		gen laby = .
		gen labn = ""
		
		replace labx = 0.5 		 in 1
		replace laby = -0.25 - `labxgap' 	 in 1
		replace labn = "`textx'" in 1
		
		replace labx = -0.3 - `labygap' 	 in 2
		replace laby = 0.5   	 in 2
		replace labn = "`texty'" in 2
	
		
		if "`wrap'" != "" {
			ren labn labn_temp
			labsplit labn_temp, wrap(`wrap') gen(labn)
			drop labn_temp
		}			
		
	
		// generate the boxes
		levelsof box, local(lvls)	
		if `check'==0 {
			colorpalette "`mycolors'", saturate(`clrsaturate') nograph	
		}
		else {
			colorpalette `color', nograph
		}

		foreach x of local lvls {

				local boxes `boxes' (area y x if box==`x', nodropbase cmissing(n) fi(100) fc("`r(p`x')'") lc(white) lw(none) ) 
			
			}
			
		if "`count'" != "" | "`percent'" != "" {
 			local mylabels (scatter y_mid x_mid, mlabel(`marksym') mlabpos(0) mcolor(none) mlabsize(`vallabsize') mlabcolor(`vallabcolor')  ) 	// labels
			
		}
			
		if "`values'" != "" {	
			local xvals (scatter y0 x_mark, mcolor(none) mlabel(x_val) mlabpos(6) mcolor(gs6) msize(0.2) mlabsize(`textlabsize') mlabcolor(`textlabcolor') ) 
						
			local yvals (scatter y_mark x0, mcolor(none) mlabel(y_val) mlabpos(9) mcolor(gs6) msize(0.2) mlabsize(`textlabsize') mlabcolor(`textlabcolor') ) 
		
		}
			

		twoway ///
			`boxes' ///
			`xvals' ///
			`yvals' ///
			`mylabels' ///
			(pcarrow spike1_y1 spike1_x1 spike1_y2 spike1_x2, lcolor(gs6) mcolor(gs6) msize(0.8) ) ///  // arrow1
			(pcarrow spike2_y1 spike2_x1 spike2_y2 spike2_x2, lcolor(gs6) mcolor(gs6) msize(0.8) ) ///  // arrow2
			(scatter laby labx in 1, mcolor(none) mlab(labn) mlabsize(`textsize') mlabcolor(`textcolor') mlabpos(0)				 )  ///
			(scatter laby labx in 2, mcolor(none) mlab(labn) mlabsize(`textsize') mlabcolor(`textcolor') mlabpos(0) mlabangle(90))  ///
			, ///
				xlabel(-0.2 1, nogrid) ylabel(-0.2 1, nogrid) ///
				yscale(range(0 1.1) off) xscale(range(0 1.1) off) ///
				aspectratio(1) ///
				xsize(1) ysize(1) ///
				fxsize(`xscale') fysize(`yscale') ///
				legend(off)		///
				name(_legend, replace)  nodraw   `scheme'

	restore			
	
	 ********************
	 ****   FINAL	 ****
	 ********************
	 
	  graph combine _map _legend, ///
		imargin(zero) `options'
	
*/


}

end


// sub routines

*************************
// 	  bimap_clrs      //  
*************************

cap program drop bimap_clrs
program bimap_clrs, rclass

syntax [, cutx(numlist integer max=1 >=2) cuty(numlist integer max=1 >=2) clr0(string) clrx(string) clry(string) ]

 qui colorpalette `clr0' `clrx', n(`cutx') local(c_*)
 mata myX = bimap_parse(`cutx')
 
 qui colorpalette `clr0' `clry', n(`cuty') local(c_*)
 mata myY = bimap_parse(`cuty') 

 mata clrlist = bimap_multiply(`cutx', `cuty', myX, myY)

end

*************************
// 	  bimap_parse     //  
*************************

cap mata mata drop bimap_parse()

mata
	function bimap_parse(cut)   
	{
		myclrs = J(cut,3,.)
		for (i=1; i<=cut; i++) {
			col=sprintf("c_%f", i)
			myclrs[i,.] = strtoreal(tokens(tokens(st_local(col))))
		}	
		return (myclrs)		
	}
end


*************************
// 	  bimap_multiply   //  
*************************

cap mata mata drop bimap_multiply()

mata
	function bimap_multiply(cutx, cuty, myx, myy)   
	{	

	colors = J(cutx * cuty, 3,.)
	
	k = 1	
	for (i=1; i<=cutx; i++) {
		for (j=1; j<=cuty; j++) {
			colors[k, .] = floor((myx[i,.] :* myy[j,.]) / 255) 
			k = k + 1
		}	
	}

	str_clr = J(rows(colors),1,.)
	str_clr = char(34) :+ strofreal( colors[.,1]) :+ " " :+ strofreal(colors[.,2]) :+ " " :+ strofreal(colors[.,3]) :+ char(34)

	clrlist = str_clr[1]
	
	for (i=2; i<=rows(str_clr); i++) {
		clrlist = clrlist + " " + str_clr[i]
	}
		
	return (clrlist)
	
	}
end	




*********************************
******** END OF PROGRAM *********
*********************************
