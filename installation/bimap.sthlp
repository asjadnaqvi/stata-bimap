{smcl}
{* 26Jun2023}{...}
{hi:help bimap}{...}
{right:{browse "https://github.com/asjadnaqvi/stata-bimap":bimap v1.8 (GitHub)}}

{hline}

{title:bimap}: A Stata package for bi-variate maps. 

{p 4 4 2}
The package is based on the {browse "https://medium.com/the-stata-guide/stata-graphs-bi-variate-maps-b1e96dd4c2be":Bi-variate maps} guide on Medium. The {cmd:bimap} command is a wrapper for {stata help spmap:spmap}.
Therefore it assumes that geographic boundaries are available, and you are familar with making maps in Stata. 
Note that {cmd:bimap} only works if you have processed the shapefiles using Stata's {stata help spshape2dta:spshape2dta} command.

{marker syntax}{title:Syntax}
{p 8 15 2}

{cmd:bimap} {it:vary varx} {ifin}, {cmd:[} {cmd:palette}({it:name}) reverse  {cmd:clr0}({it:str}) {cmd:clrx}({it:str}) {cmd:clry}({it:str}) {cmdab:clrsat:urate}({it:num})
		{cmd:cut}({it:pctile}|{it:equal}) {cmd:cutx}({it:numlist}) {cmd:cuty}({it:numlist}) {cmd:binsproper} {cmd:bins}({it:num >=2}) {cmd:binx}({it:num >=2}) {cmd:biny}({it:num >=2}) {cmd:values} {cmd:count} 
		{cmd:percent} {cmdab:showleg:end} {cmd:ocolor}({it:str}) {cmd:osize}({it:str}) {cmd:ndocolor}({it:str}) {cmd:ndfcolor}({it:str}) {cmdab:xdisc:rete} {cmdab:ydisc:rete} {cmd:labxgap}({it:num}) {cmd:labygap}({it:num})
		{cmd:textx}({it:str}) {cmd:texty}({it:str}) {cmdab:textlabs:ize}({it:num}) {cmdab:texts:ize}({it:num}) {cmd:formatx}({it:str}) {cmd:formaty}({it:str}) {cmd:xscale}({it:num}) {cmd:yscale}({it:num}) 
		{cmd:polygon}({it:options}) {cmd:line}({it:options}) {cmd:point}({it:options}) {cmd:label}({it:options}) {cmd:arrow}({it:options}) {cmd:diagram}({it:options}) {cmd:scalebar}({it:options}) 
		{cmd:title}({it:str}) {cmd:subtitle}({it:str}) {cmd:note}({it:str}) {cmd:name}({it:str}) {cmd:scheme}({it:str}) {cmd:]}


{p 4 4 2}
The options are described as follows:

{synoptset 36 tabbed}{...}
{synopthdr}
{synoptline}

{p 4 4 2}
{it:{ul:Map options}}

{p2coldent : {opt bimap} {it:vary varx}}The command requires numeric {it:vary} and {it:varx} variables.{p_end}

{p2coldent : {opt cut(option)}}Here {opt cut} take on three options: {opt cut(pctile)} for percentiles, or {opt cut(equal)} for equally-spaced intervals. If either
{opt cutx()}, or {opt cuty()}, or are specified, then they overwrite the defined {opt cut()} options. Default is {opt cut(pctile)}.{p_end}

{p2coldent : {opt cutx(numlist)}, {opt cuty(numlist)}}Define a custom set of cut-offs using {stata help numlist:numlist} to add more control to your legend.
At least three numbers need to be specified to generate the map.{p_end}

{p2coldent : {opt xdisc:rete}, {opt ydisc:rete}} can be used if the variables are assumed categorical, for example, binary variables, or ordinally ranked variables.
These options overwrite other binning options and legend axes markers will use value labels and will be centered to bin width/height. More than 10 categories will throw an error.
Hence the maximum combination of discrete variables allowed is 10x10 or 100 bins. This is also to prevent accidentally declaring a regular variable as discrete.{p_end}

{p2coldent : {opt palette(option)}}In version v1.6 and above, palettes are dynamically generated for any number of {opt bins()}. Named palettes are: 
{it:pinkgreen}, {it:bluered}, {it:greenblue}, {it:purpleyellow}, {it:yellowblue}, {it:orangeblue}. The original (legacy) palettes are still available with the following names:
 {it:pinkgreen0}, {it:bluered0}, {it:greenblue0}, {it:purpleyellow0}, {it:yellowblue0}, {it:orangeblue0}, {it:brew1}, {it:brew2}, {it:brew3}, 
{it:census}, {it:rgb}, {it:viridis}, {it:gscale}.
If legacy palettes are defined, the number of bins will default to 3x3 and any other custom binning options will be ignored.
See {browse "https://github.com/asjadnaqvi/stata-bimap":GitHub} for examples of legacy palettes. Default option is {opt palette(pinkgreen)}.
Users can also over-write the palettes using the {opt clr.()} options described below.{p_end}

{p2coldent : {opt clr0()}, {opt clrx()}, {opt clry()}}Users can overwrite the colors end-points using one or more of these options. Option {opt clr0()} is the
starting bottom-left color. Similarly, {opt clrx()}, {opt clry()} are x-axis bottom-right and y-axis top-left colors. One can either define a "named" Stata color (e.g.
named colors from {stata colorpalette s2:s2 scheme}), or they need to provide Hex values. DO NOT specify RBG values! For example, true Red has an RGB value 
of "255 0 0", while its Hex code is #ff0000. In order to convert or select Hex colors, a good option is the {browse "https://g.co/kgs/iKAHGF":Google Color Picker}.
Otherwise, {stata help colorpalette:colorpalette}, other softwares (including MS Paint), and websites can be used as well.{p_end}

{p2coldent : {opt clrsat:urate(num)}}Change the saturation of the colors. Higher values are for brighter colors. Default is {opt clrsat(6)}.{p_end}

{p2coldent : {opt reverse}}Swap the x- and y-axis colors. This option does not work for legacy palettes.{p_end}

{p2coldent : {opt bins(num)}, {opt binx(num)}, {opt biny(num)}}Users can either defined {it:n}x{it:n} bins by using the option {opt bins(n)}. Otherwise custom bins can
also be defined using {opt binx()} and/or {opt biny()}. The default is {opt bin(3)}. Bins are constrained to a minimum dimension of 2.{p_end}

{p2coldent : {opt osize(string)}}Line width of polygons. Same as in {cmd:spmap}. Default value is {it:0.02}. Also applied to polygons with no data.{p_end}

{p2coldent : {opt ocolor(str)}}Outline color of polygons with data. Same as in {cmd:spmap}. Default value is {it:white}.{p_end}

{p2coldent : {opt ndocolor(str)}}Outline color of polygons with no data. Same as in {cmd:spmap}. Default value is {it:gs12}.{p_end}

{p2coldent : {opt ndfcolor(str)}}Fill color of polygons with no data. Same as in {cmd:spmap}. Default value is {it:gs8}.{p_end}

{p2coldent : {opt polygon}(), {opt line}(), {opt point}(), {opt label}()}These are {cmd:spmap} passthru options for additional layers. See {stata help spmap} for details.{p_end}

{p2coldent : {opt arrow}(), {opt diagram}(), {opt scalebar}()}These are {cmd:spmap} passthru options for additional layers. See {stata help spmap} for details.{p_end}

{p2coldent : {opt showleg:end}}If this option is specified, then the following {stata help spmap:spmap} options are enabled: {cmd:legend}(), {cmd:legenda}(), {cmdab:legs:tyle}(), {cmdab:legj:unction}(), {cmdab:legc:ount}(), {cmdab:lego:rder()},
{cmdab:legt:title}(), plus additional options that can be specified for supplementary layers: {cmd:polygon}(), {cmd:line}(), {cmd:point}(), {cmd:label}().
{cmdab:showleg:end} can be used for describing additional layers, like boundaries, points, lines etc.
It is also highly recommended to turn off the base layer legend by using {cmd:legenda}(off) since this shows up in the bimap legend on the right.
This option is still {it:beta}, so suggestions for improvement are appreciated.{p_end}

{p2coldent : {opt title}(), {opt subtitle}(), {opt note}(), {opt name}()}These are standard twoway graph options.{p_end}


{p 4 4 2}
{it:{ul:Legend options}}

{p2coldent : {opt count} {it:or} {opt percent}}Display the count or percent of categories in each box in the map legend.{p_end}

{p2coldent : {opt values}}Display the cut-off values on the legend axes.{p_end}

{p2coldent : {opt vallabs:ize(str)}}The size of the box values. The default value is {opt vallabs(1.8)}.{p_end}

{p2coldent : {opt formatval(fmt)}}Format of the box values. Default format is {opt formatval(%5.1f)}.{p_end}

{p2coldent : {opt formatx(fmt)}, {opt formaty(fmt)}}Format the values on the legend axes. Default format is {opt formatx(%5.1f)}, {opt formaty(%5.1f)}.{p_end}

{p2coldent : {opt textx(str)}, {opt texty(str)}}The axes labels of the legend. The default values are the variable names.{p_end}

{p2coldent : {opt labxgap(num)}}The gap of the x-axis title from the default position. The default value is {opt labxgap(0)}. Use in very minor increments, e.g. {opt labxgap(0.02)}. {p_end}

{p2coldent : {opt labygap(num)}}The gap of the y-axis title from the default position. The default value is {opt labygap(0)}. Use in very minor increments, e.g. {opt labygap(0.02)}. {p_end}

{p2coldent : {opt texts:ize(str)}}The text size of the legend axis labels. The default value is {opt texts(2.5)}.{p_end}

{p2coldent : {opt textlabs:ize(str)}}The text size of the cut-off values. The default value is {opt textlabs(2)}.{p_end}

{p2coldent : {opt binsproper}}Show actual cut-off on the axes in the legend. Otherwise equally spaced boxes are shown. The option {opt binsproper} will look
squished especially if the categories are bunched together. This will most likely cause labels to overlap.{p_end}

{p2coldent : {opt xscale(num)}}The scale of the legend on the x-axis. Default value is {opt xscale(35)}. This option can be used to change the legend dimensions.{p_end}

{p2coldent : {opt yscale(num)}}The scale of the legend on the y-axis. Default value is {opt yscale(100)}. This is an advanced option so use it with caution.{p_end}

{synoptline}
{p2colreset}{...}


{title:Dependencies}

{cmd:bimap} requires {stata help spmap:spmap} (Pisati 2018) and {browse "http://repec.sowi.unibe.ch/stata/palettes/index.html":palettes} (Jann 2018, 2022):

{stata ssc install spmap, replace}
{stata ssc install palettes, replace}
{stata ssc install colrspace, replace}

Even if you have the packages installed, please check for updates: {stata ado update, update}.

{title:Examples}

Please see {browse "https://github.com/asjadnaqvi/stata-bimap":GitHub} for examples.

{hline}

{title:Package details}

Version      : {bf:bimap} v1.8
This release : 26 Jun 2023
First release: 08 Apr 2022
Repository   : {browse "https://github.com/asjadnaqvi/stata-bimap":GitHub}
Keywords     : Stata, map, bimap, bi-variate
License      : {browse "https://opensource.org/licenses/MIT":MIT}

Author       : {browse "https://github.com/asjadnaqvi":Asjad Naqvi}
E-mail       : asjadnaqvi@gmail.com
Twitter      : {browse "https://twitter.com/AsjadNaqvi":@AsjadNaqvi}



{title:Acknowledgements}

{p 4 4 2}
Paul Hufe requested changes to custom cut-offs (v1.8).
Several requests for allowing categorical variables (v1.7)
Kit Baum, Fayssal Ayad, and Paul reported bug in the bimap v1.6 legends (v1.62, v1.61).
Tyson King-Meadows and Vishakha Agarwal requested a greyscale palette (v1.5).
Souradet Shaw requested scalebar and arrow passthrus (v1.5). 
Paul Frissard Martínez requested spmap legend options (v1.4). 
Ruth Watkinson found an error in the grouping code (v1.3). 
Pierre-Henri Bono suggested core passthrus for additional {stata help spmap:spmap} layers (v1.3). 
Kit Baum requested the {it:percent} option and fixes to label colors (v1.3). 
Mattias Öhman found an error in cut-offs and color assignments with missing groups (v1.3).
Cristian Jordan Diaz found and error in variable name comparisons (v1.2).

{title:Feedback}

{p 4 4 2}
If you find bugs and/or have feature requests, then please open an {browse "https://github.com/asjadnaqvi/stata-bimap/issues":issue} on GitHub.

{title:References}

{p 4 8 2}Pisati, B. (2018). {browse "help spmap":spmap} v1.3.2.

{p 4 8 2}Jann, B. (2018). {browse "https://www.stata-journal.com/article.html?article=gr0075":Color palettes for Stata graphics}. The Stata Journal 18(4): 765-785.

{p 4 8 2}Jann, B. (2022). {browse "https://ideas.repec.org/p/bss/wpaper/43.html":Color palettes for Stata graphics: An update}. University of Bern Social Sciences Working Papers No. 43. 

{title:Other visualization packages}

{psee}
    {helpb arcplot}, {helpb alluvial}, {helpb bimap}, {helpb bumparea}, {helpb bumpline}, {helpb circlebar}, {helpb circlepack}, {helpb clipgeo}, {helpb delaunay}, {helpb joyplot}, 
	{helpb marimekko}, {helpb sankey}, {helpb schemepack}, {helpb spider}, {helpb streamplot}, {helpb sunburst}, {helpb treecluster}, {helpb treemap}


