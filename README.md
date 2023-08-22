
![bimap_banner_v2](https://github.com/asjadnaqvi/stata-bimap/assets/38498046/3d7415bd-ffba-4576-ba74-4a27921440ea)

![StataMin](https://img.shields.io/badge/stata-2015-blue) ![issues](https://img.shields.io/github/issues/asjadnaqvi/stata-bimap) ![license](https://img.shields.io/github/license/asjadnaqvi/stata-bimap) ![Stars](https://img.shields.io/github/stars/asjadnaqvi/stata-bimap) ![version](https://img.shields.io/github/v/release/asjadnaqvi/stata-bimap) ![release](https://img.shields.io/github/release-date/asjadnaqvi/stata-bimap)


---

[Installation](#Installation) | [Syntax](#Syntax) | [Examples](#Examples) | [Feedback](#Feedback) | [Change log](#Change-log)

---

# bimap v1.81
(22 Aug 2023)

This package provides the ability to draw bi-variate maps in Stata. It is based on the [Bi-variate maps Guide](https://medium.com/the-stata-guide/stata-graphs-bi-variate-maps-b1e96dd4c2be).


## Installation

The package can be installed via SSC or GitHub. The GitHub version, *might* be more recent due to bug fixes, feature updates etc, and *may* contain syntax improvements and changes in *default* values. See version numbers below. Eventually the GitHub version is published on SSC. All examples are updated to the latest version and might not be compatible with the old ones. Please check the documentation and change logs.

The package can be installed from SSC (**v1.8**):
```
ssc install bimap, replace
```

Or it can be installed from GitHub (**v1.81**):

```
net install bimap, from("https://raw.githubusercontent.com/asjadnaqvi/stata-bimap/main/installation/") replace
```


The `spmap` and `palettes` package is required to run this command:

```
ssc install spmap, replace
ssc install palettes, replace
ssc install colrspace, replace
```

Even if you have these packages installed, please check for updates: `ado update, update`.

If you want to make a clean figure, then it is advisable to load a clean scheme. I personally use the following:

```
ssc install schemepack, replace
set scheme white_tableau  
```

You can also push the scheme directly into the graph using the `scheme(schemename)` option. See the help file for details or the example below.

I also prefer narrow fonts in figures with long labels. You can change this as follows:

```
graph set window fontface "Arial Narrow"
```

This command is a wrapper for `spmap` and assumes that you have shapefiles in Stata and are comfortable with making maps.


## Syntax

The syntax for the latest version is as follows:

```stata
bimap vary varx [if] [in], [ palette(name) reverse  clr0(str) clrx(str) clry(str) clrsaturate(num)
                cut(pctile|equal) cutx(numlist) cuty(numlist) binsproper bins(num >=2) binx(num >=2) biny(num >=2) values count 
                percent showlegend ocolor(str) osize(str) ndocolor(str) ndfcolor(str) ndsize(str) xdiscrete ydiscrete labxgap(num) labygap(num)
                textx(str) texty(str) textlabsize(num) textsize(num) formatx(str) formaty(str) xscale(num) yscale(num) 
                polygon(options) line(options) point(options) label(options) arrow(options) diagram(options) scalebar(options) 
                title(str) subtitle(str) note(str) name(str) scheme(str) ]
```

See the help file `help bimap` for details.

The most basic use is as follows:

```
bimap vary varx using *shapefile*
```

See helpfile for further details



## Examples

Download the files from [GIS](./GIS/) and dump them in a folder.

Set up the data:

```
clear
set scheme white_tableau
graph set window fontface "Arial Narrow"


// set the directory to the GIS folder 
// cd <path>

use county, clear
destring _all, replace
merge 1:1 STATEFP COUNTYFP using county_race
keep if _m==3
drop _m	

save usa_county2.dta, replace   
```

Test whether the `spmap` is working properly:


```
spmap share_afam using county_shp2, id(_ID) clm(custom) clb(0(10)100) fcolor(Heat)
```

<img src="/figures/bimap1_1.png" height="500">


```
spmap share_hisp using county_shp2, id(_ID) clm(custom) clb(0(10)100) fcolor(Heat)
```

<img src="/figures/bimap1_2.png" height="500">


Let's test the `bimap` command:

```
bimap share_hisp share_afam using county_shp2, cut(pctile) palette(pinkgreen) 
```

<img src="/figures/bimap2.png" height="500">


```
bimap share_hisp share_afam using county_shp2, cut(pctile) palette(pinkgreen) count values
```

<img src="/figures/bimap2_1.png" height="500">

```
bimap share_hisp share_afam using county_shp2, cut(pctile) palette(pinkgreen) percent values
```

<img src="/figures/bimap2_1_1.png" height="500">

```
bimap share_hisp share_afam using county_shp2, cut(equal) palette(pinkgreen) count values
```

<img src="/figures/bimap2_2.png" height="500">


### Legacy palettes

These old palettes can still be used and will default to 3x3 bins.

```
local i = 1

foreach x in pinkgreen0 bluered0 greenblue0 purpleyellow0 yellowblue0 orangeblue0 brew1 brew2 brew3 census rgb viridis gscale {

		bimap share_hisp share_afam using county_shp2, cut(pctile) palette(`x') percent title("Legacy scheme: `x'") 
		graph export bimap3_`i'.png, replace wid(2000)	

			local i = `i' + 1

}
```

<img src="/figures/bimap3_1.png" height="250"><img src="/figures/bimap3_2.png" height="250"><img src="/figures/bimap3_3.png" height="250">
<img src="/figures/bimap3_4.png" height="250"><img src="/figures/bimap3_5.png" height="250"><img src="/figures/bimap3_6.png" height="250">
<img src="/figures/bimap3_7.png" height="250"><img src="/figures/bimap3_8.png" height="250"><img src="/figures/bimap3_9.png" height="250">
<img src="/figures/bimap3_10.png" height="250"><img src="/figures/bimap3_11.png" height="250"><img src="/figures/bimap3_12.png" height="250">
<img src="/figures/bimap3_13.png" height="250">


### Advanced examples

```
bimap share_asian share_afam using county_shp2, cut(pctile) palette(bluered)  ///
	title("{fontface Arial Bold:A Stata bivariate map}") note("Data from the US Census Bureau.") ///	
		 textx("Share of African Americans") texty("Share of Asians") texts(3.5) textlabs(3) values count ///
		 ocolor() osize(none) ///
		 polygon(data("state_shp2") ocolor(white) osize(0.3))
```

<img src="/figures/bimap4.png" height="500">


```
bimap share_asian share_afam using county_shp2, cut(pctile) palette(yellowblue)  ///
	title("{fontface Arial Bold:A Stata bivariate map}") note("Data from the US Census Bureau.") ///		
		 textx("Share of African Americans") texty("Share of Asians") texts(3.5) textlabs(3) values count ///
		 ocolor() osize(none) ///
		 polygon(data("state_shp2") ocolor(black) osize(0.2)) 
```

<img src="/figures/bimap6.png" height="500">


```
bimap share_asian share_hisp  using county_shp2, cut(pctile) palette(orangeblue)  ///
	title("{fontface Arial Bold:A Stata bivariate map}") note("Data from the US Census Bureau.") ///	
		 textx("Share of Hispanics") texty("Share of Asians") texts(3.5) textlabs(3) values count ///
		 ocolor() osize(none) ///
		 polygon(data("state_shp2") ocolor(black) osize(0.2)) 
```

<img src="/figures/bimap7.png" height="500">



Since `bimap` is a wrapper of `spmap`, we can pass information for other layers as well including dots. Below we use the file we saved in the first step to plot the population of counties:

```
bimap share_hisp share_afam using county_shp2, cut(pctile) palette(pinkgreen) percent  ///
	title("{fontface Arial Bold:A Stata bivariate map}") ///
	note("Data from the US Census Bureau. Counties with population > 100k plotted as proportional dots.", size(1.8)) ///	
		 textx("Share of African Americans") texty("Share of Hispanics") texts(3.5) textlabs(3) values  ///
		 ocolor() osize(none) ///
		 polygon(data("state_shp2") ocolor(white) osize(0.3)) ///
		 point(data("county") x(_CX) y(_CY) select(keep if tot_pop>100000) proportional(tot_pop) psize(absolute) fcolor(lime%85) ocolor(black) osize(0.12) size(0.9) )  
```

<img src="/figures/bimap8.png" height="500">



### v1.4 updates

Let's make a `bimap` with percentiles as cut-offs and percentages shown in boxes:

```
bimap share_hisp share_afam using county_shp2, cut(pctile) palette(orangeblue)  ///
		note("Data from the US Census Bureau.") ///	
		texty("Share of Hispanics") textx("Share of African Americans") texts(3.5) textlabs(3) values percent  ///
		 ocolor() osize(none) ///
		 polygon(data("state_shp2") ocolor(black) osize(0.2)) 
```

<img src="/figures/bimap9_0.png" height="500">


### Custom cut-offs (v1.8)

we can now modify the cut-offs as follows:

```
bimap share_hisp share_afam using county_shp2, cuty(0(20)100) cutx(0(20)100)  palette(orangeblue)    ///
		 note("Data from the US Census Bureau.") ///	
		 texty("Share of Hispanics") textx("Share of African Americans") texts(3.5) textlabs(3) values percent  ///
		 ocolor() osize(none) ///
		 polygon(data("state_shp2") ocolor(black) osize(0.2)) 
```

<img src="/figures/bimap9.png" height="500">


Cut-offs can be formatted as follows:

```
bimap share_hisp share_afam using county_shp2, cuty(0(25)100) cutx(0(25)100)  formatx(%3.0f) formaty(%3.0f)  palette(orangeblue)    ///
		 note("Data from the US Census Bureau.") ///	
		 texty("Share of Hispanics") textx("Share of African Americans") texts(3.5) textlabs(3) values count  ///
		 ocolor() osize(none) ///
		 polygon(data("state_shp2") ocolor(black) osize(0.2)) 
```

<img src="/figures/bimap11.png" height="500">


If we define only one custom cut-off, the other will automatically take on the pctile values:

```
bimap share_hisp share_afam using county_shp2, cutx(0 2 6 100) formatx(%5.0f)   palette(orangeblue)    ///
		 note("Data from the US Census Bureau.") ///	
		 texty("Share of Hispanics") textx("Share of African Americans") texts(3.5) textlabs(3) values percent  ///
		 ocolor() osize(none) ///
		 polygon(data("state_shp2") ocolor(black) osize(0.2)) 
```

<img src="/figures/bimap10.png" height="500">


### legend checks + offset (v1.8)

`spmap` legend options can be passed to `bimap` to describe additional layers:


```
bimap share_hisp share_afam using county_shp2, cut(pctile) palette(census)  ///
		 note("Data from the US Census Bureau.", size(small)) ///	
		 texty("Share of Hispanics") textx("Share of African Americans") texts(3.2) textlabs(3) values percent ///
		 ocolor(black) osize(0.03)  ///
		 polygon(data("state_shp2") ocolor(black) osize(0.2) legenda(on) leglabel(State boundaries))  ///
		 scalebar(units(500) scale(1/1000) xpos(100) label(Kilometers)) ///
		 showleg legenda(off) legend(pos(7) size(5)) legstyle(2) 
```

<img src="/figures/bimap12.png" height="500">


```
bimap share_hisp share_afam using county_shp2, cut(pctile) palette(census)  ///
		 note("Data from the US Census Bureau.", size(small)) ///	
		 texty("Share of Hispanics") textx("Share of African Americans") texts(3.2) textlabs(3) values percent labxgap(0.05)  labygap(0.05) ///
		 ocolor(black) osize(0.03)  ///
		 polygon(data("state_shp2") ocolor(black) osize(0.2) legenda(on) leglabel(State boundaries))  ///
		 scalebar(units(500) scale(1/1000) xpos(100) label(Kilometers)) ///
		 showleg legenda(off) legend(pos(7) size(5)) legstyle(2) 
```

<img src="/figures/bimap12_1.png" height="500">


### v1.5 updates

If condition checks with legends

```
bimap share_hisp share_afam using county_shp2 if STATEFP==36, cut(pctile) palette(census)  ///
		 title("New York") ///
		 note("Data from the US Census Bureau.", size(small)) ///	
		 texty("Share of Hispanics") textx("Share of African Americans") texts(3.2) textlabs(3) values percent ///
		 ocolor(black) osize(0.03)  ///
		 polygon(data("state_shp2") select(keep if _ID==19) ocolor(black) osize(0.2) legenda(on) leglabel(State boundaries))  ///
		 showleg legenda(off) legend(pos(7) size(5)) legstyle(2)
```

<img src="/figures/bimap13.png" height="500">

```
bimap share_hisp share_afam using county_shp2 if STATEFP==36, cut(pctile) palette(census)  ///
		 title("New York") ///
		 note("Data from the US Census Bureau.", size(small)) ///	
		 texty("Share of Hispanics") textx("Share of`=char(10)'African Americans") texts(3.2) textlabs(3) values percent ///
		 ocolor(black) osize(0.03)  ///
		 polygon(data("state_shp2") select(keep if _ID==19) ocolor(black) osize(0.2) legenda(on) leglabel(State boundaries))  ///
		 showleg legenda(off) legend(pos(7) size(5)) legstyle(2) 
```

<img src="/figures/bimap14.png" height="500">


### v1.6 updates

```
bimap share_hisp share_afam using county_shp2, cut(pctile) palette(orangeblue) bins(5)  ///
		note("Data from the US Census Bureau.") ///	
		texty("Share of Hispanics") textx("Share of African Americans") texts(3.5) textlabs(3) values count  ///
		ocolor() osize(none) ///
		polygon(data("state_shp2") ocolor(black) osize(0.2)) 
```

<img src="/figures/bimap15.png" height="500">

```
bimap share_hisp share_afam using county_shp2, cut(pctile) palette(orangeblue) binx(4) biny(5)  ///
		note("Data from the US Census Bureau.") ///	
		texty("Share of Hispanics") textx("Share of African Americans") texts(3.5) textlabs(3) values count  ///
		ocolor() osize(none) ///
		polygon(data("state_shp2") ocolor(black) osize(0.2)) 
```

<img src="/figures/bimap16.png" height="500">

```
bimap share_hisp share_afam using county_shp2, cut(pctile) palette(orangeblue) binx(3) biny(8)  ///
		note("Data from the US Census Bureau.") ///	
		texty("Share of Hispanics") textx("Share of African Americans") texts(3.5) textlabs(3) values count  ///
		 ocolor() osize(none) ///
		 polygon(data("state_shp2") ocolor(black) osize(0.2)) 
```

<img src="/figures/bimap17.png" height="500">

```
bimap share_hisp share_afam using county_shp2, cut(pctile) palette(orangeblue) bins(8)   ///
		note("Data from the US Census Bureau.") ///	
		texty("Share of Hispanics") textx("Share of African Americans") texts(3.5) textlabs(3) values   ///
		 ocolor() osize(none) ///
		 polygon(data("state_shp2") ocolor(black) osize(0.1)) 
```

<img src="/figures/bimap18.png" height="500">

```
bimap share_hisp share_afam using county_shp2, cut(pctile) palette(orangeblue) reverse bins(8)   ///
		note("Data from the US Census Bureau.") ///	
		texty("Share of Hispanics") textx("Share of African Americans") texts(3.5) textlabs(3) values count  ///
		 ocolor() osize(none) ///
		 polygon(data("state_shp2") ocolor(black) osize(0.2)) 
```

<img src="/figures/bimap19.png" height="500">

```
bimap share_hisp share_afam using county_shp2, cut(pctile) palette(orangeblue) clr0(white) clrx(red) bins(6) clrsat(10)   ///
		note("Data from the US Census Bureau.") ///	
		texty("Share of Hispanics") textx("Share of African Americans") texts(3.5) textlabs(3) values count  ///
		 ocolor() osize(none) ///
		 polygon(data("state_shp2") ocolor(black) osize(0.2)) 
```

<img src="/figures/bimap20.png" height="500">

```
bimap share_hisp share_afam using county_shp2, cut(pctile) palette(orangeblue) bins(4)  percent  ///
		note("Data from the US Census Bureau.") ///	
		texty("Share of Hispanics") textx("Share of African Americans") texts(3.5) textlabs(3) values   ///
		 ocolor() osize(none) ///
		 polygon(data("state_shp2") ocolor(black) osize(0.2)) 
```

<img src="/figures/bimap21.png" height="500">


### showing proper bins (v1.6)

Bins can be scaled to show actual division. Use this cautiously especially if the data distribution is highly skewed. 

```
bimap share_hisp share_afam using county_shp2, cuty(0 20 60 100) cutx(0 30 50 75 100) palette(orangeblue) formatx(%5.0f)  formaty(%5.0f) binsproper   ///
		note("Data from the US Census Bureau.") ///	
		texty("Share of Hispanics") textx("Share of African Americans") texts(3.5) textlabs(3) values count  ///
		 ocolor() osize(none) ///
		 polygon(data("state_shp2") ocolor(black) osize(0.2)) 
```

<img src="/figures/bimap22.png" height="500">


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

```
bimap discy share_afam using county_shp2, palette(yellowblue) values count ydisc
```

<img src="/figures/bimap23_1.png" height="500">
 

```
bimap share_hisp discx using county_shp2, palette(yellowblue) values count xdisc
```

<img src="/figures/bimap23_2.png" height="500">

```
bimap discy discx using county_shp2, palette(yellowblue) values count xdisc ydisc
```

<img src="/figures/bimap23_3.png" height="500">


### missing data fixed (v1.81)

```
use county, clear
destring _all, replace
merge 1:1 STATEFP COUNTYFP using county_race
keep if _m==3
drop _m	

replace share_hisp = . if stname=="Texas"

bimap share_hisp share_afam using county_shp2, palette(orangeblue)    ///
		 ndfcolor(pink) ndocolor(lime) ndsize(0.3)  ///
		 values count  ///
		 polygon(data("state_shp2") ocolor(black) osize(0.2)) 
```

<img src="/figures/bimap24.png" height="500">

## Feedback

Please open an [issue](https://github.com/asjadnaqvi/stata-bimap/issues) to report errors, feature enhancements, and/or other requests. 


## Change log

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
- Error in how cut-off values are collected is fixed.
- Two palettes added  `yellowblue`, `orangeblue`. If you have more palette suggestions, then please let me know!
- Several `spmap` additional layer commands added as passthru options (thanks to Pierre-Henri Bono).
- Count of each category added as an option.
- Several bug fixes and error checks added.

**v1.1 (14 Apr 2022)**
- Errors in ado file corrected.
- Help file was missing a couple of options.

**v1.0 (08 Apr 2022)**
- Public release.




