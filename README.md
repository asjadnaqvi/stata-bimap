# bimap v1.0

This package provides the ability to draw bi-variate maps in Stata. It is based on the [Bi-variate maps Guide](https://medium.com/the-stata-guide/stata-graphs-bi-variate-maps-b1e96dd4c2be) that I released in December 2021.


## Installation

The package has been submitted to SSC and should be installable as:
```
ssc install bimap, replace
```

Or it can be installed from GitHub:

```
net install bimap, from("https://raw.githubusercontent.com/asjadnaqvi/stata-bimap/main/installation/") replace
```

The GitHub version, *might* be more recent due to bug fixes, feature updates etc.

The `spmap` and `palettes` package is required to run this command:

```
ssc install spmap, replace
ssc install palettes, replace
ssc install colrspace, replace
```

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

The syntax is as follows:

```

bimap vary varx [if] [in], cut(option) palette(option) 
                [ ocolor(str) osize(str) ndocolor(str) ndsize(str) ndocolor(str) polygon(str)
                textx(string) texty(str) values TEXTLABSize(num) TEXTSize(num) BOXsize(num) xscale(num) yscale(num) 
                title(str) subtitle(str) note(str) scheme(str) ]
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

Test if `spmap` is working properly.

We can generate basic graphs as follows:

```
spmap share_afam using usa_county_shp_clean, id(_ID) clm(custom) clb(0(10)100) fcolor(Heat)
```

<img src="/figures/bimap1.png" height="600">


Let's test the command:

```
bimap share_hisp share_afam using usa_county_shp_clean, cut(pctile) palette(pinkgreen) 	
```

<img src="/figures/bimap2.png" height="600">


```
bimap share_hisp share_afam using usa_county_shp_clean, cut(pctile) palette(purpleyellow) ///
	title("My first bivariate map") subtitle("Made with Stata") note("Data from US Census")
```

<img src="/figures/bimap3.png" height="600">



```
bimap share_asian share_afam using usa_county_shp_clean, cut(pctile) palette(bluered)  ///
	title("My first bivariate map") subtitle("Made with Stata") note("Data from US Census Bureau.") ///	
		 textx("Share African Americans") texty("Share of Asians") texts(3.5) textlabs(3) values ///
		 ocolor() osize() ///
		 polygon(data("usa_state_shp_clean") ocolor(white) osize(0.3))
```

<img src="/figures/bimap4.png" height="600">

## Feedback

Please open an [issue](https://github.com/asjadnaqvi/stata-bimap/issues) to report errors, feature enhancements, and/or other requests. 


## Versions

**v1.0 (08 Apr 2022)**
- Public release.







