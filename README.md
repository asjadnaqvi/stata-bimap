
![StataMin](https://img.shields.io/badge/stata-2015-blue) ![issues](https://img.shields.io/github/issues/asjadnaqvi/stata-bimap) ![license](https://img.shields.io/github/license/asjadnaqvi/stata-bimap) ![Stars](https://img.shields.io/github/stars/asjadnaqvi/stata-bimap) ![version](https://img.shields.io/github/v/release/asjadnaqvi/stata-bimap) ![release](https://img.shields.io/github/release-date/asjadnaqvi/stata-bimap)

# bimap v1.2

This package provides the ability to draw bi-variate maps in Stata. It is based on the [Bi-variate maps Guide](https://medium.com/the-stata-guide/stata-graphs-bi-variate-maps-b1e96dd4c2be) that I released in December 2021.


## Installation

The package can be installed via SSC or GitHub. The GitHub version, *might* be more recent due to bug fixes, feature updates etc, and *may* contain syntax improvements and changes in *default* values. See version numbers below. Eventually the GitHub version is published on SSC.

The package can be installed from SSC (**v1.0**):
```
ssc install bimap, replace
```

Or it can be installed from GitHub (**v1.2**):

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

If you want to make a clean figure, then it is advisable to load a clean scheme. These are several available and I personally use the following:

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

The syntax for **v1.2** is as follows:

```

bimap vary varx [if] [in], cut(option) palette(option) 
		[ count values ocolor(str) osize(str) ndocolor(str) ndsize(str) ndocolor(str)
		polygon(str) line(str) point(str) label(str) 
		textx(string) texty(str) TEXTLABSize(num) TEXTSize(num) BOXsize(num) xscale(num) yscale(num) 
		title(str) subtitle(str) note(str) name(srt) scheme(str) ]
```

See the help file `help bimap` for details.

The most basic use is as follows:

```
bimap vary varx using *shapefile*, cut(option) palette(option)
```

where `vary` and `varx` are the variables we want to plot. The `cut` option takes on one argument which is either `pctile` or `equal` for percentile and equal cut offs respectively. The palette option takes on one argument which are `pinkgreen`, `bluered`, `greenblue`, or `purpleyellow`. These are frequently-used bi-variate palettes baked into the command.



## Examples

Download the files from [GIS](./GIS/) and dump them in a folder.

Set up the data:

```
clear
set scheme white_tableau
graph set window fontface "Arial Narrow"


// set the directory to the GIS folder 
// cd <path>

use usa_county, clear
	destring _all, replace
	
merge 1:1 STATEFP COUNTYFP using county_race
keep if _m==3
drop _m	
```

Test whether the `spmap` is working properly:


```
spmap share_afam using usa_county_shp_clean, id(_ID) clm(custom) clb(0(10)100) fcolor(Heat)
```

<img src="/figures/bimap1_1.png" height="600">


```
spmap share_hisp using usa_county_shp_clean, id(_ID) clm(custom) clb(0(10)100) fcolor(Heat)
```

<img src="/figures/bimap1_2.png" height="600">




Let's test the `bimap` command:

```
bimap share_hisp share_afam using usa_county_shp_clean, cut(pctile) palette(pinkgreen) 	
```

<img src="/figures/bimap2.png" height="600">


```
bimap share_hisp share_afam using usa_county_shp_clean, cut(pctile) palette(pinkgreen) count values
```

<img src="/figures/bimap2_1.png" height="600">


```
bimap share_hisp share_afam using usa_county_shp_clean, cut(equal) palette(pinkgreen) count values
```

<img src="/figures/bimap2_2.png" height="600">


```
bimap share_hisp share_afam using usa_county_shp_clean, cut(pctile) palette(purpleyellow) ///
	title("My first bivariate map") subtitle("Made with Stata") note("Data from US Census")
```

<img src="/figures/bimap3.png" height="600">


```
bimap share_asian share_afam using usa_county_shp_clean, cut(pctile) palette(bluered)  ///
	title("{fontface Arial Bold:My first bivariate map}") subtitle("Made with Stata") note("Data from the US Census Bureau.") ///	
	textx("Share of African Americans") texty("Share of Asians") texts(3.5) textlabs(3) values count ///
	ocolor() osize(none) ///
	polygon(data("usa_state_shp_clean") ocolor(white) osize(0.3))
```

<img src="/figures/bimap4.png" height="600">



```
bimap share_asian share_afam using usa_county_shp_clean, cut(pctile) palette(yellowblue)  ///
	title("{fontface Arial Bold:My first bivariate map}") subtitle("Made with Stata") note("Data from the US Census Bureau.") ///	
		 textx("Share of African Americans") texty("Share of Asians") texts(3.5) textlabs(3) values count ///
		 ocolor() osize(none) ///
		 polygon(data("usa_state_shp_clean") ocolor(black) osize(0.2)) 
```

<img src="/figures/bimap6.png" height="600">


## Feedback

Please open an [issue](https://github.com/asjadnaqvi/stata-bimap/issues) to report errors, feature enhancements, and/or other requests. 


## Versions

**v1.2 (29 Apr 2022)**
- Fixed a bug in cut-off groupings (thanks to Ruth Watkinson).
- Error in how cut-off are collected fixed.
- Several `spmap` additional layer commands added as passthru options (thanks to Pierre-Henri Bono).
- Count of each category added as an option.
- Several bug fixes and error checks added.

**v1.1 (14 Apr 2022)**
- Errors in ado file corrected.
- Help file was missing a couple of options.


**v1.0 (08 Apr 2022)**
- Public release.







