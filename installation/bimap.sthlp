{smcl}
{* 29April2022}{...}
{hi:help bimap}{...}
{right:{browse "https://github.com/asjadnaqvi/stata-bimap":bimap v1.2 (GitHub)}}

{hline}

{title:bimap}: A Stata package for bi-variate maps. 

{p 4 4 2}
The package is based on the following guide on Medium: {browse "https://medium.com/the-stata-guide/stata-graphs-bi-variate-maps-b1e96dd4c2be":Bi-variate maps}.

The {cmd:bimap} command is a wrapper for {stata help spmap:spmap}. Therefore it assumes that geographic boundaries are available and you are familar with making maps in Stata.

{marker syntax}{title:Syntax}
{p 8 15 2}

{cmd:bimap} {it:vary varx} {ifin}, {cmd:cut}({it:option}) {cmd:palette}({it:option}) 
		{cmd:[} {cmd:count} {cmd:values} {cmd:ocolor}({it:str}) {cmd:osize}({it:str}) {cmd:ndocolor}({it:str}) {cmd:ndfcolor}({it:str}) 
		{cmd:polygon}({it:options}) {cmd:line}({it:options}) {cmd:point}({it:options}) {cmd:label}({it:options}) 
		{cmd:textx}({it:string}) {cmd:texty}({it:str}) {cmdab:textlabs:ize}({it:num}) {cmdab:texts:ize}({it:num}) {cmdab:box:size}({it:num}) {cmd:xscale}({it:num}) {cmd:yscale}({it:num}) 
		{cmd:title}({it:str}) {cmd:subtitle}({it:str}) {cmd:note}({it:str}) {cmd:name}({it:str}) {cmd:scheme}({it:str}) {cmd:]}


{p 4 4 2}
The options are described as follows:

{synoptset 36 tabbed}{...}
{synopthdr}
{synoptline}

{p2coldent : {opt bimap} {it:vary varx}}The command requires numeric {it:vary} and {it:varx} variables.{p_end}

{p2coldent : {opt cut(option)}}Here {cmd:cut} can take on two values: {ul:{it:pctile}} for percentiles or terciles in this case, 
OR {ul:{it:equal}} for equal intervals. These cutoff values can be displayed using the {cmd:values} option. See below.{p_end}

{p2coldent : {opt palette(option)}}Palette options for bi-variate maps are: {ul:{it:pinkgreen}}, {ul:{it:bluered}}, {ul:{it:greenblue}}, {ul:{it:purpleyellow}}, {ul:{it:yellowblue}}.{p_end}

{p2coldent : {opt osize(string)}}Line width of polygons. Same as in {cmd:spmap}. Default value is {it:0.02}. Also applied to polygons with no data.{p_end}

{p2coldent : {opt ocolor(string)}}Outline color of polygons with data. Same as in {cmd:spmap}. Default value is {it:white}.{p_end}

{p2coldent : {opt ndocolor(string)}}Outline color of polygons with no data. Same as in {cmd:spmap}. Default value is {it:gs12}.{p_end}

{p2coldent : {opt ndfcolor(string)}}Fill color of polygons with no data. Same as in {cmd:spmap}. Default value is {it:gs8}.{p_end}

{p2coldent : {opt polygon}(), {opt line}(), {opt point}(), {opt label}()}These are {cmd:spmap} passthru options for additional layers. See {stata help spmap} for details.{p_end}

{p2coldent : {opt title, subtitle, note, name}}These are standard twoway graph options.{p_end}



{p 4 4 2}
{it:{ul:Legend options}:}

{p2coldent : {opt count}}Display the count of categories in each box in the bi-variate map legend.{p_end}

{p2coldent : {opt values}}Display the cut off values in the bi-variate map legend.{p_end}

{p2coldent : {opt texty(string)}}The label of legend variable on the y-axis. The default value is the variable name of {textit:vary}.{p_end}

{p2coldent : {opt textx(string)}}The label of legend variable on the x-axis. The default value is the variable name of {textit:varx}.{p_end}

{p2coldent : {opt texts:ize(string)}}The text size of the legend axis labels. The default value is 2.5.{p_end}

{p2coldent : {opt textlabs:ize(string)}}The text size of the cut-off values. The default value is 2.{p_end}

{p2coldent : {opt boxs:ize(num)}}Size of the square grids in the legend. Default value is 8. This is an advanced option and use it with caution.{p_end}

{p2coldent : {opt xscale(num)}}The scale of the legend on the x-axis. Default value is 30. This is an advanced option and use it with caution. This option also requires adjusting the {cmd:boxsize}.{p_end}

{p2coldent : {opt yscale(num)}}The scale of the legend on the y-axis. Default value is 100. This is an advanced option and use it with caution. This option also requires adjusting the {cmd:boxsize}. 
Ideally don't touch this.{p_end}

{synoptline}
{p2colreset}{...}


{title:Dependencies}

{cmd:bimap} requires {stata help spmap:spmap} (Pisati 2018) and {browse "http://repec.sowi.unibe.ch/stata/palettes/index.html":palettes} (Jann 2018):

{stata ssc install spmap, replace}
{stata ssc install palettes, replace}
{stata ssc install colrspace, replace}

Even if you have the packages installed, please check for updates: {stata ado update, update}.

{title:Examples}

- Download the files from the {browse "https://github.com/asjadnaqvi/stata-bimap/tree/main/GIS":bimap GitHub repository} and copy them in a directory.

use usa_county, clear
	destring _all, replace
	
merge 1:1 STATEFP COUNTYFP using county_race
keep if _m==3
drop _m


Test with the {cmd:spmap} command:
{stata spmap share_afam using usa_county_shp_clean, id(_ID) clm(custom) clb(0(10)100) fcolor(Heat)}

{ul:Basic use}
{stata bimap share_hisp share_afam using usa_county_shp_clean, cut(pctile) palette(pinkgreen)}

{stata bimap share_hisp share_afam using usa_county_shp_clean, cut(pctile) palette(pinkgreen) count values}


{ul:Add additional information}
bimap share_hisp share_afam using usa_county_shp_clean, cut(pctile) palette(purpleyellow) ///
	title("My first bivariate map") subtitle("Made with Stata") note("Data from US Census Bureau.")

{ul:Add additional polygon layer}
bimap share_asian share_afam using usa_county_shp_clean, cut(pctile) palette(bluered)  ///
	title("{fontface Arial Bold:My first bivariate map}") subtitle("Made with Stata") note("Data from the US Census Bureau.") ///	
		 textx("Share of African Americans") texty("Share of Asians") texts(3.5) textlabs(3) values count ///
		 ocolor() osize(none) ///
		 polygon(data("usa_state_shp_clean") ocolor(white) osize(0.3))

{hline}

{title:Package details}

Version      : {bf:bimap} v1.2
This release : 29 Apr 2022
First release: 08 Apr 2022
Repository   : {browse "https://github.com/asjadnaqvi/stata-bimap":GitHub}
Keywords     : Stata, graph, bi-variate, map
License      : {browse "https://opensource.org/licenses/MIT":MIT}

Author       : {browse "https://github.com/asjadnaqvi":Asjad Naqvi}
E-mail       : asjadnaqvi@gmail.com
Twitter      : {browse "https://twitter.com/AsjadNaqvi":@AsjadNaqvi}



{title:References}

{p 4 8 2}Pisati, B. (2018). {browse "help spmap":spmap} v1.3.2. SSC.

{p 4 8 2}Jann, B. (2018). {browse "https://www.stata-journal.com/article.html?article=gr0075":Color palettes for Stata graphics}. The Stata Journal 18(4): 765-785.


