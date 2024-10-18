{smcl}
{* 18Oct2024}{...}
{hi:help bimap}{...}
{right:{browse "https://github.com/asjadnaqvi/stata-bimap":bimap v2.1 (GitHub)}}

{hline}

{title:bimap}: A Stata package for bi-variate maps. 

{p 4 4 2}
The package is based on the {browse "https://medium.com/the-stata-guide/stata-graphs-bi-variate-maps-b1e96dd4c2be":Bi-variate maps} guide on Medium. The {cmd:bimap} command is a wrapper
for {stata help spmap:geoplot} (v17+) and {stata help spmap:spmap} (v16-).
The command will auto-detect the Stata version and execute the right code. Each code block comes with its own set of input requirements. 
The older version can still be used by specifying the {it:old} option. The older version that relies on {stata help spmap:spmap} will eventually be phased out.

{p 4 4 2}
The command assumes that data on geographic boundaries is available and it is set up or ready for setup. Familiarity with making maps in Stata is also assumed. 
Note that {cmd:bimap} only works if you have processed the shapefiles using Stata's {stata help spshape2dta:spshape2dta} or the {stata help geoplot:geoplot} command.

{p 4 4 2}
The two command versions have different input requirements that are defined in the first two lines in the syntax below. The remaining code block, that determines
the cuts and how the legend is drawn, is common across the two versions. Therefore porting basic maps is fairly easy. For more advance features,
such as drawing multiple layers in {cmd:geoplot}, can be added by using the {cmd:geo()} option. Additional features such as arrows, scalebars, zooms etc can be passed on
using the {cmd:geopost()} options. For {cmd:spmap}, the old syntax just passes on individual options. This has been maintained to avoid the breaking the old code completely.


{marker syntax}{title:Syntax (version 17 or newer)}

{p 8 15 2}
{cmd:bimap} {it:vary varx} {ifin}, {cmd:frame}({it:name}) 
        {cmd:[} {cmd:geo}({it:options}) {cmd:geopost}({it:options})  
          {cmd:palette}({it:name}) {cmd:reverse} {cmd:clr0}({it:str}) {cmd:clrx}({it:str}) {cmd:clry}({it:str}) {cmdab:clrsat:urate}({it:num})
          {cmd:cut}({it:pctile}|{it:equal}) {cmd:cutx}({it:numlist}) {cmd:cuty}({it:numlist}) {cmd:binsproper} {cmd:bins}({it:num >=2}) {cmd:binx}({it:num >=2}) {cmd:biny}({it:num >=2}) {cmd:values} {cmd:count}
          {cmd:percent} {cmdab:showleg:end} {cmd:ocolor}({it:str}) {cmd:osize}({it:str}) {cmd:ndocolor}({it:str}) {cmd:ndfcolor}({it:str}) {cmd:ndfsize}({it:str}) {cmdab:xdisc:rete} {cmdab:ydisc:rete} 
          {cmd:labxgap}({it:num}) {cmd:labygap}({it:num}) {cmd:textx}({it:str}) {cmd:texty}({it:str}) {cmd:formatx}({it:str}) {cmd:formaty}({it:str}) {cmd:detail} {cmd:wrap}({it:num})
          {cmdab:texts:ize}({it:str}) {cmdab:textlabs:ize}({it:str}) {cmdab:vallabs:ize}({it:str}) {cmdab:textc:olor}({it:str}) {cmdab:textlabc:olor}({it:str}) {cmdab:vallabc:olor}({it:str}) 
          {cmd:xscale}({it:num}) {cmd:yscale}({it:num}) * {cmd:]}


{marker syntax}{title:Syntax (version 16 or earlier)}

{p 8 15 2}
{cmd:bimap} {it:vary varx} {ifin}, {cmd:shp}({it:shapefile}) 
        {cmd:[} {cmd:old} {cmd:polygon}({it:str}) {cmd:line}({it:str}) {cmd:point}({it:str}) {cmd:label}({it:str}) {cmd:arrow}({it:str}) {cmd:diagram}({it:str}) {cmd:scalebar}({it:str}) 
          {cmd:palette}({it:name}) {cmd:reverse} {cmd:clr0}({it:str}) {cmd:clrx}({it:str}) {cmd:clry}({it:str}) {cmdab:clrsat:urate}({it:num})
          {cmd:cut}({it:pctile}|{it:equal}) {cmd:cutx}({it:numlist}) {cmd:cuty}({it:numlist}) {cmd:binsproper} {cmd:bins}({it:num >=2}) {cmd:binx}({it:num >=2}) {cmd:biny}({it:num >=2}) {cmd:values} {cmd:count} 
          {cmd:percent} {cmdab:showleg:end} {cmd:ocolor}({it:str}) {cmd:osize}({it:str}) {cmd:ndocolor}({it:str}) {cmd:ndfcolor}({it:str})  {cmd:ndfsize}({it:str}) {cmdab:xdisc:rete} {cmdab:ydisc:rete} 
          {cmd:labxgap}({it:num}) {cmd:labygap}({it:num}) {cmd:textx}({it:str}) {cmd:texty}({it:str}) {cmd:formatx}({it:str}) {cmd:formaty}({it:str}) {cmd:detail} {cmd:wrap}({it:num})
          {cmdab:texts:ize}({it:str}) {cmdab:textlabs:ize}({it:str}) {cmdab:vallabs:ize}({it:str}) {cmdab:textc:olor}({it:str}) {cmdab:textlabc:olor}({it:str}) {cmdab:vallabc:olor}({it:str}) 
          {cmd:xscale}({it:num}) {cmd:yscale}({it:num}) * {cmd:]}



{p 4 4 2}
The options are described as follows:

{synoptset 36 tabbed}{...}
{synopthdr}
{synoptline}

{p 4 4 2}
{it:{ul:Map syntax}}

{p2coldent : {opt bimap} {it:vary varx, options}}The command requires numeric {it:vary} and {it:varx} variables. See options below for additional info.{p_end}

{p 4 4 2}
{it:{ul:Version 17 or newer}}

{p2coldent : {opt frame(name)}}The geoplot frames need to be defined before executing the bimap command. The {opt frame()} therefore
ask users to define the frame name with the plot data. This is to ensure that the command still executes regardless of which frame is active.{p_end}

{p2coldent : {opt geo(string)}}This option can be used to define addition area, line or point layers. It is assumed that each layer has a frame 
defined (see help geoplot) and is ready to be plotted. This can be any number of layers. Make sure that each layer is enclosed in round brackets,
for example, {opt geo((area ..., ...) (area ..., ...) (line ..., ...))} etc.{p_end}

{p2coldent : {opt geopost(string)}}Similar to {opt geo()}, {opt geopost()} can be used to pass on additional commands in {cmd:geoplot}.
This for example, can include zooms, legend options, arrows, scalebars etc.{p_end}


{p 4 4 2}
{it:{ul:Version 16 or older}}

{p2coldent : {opt old}}If this option is specified, the command switches to the {cmd spmap} options below regardless of the Stata version. This is to
ensure consistency and backward compatibility when using running dofiles that are setup for older command versions.{p_end}

{p2coldent : {opt shp(shapefile)}}The spmap requires defining a shapefile using the {opt shp()} options. {bf: NOTE:} This is a slight change from the
older {cmd:bimap} versions where the users previously specified {opt bimap vary varx using shpfile}. The new version requires {opt bimap vary varx, shp(shpfile)}.
While this might cause some incovinience to vetran {cmd:bimap} users, it has been implemented to ensure syntax consistency. 
The users are assumed to have the attributes file with the required data already loaded that can be merged with the {opt shp()} file 
on the {it:_ID} variable. The shapefile file usually has {it:*_shp.dta} name and is automatically created while using the {stata help spshape2dta:spshape2dta}
command.{p_end}

{p2coldent : {opt polygon}(), {opt line}(), {opt point}(), {opt label}()}These are {cmd:spmap} passthru options to draw additional layers. See {stata help spmap} for details.{p_end}

{p2coldent : {opt arrow}(), {opt diagram}(), {opt scalebar}()}These are {cmd:spmap} passthru options for additional map options. See {stata help spmap} for details.{p_end}


{p 4 4 2}
{it:{ul:Map cuts and colors}}

{p2coldent : {opt cut(option)}}Here {opt cut} take on three options: {opt cut(pctile)} for percentiles, or {opt cut(equal)} for equally-spaced intervals. If either
{opt cutx()}, or {opt cuty()}, or are specified, then they overwrite the defined {opt cut()} options. Default is {opt cut(pctile)}.{p_end}

{p2coldent : {opt cutx(numlist)}, {opt cuty(numlist)}}Define a custom set of cut-offs using {stata help numlist:numlist} to add more control to your legend.
At least three numbers need to be specified to generate the map.{p_end}

{p2coldent : {opt xdisc:rete}, {opt ydisc:rete}} These can be used if the variables are categorical, for example, binary or ordinally ranked variables.
These options overwrite other binning options and legend axes markers will use value labels and will be centered to bin width/height. More than 10 categories will throw an error.
Hence the maximum combination of discrete variables allowed is 10x10 or 100 bins. This also prevents accidentally declaring a regular variable as discrete which
can get computationally messy very fast.{p_end}

{p2coldent : {opt palette(option)}}Palettes are dynamically generated for any number of {opt bins()}. Named palettes are: 
{it:pinkgreen}, {it:bluered}, {it:greenblue}, {it:purpleyellow}, {it:yellowblue}, {it:orangeblue}. The original (legacy) palettes are still available with the following names:
 {it:pinkgreen0}, {it:bluered0}, {it:greenblue0}, {it:purpleyellow0}, {it:yellowblue0}, {it:orangeblue0}, {it:brew1}, {it:brew2}, {it:brew3}, 
{it:census}, {it:rgb}, {it:viridis}, {it:gscale}.
If legacy palettes are defined, the number of bins will default to 3x3 and any other custom binning options will be ignored.
See {browse "https://github.com/asjadnaqvi/stata-bimap":GitHub} for examples of legacy palettes. Default option is {opt palette(pinkgreen)}.
Users can also over-write the palettes using the {opt clr...()} options described below.{p_end}

{p2coldent : {opt clr0()}, {opt clrx()}, {opt clry()}}Users can overwrite the colors end-points using one or more of these options. Option {opt clr0()} is the starting 
bottom-left color. Similarly, {opt clrx()}, {opt clry()} are x-axis bottom-right and y-axis top-left colors respectively. One can either define a "named" Stata color (e.g.
named colors from {stata colorpalette s2:s2 scheme}), or they need to provide Hex values. DO NOT specify RBG values! For example, true Red has an RGB value 
of "255 0 0", while its Hex code is #ff0000. In order to convert or select Hex colors, a good option is the {browse "https://g.co/kgs/iKAHGF":Google Color Picker}.
Otherwise, {stata help colorpalette:colorpalette}, other softwares (including MS Paint), and websites can be used as well.{p_end}

{p2coldent : {opt clrsat:urate(num)}}Change the saturation of the colors. Higher values are for brighter colors. Default is {opt clrsat(6)}.{p_end}

{p2coldent : {opt reverse}}Swap the x- and y-axis colors. This option does not work for legacy palettes.{p_end}

{p2coldent : {opt bins(num)}, {opt binx(num)}, {opt biny(num)}}Users can either defined {it:n}x{it:n} bins by using the option {opt bins(n)}. Otherwise custom bins can
also be defined using {opt binx()} and/or {opt biny()}. The default is {opt bin(3)}. Bins are constrained to a minimum dimension of 2.{p_end}

{p2coldent : {opt osize(string)}}Line width of polygons. Default value is {opt osize(0.02)}. Also applied to polygons with no data.{p_end}

{p2coldent : {opt ocolor(str)}}Outline color of polygons with data. Default value is {opt ocolor(white)}.{p_end}

{p2coldent : {opt ndocolor(str)}}Outline color of polygons with no data. Default value is {opt ndocolor(gs12)}.{p_end}

{p2coldent : {opt ndfcolor(str)}}Fill color of polygons with no data. Default value is {opt ndfcolor(gs8)}.{p_end}

{p2coldent : {opt ndsize(str)}}Line width of missing observations. If no value is specified, it defaults to the {opt osize(0.02)} value.{p_end}

{p2coldent : {opt noleg:end}}Hide the legend. Useful if you are generating several maps with a controlled legend where one map with a legend is sufficient if combining graphs.{p_end}

{p2coldent : {opt showleg:end}}If this option is specified, then the {stata help geoplot:geoplot} and {stata help spmap:spmap} options are enabled. Both commands have
fairly complex syntaxes for generating legends so please see individual helpfiles for details.{p_end}

{p2coldent : {opt detail}}Show which Stata version is detected and which program is called.{p_end}

{p2coldent : {opt *}}All other standard twoway options.{p_end}


{p 4 4 2}
{it:{ul:Legend options}}

{p2coldent : {opt count} {it:or} {opt percent}}Display the count or percent of categories in each box in the map legend.{p_end}

{p2coldent : {opt values}}Display the cut-off values on the legend axes.{p_end}

{p2coldent : {opt textx(str)}, {opt texty(str)}}The axes labels of the legend. The default values are the variable names.{p_end}

{p2coldent : {opt wrap(num)}}Wrap the legend title after a number of characters. Word boundaries are respected.{p_end}

{p2coldent : {opt texts:ize(str)}}The text size of the legend axes labels. The default value is {opt texts(3)}.{p_end}

{p2coldent : {opt textlabs:ize(str)}}The text size of the axes cut-off values. The default value is {opt textlabs(2.2)}.{p_end}

{p2coldent : {opt vallabs:ize(str)}}The size of the box values. The default value is {opt vallabs(2.2)}.{p_end}

{p2coldent : {opt textc:olor(str)}}The text color of the legend axis labels. The default value is {opt textc(black)}.{p_end}

{p2coldent : {opt textlabc:olor(str)}}The text color of the axes cut-off values. The default value is {opt textlabc(black)}.{p_end}

{p2coldent : {opt vallabc:olor(str)}}The text color of the box values. The default value is {opt vallabc(black)}.{p_end}

{p2coldent : {opt formatval(fmt)}}Format of the box values. Default format is {opt formatval(%5.1f)}.{p_end}

{p2coldent : {opt formatx(fmt)}, {opt formaty(fmt)}}Format the values on the legend axes. Default format is {opt formatx(%5.1f)}, {opt formaty(%5.1f)}.{p_end}

{p2coldent : {opt labxgap(num)}}The gap of the x-axis title from the default position. The default value is {opt labxgap(0)}. Use in very minor increments, e.g. {opt labxgap(0.02)}.{p_end}

{p2coldent : {opt labygap(num)}}The gap of the y-axis title from the default position. The default value is {opt labygap(0)}. Use in very minor increments, e.g. {opt labygap(0.02)}.{p_end}

{p2coldent : {opt binsproper}}Show actual cut-off on the axes in the legend. Otherwise equally spaced boxes are shown. The option {opt binsproper} will look
squished especially if the categories are bunched together. This will most likely cause labels to overlap.{p_end}

{p2coldent : {opt xscale(num)}}The scale of the legend on the x-axis. Default value is {opt xscale(35)}. This option can be used to change the legend dimensions.{p_end}

{p2coldent : {opt yscale(num)}}The scale of the legend on the y-axis. Default value is {opt yscale(100)}. This is an advanced option so use it with caution.{p_end}

{synoptline}
{p2colreset}{...}


{title:Dependencies}

Stata version 17 or newer requires the following packages:
{stata ssc install geoplot, replace}
{stata ssc install moremata, replace}
{stata ssc install palettes, replace}
{stata ssc install colrspace, replace}
{stata ssc install graphfunctions, replace}

Stata version 16 or earlier requires the following packages:
{stata ssc install spmap, replace}
{stata ssc install palettes, replace}
{stata ssc install colrspace, replace}
{stata ssc install graphfunctions, replace}

Even if you have these packages installed, please reguarly check for their updates.

{title:Examples}

Please see {browse "https://github.com/asjadnaqvi/stata-bimap":GitHub} for examples.

{hline}

{title:Package details}

Version      : {bf:bimap} v2.1
This release : 18 Oct 2024
First release: 08 Apr 2022
Repository   : {browse "https://github.com/asjadnaqvi/stata-bimap":GitHub}
Keywords     : Stata, map, bimap, bi-variate
License      : {browse "https://opensource.org/licenses/MIT":MIT}

Author       : {browse "https://github.com/asjadnaqvi":Asjad Naqvi}
E-mail       : asjadnaqvi@gmail.com
Twitter      : {browse "https://twitter.com/AsjadNaqvi":@AsjadNaqvi}



{title:Feedback}

{p 4 4 2}
If you find bugs and/or have feature requests, then please open an {browse "https://github.com/asjadnaqvi/stata-bimap/issues":issue} on GitHub.


{title:Citation guidelines}

Suggested citation guidlines for this package:

Naqvi, A. (2024). Stata package "bimap" version 2.1. Release date 18 October 2024. https://github.com/asjadnaqvi/stata-bimap.

@software{bimap,
   author = {Naqvi, Asjad},
   title = {Stata package ``bimap''},
   url = {https://github.com/asjadnaqvi/stata-bimap},
   version = {2.1},
   date = {2024-10-18}
}

{title:References}

{p 4 8 2}Pisati, B. (2007). spmap: Stata module to visualize spatial data. Available from {browse "https://ideas.repec.org/c/boc/bocode/s456812.html"}.

{p 4 8 2}Jann, B. (2005). moremata: Stata module (Mata) to provide various functions. Available from {browse "https://ideas.repec.org/c/boc/bocode/s455001.html"}.

{p 4 8 2}Jann, B. (2018). {browse "https://www.stata-journal.com/article.html?article=gr0075":Color palettes for Stata graphics}. The Stata Journal 18(4): 765-785.

{p 4 8 2}Jann, B. (2022). {browse "https://ideas.repec.org/p/bss/wpaper/43.html":Color palettes for Stata graphics: An update}. University of Bern Social Sciences Working Papers No. 43. 

{p 4 8 2}Jann, B. (2023). geoplot: Stata module to draw maps. Available from {browse "https://ideas.repec.org/c/boc/bocode/s459211.html"}.


{title:Other visualization packages}

{psee}
    {helpb arcplot}, {helpb alluvial}, {helpb bimap}, {helpb bumparea}, {helpb bumpline}, {helpb circlebar}, {helpb circlepack}, {helpb clipgeo}, {helpb delaunay}, {helpb joyplot}, 
	{helpb marimekko}, {helpb polarspike}, {helpb sankey}, {helpb schemepack}, {helpb spider}, {helpb splinefit}, {helpb streamplot}, {helpb sunburst}, {helpb treecluster}, {helpb treemap}, {helpb waffle}
	
or visit {browse "https://github.com/asjadnaqvi":GitHub} for detailed documentation and examples.	


