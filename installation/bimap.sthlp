{smcl}
{* 02Oct2022}{...}
{hi:help bimap}{...}
{right:{browse "https://github.com/asjadnaqvi/stata-bimap":bimap v1.4 (GitHub)}}

{hline}

{title:bimap}: A Stata package for bi-variate maps. 

{p 4 4 2}
The package is based on the {browse "https://medium.com/the-stata-guide/stata-graphs-bi-variate-maps-b1e96dd4c2be":Bi-variate maps} guide on Medium. The {cmd:bimap} command is a wrapper for {stata help spmap:spmap}.
Therefore it assumes that geographic boundaries are available, and you are familar with making maps in Stata. 
Note that {cmd:bimap} only works in your have processed the shapefiles using Stata's {stata help spshape2dta:spshape2dta} command.

{marker syntax}{title:Syntax}
{p 8 15 2}

{cmd:bimap} {it:vary varx} {ifin}, {cmd:palette}({it:option}) {cmd:cut}({it:option}) 
		{cmd:[} {cmd:cutx}({it:val1 val2}) {cmd:cuty}({it:val1 val2}) {cmd:values} {cmd:count} {cmd:percent}  {cmd:ocolor}({it:str}) {cmd:osize}({it:str}) {cmd:ndocolor}({it:str}) {cmd:ndfcolor}({it:str}) 
		{cmd:polygon}({it:options}) {cmd:line}({it:options}) {cmd:point}({it:options}) {cmd:label}({it:options}) {cmdab:showleg:end} {cmd:formatx}({it:str}) {cmd:formaty}({it:str}) 
		{cmd:textx}({it:string}) {cmd:texty}({it:str}) {cmdab:textg:ap}({it:num}) {cmdab:textlabs:ize}({it:num}) {cmdab:texts:ize}({it:num}) {cmdab:box:size}({it:num}) {cmd:xscale}({it:num}) {cmd:yscale}({it:num}) 
		{cmd:title}({it:str}) {cmd:subtitle}({it:str}) {cmd:note}({it:str}) {cmd:name}({it:str}) {cmd:scheme}({it:str}) {cmd:]}


{p 4 4 2}
The options are described as follows:

{synoptset 36 tabbed}{...}
{synopthdr}
{synoptline}

{p2coldent : {opt bimap} {it:vary varx}}The command requires numeric {it:vary} and {it:varx} variables.{p_end}

{p2coldent : {opt cut(option)}}Here {cmd:cut} take on three options: {cmd:cutcut({it:pctile})} for percentiles or terciles in this case, 
OR {cmd:cut({it:equal})} for equal intervals, OR {cmd:cut({{it:custom})} for custom cut-offs.
If {ul:{it:custom}} is specified, then {cmd:cutx()} and {cmd:cuty()} need to be defined.{p_end}

{p2coldent : {opt cutx(val1 val2)}, {opt cuty(val1 val2)}}Define the middle two cut-off points for the x and y variables.
The minimum and maximum cut-offs will be estimated directly by the program.
Use these options carefully. If values are outside of the variable range, then the program will throw an error.{p_end}

{p2coldent : {opt palette(option)}}Palette options for bi-variate maps are: {ul:{it:pinkgreen}}, {ul:{it:bluered}}, {ul:{it:greenblue}}, {ul:{it:purpleyellow}}, {ul:{it:yellowblue}}, {ul:{it:orangeblue}},
{ul:{it:brew1}}, {ul:{it:brew2}}, {ul:{it:brew3}}, {ul:{it:census}}.
See {stata help bimap:help file} for details and {browse "https://github.com/asjadnaqvi/stata-bimap":GitHub} for palette examples.{p_end}

{p2coldent : {opt osize(string)}}Line width of polygons. Same as in {cmd:spmap}. Default value is {it:0.02}. Also applied to polygons with no data.{p_end}

{p2coldent : {opt ocolor(str)}}Outline color of polygons with data. Same as in {cmd:spmap}. Default value is {it:white}.{p_end}

{p2coldent : {opt ndocolor(str)}}Outline color of polygons with no data. Same as in {cmd:spmap}. Default value is {it:gs12}.{p_end}

{p2coldent : {opt ndfcolor(str)}}Fill color of polygons with no data. Same as in {cmd:spmap}. Default value is {it:gs8}.{p_end}

{p2coldent : {opt polygon}(), {opt line}(), {opt point}(), {opt label}()}These are {cmd:spmap} passthru options for additional layers. See {stata help spmap} for details.{p_end}

{p2coldent : {opt showleg:end}}If this option is specified, then the following {stata help spmap:spmap} options are enabled: {cmd:legend}(), {cmd:legenda}(), {cmdab:legs:tyle}(), {cmdab:legj:unction}(), {cmdab:legc:ount}(), {cmdab:lego:rder()},
{cmdab:legt:title}(), plus additional options that can be specified for supplementary layers: {cmd:polygon}(), {cmd:line}(), {cmd:point}(), {cmd:label}().
{cmdab:showleg:end} can be used for describing additional layers, like boundaries, points, lines etc.
It is also highly recommended to turn off the base layer legend by using {cmd:legenda}(off) since this shows up in the bimap legend on the right.
This option is still {it:beta}, so suggestions for improvement are appreciated.{p_end}

{p2coldent : {opt title}(), {opt subtitle}(), {opt note}(), {opt name}()}These are standard twoway graph options.{p_end}


{p 4 4 2}
{it:{ul:Bi-variate legend}:}

{p2coldent : {opt count} {it:or} {opt percent}}Display the count or percent of categories in each box in the map legend.{p_end}

{p2coldent : {opt values}}Display the cut-off values on the legend axes.{p_end}

{p2coldent : {opt formatx}(str), {opt formaty}(str)}Format the values on the legend axes. Default format is {it:%5.1f}.{p_end}

{p2coldent : {opt textx(str)}, {opt texty(str)}}The axes labels of the legend. The default values are the variable names.{p_end}

{p2coldent : {opt textg:ap(num)}}The gap of the axes labels from the lines. The default value is {it:2}.{p_end}

{p2coldent : {opt texts:ize(str)}}The text size of the legend axis labels. The default value is {it:2.5}.{p_end}

{p2coldent : {opt textlabs:ize(str)}}The text size of the cut-off values. The default value is {it:2}.{p_end}

{p2coldent : {opt boxs:ize(num)}}Size of the square grids in the legend. Default value is {it:8}. This is an advanced option so use it with caution.
Ideally don't touch this.{p_end}

{p2coldent : {opt xscale(num)}}The scale of the legend on the x-axis. Default value is {it:30}. This option also requires adjusting the {cmd:boxsize}. This is an advanced option so use it with caution. 
Ideally don't touch this.{p_end}

{p2coldent : {opt yscale(num)}}The scale of the legend on the y-axis. Default value is {it:100}. This option also requires adjusting the {cmd:boxsize}. This is an advanced option so use it with caution. 
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

Download the files from the {browse "https://github.com/asjadnaqvi/stata-bimap/tree/main/GIS":bimap GitHub repository} and copy them in a directory.

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


Additional examples on {browse "https://github.com/asjadnaqvi/stata-bimap":GitHub}.

{hline}

{title:Package details}

Version      : {bf:bimap} v1.4
This release : 04 Oct 2022
First release: 08 Apr 2022
Repository   : {browse "https://github.com/asjadnaqvi/stata-bimap":GitHub}
Keywords     : Stata, graph, bi-variate, map
License      : {browse "https://opensource.org/licenses/MIT":MIT}

Author       : {browse "https://github.com/asjadnaqvi":Asjad Naqvi}
E-mail       : asjadnaqvi@gmail.com
Twitter      : {browse "https://twitter.com/AsjadNaqvi":@AsjadNaqvi}



{title:Acknowledgements}

{p 4 4 2}
Ruth Watkinson found an error in the grouping code. Pierre-Henri Bono suggested {it:passthru} options for {cmd:spmap}. 
Kit Baum requested the {it:percent} option and fixes to label colors. 
Mattias Öhman found an error in cut-offs and color assignments with missing groups.
Cristian Jordan Diaz found and error in variable name comparisons.

{title:Feedback}

{p 4 4 2}
If you find bugs or have feature requests, then please open an {browse "https://github.com/asjadnaqvi/stata-bimap/issues":issue} on GitHub.

{title:References}

{p 4 8 2}Pisati, B. (2018). {browse "help spmap":spmap} v1.3.2.

{p 4 8 2}Jann, B. (2018). {browse "https://www.stata-journal.com/article.html?article=gr0075":Color palettes for Stata graphics}. The Stata Journal 18(4): 765-785.


