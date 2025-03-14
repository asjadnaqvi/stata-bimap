![StataMin](https://img.shields.io/badge/stata-2015-blue) ![issues](https://img.shields.io/github/issues/asjadnaqvi/stata-bimap) ![license](https://img.shields.io/github/license/asjadnaqvi/stata-bimap) ![Stars](https://img.shields.io/github/stars/asjadnaqvi/stata-bimap) ![version](https://img.shields.io/github/v/release/asjadnaqvi/stata-bimap) ![release](https://img.shields.io/github/release-date/asjadnaqvi/stata-bimap)

[Installation](#Installation) | [Syntax](#Syntax) | [Citation guidelines](#Citation-guidelines) | [Examples](#Examples) | [Feedback](#Feedback) | [Change log](#Change-log)

---

![bimap_banner_v2](https://github.com/asjadnaqvi/stata-bimap/assets/38498046/3d7415bd-ffba-4576-ba74-4a27921440ea)



# bimap v2.3
(14 Mar 2025)

This package provides the ability to draw bi-variate maps in Stata. It is based on the [Bi-variate maps Guide](https://medium.com/the-stata-guide/stata-graphs-bi-variate-maps-b1e96dd4c2be).


As of version 2.0 (released on 22nd August 2024), **bimap** uses **geoplot** for Stata versions 17 or newer, and **spmap** for Stata versions 16 or earlier. Users with newer versions can still opt to use the original **spmap** implementation by defining the original code (with minor changes, see below) and using the option `old`. Information on which version is detected and which map package is used can be displayed by using the `detail` option.

As more and more users switch to newer Stata versions, the **spmap** implementation will eventually be phased out. As of v2.0 it will no longer be developed further. 

## Installation

The package can be installed via SSC or GitHub. The GitHub version, *might* be more recent due to bug fixes, feature updates etc, and *may* contain syntax improvements and changes in *default* . See version numbers below. Eventually the GitHub version is published on SSC. All examples are updated to the latest version and might not be compatible with the old ones. Please check the documentation and change logs.

The package can be installed from SSC (**v2.1**):
```
ssc install bimap, replace
```

Or it can be installed from GitHub (**v2.3**):

```
net install bimap, from("https://raw.githubusercontent.com/asjadnaqvi/stata-bimap/main/installation/") replace
```

For using the command with `geoplot` the following packages are required:

```stata
ssc install geoplot, replace
ssc install moremata, replace
ssc install palettes, replace
ssc install colrspace, replace
ssc install graphfunctions, replace
``` 


For using the command with `spmap` the following packages are required:

```stata
ssc install spmap, replace
ssc install palettes, replace
ssc install colrspace, replace
ssc install graphfunctions, replace
```

Even if you have these packages installed, please check for updates: `ado update, update`.

*Optional*: Users can also install the `geo2xy` package for projection transformations, even though `geoplot` supports projects internally as well:

```stata
ssc install geo2xy, replace
```


*Optional*: If you want to make a clean figure, then it is advisable to load a clean scheme. I personally use the following:

```
ssc install schemepack, replace
set scheme white_tableau  
```

You can also push the scheme directly into the graph using the `scheme(schemename)` option.

I also prefer narrow fonts in figures with long labels. You can change this as follows:

```
graph set window fontface "Arial Narrow"
```


## Syntax for Stata versions 17 or newer

The syntax for the latest version is as follows:

```stata
        bimap vary varx [if] [in], frame(name) [ geo(geoplot layers) geo(geoplot layers) geopost(options) palette(name) reverse clr0(str) clrx(str)
               clry(str) clrsaturate(num) cut(pctile|equal) cutx(numlist) cuty(numlist) binsproper bins(num >=2) binx(num >=2) biny(num >=2) no
               count percent showlegend lcolor(str) lwidth(str) ndlc(str) ndfcolor(str) ndfsize(str) xdiscrete ydiscrete labxgap(num) labygap(num)
               textx(str) texty(str) formatx(str) formaty(str) detail wrap(num) textsize(str) textlabsize(str) vallabsize(str) textcolor(str)
               textlabcolor(str) vallabcolor(str) fxsize(num) fysize(num) scale(num) * ]
```

with the following minimal syntax requirement:

```
bimap vary varx, frame(framename)
```



## Syntax for Stata versions 16 or older

```stata
        bimap vary varx [if] [in], shp(shapefile) [ old polygon(str) line(str) point(str) label(str) arrow(str) diagram(str) scalebar(str) palette(name)
               reverse clr0(str) clrx(str) clry(str) clrsaturate(num) cut(pctile|equal) cutx(numlist) cuty(numlist) binsproper bins(num >=2) binx(num
               >=2) biny(num >=2)  count percent showlegend lcolor(str) lwidth(str) ndlc(str) ndfcolor(str) ndfsize(str) xdiscrete ydiscrete
               labxgap(num) labygap(num) textx(str) texty(str) formatx(str) formaty(str) detail wrap(num) textsize(str) textlabsize(str) vallabsize(str)
               textcolor(str) textlabcolor(str) vallabcolor(str) fxsize(num) fysize(num) scale(num) * ]
```

with the following minimal syntax requirement:

```stata
bimap vary varx, shp(shapefile)
```

Note that v2.0 changes the use of the shapefile syntax. This might be a minor inconvinience for older users of bimap.

See `help bimap` for details.



## Citation guidelines
Software packages take countless hours of programming, testing, and bug fixing. If you use this package, then a citation would be highly appreciated. 

The [SSC citation](https://ideas.repec.org/c/boc/bocode/s459063.html) is recommended. Please note that the GitHub version might be newer than the SSC version.



## Examples

The examples showcase both the syntax for the use with `geoplot` (first syntax) and `spmap` (second syntax). The map outputs have been aligned to the extent possible but very minor differences in outputs might remain. Additionally, as `geoplot` is still in active development, output might break with latest updates or syntax might change. Please report these as soon as possible.

Since I am using Stata 18+, I have to specify `old` option to pass the syntax to use `spmap`. This might be uncessary if you have older Stata versions.

Users can either download the files from [GIS](./GIS/) and dump them in a folder or directly get them from Stata:

Set up the data:

```stata
cd <change path to the working directory>

foreach x in county county_shp2 state state_shp2 usa_county2 {
	copy "https://github.com/asjadnaqvi/stata-bimap/raw/main/GIS/`x'.dta" "`x'.dta", replace
}
```



Test whether the `geoplot` is working properly. First set up the layer frames:


```stata
// create the geoframes
geoframe create county, replace shp(county_shp2)
geoframe create state, replace shp(state_shp2)
geoframe create cities usa_county2, replace shp(county_shp2)  // minor example of pairing with point location data. 

// make the country frame active
frames change county 


destring _all, replace
merge 1:1 STATEFP COUNTYFP using county_race
keep if _m==3
drop _m	
```

```stata
geoplot (area county share_afam) (line state)
```

<img src="/figures/geoplot_test.png" width="100%">


Test whether the `spmap` is working properly:


```stata
spmap share_afam using county_shp2, id(_ID) clm(custom) clb(0(10)100) fcolor(Heat)
```

<img src="/figures/bimap1_1.png" width="100%">


## Basic bimap

Let's test the `bimap` command:

```stata
bimap share_hisp share_afam, frame(county) cut(pctile) palette(pinkgreen) 
```

```stata
bimap share_hisp share_afam, shp(county_shp2) old cut(pctile) palette(pinkgreen)
```

<img src="/figures/bimap2_geo.png" width="100%">

<img src="/figures/bimap2.png" width="100%">


```stata
bimap share_hisp share_afam , frame(county) cut(pctile) palette(pinkgreen) count 
```


```stata
bimap share_hisp share_afam, shp(county_shp2) old cut(pctile) palette(pinkgreen) count 
```

<img src="/figures/bimap2_1_geo.png" width="100%">

<img src="/figures/bimap2_1.png" width="100%">



```stata
bimap share_hisp share_afam , cut(pctile) palette(pinkgreen) percent  frame(county).
```


```stata
bimap share_hisp share_afam, shp(county_shp2) old cut(pctile) palette(pinkgreen) percent 
```

<img src="/figures/bimap2_1_1_geo.png" width="100%">

<img src="/figures/bimap2_1_1.png" width="100%">


```stata
bimap share_hisp share_afam, frame(county) cut(equal) palette(pinkgreen) count 
```


```stata
bimap share_hisp share_afam, shp(county_shp2) old cut(equal) palette(pinkgreen) count 
```

<img src="/figures/bimap2_2_geo.png" width="100%">

<img src="/figures/bimap2_2.png" width="100%">


### Legacy palettes

These old palettes can still be used and will default to 3x3 bins.


```stata
local i = 1

foreach x in pinkgreen0 bluered0 greenblue0 purpleyellow0 yellowblue0 orangeblue0 brew1 brew2 brew3 census rgb viridis gscale {

		bimap share_hisp share_afam, frame(county) cut(pctile) palette(`x') percent title("Legacy scheme: `x'") 

			local ++i
}
```

```stata
local i = 1

foreach x in pinkgreen0 bluered0 greenblue0 purpleyellow0 yellowblue0 orangeblue0 brew1 brew2 brew3 census rgb viridis gscale {

		bimap share_hisp share_afam, shp(county_shp2) old cut(pctile) palette(`x') percent title("Legacy scheme: `x'") 

		local ++i
}
```

<img src="/figures/bimap3_1.png" height="250"><img src="/figures/bimap3_2.png" height="250"><img src="/figures/bimap3_3.png" height="250">
<img src="/figures/bimap3_4.png" height="250"><img src="/figures/bimap3_5.png" height="250"><img src="/figures/bimap3_6.png" height="250">
<img src="/figures/bimap3_7.png" height="250"><img src="/figures/bimap3_8.png" height="250"><img src="/figures/bimap3_9.png" height="250">
<img src="/figures/bimap3_10.png" height="250"><img src="/figures/bimap3_11.png" height="250"><img src="/figures/bimap3_12.png" height="250">
<img src="/figures/bimap3_13.png" height="250">


### Advanced examples

```
bimap share_asian share_afam, cut(pctile) palette(bluered) frame(county)  ///
	title("{fontface Arial Bold:A Stata bivariate map}") note("Data from the US Census Bureau.") ///	
		 textx("Share of African Americans") texty("Share of Asians") texts(3.5) textlabs(3)  count ///
		 lw(none) geo((line state)) 
```


```
bimap share_asian share_afam, shp(county_shp2) old cut(pctile) palette(bluered)  ///
	title("{fontface Arial Bold:A Stata bivariate map}") note("Data from the US Census Bureau.") ///	
		 textx("Share of African Americans") texty("Share of Asians") texts(3.5) textlabs(3)  count ///
		 lc() lw(none) ///
		 polygon(data("state_shp2") ocolor(white) osize(0.3))
```

<img src="/figures/bimap4_geo.png" width="100%">

<img src="/figures/bimap4.png" width="100%">


```
bimap share_asian share_afam, cut(pctile) palette(orangeblue) frame(county)  ///
	title("{fontface Arial Bold:A Stata bivariate map}") note("Data from the US Census Bureau.") ///		
		 textx("Share of African Americans") texty("Share of Asians") texts(3.5) textlabs(3)  count ///
		 lw(none) geo((line state, lc(white) lw(0.2)))  
```



```stata
bimap share_asian share_afam, shp(county_shp2) old cut(pctile) palette(yellowblue)  ///
	title("{fontface Arial Bold:A Stata bivariate map}") note("Data from the US Census Bureau.") ///		
		 textx("Share of African Americans") texty("Share of Asians") texts(3.5) textlabs(3)  count lw(none) ///
		 polygon(data("state_shp2") ocolor(black) osize(0.2)) 
```

<img src="/figures/bimap6_geo.png" width="100%">

<img src="/figures/bimap6.png" width="100%">


```stata
bimap share_asian share_hisp, cut(pctile) palette(orangeblue) frame(county)  ///
	title("{fontface Arial Bold:A Stata bivariate map}") note("Data from the US Census Bureau.") ///	
		 textx("Share of Hispanics") texty("Share of Asians") texts(3.5) textlabs(3)  count ///
		 lw(none) geo((line state, lc(black) lw(0.2)))  
```


```stata
bimap share_asian share_hisp, shp(county_shp2) old cut(pctile) palette(orangeblue)  ///
	title("{fontface Arial Bold:A Stata bivariate map}") note("Data from the US Census Bureau.") ///	
		 textx("Share of Hispanics") texty("Share of Asians") texts(3.5) textlabs(3)  count lw(none) ///
		 polygon(data("state_shp2") ocolor(black) osize(0.2)) 
```

<img src="/figures/bimap7_geo.png" width="100%">

<img src="/figures/bimap7.png" width="100%">



### Passing advanced options



```stata
bimap share_hisp share_afam, cut(pctile) palette(pinkgreen) percent  frame(county)  ///
	title("{fontface Arial Bold:A Stata bivariate map}") ///
	note("Data from the US Census Bureau. Counties with population > 100k plotted as proportional dots.", size(1.8)) ///	
		 textx("Share of African Americans") texty("Share of Hispanics") texts(3.5) textlabs(3) lw(none) ///
		 geo( (line state, lc(black) lw(0.2))  (point cities [w = tot_pop] if tot_pop>1e5, mc(lime%80) msize(0.8) lc(black))  )  
```



```stata
bimap share_hisp share_afam, shp(county_shp2) old cut(pctile) palette(pinkgreen) percent  ///
	title("{fontface Arial Bold:A Stata bivariate map}") ///
	note("Data from the US Census Bureau. Counties with population > 100k plotted as proportional dots.", size(1.8)) ///	
		 textx("Share of African Americans") texty("Share of Hispanics") texts(3.5) textlabs(3) lw(none) ///
		 polygon(data("state_shp2") ocolor(white) osize(0.3)) ///
		 point(data("usa_county2") x(_CX) y(_CY) select(keep if tot_pop>100000) proportional(tot_pop) psize(absolute) fcolor(lime%85) lc(black) lw(0.12) size(0.9) )  
```


<img src="/figures/bimap8_geo.png" width="100%">

<img src="/figures/bimap8.png" width="100%">



### v1.4 updates

Let's make a `bimap` with percentiles as cut-offs and percentages shown in boxes:

```stata
bimap share_hisp share_afam, cut(pctile) palette(orangeblue) frame(county)  ///
		note("Data from the US Census Bureau.") ///	
		texty("Share of Hispanics") textx("Share of African Americans") texts(3.5) textlabs(3)  percent  ///
			lw(none) geo((line state, lc(black) lw(0.2)))  
```


```stata
bimap share_hisp share_afam, shp(county_shp2) old cut(pctile) palette(orangeblue)  ///
		note("Data from the US Census Bureau.") ///	
		texty("Share of Hispanics") textx("Share of African Americans") texts(3.5) textlabs(3) percent lw(none) ///
		 polygon(data("state_shp2") ocolor(black) osize(0.2)) 
```

<img src="/figures/bimap9_0_geo.png" width="100%">

<img src="/figures/bimap9_0.png" width="100%">


### Custom cut-offs (v1.8)

we can now modify the cut-offs as follows:


```stata
bimap share_hisp share_afam, cut(pctile) palette(orangeblue) frame(county)  ///
		note("Data from the US Census Bureau.") ///	
		texty("Share of Hispanics") textx("Share of African Americans") texts(3.5) textlabs(3)  percent  ///
			lw(none) geo((line state, lc(black) lw(0.2)))  
```


```
bimap share_hisp share_afam, shp(county_shp2) old cuty(0(20)100) cutx(0(20)100)  palette(orangeblue)    ///
		 note("Data from the US Census Bureau.") ///	
		 texty("Share of Hispanics") textx("Share of African Americans") texts(3.5) textlabs(3)  percent  lw(none) ///
		 polygon(data("state_shp2") ocolor(black) osize(0.2)) 
```

<img src="/figures/bimap9_geo.png" width="100%">

<img src="/figures/bimap9.png" width="100%">


Cut-offs can be formatted as follows:


```
bimap share_hisp share_afam, cuty(0(25)100) cutx(0(25)100)  formatx(%3.0f) formaty(%3.0f)  palette(orangeblue) frame(county)    ///
		 note("Data from the US Census Bureau.") ///	
		 texty("Share of Hispanics") textx("Share of African Americans") texts(3.5) textlabs(3)  count  ///
			lw(none) geo((line state, lc(black) lw(0.2)))
```


```
bimap share_hisp share_afam, shp(county_shp2) old cuty(0(25)100) cutx(0(25)100)  formatx(%3.0f) formaty(%3.0f)  palette(orangeblue)    ///
		 note("Data from the US Census Bureau.") ///	
		 texty("Share of Hispanics") textx("Share of African Americans") texts(3.5) textlabs(3)  count  ///
		 lc() lw(none) ///
		 polygon(data("state_shp2") ocolor(black) osize(0.2)) 
```

<img src="/figures/bimap11_geo.png" width="100%">

<img src="/figures/bimap11.png" width="100%">


If we define only one custom cut-off, the other will automatically take on the pctile :


```
bimap share_hisp share_afam, cutx(0 2 6 100) formatx(%5.0f)   palette(orangeblue) frame(county)    ///
		 note("Data from the US Census Bureau.") ///	
		 texty("Share of Hispanics") textx("Share of African Americans") texts(3.5) textlabs(3)  percent  ///
		lw(none) geo((line state, lc(black) lw(0.2)))
```


```
bimap share_hisp share_afam, shp(county_shp2) old cutx(0 2 6 100) formatx(%5.0f)   palette(orangeblue)    ///
		 note("Data from the US Census Bureau.") ///	
		 texty("Share of Hispanics") textx("Share of African Americans") texts(3.5) textlabs(3)  percent  ///
		 lc() lw(none) ///
		 polygon(data("state_shp2") ocolor(black) osize(0.2)) 
```

<img src="/figures/bimap10_geo.png" width="100%">

<img src="/figures/bimap10.png" width="100%">


### legend checks + offset (v1.8)



```
bimap share_hisp share_afam, cut(pctile) palette(census) frame(county)  ///
		 note("Data from the US Census Bureau.", size(small)) ///	
		 texty("Share of Hispanics") textx("Share of African Americans") texts(3.2) textlabs(3)  percent labxgap(0.05) labygap(0.05) ///
		 lc(black) lw(0.03)  ///
		 geo((line state, lc(black) lw(0.2))) showlegend ///
		 geopost( ///
			compass ///
			sbar(length(1000) units(km) position(sw)) ///
			)	
```


```stata
bimap share_hisp share_afam, shp(county_shp2) old cut(pctile) palette(census)  ///
		 note("Data from the US Census Bureau.", size(small)) ///	
		 texty("Share of Hispanics") textx("Share of African Americans") texts(3.2) textlabs(3)  percent ///
		 lc(black) lw(0.03)  ///
		 polygon(data("state_shp2") ocolor(black) osize(0.2) legenda(on) leglabel(State boundaries))  ///
		 scalebar(units(500) scale(1/1000) xpos(100) label(Kilometers)) ///
		 showleg legenda(off) legend(pos(7) size(5)) legstyle(2) 
```


<img src="/figures/bimap12_geoplot.png" width="100%">

<img src="/figures/bimap12.png" width="100%">


```stata
bimap share_hisp share_afam, shp(county_shp2) old cut(pctile) palette(census)  ///
		 note("Data from the US Census Bureau.", size(small)) ///	
		 texty("Share of Hispanics") textx("Share of African Americans") texts(3.2) textlabs(3)  percent labxgap(0.05)  labygap(0.05) ///
		 lc(black) lw(0.03)  ///
		 polygon(data("state_shp2") ocolor(black) osize(0.2) legenda(on) leglabel(State boundaries))  ///
		 scalebar(units(500) scale(1/1000) xpos(100) label(Kilometers)) ///
		 showleg legenda(off) legend(pos(7) size(5)) legstyle(2) 
```


<img src="/figures/bimap12_1.png" width="100%">


### new legend checks (v1.9)

Check for legend color options:

```
bimap share_asian share_afam, cut(pctile) frame(county)   ///
	title("{fontface Arial Bold:A Stata bivariate map}") note("Data from the US Census Bureau.") ///	
		 textx("Share of African Americans") texty("Share of Asians")  count textcolor(lime) textlabcolor(blue) vallabc(red) lw(none) ///
		 geo((line state, lc(white) lw(0.3)))
```


```
bimap share_asian share_afam, shp(county_shp2) old cut(pctile)   ///
	title("{fontface Arial Bold:A Stata bivariate map}") note("Data from the US Census Bureau.") ///	
		 textx("Share of African Americans") texty("Share of Asians")  count textcolor(lime) textlabcolor(blue) vallabc(red) lw(none) ///
		 polygon(data("state_shp2") ocolor(white) osize(0.3))
```

<img src="/figures/bimap12_2_geoplot.png" width="100%">

<img src="/figures/bimap12_2.png" width="100%">


Check for label wrapping in the legend:


```stata
bimap share_asian share_afam, cut(pctile) frame(county)    ///
	title("{fontface Arial Bold:A Stata bivariate map}") note("Data from the US Census Bureau.") ///	
		 textx("Share of African Americans") texty("Share of Asians") wrap(16) count lw(none) ///
		 geo((line state, lc(white) lw(0.3)))
```

```stata
bimap share_asian share_afam, shp(county_shp2) old cut(pctile)   ///
	title("{fontface Arial Bold:A Stata bivariate map}") note("Data from the US Census Bureau.") ///	
		 textx("Share of African Americans") texty("Share of Asians") wrap(16)  count lw(none) ///
		 polygon(data("state_shp2") ocolor(white) osize(0.3))
```


<img src="/figures/bimap12_3_geoplot.png" width="100%">

<img src="/figures/bimap12_3.png" width="100%">

Check for hiding the legend:

```stata
bimap share_asian share_afam, cut(pctile) frame(county)  ///
	title("{fontface Arial Bold:A Stata bivariate map}") note("Data from the US Census Bureau.") lw(none) ///
		 geo((line state, lc(white) lw(0.3))) nolegend
```


```stata
bimap share_asian share_afam, shp(county_shp2) old cut(pctile)   ///
	title("{fontface Arial Bold:A Stata bivariate map}") note("Data from the US Census Bureau.") lw(none) ///
		 polygon(data("state_shp2") ocolor(white) lw(0.3)) nolegend
```


<img src="/figures/bimap12_4_geoplot.png" width="100%">

<img src="/figures/bimap12_4.png" width="100%">


### v1.5 updates

If condition checks with legends

```stata
bimap share_hisp share_afam if STATEFP==36, cut(pctile) palette(census) frame(county)   ///
		 title("New York") ///
		 note("Data from the US Census Bureau.", size(small)) ///	
		 texty("Share of Hispanics") textx("Share of African Americans") texts(3.2) textlabs(3)  percent ///
		 lc(black) lw(0.03)  ///
		 geo((line state if _ID==19, lc(black) lw(0.2))) nolegend
```


```stata
bimap share_hisp share_afam if STATEFP==36, shp(county_shp2) old cut(pctile) palette(census)  ///
		 title("New York") ///
		 note("Data from the US Census Bureau.", size(small)) ///	
		 texty("Share of Hispanics") textx("Share of African Americans") texts(3.2) textlabs(3) percent ///
		 lc(black) lw(0.03)  ///
		 polygon(data("state_shp2") select(keep if _ID==19) ocolor(black) osize(0.2) legenda(on) leglabel(State boundaries))  ///
		 showleg legenda(off) legend(pos(7) size(5)) legstyle(2)
```

<img src="/figures/bimap13_geoplot.png" width="100%">

<img src="/figures/bimap13.png" width="100%">


### v1.6 updates

```stata
bimap share_hisp share_afam, cut(pctile) palette(orangeblue) bins(5) frame(county) ///
		note("Data from the US Census Bureau.") ///	
		texty("Share of Hispanics") textx("Share of African Americans") texts(3.5) textlabs(3) count lw(none) ///
		 geo((line state, lc(black) lw(0.2)))
```


```stata
bimap share_hisp share_afam, shp(county_shp2) old cut(pctile) palette(orangeblue) bins(5)  ///
		note("Data from the US Census Bureau.") ///	
		texty("Share of Hispanics") textx("Share of African Americans") texts(3.5) textlabs(3) count lw(none) ///
		polygon(data("state_shp2") osize(black) ocolor(0.2)) 
```

<img src="/figures/bimap15_geoplot.png" width="100%">

<img src="/figures/bimap15.png" width="100%">

```stata
bimap share_hisp share_afam, cut(pctile) palette(orangeblue) binx(4) biny(5) frame(county)  ///
		note("Data from the US Census Bureau.") ///	
		texty("Share of Hispanics") textx("Share of African Americans") texts(3.5) textlabs(3) count lw(none) ///
		 geo((line state, lc(black) lw(0.2)))
```


```stata
bimap share_hisp share_afam, shp(county_shp2) old cut(pctile) palette(orangeblue) binx(4) biny(5)  ///
		note("Data from the US Census Bureau.") ///	
		texty("Share of Hispanics") textx("Share of African Americans") texts(3.5) textlabs(3) count lw(none) ///
		polygon(data("state_shp2") ocolor(black) osize(0.2)) 
```

<img src="/figures/bimap16_geoplot.png" width="100%">

<img src="/figures/bimap16.png" width="100%">

```stata
bimap share_hisp share_afam, cut(pctile) palette(orangeblue) binx(3) biny(8) frame(county)  ///
		note("Data from the US Census Bureau.") ///	
		texty("Share of Hispanics") textx("Share of African Americans") texts(3.5) textlabs(3) count lw(none) ///
		 geo((line state, lc(black) lw(0.2)))
```


```stata
bimap share_hisp share_afam, shp(county_shp2) old cut(pctile) palette(orangeblue) binx(3) biny(8)  ///
		note("Data from the US Census Bureau.") ///	
		texty("Share of Hispanics") textx("Share of African Americans") texts(3.5) textlabs(3) count lw(none) ///
		 polygon(data("state_shp2") ocolor(black) osize(0.2)) 
```



<img src="/figures/bimap17_geoplot.png" width="100%">

<img src="/figures/bimap17.png" width="100%">

```stata
bimap share_hisp share_afam, cut(pctile) palette(orangeblue) bins(8) frame(county)  ///
		note("Data from the US Census Bureau.") ///	
		texty("Share of Hispanics") textx("Share of African Americans") texts(3.5) textlabs(3) lw(none) ///
		 geo((line state, lc(black) lw(0.2)))
```


```stata
bimap share_hisp share_afam, shp(county_shp2) old cut(pctile) palette(orangeblue) bins(8)   ///
		note("Data from the US Census Bureau.") ///	
		texty("Share of Hispanics") textx("Share of African Americans") texts(3.5) textlabs(3) lc() lw(none) ///
		 polygon(data("state_shp2") ocolor(black) osize(0.1)) 
```

<img src="/figures/bimap18_geoplot.png" width="100%">

<img src="/figures/bimap18.png" width="100%">


```stata
bimap share_hisp share_afam, cut(pctile) palette(orangeblue) bins(8) frame(county)  ///
		note("Data from the US Census Bureau.") ///	
		texty("Share of Hispanics") textx("Share of African Americans") texts(3.5) textlabs(3) lw(none) ///
		 geo((line state, lc(black) lw(0.2)))
```


```stata
bimap share_hisp share_afam, shp(county_shp2) old cut(pctile) palette(orangeblue) reverse bins(8)   ///
		note("Data from the US Census Bureau.") ///	
		texty("Share of Hispanics") textx("Share of African Americans") texts(3.5) textlabs(3) count lw(none) ///
		 polygon(data("state_shp2") ocolor(black) osize(0.2)) 
```

<img src="/figures/bimap19_geoplot.png" width="100%">

<img src="/figures/bimap19.png" width="100%">


```stata
bimap share_hisp share_afam, cut(pctile) palette(orangeblue) clr0(white) clrx(red) bins(6) clrsat(10) frame(county)   ///
		note("Data from the US Census Bureau.") ///	
		texty("Share of Hispanics") textx("Share of African Americans") texts(3.5) textlabs(3) count lw(none) ///
		 geo((line state, lc(black) lw(0.2)))
```

```stata
bimap share_hisp share_afam, shp(county_shp2) old cut(pctile) palette(orangeblue) clr0(white) clrx(red) bins(6) clrsat(10)   ///
		note("Data from the US Census Bureau.") ///	
		texty("Share of Hispanics") textx("Share of African Americans") texts(3.5) textlabs(3) count lw(none) ///
		 polygon(data("state_shp2") ocolor(black) osize(0.2)) 
```

<img src="/figures/bimap20_geoplot.png" width="100%">

<img src="/figures/bimap20.png" width="100%">

```stata
bimap share_hisp share_afam, cut(pctile) palette(orangeblue) bins(4)  percent frame(county)   ///
		note("Data from the US Census Bureau.") ///	
		texty("Share of Hispanics") textx("Share of African Americans") texts(3.5) textlabs(3) lw(none) ///
		 geo((line state, lc(black) lw(0.2)))
```

```stata
bimap share_hisp share_afam, shp(county_shp2) old cut(pctile) palette(orangeblue) bins(4)  percent  ///
		note("Data from the US Census Bureau.") ///	
		texty("Share of Hispanics") textx("Share of African Americans") texts(3.5) textlabs(3) lw(none) ///
		 polygon(data("state_shp2") ocolor(black) osize(0.2)) 
```

<img src="/figures/bimap21_geoplot.png" width="100%">

<img src="/figures/bimap21.png" width="100%">


### showing proper bins (v1.6)

Bins can be scaled to show actual division. Use this cautiously especially if the data distribution is highly skewed. 


```stata
bimap share_hisp share_afam, cuty(0 20 60 100) cutx(0 30 50 75 100) palette(orangeblue) formatx(%5.0f)  formaty(%5.0f) binsproper frame(county)   ///
		note("Data from the US Census Bureau.") ///	
		texty("Share of Hispanics") textx("Share of African Americans") texts(3.5) textlabs(3) count lw(none) ///
		geo((line state, lc(black) lw(0.2)))
```


```stata
bimap share_hisp share_afam, shp(county_shp2) old cuty(0 20 60 100) cutx(0 30 50 75 100) palette(orangeblue) formatx(%5.0f)  formaty(%5.0f) binsproper   ///
		note("Data from the US Census Bureau.") ///	
		texty("Share of Hispanics") textx("Share of African Americans") texts(3.5) textlabs(3) count lw(none) ///
		polygon(data("state_shp2") ocolor(black) osize(0.2)) 
```

<img src="/figures/bimap22_geoplot.png" width="100%">

<img src="/figures/bimap22.png" width="100%">


### discrete variables (v1.7)

Let's make some variables discrete:

```
xtile discx = share_afam, n(4)
gen discy = share_hisp < 10


lab de dx 1 "Catx 1" 2 "Catx 2" 3 "Catx 3" 4 "Catx 4"
lab val discx dx

lab de dy 0 "Caty 0" 1 "Caty 1" 
lab val discy dy


tab discy discx, m
```

We can also now declare these variables as discrete while using `bimap` in any combination:

```stata
bimap discy share_afam, palette(yellowblue) count ydisc frame(county) 
```


```stata
bimap discy share_afam, shp(county_shp2) old palette(yellowblue) count ydisc
```

<img src="/figures/bimap23_1.png" width="100%">

<img src="/figures/bimap23_1_geoplot.png" width="100%">

 
```stata
bimap share_hisp discx, palette(yellowblue) count xdisc frame(county) 
``` 
 

```stata
bimap share_hisp discx, shp(county_shp2) old palette(yellowblue) count xdisc
```

<img src="/figures/bimap23_2_geoplot.png" width="100%">

<img src="/figures/bimap23_2.png" width="100%">

```stata
bimap discy discx, palette(yellowblue) count xdisc ydisc frame(county) 
```


```stata
bimap discy discx, shp(county_shp2) old palette(yellowblue) count xdisc ydisc
```

<img src="/figures/bimap23_3_geoplot.png" width="100%">

<img src="/figures/bimap23_3.png" width="100%">


### statvar() (v2.3)

We can now summarize a vector level variable, e.g. population in county in our example, rather than count of countries. This might be more meaningful especially if population sizes vary considerably.

```
replace tot_pop = tot_pop / 1e6

summ tot_pop
di "`r(sum)'"
```

which shows a population of approximately 329 million. Here is a comparison of with defining the `statvar()` option. If we just specify `count`, we get the sum of population for each category:

```stata
bimap share_hisp share_afam, palette(orangeblue)  frame(county)  ///
		 ndfcolor(pink) ndocolor(lime) ndsize(0.2)  count  ///
		 geo((line state, lc(black) lw(0.2))) 	 
		 
bimap share_hisp share_afam, palette(orangeblue)  frame(county)  ///
		 ndfcolor(pink) ndocolor(lime) ndsize(0.2)  count  ///
		 geo((line state, lc(black) lw(0.2))) statvar(tot_pop)			 
```

Where the summ of cells in the second map now equals total population:

<img src="/figures/bimap25_statvar1.png" width="100%">

<img src="/figures/bimap25_statvar2.png" width="100%">

We can similarly use `percentage` to compare count-weighted cells versus population-weighted cells:

```stata
bimap share_hisp share_afam, palette(orangeblue) frame(county)  ///
		 ndfcolor(pink) ndocolor(lime) ndsize(0.2)  percent  ///
		 geo((line state, lc(black) lw(0.2))) 
		 
bimap share_hisp share_afam, palette(orangeblue) frame(county)  ///
		 ndfcolor(pink) ndocolor(lime) ndsize(0.2)  percent  ///
		 geo((line state, lc(black) lw(0.2))) statvar(tot_pop)		
```

And observe that shares change quite a bit:

<img src="/figures/bimap25_statvar3.png" width="100%">

<img src="/figures/bimap25_statvar4.png" width="100%">

### missing data (v1.81)

```stata
replace share_hisp = . if stname=="Texas"
```

```stata
bimap share_hisp share_afam, palette(orangeblue)  frame(county)  ///
		 ndfcolor(pink) ndlc(lime) ndsize(0.2) count  ///
		 geo((line state, lc(black) lw(0.2)))
```


```stata
bimap share_hisp share_afam, shp(county_shp2) old palette(orangeblue)    ///
		 ndfcolor(pink) ndlc(lime) ndsize(0.3) count  ///
		 polygon(data("state_shp2") ocolor(black) osize(0.2)) 
```

<img src="/figures/bimap24_geoplot.png" width="100%">

<img src="/figures/bimap24.png" width="100%">

## Feedback

Please open an [issue](https://github.com/asjadnaqvi/stata-bimap/issues) to report errors, feature enhancements, and/or other requests. 


## Change log

**v2.3 (14 Mar 2025)**
- New option `statvar()` added that now allows us to summarize each cell by a sum of the underlying variable. E.g. population counts might make more sense than cell counts. Many thanks to **Minh Nguyen** for the amazing suggestion.
- Option `formatval()` is now just `format()`. This modifies the format of the cells and now the universal default if `format(%5.1f)`. 
- Minor code improvements.

**v2.2 (23 Feb 2025)**
- Legend labels are now shown be default. Previously, these had to be enabled via the `values` option. This has been replace with `novalue`, which now turns off the labels.
- `ocolor()` and `osize()` have been changed to `lcolor()` and `lwidth()` to align it with standard Stata use. No data options remain as they are (for now) since these are only used in `spmap` currently. Please note that this change also makes the use of `bimap` with `bimap` a bit convoluted since secondary layers passed on as `polygon()` would still require the default `osize()` and `ocolor()` options. See examples above.
- `xscale()` and `yscale()` renamed to `fxsize()` and `fysize()` the correct options for Stata. These were also reworked to allow for proper lagend scaling. Defaults also updated.
- Option `scale()` added to allow easy scaling of legend text. 
- Added `geopre()` that allows users to draw layers underneath the bimap layer. This is in constrast to `geo()` that draws layers on top of the bimap layer.
- Option `tight`, a default in the backgroud has been removed. Users now have to specify it additionally as `geopost(tight)`. 
- Many other bug fixes.

**v2.1 (18 Oct 2024)**
- Supporting for better label wrapping added using `graphfunctions`. The latest version of this package is required.
- Minor syntax cleanups.

**v2.0 (22 Aug 2024)**
- Major update. Support for `geoplot` for Stata versions 17 or newer. Support for `spmap` for Stata versions 16 or older. Versions are auto detected.
- Stata 17 or newer users can use the option `old` to call in the `spmap` version. This ensures that the code of seasoned `bimap` users does not break.
- Minor change in syntax for `spmap` versions from `bimap y x using shapefile` to `bimap y x, shp(shapefile)`. This is to ensure consistency for upcoming releases.
- Option `detail` added to show which Stata version is detected and which map program is used. This might be useful in case you want to have more information. 

**v1.9 (19 Jun 2024)**
- Fixed and added several options to control legends: `textcolor()`, `textlabcolor()`, `vallabcolor()`. 
- Better options for `textsize()`, `textlabsize()`, `vallabsize()`.
- Added `wrap()` to wrap labels in legends.
- Added `nolegend` option to generate maps without a bi-variate legend. This is useful is several maps are being generated with a controlled legend and need to be combined in one figure.
- Several improvements to graph passthru options.

**v1.82 (04 May 2024)**
- Added `textcolor()` to control random colors appearing in legend labels under some schemes.
- Backend improvements to some defaults.

**v1.81 (22 Aug 2023)**
- Fixed a bug where missing data points where getting dropped (reported by Steve Johnson).
- Fixed passthru of the `ndisze()` option.

**v1.8 (26 Jun 2023)**
- Changed the ways `cutx()` and `cuty()` are calculated (requested by Paul Hufe). These now take on lists which are used as provided.
- Removed `textgap()` that was left over from the old legend code.
- Added `labxgap()` and `labygap()` to allows users to offset the labels and improved the position of the legend axes titles.
- Various improvements including 

**v1.7 (15 Jun 2023)**
- Added two new options `xdiscrete` and `ydiscrete` to support discrete variables.

**v1.62 (19 May 2023)**
- Fixed bugs in legend labels (reported by Kit Baum). Minor improvements.

**v1.61 (12 Apr 2023)**
- Fixed a major bug in the legend. The boxes were not rescaling properly.

**v1.6 (17 Mar 2023)** (major update)
- Scalable color palettes.
- Customizable bins.
- Customizable colors.
- Dynamic scalable legends.
- Option for proper spacing of bins on legends.
- Several defaults and checks added.
- Several quality of life adjustments to make `bimap` easier to use.

**v1.51 (14 Nov 2022)** 
- Minor fixes to legend text options.

**v1.5 (05 Nov 2022)**
- Three new palettes added: `rgb`, `viridis`, `gscale`.
- Added `spmap` passthru options for `arrow`, `diagram`, and `scalebar`.

**v1.4 (04 Oct 2022)**
- Added the option to add custom cut-offs.
- Added the option to format cut-offs,
- Added the option to show default `spmap` legends.
- Code clean up. New error checks.

**v1.33 (29 Sep 2022)**
- Bug fixes to `spmap` passthru options.
- Add a new option `textgap` to allow adjustment of the distance of axes labels to the legend.

**v1.32 (19 Aug 2022)**
- Fixed an error in variable name comparisons (thanks to Cristian Jordan Diaz).

**v1.31 (20 Jun 2022)**
- Error fix in cut-offs skipping the last shape file (thanks to Mattias Öhman).
- Fixed color assignments to the 3x3 groups. If a group was missing, the colors were wrongly assigned.

**v1.3 (26 May 2022)**
- Percent option added to legend to show box share (thanks to Kit Baum).
- Legend corner label made lighter for visibility.
- Four special use palettes added: `brew1`, `brew2`, `brew3`, `brew4`, `census`.

**v1.2 (29 Apr 2022)**
- Fixed a bug in cut-off groupings (thanks to Ruth Watkinson).
- Error in how cut-off  are collected is fixed.
- Two palettes added  `yellowblue`, `orangeblue`. If you have more palette suggestions, then please let me know!
- Several `spmap` additional layer commands added as passthru options (thanks to Pierre-Henri Bono).
- Count of each category added as an option.
- Several bug fixes and error checks added.

**v1.1 (14 Apr 2022)**
- Errors in ado file corrected.
- Help file was missing a couple of options.

**v1.0 (08 Apr 2022)**
- Public release.




