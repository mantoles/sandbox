<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:trc="urn:IEEE-1636.1:2011:01:TestResultsCollection" xmlns:tr="urn:IEEE-1636.1:2011:01:TestResults" xmlns:c="urn:IEEE-1671:2010:Common" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ts="www.ni.com/TestStand/ATMLTestResults/2.0" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:user="http://www.ni.com/TestStand" id="TS5.0.0">
	<xsl:namespace-alias stylesheet-prefix="xsl" result-prefix="#default"/>
	<xsl:namespace-alias stylesheet-prefix="c" result-prefix="#default"/>
	<xsl:namespace-alias stylesheet-prefix="trc" result-prefix="#default"/>
	<xsl:namespace-alias stylesheet-prefix="tr" result-prefix="#default"/>
	<xsl:namespace-alias stylesheet-prefix="xsi" result-prefix="#default"/>
	<xsl:namespace-alias stylesheet-prefix="ts" result-prefix="#default"/>
	<xsl:namespace-alias stylesheet-prefix="msxsl" result-prefix="#default"/>
	<xsl:namespace-alias stylesheet-prefix="user" result-prefix="#default"/>
	<msxsl:script language="javascript" implements-prefix="user"><![CDATA[
	function IsGraphControlInstalled()
	{
		var haveGraphControl = 0;
		try
		{
			var xObj = new ActiveXObject("TsGraphControl2.GraphControl2");
			if(xObj != null)
				haveGraphControl =  1;
		}
		catch(ex)
		{
			haveGraphControl = 0;
		}
		return haveGraphControl;
	}
	var gIncludeArrayMeasurement = 0;
	function SetIncludeArrayMeasurement(value)
	{
		gIncludeArrayMeasurement = parseInt(value);
		return "";
	}
	function GetIncludeArrayMeasurement()
	{
		return gIncludeArrayMeasurement;
	}
	var gGraphCounter = 0;
	function GetGraphCounter()
	{
		return gGraphCounter++;
	}
	function GetDimensions(arrayElements)
	{
		var numOfElements = arrayElements.length;
		var numDimensions = 0;
		if (numOfElements != 0)
		{
			var firstElement = arrayElements.item(0);
			var firstElementAttributes = firstElement.attributes;
			var position = firstElementAttributes.getNamedItem("position").value;
			numDimensions = position.split(",").length;			
		}
		return numDimensions;
	}
	function Get1DimensionGraphScript(arrayElements, graphId)
	{
		var str = "";
		var numOfElements = arrayElements.length;
		var yPlot = new Array();
		for(var i=0;i < numOfElements; ++i)
		{
			var currentElement = arrayElements.item(i);
			var currentElementAttributes = currentElement.attributes;
			var position = currentElementAttributes.getNamedItem("position").value;
			yPlot[i] = currentElementAttributes.getNamedItem("value").value;		
		}
		str = "Array(" + yPlot.join(", ") + ")";
		str = "Call CWGRAPH" + graphId + ".PlotY(" + str + ",0,1)"
		return str;
	}
	function Get2DimensionGraphScript(arrayElements, graphId)
	{
		var str = "";	
		var numOfElements = arrayElements.length;
		var yPlots = new Array();
		for(var i=0;i < numOfElements; ++i)
		{
			var currentElement = arrayElements.item(i);
			var currentElementAttributes = currentElement.attributes;
			var position = currentElementAttributes.getNamedItem("position").value;
			var yPlotIndex = position.substr(1, position.search(",")-1);
			if (yPlots[yPlotIndex])
			{
				yPlots[yPlotIndex] += ", " + currentElementAttributes.getNamedItem("value").value;		
			}
			else
			{				
				yPlots[yPlotIndex] = "" + currentElementAttributes.getNamedItem("value").value;
			}		
		}
		str = "Array(" + yPlots.join("), Array(") + ")";
		str = 'Call CWGRAPH' + graphId + '.Plot2DArrayData(Array(' + str + '), "", "", "True", 1)';
		return str;
	}
	// This function takes an element value and 
	// 1. adds a _br_ to the output when it finds a newline character.
	// 2. Removes \r from the text
	function RemoveIllegalCharacters(text)
	{
		var sRet = "";
		var newLine = "<br/>";
		var index = text.indexOf("\n");
		if (index == -1)
			sRet = text;
		while(index != -1)
		{
			sRet += text.substring(0,index) + newLine;
			text = text.substring(index+1,text.length);
			index = text.indexOf("\n");
			if (index == -1)
				sRet += text;
		}
	
		var newText = sRet;
		sRet = "";
		
		if (newText != "")
		{
			var slashR = "\\r";
			index = newText.indexOf(slashR);
			if (index == -1)
				sRet = newText;
			else
			{
				while(index != -1)
				{
					sRet += newText.substring(0,index);
					newText = newText.substring(index+2, newText.length);
					index = newText.indexOf(slashR);
					if (index == -1)
						sRet += newText;
				}
			}
		}
		return sRet;
	}
	]]></msxsl:script>
	<xsl:output method="html" indent="no" omit-xml-declaration="yes" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"/>
	<!-- Customization variables-->
	<xsl:template name="GetTotalTimeInHHMMSSFormat">
		<xsl:param name="timeInSeconds" select="0"/>
		<xsl:variable name="totalSeconds" select="number($timeInSeconds)"/>
		<xsl:variable name="noOfHours" select="floor($totalSeconds div 3600)"/>
		<xsl:variable name="noOfMinutesInSeconds" select="$totalSeconds mod 3600"/>
		<xsl:variable name="noOfMinutes" select="floor($noOfMinutesInSeconds div 60)"/>
		<xsl:variable name="noOfSeconds" select="$noOfMinutesInSeconds mod 60"/>
		<xsl:variable name="noOfMilliSeconds" select="number(substring(substring-after($timeInSeconds,'.'),1,4)) div 10"/>
		<xsl:value-of select="concat(format-number($noOfHours,'00'),':',format-number($noOfMinutes,'00'),':',format-number($noOfSeconds,'00'),'.',format-number($noOfMilliSeconds,'000'))"/>
	</xsl:template>
	<xsl:variable name="gNumExtraColumnsToAdd" select="0"/>
	<xsl:variable name="gRemoveExpandCollapseFunctionality" select="false()"/>
	<!--End of Customization-->
	<xsl:variable name="gValueSpan" select="6+$gNumExtraColumnsToAdd"/>
	<xsl:variable name="gHeadingSpan" select="7+$gNumExtraColumnsToAdd"/>
	<xsl:variable name="gStylesheetPath">
		<xsl:call-template name="GetStylesheetPath"/>
	</xsl:variable>
	<xsl:variable name="gSingleSpaceValue" select="15"/>
	<xsl:variable name="gImageWidthValue">
		<xsl:choose>
			<xsl:when test="$gRemoveExpandCollapseFunctionality">
				<xsl:value-of select="0"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="18"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="gPlusImage">
		<xsl:call-template name="GetImageAbsolutePath">
			<xsl:with-param name="imageName" select="'plus.png'"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="gMinusImage">
		<xsl:call-template name="GetImageAbsolutePath">
			<xsl:with-param name="imageName" select="'minus.png'"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="gGraphControlInstalled">
		<xsl:choose>
			<xsl:when test="function-available('user:IsGraphControlInstalled')">
				<xsl:value-of select="number(user:IsGraphControlInstalled())"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="0"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:template match="/">
		<html>
			<head>
				<title> Report</title>
				<script type="text/javascript">
					//<![CDATA[		
					var gStylesheetpath = "";	
					/** A function to initialize the global variable with the stylesheet path**/	
					setStylesheetPath = function(path)
					{
						gStylesheetpath = path;
					}	
					/** A function to return the image path depending on whether the file was packed using the XMLPack utility.
					**/	
					getImageAbsolutePath = function(imageFileName)
					{
						var path ="";	
						if (gStylesheetpath.search(/[/]/g) == 0)	
							path = imageFileName; 
						else
							path = gStylesheetpath +  imageFileName;
						return path;	
					}

					var gExpandCollapseState = "collapsed";

					/** An array cache of all divs in HTML body, this will calculate all expand collapse divs once and 
					 store in this global array so that performance is improved for expand/collapse actions from second time**/
					var gExpandCollapseImagesArray; 


					/**Apply Expand/Collapse functionality for image element, this will be called by onClick event of img element
					**/
					expandCollapse = function(event)
					{
						var imgElem = event.target || event.srcElement;			
						expandCollapseImageDiv(imgElem);
					}

					/**Apply Expand/Collapse functionality for div element which contains imgElem
						imgElem - DOM object of img element
					**/
					expandCollapseImageDiv = function(imgElem)
					{
						var id = imgElem.className;
						var expCollDiv = document.getElementById(id);
						if(expCollDiv)
						{
							var imgSrc = imgElem.src;
							var indexOfLastSlash  = imgSrc.lastIndexOf('/') + 1;
							var imgPath = imgSrc.slice(0,indexOfLastSlash);
							var imgName = imgSrc.slice(indexOfLastSlash);
							if(expCollDiv.className == "expanded")
							{
								expCollDiv.className="collapsed";
								expCollDiv.style.display="none";
								imgName = imgName.replace("minus","plus");
							}	
							else
							{
								expCollDiv.className="expanded";
								expCollDiv.style.display="block";
								imgName = imgName.replace("plus","minus");
							}	
							imgElem.src=imgPath+imgName;
						}
					}

					/**Change classname for DIV element, so that it is visible and expanded
						imgElem - DOM object of img element
					**/
					expandImageDiv = function(imgElem)
					{
						var id = imgElem.className;
						var expCollDiv = document.getElementById(id);
						if(expCollDiv)
						{
							var imgSrc = imgElem.src;
							var indexOfLastSlash  = imgSrc.lastIndexOf('/') + 1;
							var imgPath = imgSrc.slice(0,indexOfLastSlash);
							var imgName = imgSrc.slice(indexOfLastSlash);
							expCollDiv.className="expanded";
							expCollDiv.style.display="block";
							imgName = imgName.replace("plus","minus");					
							imgElem.src=imgPath+imgName;
						}
					}
					/**Change classname for DIV element, so that it is hidden and collapsed
						imgElem - DOM object of img element
					**/
					collapseImageDiv = function(imgElem)
					{
						var id = imgElem.className;
						var expCollDiv = document.getElementById(id);
						if(expCollDiv)
						{
							var imgSrc = imgElem.src;
							var indexOfLastSlash  = imgSrc.lastIndexOf('/') + 1;
							var imgPath = imgSrc.slice(0,indexOfLastSlash);
							var imgName = imgSrc.slice(indexOfLastSlash);
							expCollDiv.className="collapsed";
							expCollDiv.style.display="none";
							imgName = imgName.replace("minus","plus");	
							imgElem.src=imgPath+imgName;
						}
					}
					/**
					* @constructor
					*/
					ImgCollection = function(imgArray) { this.imgArray= imgArray; 	this.state = "expanded"; };
					
					/** A High level expand/collapse function which will expand or collapse all the DIVs in HTML body 
					**/
					expandCollapseAll = function(event)
					{
						var rootImgElem = event.target || event.srcElement;		
						var uniqueDivId = 	rootImgElem.className;
						if(!gExpandCollapseImagesArray)
						{
							gExpandCollapseImagesArray =  new Array();
						}						
						if(!gExpandCollapseImagesArray[uniqueDivId])
						{
							var divElement = document.getElementById(uniqueDivId);						
							gExpandCollapseImagesArray[uniqueDivId] = new ImgCollection(divElement.getElementsByTagName("img"));
						}
						var expandCollapseState = gExpandCollapseImagesArray[uniqueDivId].state;
						var expandCollapseImagesArray = gExpandCollapseImagesArray[uniqueDivId].imgArray;
						if (expandCollapseState == "expanded")
						{
							for(var i=0; i<expandCollapseImagesArray.length;++i)
							{
								var imgElem = expandCollapseImagesArray[i];
								if (imgElem.className == "trExpanded")
									collapseTRImg(imgElem);
								else
									collapseImageDiv(imgElem);
							}
							rootImgElem.src =getImageAbsolutePath("plus.png");
							collapseImageDiv(rootImgElem);
							expandCollapseState="collapsed";
						}
						else
						{
							for(var i=0; i<expandCollapseImagesArray.length;++i)
							{
								var imgElem = expandCollapseImagesArray[i];
								if (imgElem.className == "trExpanded")
									expandTRImg(imgElem);
								else
									expandImageDiv(imgElem);
							}
							rootImgElem.src =getImageAbsolutePath("minus.png");
							expandImageDiv(rootImgElem);
							expandCollapseState="expanded";
						}
						gExpandCollapseImagesArray[uniqueDivId].state = expandCollapseState;
					}
					/** A High level expand function which will expand all the DIVs in HTML body 
					**/
					expandAllTables = function(event)
					{
						var anchorElement = event.target || event.srcElement;	
						if (anchorElement)
						{
							var anchorHref = anchorElement.href;
							var uniqueDivId = 	anchorElement.className;
							var rootImgElem = document.getElementById(uniqueDivId +'img');	
							if(!gExpandCollapseImagesArray)
							{
								gExpandCollapseImagesArray =  new Array();
							}		
							if(!gExpandCollapseImagesArray[uniqueDivId])
							{
								var divElement = document.getElementById(uniqueDivId);						
								gExpandCollapseImagesArray[uniqueDivId] = new ImgCollection(divElement.getElementsByTagName("img"));
							}
							var expandCollapseImagesArray = gExpandCollapseImagesArray[uniqueDivId].imgArray;
							for(var i=0; i<expandCollapseImagesArray.length;++i)
							{
								var imgElem = expandCollapseImagesArray[i];
								if (imgElem.className != "trExpanded")
									expandImageDiv(imgElem);
							}
							rootImgElem.src =getImageAbsolutePath("minus.png");
							expandImageDiv(rootImgElem);		
							gExpandCollapseImagesArray[uniqueDivId].state = "expanded";
							window.location.href = anchorHref; 
						}
							return false;
					}	

					expandTable = function(event)
					{
						var anchorElement = event.target || event.srcElement;		
						var anchorHref = anchorElement.href;
						var indexOfHash = anchorHref.lastIndexOf('#');
						var id = anchorHref.substring(indexOfHash + 1);
						var tableElement = document.getElementById(id);
						var parentElement = tableElement.parentNode;
						while(parentElement.tagName != "BODY")
						{
							if(parentElement.tagName=='DIV' && parentElement.className=='collapsed')
							{
								var imgElem = parentElement.parentNode.getElementsByTagName("IMG")[0];
								var imgSrc = imgElem.src;
								var indexOfLastSlash  = imgSrc.lastIndexOf('/') + 1;
								var imgPath = imgSrc.slice(0,indexOfLastSlash);
								var imgName = imgSrc.slice(indexOfLastSlash);
								parentElement.className="expanded";
								imgName = imgName.replace("plus","minus");					
								imgElem.src=imgPath+imgName;
							}
							parentElement = parentElement.parentNode;
						}
						window.location.href = anchorHref;
						return false;
					}
					
				/** Functions to expand collapse tr elements **/
				var kExpandedState = 1;
				var kCollapsedState = 0;
				expandCollapseTR = function(event)
				{
					var imgElem = event.target || event.srcElement;			 
					if (imgElem)
					{
						expandCollapseTRImg(imgElem);
					}
				}
				expandCollapseTRImg  = function(imgElem)
				{
					var trElem	= imgElem.parentNode.parentNode;
					if(trElem)
					{
						var expCollState = getStateFromTRElement(trElem);
						if (expCollState == kCollapsedState)
						{
							expandNestedRows(trElem);
							setStateOfTR(trElem, kExpandedState);
							setImageToMinus(imgElem);
						}
						else if (expCollState == kExpandedState)
						{
							collapseNestedRows(trElem);
							setStateOfTR(trElem, kCollapsedState);
							setImageToPlus(imgElem);
						}
					}
				}
				expandTRImg  = function(imgElem)
				{
					var trElem	= imgElem.parentNode.parentNode;
					if(trElem)
					{
						expandNestedRows(trElem);
						setStateOfTR(trElem, kExpandedState);
						setImageToMinus(imgElem)
					}
				}
				collapseTRImg  = function(imgElem)
				{
					var trElem	= imgElem.parentNode.parentNode;
					if(trElem)
					{
						collapseNestedRows(trElem);
						setStateOfTR(trElem, kCollapsedState);
						setImageToMinus(imgElem);
					}
				}
				getStateFromTRElement = function(trElem)
				{
					var className = trElem.className;
					var state = kExpandedState;
					var splitData = className.split(' ');
					if(splitData.length >= 3)
					{
						state = parseInt(splitData[2].split(':')[1],10)
					}
					return state;
				}
				getLevelFromTRElement = function(trElem)
				{
					var className = trElem.className;
					var level = -1;
					var splitData = className.split(' ');
					if(splitData.length >= 2)
					{
						level = parseInt(splitData[1].split(':')[1],10)
					}
					return level;
				}
				setVisibiltyOfTR = function(trElem, visibility)
				{
					var className = trElem.className;
					var splitData = className.split(' ');
					if(splitData.length >= 3)
					{
						splitData[0] = visibility;
						trElem.className = splitData.join(' ');
					}					
				}
				setStateOfTR = function(trElem, state)
				{
					var className = trElem.className;
					var splitData = className.split(' ');
					if(splitData.length >= 3)
					{
						splitData[2] = 'state:' + state;
						trElem.className = splitData.join(' ');
					}					
				}
				setImageToPlus = function(imgElem)
				{
					var imgSrc = imgElem.src;
					var indexOfLastSlash  = imgSrc.lastIndexOf('/') + 1;
					var imgPath = imgSrc.slice(0,indexOfLastSlash);
					var imgName = imgSrc.slice(indexOfLastSlash);
					imgName = imgName.replace("minus","plus");
					imgElem.src=imgPath+imgName;
				}
				setImageToMinus = function(imgElem)
				{
					var imgSrc = imgElem.src;
					var indexOfLastSlash  = imgSrc.lastIndexOf('/') + 1;
					var imgPath = imgSrc.slice(0,indexOfLastSlash);
					var imgName = imgSrc.slice(indexOfLastSlash);
					imgName = imgName.replace("plus","minus");
					imgElem.src=imgPath+imgName;
				}
				collapseNestedRows = function(trElem)
				{					
					var currLevel = getLevelFromTRElement(trElem);
					trElem = trElem.nextSibling;
					while (trElem)
					{
						var nextLevel = getLevelFromTRElement(trElem);
						if (nextLevel > currLevel)
							setVisibiltyOfTR(trElem, "hidden");
						else
							break;
						trElem =  trElem.nextSibling;
					}
				}
				expandNestedRows = function(trElem)
				{
					var currLevel = getLevelFromTRElement(trElem);
					var makeVisible = true;
					var level = -1;
					trElem = trElem.nextSibling;
					while (trElem)
					{
						var nextLevel = getLevelFromTRElement(trElem);
						if (nextLevel > currLevel)
						{
							var state = getStateFromTRElement(trElem);
							if (makeVisible == true)
							{
								if (state == kCollapsedState)
								{
									level = nextLevel;
									makeVisible = false;
								}
								setVisibiltyOfTR(trElem, "visible");
							}
							else if(nextLevel <= level)
							{
								level = -1;
								makeVisible = true;
								if (state == kCollapsedState)
								{
									level = nextLevel;
									makeVisible = false;
								}
								setVisibiltyOfTR(trElem, "visible");
							}							 
						}
						else
							break;
						trElem = trElem.nextSibling;
					}
				}
				//Perform any initialization in this method and add dynamic event handlers here	
					init = function(path)
					{																	
						setStylesheetPath(path);
					}
						//]]></script>
				<style type="text/css">
					body {font-family:VERDANA;}
					img {margin-right:5px;}
					img.expandCollapseAll{width:26px; height:28px; border-style:none; cursor:pointer;}
					img.expandCollapse{border-style:none; cursor:pointer}
					table.uutTable{font-size: 11px;border-width:0.13em;border-style:ridge;border-color:silver;border-collapse:collapse;width:70%;}
					table.uutTable td, th, tr{border-width:1px;border-style:ridge;border-color:silver;white-space:nowrap;padding:0.4em;vertical-align:text-top;border-collapse:collapse;}
					table.batchTable{width:80%;font-size: 11px;border-width:0.13em;border-style:ridge;border-color:silver;border-collapse:collapse;}
					table.batchTable td, th, tr{border-width:1px;border-style:ridge;border-color:silver;white-space:normal;padding:0.4em;vertical-align:text-top;border-collapse:collapse;}
					table.uutHrefTable{width:80%;font-size: 11px;border-width:0.13em;border-color:silver;border-collapse:collapse;border-style:ridge;}
					table.uutHrefTable td, th, tr{border-width:0.13em;border-color:silver;border-collapse:collapse;border-style:ridge;padding:0.4em;text-align:center;}
					table.stepTable{width:70%;font-size: 11px;border-width:0.13em;border-color:silver;border-collapse:collapse;border-style:ridge;}
					table.stepTable td, th, tr{border-width:0.13em;border-color:silver;border-collapse:collapse;border-style:ridge;padding:0.4em;text-align:left;}					
					hr.headerSeparator{text-align:left;height:1px;width:90%;margin-left:0px;}
					hr.uutSeparator{text-align:left;height:1px;width:90%;margin-left:0px;}
					hr.batchSeparator{text-align:center;height:1px;width:90%;}
					table.criticalFailureTable{width:70%;font-size: 11px;border-width:1px;border-style:ridge;border-color:silver;border-collapse:collapse;}
					table.criticalFailureTable td, th{border-width:1px;border-style:ridge;border-color:silver;border-collapse:collapse;white-space:nowrap;padding:0.4em;vertical-align:text-top;}
					table.criticalFailureTable td {text-align:left;}
					table.criticalFailureTable th {text-align:center;}
					span.stepText{font-size:15px;}
					tr.visible{diplay:inline;}
					tr.hidden{display:none;}
					img{margin:0px;padding:0px;}
					<xsl:if test="$gRemoveExpandCollapseFunctionality">
						img{display:none;}
					</xsl:if>
				</style>
			</head>
			<body onload="init('{$gStylesheetPath}');">
				<!-- ADD_HEADER_INFO Section to add some header Text/Image to the entire report-->
        <img src = 'D:\Reports\CompanyLogo.jpg'/>
        <br/>
        <br/>
					<span style="font-size:2.00em;color:#003366;">Final Functional Test</span>
        <br/>
				<xsl:for-each select="//trc:TestResults|//trc:Extension">
					<xsl:apply-templates select="."/>
				</xsl:for-each>
				<!-- ADD_FOOTER_INFO Section to add some footer Text/Image to the entire report-->
				<!--span style="font-size:1.13em;color:#003366;">TestStand Generated Report</span-->
			</body>
		</html>
	</xsl:template>
	<xsl:template match="trc:Extension">
		<h5>Batch Report</h5>
		<table class="batchTable">
			<tr>
				<td style="font-weight:bold;">Station ID</td>
				<td>
					<xsl:value-of select="ts:TSBatchTable/@stationID"/>
				</td>
			</tr>
			<tr>
				<td style="font-weight:bold;">Batch Serial Number</td>
				<td>
					<xsl:choose>
						<xsl:when test="ts:TSBatchTable/@batchSerialNumber != ''">
							<xsl:value-of select="ts:TSBatchTable/@batchSerialNumber"/>
						</xsl:when>
						<xsl:otherwise>NONE</xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>
			<tr>
				<td style="font-weight:bold;">Date</td>
				<td>
					<xsl:call-template name="GetUUTDate">
						<xsl:with-param name="date" select="substring-before(ts:TSBatchTable/@startDateTime,'T')"/>
					</xsl:call-template>
				</td>
			</tr>
			<tr>
				<td style="font-weight:bold;">Time</td>
				<td>
					<xsl:call-template name="GetUUTTime">
						<xsl:with-param name="dateTime" select="ts:TSBatchTable/@startDateTime"/>
					</xsl:call-template>
				</td>
			</tr>
			<tr>
				<td style="font-weight:bold;">Operator</td>
				<td>
					<xsl:value-of select="ts:TSBatchTable/@operator"/>
				</td>
			</tr>
			<xsl:if test="ts:TSBatchTable/ts:TSRData">
				<tr>
					<td style="font-weight:bold;">TSR File Name</td>
					<td>
						<xsl:value-of select="ts:TSBatchTable/ts:TSRData/@TSRFileName"/>
					</td>
				</tr>
				<tr>
					<td style="font-weight:bold;">TSR File ID</td>
					<td>
						<xsl:value-of select="ts:TSBatchTable/ts:TSRData/@TSRFileID"/>
					</td>
				</tr>
				<tr>
					<td style="font-weight:bold;">TSR File Closed</td>
					<td>
						<xsl:choose>
							<xsl:when test="ts:TSBatchTable/ts:TSRData/@TSRFileClosed = 'true'">OK</xsl:when>
							<xsl:otherwise>The .tsr file was not closed normally when written. This can indicate that the testing process was interrupted or aborted.</xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>
			</xsl:if>
		</table>
		<br/>
		<table class="uutHrefTable">
			<tr style="font-weight:bold;">
				<td>Test Socket</td>
				<td>UUT Serial Number</td>
				<td>UUT Result</td>
			</tr>
			<xsl:apply-templates select="ts:TSBatchTable/ts:UUTHref">
				<xsl:with-param name="colors" select="ts:TSBatchTable/ts:ReportOptions/c:Item[@name='Colors']/c:Collection"/>
			</xsl:apply-templates>
		</table>
		<br/>
		<h5>End Batch Report</h5>
		<hr class="batchSeparator"/>
	</xsl:template>
	<xsl:template match="ts:UUTHref">
		<xsl:param name="colors"/>
		<tr>
			<td>
				<xsl:value-of select="@socketIndex"/>
			</td>
			<td>
				<a>
					<xsl:if test="@uutURI != ''">
						<xsl:attribute name="href"><xsl:value-of select="concat(@uutURI,'#',@socketIndex,'-',@anchorName)"/></xsl:attribute>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="string-length(normalize-space(@linkName)) = 0">NONE</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="@linkName"/>
						</xsl:otherwise>
					</xsl:choose>
				</a>
			</td>
			<xsl:variable name="uutResultBgColor">
				<xsl:call-template name="GetUutResultColor">
					<xsl:with-param name="status" select="@uutResult"/>
					<xsl:with-param name="colors" select="$colors"/>
				</xsl:call-template>
			</xsl:variable>
			<td style="color:{$uutResultBgColor}">
				<xsl:value-of select="@uutResult"/>
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="ts:LoopingProperties">
	<xsl:if test="ts:NumLoops">
		<tr>
			<td style="padding-left:{$gSingleSpaceValue}px;">Number of Loops:</td>
			<td colspan="{$gValueSpan};">
				<xsl:value-of select="ts:NumLoops/@value"/>
			</td>
		</tr>
		<tr>
			<td style="padding-left:{$gSingleSpaceValue}px;">Number of Passes:</td>
			<td colspan="{$gValueSpan};">
				<xsl:value-of select="ts:NumPassed/@value"/>
			</td>
		</tr>
		<tr>
			<td style="padding-left:{$gSingleSpaceValue}px;">Number of Failures:</td>
			<td colspan="{$gValueSpan};">
				<xsl:value-of select="ts:NumFailed/@value"/>
			</td>
		</tr>
		<tr>
			<td style="padding-left:{$gSingleSpaceValue}px;">Final Loop Index:</td>
			<td colspan="{$gValueSpan};">
				<xsl:value-of select="ts:EndingLoopIndex/@value"/>
			</td>
		</tr>
	</xsl:if>
	</xsl:template>
	<xsl:template match="trc:TestResults">
		<xsl:variable name="reportOptions" select="tr:TestProgram/tr:Configuration/c:Collection"/>
		<h5>UUT Report</h5>
		<xsl:call-template name="PutBatchUutLink"/>
		<xsl:variable name="includeAttributes" select="$reportOptions/c:Item[@name='IncludeAttributes']/c:Datum/@value = 'true'"/>
		<xsl:variable name="includeMeasurements" select="$reportOptions/c:Item[@name='IncludeMeasurements']/c:Datum/@value = 'true'"/>
		<xsl:variable name="includeLimits" select="$reportOptions/c:Item[@name='IncludeLimits']/c:Datum/@value = 'true'"/>
		<xsl:if test="function-available('user:SetIncludeArrayMeasurement')">
			<xsl:variable name="includeArrayMeasurement" select="concat($reportOptions/c:Item[@name='IncludeArrayMeasurement']/c:Datum/@value, '')"/>
			<xsl:value-of select="user:SetIncludeArrayMeasurement($includeArrayMeasurement)"/>
		</xsl:if>
		<xsl:variable name="statusColor">
			<xsl:call-template name="GetStatusColor">
				<xsl:with-param name="colors" select="$reportOptions/c:Item[@name='Colors']/c:Collection"/>
				<xsl:with-param name="status" select="tr:ResultSet/tr:Outcome/@value"/>
				<xsl:with-param name="qualifier" select="tr:ResultSet/tr:Outcome/@qualifier"/>
			</xsl:call-template>
		</xsl:variable>
		<table class="uutTable">
			<tr>
				<td style="font-weight:bold;">Station ID</td>
				<td>
					<xsl:value-of select="tr:TestStation/c:SerialNumber"/>
				</td>
			</tr>
			<xsl:if test="string-length(tr:Extension/ts:TSResultSetProperties/ts:BatchSerialNumber/@value)!=0">
				<tr>
					<td style="font-weight:bold;">Batch Serial Number</td>
					<td>
						<xsl:value-of select="tr:Extension/ts:TSResultSetProperties/ts:BatchSerialNumber/@value"/>
					</td>
				</tr>
			</xsl:if>
			<xsl:if test="tr:Extension/ts:TSResultSetProperties/ts:TestSocketIndex">
				<tr>
					<td style="font-weight:bold;">Test Socket Index</td>
					<td>
						<xsl:value-of select="tr:Extension/ts:TSResultSetProperties/ts:TestSocketIndex/@value"/>
					</td>
				</tr>
			</xsl:if>
			<tr>
				<td style="font-weight:bold;">Serial Number</td>
				<td>
					<xsl:value-of select="tr:UUT/c:SerialNumber"/>
				</td>
			</tr>
      <tr>
        <td style="font-weight:bold;">QiG Serial Number</td>
        <td>
          <xsl:value-of select="tr:ResultSet/tr:QiGSerialNumber/tr:Number/@value"/>
        </td>
      </tr>
			<tr>
				<td style="font-weight:bold;">Part Number</td>
				<td>
					<xsl:value-of select="tr:ResultSet/tr:PartNumber/tr:Number/@value"/>
				</td>
			</tr>
      <tr>
        <td style="font-weight:bold;">Model Number</td>
        <td>
          <xsl:value-of select="tr:ResultSet/tr:ModelNumber/tr:Number/@value"/>
        </td>
      </tr>
      <tr>
        <td style="font-weight:bold;">Lot Number</td>
        <td>
          <xsl:value-of select="tr:ResultSet/tr:LotNumber/tr:Number/@value"/>
        </td>
      </tr>
      <tr>
        <td style="font-weight:bold;">Work Order Number</td>
        <td>
          <xsl:value-of select="tr:ResultSet/tr:WorkOrderNumber/tr:Number/@value"/>
        </td>
      </tr>
      <tr>
        <td style="font-weight:bold;">MICS ID</td>
        <td>
          <xsl:value-of select="tr:ResultSet/tr:MICSID/tr:Number/@value"/>
        </td>
      </tr>
			<tr>
				<td style="font-weight:bold;">Date</td>
				<td>
					<xsl:call-template name="GetUUTDate">
						<xsl:with-param name="date" select="substring-before(tr:ResultSet/@startDateTime,'T')"/>
					</xsl:call-template>
				</td>
			</tr>
			<tr>
				<td style="font-weight:bold;">Time</td>
				<td>
					<xsl:call-template name="GetUUTTime">
						<xsl:with-param name="dateTime" select="tr:ResultSet/@startDateTime"/>
					</xsl:call-template>
				</td>
			</tr>
			<tr>
				<td style="font-weight:bold;">Operator</td>
				<td>
					<xsl:value-of select="tr:Personnel/tr:SystemOperator/@name"/>
				</td>
			</tr>
			<xsl:if test="tr:ResultSet/tr:Extension/ts:TSStepProperties/ts:TotalTime">
				<tr>
					<td style="font-weight:bold;">Execution Time </td>
					<td>
						<!--CHANGE_TOTAL_TIME_FORMAT-->
						<xsl:value-of select="tr:ResultSet/tr:Extension/ts:TSStepProperties/ts:TotalTime/@value"/> seconds						
						<!--xsl:call-template name="GetTotalTimeInHHMMSSFormat">
							<xsl:with-param name="timeInSeconds" select="tr:ResultSet/tr:Extension/ts:TSStepProperties/ts:TotalTime/@value"/>
						</xsl:call-template-->
					</td>
				</tr>
			</xsl:if>
			<tr>
				<td style="font-weight:bold;">Number of Results</td>
				<td>
					<xsl:value-of select="tr:Extension/ts:TSResultSetProperties/ts:NumOfResults/@value"/>
				</td>
			</tr>
			<tr>
				<td style="font-weight:bold;">UUT Result</td>
				<td style="color:{$statusColor};">
					<xsl:choose>
						<xsl:when test="tr:ResultSet/tr:Outcome/@qualifier">
							<xsl:value-of select="tr:ResultSet/tr:Outcome/@qualifier"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="tr:ResultSet/tr:Outcome/@value"/>
						</xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>  
			<xsl:if test="tr:UUT/c:Definition/c:Identification/c:IdentificationNumbers/c:IdentificationNumber[@type='Part']">
				<tr>
					<td style="font-weight:bold;">Part Number:</td>
					<td><xsl:value-of select="tr:UUT/c:Definition/c:Identification/c:IdentificationNumbers/c:IdentificationNumber[@type='Part']/@number"/></td>
				</tr>
			</xsl:if>
			<xsl:if test="tr:Extension/ts:TSResultSetProperties/ts:TSRData">
				<tr>
					<td style="font-weight:bold;">TSR File Name</td>
					<td>
						<xsl:value-of select="tr:Extension/ts:TSResultSetProperties/ts:TSRData/@TSRFileName"/>
					</td>
				</tr>
				<tr>
					<td style="font-weight:bold;">TSR File ID</td>
					<td>
						<xsl:value-of select="tr:Extension/ts:TSResultSetProperties/ts:TSRData/@TSRFileID"/>
					</td>
				</tr>
				<tr>
					<td style="font-weight:bold;">TSR File Closed</td>
					<td style="white-space:normal">
						<xsl:choose>
							<xsl:when test="tr:Extension/ts:TSResultSetProperties/ts:TSRData/@TSRFileClosed = 'true'">OK</xsl:when>
							<xsl:otherwise>The .tsr file was not closed normally when written. This can indicate that the testing process was interrupted or aborted.</xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>
			</xsl:if>
			<xsl:if test="tr:ResultSet/tr:Outcome/@qualifier='Error'">
				<tr>
					<td colspan="2" style="color:{$reportOptions/c:Item[@name='Colors']/c:Collection/c:Item[@name='Error']}; white-space:normal; text-align:left;">
					<xsl:if test="tr:ResultSet/tr:Events/tr:Event[@ID='Error Message']">
						<xsl:variable name="errorMsg">
							<xsl:apply-templates select="tr:ResultSet/tr:Events/tr:Event[@ID='Error Message']/tr:Data/c:Datum">
								<xsl:with-param name="addProperty" select="true()"/>
							</xsl:apply-templates>
						</xsl:variable>Error: 
							<xsl:call-template name="ReplaceNewLineWithBreak">
							<xsl:with-param name="inputString" select="$errorMsg"/>
						</xsl:call-template>
					</xsl:if>
					<xsl:if test="tr:ResultSet/tr:Events/tr:Event[@ID='Error Code']">[Error Code: <xsl:apply-templates select="tr:ResultSet/tr:Events/tr:Event[@ID='Error Code']/tr:Data/c:Datum"><xsl:with-param name="addProperty" select="true()"/></xsl:apply-templates>
					</xsl:if>
					<xsl:if test="tr:ResultSet/tr:Events/tr:Event[@ID='Error Code']/tr:Message">, <xsl:value-of select="tr:ResultSet/tr:Events/tr:Event[@ID='Error Code']/tr:Message" disable-output-escaping="yes"/>
					</xsl:if>]
					</td>
				</tr>
			</xsl:if>
		</table>
		<xsl:variable name="criticalFailureStackNode" select="tr:Extension/ts:TSResultSetProperties/ts:CriticalFailureStack"/>
		<xsl:variable name="uniqueDivId" select="generate-id()"/>
		<br/>
		<xsl:if test="$criticalFailureStackNode">
			<xsl:call-template name="AddCriticalFailureStack">
				<xsl:with-param name="criticalFailureStackNode" select="$criticalFailureStackNode"/>
				<xsl:with-param name="uniqueDivId" select="$uniqueDivId"/>
			</xsl:call-template>
		</xsl:if>
		<hr class="headerSeparator"/>
		<xsl:apply-templates select="tr:Extension/ts:TSResultSetProperties/ts:ResultListPresent"/>
		<xsl:apply-templates select="tr:ResultSet">
			<xsl:with-param name="reportOptions" select="$reportOptions"/>
			<xsl:with-param name="includeAttributes" select="$includeAttributes"/>
			<xsl:with-param name="includeMeasurements" select="$includeMeasurements"/>
			<xsl:with-param name="includeLimits" select="$includeLimits"/>
			<xsl:with-param name="uniqueDivId" select="$uniqueDivId"/>
		</xsl:apply-templates>
		<h5>End UUT Report</h5>
		<xsl:variable name="uutSeparatorColor" select="$reportOptions/c:Item[@name = 'Colors']/c:Collection/c:Item[@name = 'UUTSeparator']/c:Datum/c:Value"/>
		<hr class="uutSeparator"/>
	</xsl:template>
	<xsl:template match="ts:ResultListPresent">
		<xsl:variable name="indentation">
			<xsl:choose>
				<xsl:when test="@value = 'false'">40</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="@value = 'false'">
			<span style="margin-left:20px;font-size:11px;font-weight:bold;">
			Begin Sequence:  MainSequence
			</span>
				<br/>
				<xsl:choose>
				  <xsl:when test="contains(../../../tr:ResultSet/@name,'#')">	
				<span style="margin-left:20px;font-size:11px;font-weight:bold;">
					(<xsl:value-of select="substring-before(../../../tr:ResultSet/@name, '#')"/>)
				</span>
				  </xsl:when>
				  <xsl:otherwise>
				<span style="margin-left:20px;font-size:11px;font-weight:bold;">
					(<xsl:value-of select="../../../tr:ResultSet/@name"/>)
				</span>
				  </xsl:otherwise>
			    </xsl:choose>
		</xsl:if>
		<h4 style="margin-left:{$indentation}px;font-size:11px;font-weight:bold;">
			No Sequence Results Found
		</h4>
		<xsl:if test="@value = 'false'">
			<span style="margin-left:20px;font-size:11px;font-weight:bold;">
			End Sequence: MainSequence
			</span>
		</xsl:if>
	</xsl:template>
	<xsl:template match="tr:ResultSet">
		<xsl:param name="reportOptions"/>
		<xsl:param name="includeAttributes"/>
		<xsl:param name="includeMeasurements"/>
		<xsl:param name="includeLimits"/>
		<xsl:param name="uniqueDivId" select="''"/>
		<xsl:if test="count(tr:Test|tr:SessionAction|tr:TestGroup)>0">			
			<xsl:if test="not($gRemoveExpandCollapseFunctionality)">
				<span style="font-size:11px;font-weight:bold;">
					<img onclick="expandCollapseAll(event)" alt="Expand/Collapse" src="{$gMinusImage}" class="{$uniqueDivId}" id="{$uniqueDivId}img"/>
				Expand / Collapse MainSequence
			</span>
				<br/>
				<br/>
			</xsl:if>
			<div class="expanded" id="{$uniqueDivId}">
				<xsl:variable name="firstBlockLevel">
					<xsl:choose>
						<xsl:when test="(tr:Test|tr:SessionAction|tr:TestGroup)[1]/tr:Extension/ts:TSStepProperties/ts:BlockLevel">
							<xsl:value-of select="(tr:Test|tr:SessionAction|tr:TestGroup)[1]/tr:Extension/ts:TSStepProperties/ts:BlockLevel/@value"/>
						</xsl:when>
						<xsl:when test="(tr:Test|tr:SessionAction|tr:TestGroup)[1]/@userDefinedType">
							<xsl:variable name="blockLevel">
								<xsl:value-of select="substring-after((tr:Test|tr:SessionAction|tr:TestGroup)[1]/@userDefinedType, 'bl = ')"/>
							</xsl:variable>
							<xsl:value-of select="number(substring($blockLevel,2,string-length($blockLevel)-2))"/>
						</xsl:when>	
						<xsl:otherwise>
							<xsl:value-of select="0"/>
						</xsl:otherwise>					
					</xsl:choose>
				</xsl:variable>
				<xsl:call-template name="PutNDivOpenTags">
					<xsl:with-param name="n" select="$firstBlockLevel"/>
				</xsl:call-template>
				<span style="margin-left:20px;font-size:11px;font-weight:bold;">
			Begin Sequence:  MainSequence
			</span>
				<br/>
				<xsl:choose>
				  <xsl:when test="contains(@name,'#')">	
				<span style="margin-left:20px;font-size:11px;font-weight:bold;">
					(<xsl:value-of select="substring-before(@name, '#')"/>)
				</span>
				  </xsl:when>
				  <xsl:otherwise>
				<span style="margin-left:20px;font-size:11px;font-weight:bold;">
					(<xsl:value-of select="@name"/>)
				</span>
				  </xsl:otherwise>
			    </xsl:choose>
				<br/>
				<br/>
				<xsl:variable name="indentation">
					<xsl:call-template name="GetIndentationMargin">
						<xsl:with-param name="blockLevel" select="$firstBlockLevel"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:call-template name="AddTableElement">
					<xsl:with-param name="indentation" select="$indentation"/>
					<xsl:with-param name="reportOptions" select="$reportOptions"/>
				</xsl:call-template>
					<xsl:apply-templates select="tr:Test|tr:SessionAction|tr:TestGroup">
						<xsl:with-param name="reportOptions" select="$reportOptions"/>
						<xsl:with-param name="testGroupIndentation" select="0"/>
						<xsl:with-param name="includeAttributes" select="$includeAttributes"/>
						<xsl:with-param name="includeMeasurements" select="$includeMeasurements"/>
						<xsl:with-param name="includeLimits" select="$includeLimits"/>
					</xsl:apply-templates>
				<xsl:variable name="isLastChildTestGroup" select="local-name(./*[last()])='TestGroup'"/>
				<xsl:if test="not($isLastChildTestGroup) or (count(./*[last()]/tr:Test) + count(./*[last()]/tr:SessionAction) + count(./*[last()]/tr:TestGroup))=0">
					<xsl:value-of select="concat('&lt;/','table>')" disable-output-escaping="yes"/>
				</xsl:if>
				<br/>
				<span style="margin-left:20px;font-size:11px;font-weight:bold;">
							
			End Sequence: MainSequence
			</span>
				<xsl:variable name="lastBlockLevel">
					<xsl:choose>
						<xsl:when test="child::*[position()=last()]/tr:Extension/ts:TSStepProperties/ts:BlockLevel">
							<xsl:value-of select="child::*[position()=last()]/tr:Extension/ts:TSStepProperties/ts:BlockLevel/@value"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="blockLevel">
								<xsl:value-of select="substring-after(child::*[position()=last()]/@userDefinedType, 'bl = ')"/>
							</xsl:variable>
							<xsl:value-of select="number(substring($blockLevel,2,string-length($blockLevel)-2))"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:call-template name="PutNDivCloseTags">
					<xsl:with-param name="n" select="$lastBlockLevel"/>
				</xsl:call-template>
			</div>
		</xsl:if>
	</xsl:template>
	<xsl:template match="tr:Test">
		<xsl:param name="reportOptions"/>
		<xsl:param name="testGroupIndentation" select="0"/>
		<xsl:param name="includeAttributes"/>
		<xsl:param name="includeMeasurements"/>
		<xsl:param name="includeLimits"/>
		<xsl:variable name="nextBlockLevel">
			<xsl:call-template name="GetNextBlockLevel"/>
		</xsl:variable>
		<xsl:variable name="currentBlockLevel">
			<xsl:choose>
				<xsl:when test="tr:Extension/ts:TSStepProperties/ts:BlockLevel">
					<xsl:value-of select="tr:Extension/ts:TSStepProperties/ts:BlockLevel/@value"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="blockLevel">
						<xsl:value-of select="substring-after(@userDefinedType, 'bl = ')"/>
					</xsl:variable>
					<xsl:value-of select="number(substring($blockLevel,2,string-length($blockLevel)-2))"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="uniqueDivId" select="generate-id()"/>
		<xsl:variable name="isStepCausedSequenceFailure" select="tr:Extension/ts:TSStepProperties/ts:StepCausedSequenceFailure/@value='true'"/>
		<xsl:variable name="hasNumericLimits" select="count(tr:TestResult[(@name='Numeric') and count(tr:TestLimits)=1]) != 0"/>
		<xsl:variable name="hasStringLimits" select="count(tr:TestResult[(@name='String') and count(tr:TestLimits)=1]) != 0"/>
		<xsl:variable name="endingLoopIndex" select="tr:Extension/ts:TSStepProperties/ts:LoopingProperties/ts:EndingLoopIndex"/>
		<xsl:variable name="loopIndex" select="tr:Extension/ts:TSStepProperties/ts:LoopingProperties/ts:LoopIndex"/>
		<tr>
			<td>
				<xsl:if test="$loopIndex">
					<xsl:attribute name="style">vertical-align:top;padding-left:20px;</xsl:attribute>
				</xsl:if>
					<a name="{concat('ResultId',@ID)}"/>
				<xsl:if test="$nextBlockLevel &gt; $currentBlockLevel">
					<img onclick="expandCollapse(event)" alt="expanded" src="{$gMinusImage}" class="{$uniqueDivId}"/>
				</xsl:if>
				<xsl:choose>
					<xsl:when test="@callerName">
						<xsl:value-of select="@callerName"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="@name"/>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<xsl:apply-templates select="tr:Outcome">
				<xsl:with-param name="colors" select="$reportOptions/c:Item[@name='Colors']/c:Collection"/>
				<xsl:with-param name="isBold" select="$isStepCausedSequenceFailure"/>
			</xsl:apply-templates>	
			<xsl:if test="not($hasNumericLimits or $hasStringLimits or count(tr:TestResult[@name='Numeric']/tr:Extension/ts:TSLimitProperties/ts:IsComparisonTypeLog)=1)">
				<td/>
				<td/>
				<td/>
				<td/>
				<td/>
			</xsl:if>
			<xsl:apply-templates select="tr:TestResult[(@name='Numeric' or @name='String') and (count(tr:TestLimits)=1 or count(tr:Extension/ts:TSLimitProperties/ts:IsComparisonTypeLog)=1)]">
				<xsl:with-param name="includeAttributes" select="$includeAttributes"/>
				<xsl:with-param name="includeMeasurements" select="$includeMeasurements"/>
				<xsl:with-param name="includeLimits" select="$includeLimits"/>
			</xsl:apply-templates>
			<!--ADD_COLUMN_DATA-->
			<!--td><xsl:value-of select="@testReferenceID"/></td-->
		</tr>
		<xsl:if test="$hasNumericLimits and $includeLimits">
			<xsl:variable name="lowLimitAttributes">
				<xsl:call-template name="ProcessAttributes">
					<xsl:with-param name="node" select="."/>
					<xsl:with-param name="objectPath" select="'Numeric.Limits.Low'"/>
					<xsl:with-param name="numSpaces" select="3"/>
					<xsl:with-param name="includeAttributes" select="$includeAttributes"/>
					<xsl:with-param name="includeMeasurements" select="$includeMeasurements"/>
					<xsl:with-param name="includeLimits" select="$includeLimits"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="highLimitAttributes">
				<xsl:call-template name="ProcessAttributes">
					<xsl:with-param name="node" select="."/>
					<xsl:with-param name="objectPath" select="'Numeric.Limits.High'"/>
					<xsl:with-param name="numSpaces" select="3"/>
					<xsl:with-param name="includeAttributes" select="$includeAttributes"/>
					<xsl:with-param name="includeMeasurements" select="$includeMeasurements"/>
					<xsl:with-param name="includeLimits" select="$includeLimits"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:if test="$lowLimitAttributes!='' or $highLimitAttributes!=''">
				<tr class="visible level:1 state:0">
					<td colspan="{$gHeadingSpan}" style="padding-left:{$gSingleSpaceValue - $gImageWidthValue}px; vertical-align:middle;">
						<img alt="" src="{$gPlusImage}" onclick="expandCollapseTR(event)" class="trExpanded"/>Limits:</td>
				</tr>
				<xsl:if test="$lowLimitAttributes!=''">
					<tr class="hidden level:2 state:0">
						<td colspan="{$gHeadingSpan}" style="padding-left:{$gSingleSpaceValue * 2 - $gImageWidthValue}px; vertical-align:middle;">
							<img alt="" src="{$gPlusImage}" onclick="expandCollapseTR(event)" class="trExpanded"/>Low:</td>
					</tr>
					<xsl:copy-of select="$lowLimitAttributes"/>
				</xsl:if>
				<xsl:if test="$highLimitAttributes!=''">
					<tr class="hidden level:2 state:0">
						<td colspan="{$gHeadingSpan}" style="padding-left:{$gSingleSpaceValue * 2 - $gImageWidthValue}px; vertical-align:middle;">
							<img alt="" src="{$gPlusImage}" onclick="expandCollapseTR(event)" class="trExpanded"/>High:</td>
					</tr>
					<xsl:copy-of select="$highLimitAttributes"/>
				</xsl:if>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$hasStringLimits and $includeLimits">
			<xsl:variable name="stringLimitAttributes">
				<xsl:call-template name="ProcessAttributes">
					<xsl:with-param name="node" select="."/>
					<xsl:with-param name="objectPath" select="'String.Limits.String'"/>
					<xsl:with-param name="numSpaces" select="3"/>
					<xsl:with-param name="includeAttributes" select="$includeAttributes"/>
					<xsl:with-param name="includeMeasurements" select="$includeMeasurements"/>
					<xsl:with-param name="includeLimits" select="$includeLimits"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:if test="$stringLimitAttributes!=''">
				<tr class="visible level:1 state:0">
					<td colspan="{$gHeadingSpan}" style="padding-left:{$gSingleSpaceValue - $gImageWidthValue}px; vertical-align:middle;">
						<img alt="" src="{$gPlusImage}" onclick="expandCollapseTR(event)" class="trExpanded"/>Limits:</td>
				</tr>
				<tr class="hidden level:2 state:0">
					<td colspan="{$gHeadingSpan}" style="padding-left:{$gSingleSpaceValue * 2 - $gImageWidthValue}px; vertical-align:middle;">
						<img alt="" src="{$gPlusImage}" onclick="expandCollapseTR(event)" class="trExpanded"/>String:</td>
				</tr>
				<xsl:copy-of select="$stringLimitAttributes"/>
			</xsl:if>
		</xsl:if>
		<xsl:apply-templates select="tr:Extension/ts:TSStepProperties/ts:InteractiveExecutionId"/>
		<xsl:apply-templates select="tr:Extension/ts:TSStepProperties/ts:RemoteServerId"/>
		<xsl:call-template name="PutMeasurements">
			<xsl:with-param name="includeAttributes" select="$includeAttributes"/>
			<xsl:with-param name="includeMeasurements" select="$includeMeasurements"/>
			<xsl:with-param name="includeLimits" select="$includeLimits"/>
			<xsl:with-param name="colors" select="$reportOptions/c:Item[@name='Colors']/c:Collection"/>
			<xsl:with-param name="node" select="."/>
		</xsl:call-template>
		<xsl:apply-templates select="tr:Parameters">
			<xsl:with-param name="includeAttributes" select="$includeAttributes"/>
			<xsl:with-param name="includeMeasurements" select="$includeMeasurements"/>
			<xsl:with-param name="includeLimits" select="$includeLimits"/>
			<xsl:with-param name="isLoopIndex" select="$loopIndex"/>
		</xsl:apply-templates>
		<xsl:variable name="dataValue">
			<xsl:apply-templates select="tr:TestResult[(count(tr:TestLimits)=0 and count(tr:Extension/ts:TSLimitProperties/ts:IsComparisonTypeLog)=0) and @name!='ReportText']">
				<xsl:with-param name="numSpaces" select="2"/>
				<xsl:with-param name="includeAttributes" select="$includeAttributes"/>
				<xsl:with-param name="includeMeasurements" select="$includeMeasurements"/>
				<xsl:with-param name="includeLimits" select="$includeLimits"/>
				<xsl:with-param name="colors" select="$reportOptions/c:Item[@name='Colors']/c:Collection"/>
			</xsl:apply-templates>
		</xsl:variable>
		<xsl:if test="$dataValue!=''">
			<tr class="visible level:1 state:1">
			<xsl:choose>
				<xsl:when test="$loopIndex"><td colspan="{$gHeadingSpan}" style="font-weight:500;padding-left:{number($gSingleSpaceValue) + 9}px;">TestResults/Data</td></xsl:when>
				<xsl:otherwise><td colspan="{$gHeadingSpan}" style="font-weight:500;padding-left:{$gSingleSpaceValue}px;">TestResults/Data</td></xsl:otherwise>
			</xsl:choose>
			</tr>
			<xsl:copy-of select="$dataValue"/>
		</xsl:if>
		<xsl:if test="tr:Outcome/@qualifier='Error'">
			<xsl:call-template name="ReportError">
				<xsl:with-param name="eventsNode" select="tr:Events"/>
				<xsl:with-param name="reportOptions" select="$reportOptions"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:apply-templates select="tr:Extension/ts:TSStepProperties/ts:LoopingProperties"/>
		<xsl:apply-templates select="tr:TestResult[@name='ReportText']">
			<xsl:with-param name="bgColor" select="$reportOptions/c:Item[@name='Colors']/c:Collection/c:Item[@name='ReportTextBg']"/>
		</xsl:apply-templates>
		<xsl:if test="$endingLoopIndex">
			<tr>
				<td style="padding-left:15px;">
					<xsl:choose>
						<xsl:when test="@callerName">
							<xsl:value-of select="@callerName"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="@name"/>
						</xsl:otherwise>
					</xsl:choose> (Loop Indices)
				</td>
			</tr>
		</xsl:if>
		<xsl:if test="$currentBlockLevel != $nextBlockLevel">
			<xsl:variable name="indentation">
				<xsl:call-template name="GetIndentationMargin">
					<xsl:with-param name="blockLevel" select="$nextBlockLevel"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:value-of select="concat('&lt;/','table>')" disable-output-escaping="yes"/>
			<xsl:choose>
				<xsl:when test="$nextBlockLevel &gt; $currentBlockLevel">
					<xsl:value-of select="concat('&lt;','div ')" disable-output-escaping="yes"/> class="expanded" id="<xsl:value-of select="$uniqueDivId"/>"<xsl:value-of select="'>'" disable-output-escaping="yes"/>
					<xsl:call-template name="PutNDivOpenTags">
						<xsl:with-param name="n" select="$nextBlockLevel - $currentBlockLevel - 1"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="$nextBlockLevel &lt; $currentBlockLevel">
					<xsl:value-of select="concat('&lt;/','div>')" disable-output-escaping="yes"/>
					<xsl:call-template name="PutNDivCloseTags">
						<xsl:with-param name="n" select="$currentBlockLevel - $nextBlockLevel - 1"/>
					</xsl:call-template>
				</xsl:when>
			</xsl:choose>
			<br/>
			<xsl:call-template name="AddTableElement">
				<xsl:with-param name="indentation" select="$testGroupIndentation + $indentation"/>
				<xsl:with-param name="reportOptions" select="$reportOptions"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template match="tr:SessionAction">
		<xsl:param name="reportOptions"/>
		<xsl:param name="testGroupIndentation" select="0"/>
		<xsl:param name="includeAttributes"/>
		<xsl:param name="includeMeasurements"/>
		<xsl:param name="includeLimits"/>
		<xsl:variable name="uniqueDivId" select="generate-id()"/>
		<xsl:variable name="nextBlockLevel">
			<xsl:call-template name="GetNextBlockLevel"/>
		</xsl:variable>
		<xsl:variable name="currentBlockLevel">
			<xsl:choose>
				<xsl:when test="tr:Extension/ts:TSStepProperties/ts:BlockLevel">
					<xsl:value-of select="tr:Extension/ts:TSStepProperties/ts:BlockLevel/@value"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="blockLevel">
						<xsl:value-of select="substring-after(@userDefinedType, 'bl = ')"/>
					</xsl:variable>
					<xsl:value-of select="number(substring($blockLevel,2,string-length($blockLevel)-2))"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="isFlowType">
			<xsl:call-template name="CheckIfTypeFlow"/>
		</xsl:variable>
		<xsl:variable name="isStepCausedSequenceFailure" select="tr:Extension/ts:TSStepProperties/ts:StepCausedSequenceFailure/@value='true'"/>
		<xsl:variable name="loopIndex" select="tr:Extension/ts:TSStepProperties/ts:LoopingProperties/ts:LoopIndex"/>
		<tr>
			<td>
				<xsl:if test="$loopIndex">
					<xsl:attribute name="style">padding-left:20px;</xsl:attribute>
				</xsl:if>
					<a name="{concat('ResultId',@ID)}"/>
				<xsl:variable name="isNiFlowEnd">
					<xsl:choose>
						<xsl:when test="tr:Extension/ts:TSStepProperties/ts:StepType">
							<xsl:choose>
								<xsl:when test="tr:Extension/ts:TSStepProperties/ts:StepType = 'NI_Flow_End'">True</xsl:when>
								<xsl:otherwise>False</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="@name = 'End'">True</xsl:when>
								<xsl:otherwise>False</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:if test="$nextBlockLevel &gt; $currentBlockLevel and $isFlowType='True' and $isNiFlowEnd='False'">
					<img onclick="expandCollapse(event)" alt="expanded" src="{$gMinusImage}" class="{$uniqueDivId}"/>
				</xsl:if>
				<xsl:value-of select="@name"/>
				<xsl:if test="$isFlowType='True'">
					<xsl:apply-templates select="tr:Data/c:Collection/c:Item[@name='ReportText']/c:Datum">
						<xsl:with-param name="addProperty" select="true()"/>
					</xsl:apply-templates>
				</xsl:if>
			</td>
			<xsl:apply-templates select="tr:ActionOutcome">
				<xsl:with-param name="colors" select="$reportOptions/c:Item[@name='Colors']/c:Collection"/>
				<xsl:with-param name="isBold" select="$isStepCausedSequenceFailure"/>
			</xsl:apply-templates>
			<td/>
			<td/>
			<td/>
			<td/>
			<td/>
			<!--ADD_COLUMN_DATA-->
			<!--td><xsl:value-of select="@testReferenceID"/></td-->
		</tr>
		<xsl:apply-templates select="tr:Extension/ts:TSStepProperties/ts:InteractiveExecutionId"/>
		<xsl:apply-templates select="tr:Extension/ts:TSStepProperties/ts:RemoteServerId"/>
		<xsl:apply-templates select="tr:Parameters">
			<xsl:with-param name="includeAttributes" select="$includeAttributes"/>
			<xsl:with-param name="includeMeasurements" select="$includeMeasurements"/>
			<xsl:with-param name="includeLimits" select="$includeLimits"/>
			<xsl:with-param name="isLoopIndex" select="$loopIndex"/>
		</xsl:apply-templates>
		<xsl:variable name="dataValue">
			<xsl:apply-templates select="tr:Data">
				<xsl:with-param name="isSessionAction" select="true()"/>
				<xsl:with-param name="parentNode" select="."/>
				<xsl:with-param name="numSpaces" select="2"/>
				<xsl:with-param name="includeAttributes" select="$includeAttributes"/>
				<xsl:with-param name="includeMeasurements" select="$includeMeasurements"/>
				<xsl:with-param name="includeLimits" select="$includeLimits"/>
			</xsl:apply-templates>
		</xsl:variable>
		<xsl:if test="$dataValue!=''">
			<tr class="visible level:1 state:1">
				<xsl:choose>
					<xsl:when test="$loopIndex"><td colspan="{$gHeadingSpan}" style="font-weight:500;padding-left:{number($gSingleSpaceValue) + 9}px;">TestResults/Data</td></xsl:when>
					<xsl:otherwise><td colspan="{$gHeadingSpan}" style="font-weight:500;padding-left:{$gSingleSpaceValue}px;">TestResults/Data</td></xsl:otherwise>
				</xsl:choose>
			</tr>
			<xsl:copy-of select="$dataValue"/>
		</xsl:if>
		<xsl:if test="tr:ActionOutcome/@qualifier='Error'">
			<xsl:call-template name="ReportError">
				<xsl:with-param name="eventsNode" select="tr:Events"/>
				<xsl:with-param name="reportOptions" select="$reportOptions"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="$isFlowType='False' and tr:Data/c:Collection/c:Item[@name='ReportText']">
			<tr style="color:{$reportOptions/c:Item[@name='Colors']/c:Collection/c:Item[@name='ReportTextBg']};">
				<td style="padding-left:{$gSingleSpaceValue}px; vertical-align:top;">
					 <xsl:text>Report Text:</xsl:text>
				</td>
				<td colspan="{$gValueSpan}">
					<xsl:call-template name="ReplaceNewLineWithBreak">
						<xsl:with-param name="inputString" select="tr:Data/c:Collection/c:Item[@name='ReportText']/c:Datum/c:Value"/>
					</xsl:call-template>
				</td>
			</tr>
		</xsl:if>
		<xsl:if test="$currentBlockLevel != $nextBlockLevel">
			<xsl:variable name="indentation">
				<xsl:call-template name="GetIndentationMargin">
					<xsl:with-param name="blockLevel" select="$nextBlockLevel"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:value-of select="concat('&lt;/','table>')" disable-output-escaping="yes"/>
			<br/>
			<xsl:choose>
				<xsl:when test="$nextBlockLevel &gt; $currentBlockLevel">
					<xsl:value-of select="concat('&lt;','div ')" disable-output-escaping="yes"/> class="expanded" id="<xsl:value-of select="$uniqueDivId"/>"<xsl:value-of select="'>'" disable-output-escaping="yes"/>
					<xsl:call-template name="PutNDivOpenTags">
						<xsl:with-param name="n" select="$nextBlockLevel - $currentBlockLevel - 1"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="$nextBlockLevel &lt; $currentBlockLevel">
					<xsl:value-of select="concat('&lt;/','div>')" disable-output-escaping="yes"/>
					<xsl:call-template name="PutNDivCloseTags">
						<xsl:with-param name="n" select="$currentBlockLevel - $nextBlockLevel - 1"/>
					</xsl:call-template>
				</xsl:when>
			</xsl:choose>
			<xsl:call-template name="AddTableElement">
				<xsl:with-param name="indentation" select="$testGroupIndentation + $indentation"/>
				<xsl:with-param name="reportOptions" select="$reportOptions"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template match="tr:TestGroup">
		<xsl:param name="reportOptions"/>
		<xsl:param name="testGroupIndentation" select="0"/>
		<xsl:param name="includeAttributes"/>
		<xsl:param name="includeMeasurements"/>
		<xsl:param name="includeLimits"/>
		<xsl:variable name="isPostAction" select="contains(@ID,'_PostAction')"/>
		<xsl:variable name="testGroupBlockLevel">
			<xsl:call-template name="GetBlockLevel"/>
		</xsl:variable>
		<xsl:variable name="uniqueDivId" select="generate-id()"/>
		<xsl:variable name="indentation">
			<xsl:call-template name="GetIndentationMargin">
				<xsl:with-param name="blockLevel" select="$testGroupBlockLevel"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="nextBlockLevel">
			<xsl:call-template name="GetNextBlockLevel"/>
		</xsl:variable>
		<xsl:variable name="currentBlockLevel">
			<xsl:choose>
				<xsl:when test="tr:Extension/ts:TSStepProperties/ts:BlockLevel">
					<xsl:value-of select="tr:Extension/ts:TSStepProperties/ts:BlockLevel/@value"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="blockLevel">
						<xsl:value-of select="substring-after(@userDefinedType, 'bl = ')"/>
					</xsl:variable>
					<xsl:value-of select="number(substring($blockLevel,2,string-length($blockLevel)-2))"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="isStepCauseSequenceFailure" select="tr:Extension/ts:TSStepProperties/ts:StepCausedSequenceFailure/@value='true'"/>
		<xsl:variable name="hasNumericLimits" select="count(tr:TestResult[(@name='Numeric') and count(tr:TestLimits)=1]) != 0"/>
		<xsl:variable name="hasStringLimits" select="count(tr:TestResult[(@name='String') and count(tr:TestLimits)=1]) != 0"/>
		<xsl:variable name="loopIndex" select="tr:Extension/ts:TSStepProperties/ts:LoopingProperties/ts:LoopIndex"/>
		<xsl:if test="not($isPostAction)">
			<tr>
				<td>
						<a name="{concat('ResultId',@ID)}"/>
					<xsl:if test="count(tr:Test|tr:SessionAction|tr:TestGroup)>0">
						<img onclick="expandCollapse(event)" alt="expanded" src="{$gMinusImage}" class="{$uniqueDivId}"/>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="@callerName">
							<xsl:value-of select="@callerName"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="@name"/>
						</xsl:otherwise>
					</xsl:choose>
				</td>
				<xsl:apply-templates select="tr:Outcome">
					<xsl:with-param name="colors" select="$reportOptions/c:Item[@name='Colors']/c:Collection"/>
					<xsl:with-param name="isBold" select="$isStepCauseSequenceFailure"/>
				</xsl:apply-templates>
				<xsl:if test="not($hasNumericLimits or $hasStringLimits or count(tr:TestResult/tr:Extension/ts:TSLimitProperties/ts:IsComparisonTypeLog)=1)">
					<td/>
					<td/>
					<td/>
					<td/>
					<td/>
				</xsl:if>
				<xsl:apply-templates select="tr:TestResult[(@name='Numeric' or @name='String') and (count(tr:TestLimits)=1 or count(tr:Extension/ts:TSLimitProperties/ts:IsComparisonTypeLog)=1)]">
					<xsl:with-param name="includeAttributes" select="$includeAttributes"/>
					<xsl:with-param name="includeMeasurements" select="$includeMeasurements"/>
					<xsl:with-param name="includeLimits" select="$includeLimits"/>
				</xsl:apply-templates>
				<!--ADD_COLUMN_DATA-->
				<!--td><xsl:value-of select="@testReferenceID"/></td-->
			</tr>
			<xsl:if test="$hasNumericLimits and $includeLimits">
				<xsl:variable name="lowLimitAttributes">
					<xsl:call-template name="ProcessAttributes">
						<xsl:with-param name="node" select="."/>
						<xsl:with-param name="objectPath" select="'Numeric.Limits.Low'"/>
						<xsl:with-param name="numSpaces" select="3"/>
						<xsl:with-param name="includeAttributes" select="$includeAttributes"/>
						<xsl:with-param name="includeMeasurements" select="$includeMeasurements"/>
						<xsl:with-param name="includeLimits" select="$includeLimits"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="highLimitAttributes">
					<xsl:call-template name="ProcessAttributes">
						<xsl:with-param name="node" select="."/>
						<xsl:with-param name="objectPath" select="'Numeric.Limits.High'"/>
						<xsl:with-param name="numSpaces" select="3"/>
						<xsl:with-param name="includeAttributes" select="$includeAttributes"/>
						<xsl:with-param name="includeMeasurements" select="$includeMeasurements"/>
						<xsl:with-param name="includeLimits" select="$includeLimits"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:if test="$lowLimitAttributes!='' or $highLimitAttributes!=''">
					<tr class="visible level:1 state:0">
						<td colspan="{$gHeadingSpan}" style="padding-left:{$gSingleSpaceValue - $gImageWidthValue}px; vertical-align:middle;">
							<img alt="" src="{$gPlusImage}" onclick="expandCollapseTR(event)" class="trExpanded"/>Limits:</td>
					</tr>
					<xsl:if test="$lowLimitAttributes!=''">
						<tr class="hidden level:2 state:0">
							<td colspan="{$gHeadingSpan}" style="padding-left:{$gSingleSpaceValue * 2 - $gImageWidthValue}px;">
								<img alt="" src="{$gPlusImage}" onclick="expandCollapseTR(event)" class="trExpanded"/>Low:</td>
						</tr>
						<xsl:copy-of select="$lowLimitAttributes"/>
					</xsl:if>
					<xsl:if test="$highLimitAttributes!=''">
						<tr class="hidden level:2 state:0">
							<td colspan="{$gHeadingSpan}" style="padding-left:{$gSingleSpaceValue * 2 - $gImageWidthValue}px; vertical-align:middle;">
								<img alt="" src="{$gPlusImage}" onclick="expandCollapseTR(event)" class="trExpanded"/>High:</td>
						</tr>
						<xsl:copy-of select="$highLimitAttributes"/>
					</xsl:if>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$hasStringLimits and $includeLimits">
				<xsl:variable name="stringLimitAttributes">
					<xsl:call-template name="ProcessAttributes">
						<xsl:with-param name="node" select="."/>
						<xsl:with-param name="objectPath" select="'String.Limits.String'"/>
						<xsl:with-param name="numSpaces" select="3"/>
						<xsl:with-param name="includeAttributes" select="$includeAttributes"/>
						<xsl:with-param name="includeMeasurements" select="$includeMeasurements"/>
						<xsl:with-param name="includeLimits" select="$includeLimits"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:if test="$stringLimitAttributes!=''">
					<tr class="visible level:1 state:0">
						<td colspan="{$gHeadingSpan}" style="padding-left:{$gSingleSpaceValue - $gImageWidthValue}px; vertical-align:middle;">
							<img alt="" src="{$gPlusImage}" onclick="expandCollapseTR(event)" class="trExpanded"/>Limits:</td>
					</tr>
					<tr class="hidden level:2 state:0">
						<td colspan="{$gHeadingSpan}" style="padding-left:{$gSingleSpaceValue * 2 - $gImageWidthValue}px;">
							<img alt="" src="{$gPlusImage}" onclick="expandCollapseTR(event)" class="trExpanded"/>String:</td>
					</tr>
					<xsl:copy-of select="$stringLimitAttributes"/>
				</xsl:if>
			</xsl:if>
			<xsl:apply-templates select="tr:Extension/ts:TSStepProperties/ts:InteractiveExecutionId"/>
			<xsl:apply-templates select="tr:Extension/ts:TSStepProperties/ts:RemoteServerId"/>
			<xsl:call-template name="PutMeasurements">
				<xsl:with-param name="includeAttributes" select="$includeAttributes"/>
				<xsl:with-param name="includeMeasurements" select="$includeMeasurements"/>
				<xsl:with-param name="includeLimits" select="$includeLimits"/>
				<xsl:with-param name="colors" select="$reportOptions/c:Item[@name='Colors']/c:Collection"/>
				<xsl:with-param name="node" select="."/>
			</xsl:call-template>
			<xsl:apply-templates select="tr:Parameters">
				<xsl:with-param name="includeAttributes" select="$includeAttributes"/>
				<xsl:with-param name="includeMeasurements" select="$includeMeasurements"/>
				<xsl:with-param name="includeLimits" select="$includeLimits"/>
				<xsl:with-param name="isLoopIndex" select="$loopIndex"/>
			</xsl:apply-templates>
			<xsl:variable name="dataValue">
				<xsl:apply-templates select="tr:TestResult[(count(tr:TestLimits)=0 and count(tr:Extension/ts:TSLimitProperties/ts:IsComparisonTypeLog)=0) and @name!='ReportText']">
					<xsl:with-param name="numSpaces" select="2"/>
					<xsl:with-param name="includeAttributes" select="$includeAttributes"/>
					<xsl:with-param name="includeMeasurements" select="$includeMeasurements"/>
					<xsl:with-param name="includeLimits" select="$includeLimits"/>
				</xsl:apply-templates>
			</xsl:variable>
			<xsl:if test="$dataValue!=''">
				<tr class="visible level:1 state:1">
					<xsl:choose>
						<xsl:when test="$loopIndex"><td colspan="{$gHeadingSpan}" style="font-weight:500;padding-left:{number($gSingleSpaceValue) + 9}px;">TestResults/Data</td></xsl:when>
						<xsl:otherwise><td colspan="{$gHeadingSpan}" style="font-weight:500;padding-left:{$gSingleSpaceValue}px;">TestResults/Data</td></xsl:otherwise>
					</xsl:choose>
				</tr>
				<xsl:copy-of select="$dataValue"/>
			</xsl:if>
			<xsl:if test="tr:Outcome/@qualifier='Error'">
				<xsl:call-template name="ReportError">
					<xsl:with-param name="eventsNode" select="tr:Events"/>
					<xsl:with-param name="reportOptions" select="$reportOptions"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:apply-templates select="tr:TestResult[@name='ReportText']">
				<xsl:with-param name="bgColor" select="$reportOptions/c:Item[@name='Colors']/c:Collection/c:Item[@name='ReportTextBg']"/>
			</xsl:apply-templates>
			<xsl:variable name="isNotEmpty" select="count(tr:Test|tr:SessionAction|tr:TestGroup[not(contains(@ID,'_PostAction'))])>0"/>
			<xsl:variable name="testGroupPostActionNode" select="tr:TestGroup[contains(@ID,'_PostAction')]"/>
			<xsl:if test="$isNotEmpty or $testGroupPostActionNode">
				<xsl:value-of select="concat('&lt;/','table>')" disable-output-escaping="yes"/>
				<br/>
				<xsl:variable name="nextIndentation">
					<xsl:call-template name="GetIndentationMargin">
						<xsl:with-param name="blockLevel" select="$testGroupBlockLevel + 1"/>
					</xsl:call-template>
				</xsl:variable>
				<div class="expanded" id="{$uniqueDivId}">
					<xsl:if test="$isNotEmpty">
						<xsl:call-template name="GetTestGroupNameAndPath">
							<xsl:with-param name="testGroupNameAndPath" select="@name"/>
							<xsl:with-param name="indentation" select="$nextIndentation + $testGroupIndentation"/>
						</xsl:call-template>
						<xsl:call-template name="AddTableElement">
							<xsl:with-param name="indentation" select="$nextIndentation + $testGroupIndentation"/>
							<xsl:with-param name="reportOptions" select="$reportOptions"/>
							<xsl:with-param name="addDiv" select="false()"/>
						</xsl:call-template>
						<xsl:apply-templates select="tr:Test|tr:TestGroup|tr:SessionAction">
							<xsl:with-param name="reportOptions" select="$reportOptions"/>
							<xsl:with-param name="testGroupIndentation" select="$testGroupIndentation + $nextIndentation - 20"/>
							<xsl:with-param name="includeAttributes" select="$includeAttributes"/>
							<xsl:with-param name="includeMeasurements" select="$includeMeasurements"/>
							<xsl:with-param name="includeLimits" select="$includeLimits"/>
						</xsl:apply-templates>
						<xsl:variable name="isLastChildTestGroup" select="local-name(./*[last()])='TestGroup'"/>
							<xsl:if test="not($isLastChildTestGroup) or $testGroupPostActionNode or (count(./*[last()]/tr:Test) + count(./*[last()]/tr:SessionAction) + count(./*[last()]/tr:TestGroup))=0">
							<xsl:value-of select="concat('&lt;/','table>')" disable-output-escaping="yes"/>
						</xsl:if>
						<br/>
						<xsl:call-template name="GetTestGroupNameAndPath">
							<xsl:with-param name="testGroupNameAndPath" select="@name"/>
							<xsl:with-param name="displayPath" select="false()"/>
							<xsl:with-param name="indentation" select="$nextIndentation + $testGroupIndentation"/>
						</xsl:call-template>
					</xsl:if>
					<xsl:if test="$testGroupPostActionNode">
						<xsl:call-template name="GetTestGroupNameAndPath">
							<xsl:with-param name="testGroupNameAndPath" select="$testGroupPostActionNode/@name"/>
							<xsl:with-param name="indentation" select="$nextIndentation + $testGroupIndentation"/>
						</xsl:call-template>
						<xsl:call-template name="AddTableElement">
							<xsl:with-param name="indentation" select="$nextIndentation + $testGroupIndentation"/>
							<xsl:with-param name="reportOptions" select="$reportOptions"/>
							<xsl:with-param name="addDiv" select="false()"/>
						</xsl:call-template>
						<xsl:apply-templates select="$testGroupPostActionNode/tr:Test|$testGroupPostActionNode/tr:TestGroup|$testGroupPostActionNode/tr:SessionAction">
							<xsl:with-param name="reportOptions" select="$reportOptions"/>
							<xsl:with-param name="testGroupIndentation" select="$testGroupIndentation + $nextIndentation - 20"/>
							<xsl:with-param name="includeAttributes" select="$includeAttributes"/>
							<xsl:with-param name="includeMeasurements" select="$includeMeasurements"/>
							<xsl:with-param name="includeLimits" select="$includeLimits"/>
						</xsl:apply-templates>
						<xsl:variable name="isLastChildOfPostActionTestGroup" select="local-name($testGroupPostActionNode/*[last()])='TestGroup'"/>
						<xsl:if test="not($isLastChildOfPostActionTestGroup)">
						<xsl:value-of select="concat('&lt;/','table>')" disable-output-escaping="yes"/>
						</xsl:if>
						<br/>
						<xsl:call-template name="GetTestGroupNameAndPath">
							<xsl:with-param name="testGroupNameAndPath" select="$testGroupPostActionNode/@name"/>
							<xsl:with-param name="displayPath" select="false()"/>
							<xsl:with-param name="indentation" select="$nextIndentation + $testGroupIndentation"/>
						</xsl:call-template>
					</xsl:if>
				</div>
				<xsl:variable name="nextSiblingIndentation">
					<xsl:call-template name="GetIndentationMargin">
						<xsl:with-param name="blockLevel" select="$nextBlockLevel"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:if test="position()!=last()">
					<xsl:choose>
						<xsl:when test="$nextBlockLevel &gt; $currentBlockLevel">
							<xsl:value-of select="concat('&lt;','div ')" disable-output-escaping="yes"/> class="expanded" id="<xsl:value-of select="$uniqueDivId"/>"<xsl:value-of select="'>'" disable-output-escaping="yes"/>
							<xsl:call-template name="PutNDivOpenTags">
								<xsl:with-param name="n" select="$nextBlockLevel - $currentBlockLevel - 1"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$nextBlockLevel &lt; $currentBlockLevel">
							<xsl:value-of select="concat('&lt;/','div>')" disable-output-escaping="yes"/>
							<xsl:call-template name="PutNDivCloseTags">
								<xsl:with-param name="n" select="$currentBlockLevel - $nextBlockLevel - 1"/>
							</xsl:call-template>
						</xsl:when>
					</xsl:choose>
					<xsl:call-template name="AddTableElement">
						<xsl:with-param name="indentation" select="$testGroupIndentation + $nextSiblingIndentation"/>
						<xsl:with-param name="reportOptions" select="$reportOptions"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template match="tr:Outcome">
		<xsl:param name="colors"/>
		<xsl:param name="isBold" select="false()"/>
		<xsl:variable name="statusColor">
			<xsl:call-template name="GetStatusColor">
				<xsl:with-param name="colors" select="$colors"/>
				<xsl:with-param name="status" select="@value"/>
				<xsl:with-param name="qualifier" select="@qualifier"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="outcome">
			<xsl:choose>
				<xsl:when test="@qualifier">
					<xsl:value-of select="@qualifier"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@value"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!--ADD_STATUS-->
		<!--xsl:variable name="cellBackgroundColor">
			<xsl:choose>
				<xsl:when test="$outcome = 'Passed'">#FFFF00</xsl:when>
				<xsl:otherwise>#FFFFFF</xsl:otherwise> 
			</xsl:choose>
		</xsl:variable-->
		<!--td style="color:{$statusColor};background-color:{$cellBackgroundColor};text-align:center;"-->
		<td style="color:{$statusColor};text-align:center;">
			<!--ADD_IMG-->
			<!--xsl:if test="$outcome = 'Failed'">
				<img src = "C:\Images\Failed.jpg"/>
			</xsl:if-->
			<xsl:choose>
				<xsl:when test="$isBold">
					<b>
						<xsl:value-of select="$outcome"/>
					</b>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$outcome"/>
				</xsl:otherwise>
			</xsl:choose>
		</td>
	</xsl:template>
	<xsl:template match="tr:ActionOutcome">
		<xsl:param name="colors"/>
		<xsl:param name="isBold"/>
		<xsl:variable name="statusColor">
			<xsl:call-template name="GetStatusColor">
				<xsl:with-param name="colors" select="$colors"/>
				<xsl:with-param name="status" select="@value"/>
				<xsl:with-param name="qualifier" select="@qualifier"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="outcome">
			<xsl:choose>
				<xsl:when test="@qualifier">
					<xsl:value-of select="@qualifier"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@value"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!--ADD_STATUS-->
		<!--xsl:variable name="cellBackgroundColor">
			<xsl:choose>
				<xsl:when test="$outcome = 'Passed'">#FFFF00</xsl:when>
				<xsl:otherwise>#FFFFFF</xsl:otherwise> 
			</xsl:choose>
		</xsl:variable-->
		<!--td style="color:{$statusColor};background-color:{$cellBackgroundColor};text-align:center;"-->
		<td style="color:{$statusColor};text-align:center;">
			<!--ADD_IMG-->
			<!--xsl:if test="$outcome = 'Failed'">
				<img src = "C:\Images\Failed.jpg"/>
			</xsl:if-->
			<xsl:choose>
				<xsl:when test="$isBold">
					<b>
						<xsl:value-of select="$outcome"/>
					</b>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$outcome"/>
				</xsl:otherwise>
			</xsl:choose>
		</td>
	</xsl:template>
	<xsl:template match="tr:Data">
		<xsl:param name="isSessionAction" select="false()"/>
		<xsl:param name="parentNode" select="''"/>
		<xsl:param name="objectPath" select="''"/>
		<xsl:param name="numSpaces" select="2"/>
		<xsl:param name="includeAttributes"/>
		<xsl:param name="includeMeasurements"/>
		<xsl:param name="includeLimits"/>
		<xsl:choose>
			<xsl:when test="c:Collection">
				<xsl:choose>
					<xsl:when test="$isSessionAction">
						<xsl:apply-templates select="c:Collection/c:Item[@name!='ReportText' and (not(contains(@name,'.Attributes')))]">
							<xsl:with-param name="numSpaces" select="$numSpaces"/>
							<xsl:with-param name="parentNode" select="$parentNode"/>
							<xsl:with-param name="objectPath" select="'TestResult'"/>
							<xsl:with-param name="includeAttributes" select="$includeAttributes"/>
							<xsl:with-param name="includeMeasurements" select="$includeMeasurements"/>
							<xsl:with-param name="includeLimits" select="$includeLimits"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="dataValue">
							<xsl:apply-templates select="c:Collection">
								<xsl:with-param name="numSpaces" select="$numSpaces + 1"/>
								<xsl:with-param name="parentNode" select="$parentNode"/>
								<xsl:with-param name="objectPath" select="$objectPath"/>
								<xsl:with-param name="includeAttributes" select="$includeAttributes"/>
								<xsl:with-param name="includeMeasurements" select="$includeMeasurements"/>
								<xsl:with-param name="includeLimits" select="$includeLimits"/>
							</xsl:apply-templates>
						</xsl:variable>
						<xsl:variable name="shouldInclude">
							<xsl:choose>
								<xsl:when test="$dataValue != ''">
									<xsl:value-of select="true()"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:for-each select="c:Collection">
										<xsl:call-template name="GetIsIncludeInReport"/>
									</xsl:for-each>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:if test="string($shouldInclude) = string(true()) and $dataValue!=''">
							<xsl:if test="not(c:Collection/@xsi:type and c:Collection/@xsi:type ='ts:NI_TDMSReference')">
								<xsl:variable name="visibility">
									<xsl:choose>
										<xsl:when test="$numSpaces > 2">
											<xsl:value-of select="'hidden'"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="'visible'"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<tr class="{$visibility} level:{$numSpaces} state:0">
									<xsl:variable name="paddingLeft">
										<xsl:choose>
											<xsl:when test="$dataValue != ''">
												<xsl:value-of select="$numSpaces * $gSingleSpaceValue - $gImageWidthValue"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$numSpaces * $gSingleSpaceValue"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<td colspan="{$gHeadingSpan}" style="vertical-align:top;padding-left:{$paddingLeft}px;">
										<xsl:if test="$dataValue != ''">
											<img alt="" src="{$gPlusImage}" onclick="expandCollapseTR(event)" class="trExpanded"/>
										</xsl:if>
										<xsl:value-of select="../@name"/>:
								</td>
								</tr>
							</xsl:if>
							<xsl:if test="$dataValue != ''">
								<xsl:copy-of select="$dataValue"/>
							</xsl:if>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="dataValue">
					<xsl:apply-templates select="c:IndexedArray|c:Datum">
						<xsl:with-param name="parentNode" select="$parentNode"/>
						<xsl:with-param name="objectPath" select="$objectPath"/>
						<xsl:with-param name="numSpaces" select="$numSpaces + 1"/>
						<xsl:with-param name="includeAttributes" select="$includeAttributes"/>
						<xsl:with-param name="includeMeasurements" select="$includeMeasurements"/>
						<xsl:with-param name="includeLimits" select="$includeLimits"/>
					</xsl:apply-templates>
				</xsl:variable>
				<xsl:variable name="shouldInclude">
					<xsl:choose>
						<xsl:when test="$dataValue != ''">
							<xsl:value-of select="true()"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="c:IndexedArray">
									<xsl:for-each select="c:IndexedArray">
										<xsl:call-template name="GetIsIncludeInReport"/>
									</xsl:for-each>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="false()"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:if test="string($shouldInclude) = string(true()) and ($dataValue!='' or count(c:IndexedArray/ts:Element)=0)">
					<xsl:variable name="dataAttribute">
						<xsl:choose>
							<xsl:when test="$parentNode!=''">
								<xsl:call-template name="ProcessAttributes">
									<xsl:with-param name="node" select="$parentNode"/>
									<xsl:with-param name="objectPath" select="$objectPath"/>
									<xsl:with-param name="numSpaces" select="$numSpaces + 1"/>
									<xsl:with-param name="includeAttributes" select="$includeAttributes"/>
									<xsl:with-param name="includeMeasurements" select="$includeMeasurements"/>
									<xsl:with-param name="includeLimits" select="$includeLimits"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="''"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="hasAttributes" select="$dataAttribute!=''"/>
					<xsl:variable name="paddingLeft">
						<xsl:choose>
							<xsl:when test="$hasAttributes">
								<xsl:value-of select="$gSingleSpaceValue * $numSpaces - $gImageWidthValue"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$gSingleSpaceValue * $numSpaces"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="visibility">
						<xsl:choose>
							<xsl:when test="$numSpaces > 2">
								<xsl:value-of select="'hidden'"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="'visible'"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="state">
						<xsl:choose>
							<xsl:when test="$hasAttributes">
								<xsl:value-of select="'state:0'"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="'state:1'"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<tr class="{$visibility} level:{$numSpaces} {$state}">
						<td style="vertical-align:top;padding-left:{$paddingLeft}px;">
							<xsl:if test="$hasAttributes">
								<img alt="" src="{$gPlusImage}" onclick="expandCollapseTR(event)" class="trExpanded"/>
							</xsl:if>
							<xsl:value-of select="../@name"/>
							<xsl:if test="c:IndexedArray">
								<xsl:call-template name="GetArraySizeString">
									<xsl:with-param name="dimensionString" select="translate(substring-after(c:IndexedArray/@dimensions,'['),']',',')"/>
									<xsl:with-param name="firstElement" select="translate(substring-after(c:IndexedArray/@lowerBounds,'['),'][',',')"/>
									<xsl:with-param name="lastElement" select="translate(substring-after(c:IndexedArray/@upperBounds,'['),'][',',')"/>
								</xsl:call-template>
							</xsl:if>:
						</td>
						<td colspan="{$gValueSpan}">
							<xsl:choose>
								<xsl:when test="$dataValue != ''">
									<xsl:copy-of select="$dataValue"/>
								</xsl:when>
								<xsl:otherwise>
									<span style="visibility:hidden;"><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text></span>
								</xsl:otherwise>
							</xsl:choose>
						</td>
					</tr>
					<xsl:copy-of select="$dataAttribute"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="tr:Parameters">
		<xsl:param name="includeAttributes"/>
		<xsl:param name="includeMeasurements"/>
		<xsl:param name="includeLimits"/>
		<xsl:param name="isLoopIndex" select="false()"/>
		<xsl:variable name="dataValue">
			<xsl:apply-templates select="tr:Parameter">
				<xsl:with-param name="includeAttributes" select="$includeAttributes"/>
				<xsl:with-param name="includeMeasurements" select="$includeMeasurements"/>
				<xsl:with-param name="includeLimits" select="$includeLimits"/>
			</xsl:apply-templates>
		</xsl:variable>
		<xsl:if test="$dataValue!=''">
			<tr class="visible level:1 state:1">
				<xsl:choose>
					<xsl:when test="$isLoopIndex"><td colspan="{$gHeadingSpan}" style="padding-left:{number($gSingleSpaceValue) + 9}px;">Parameters</td></xsl:when>
					<xsl:otherwise><td colspan="{$gHeadingSpan}" style="padding-left:{$gSingleSpaceValue}px;">Parameters</td></xsl:otherwise>
				</xsl:choose>
			</tr>
			<xsl:copy-of select="$dataValue"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="tr:Parameter">
		<xsl:param name="includeAttributes"/>
		<xsl:param name="includeMeasurements"/>
		<xsl:param name="includeLimits"/>
		<xsl:apply-templates select="tr:Data">
			<xsl:with-param name="parentNode" select="../.."/>
			<xsl:with-param name="objectPath" select="concat('Parameter.',@name)"/>
			<xsl:with-param name="numSpaces" select="2"/>
			<xsl:with-param name="includeAttributes" select="$includeAttributes"/>
			<xsl:with-param name="includeMeasurements" select="$includeMeasurements"/>
			<xsl:with-param name="includeLimits" select="$includeLimits"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="tr:TestResult">
		<xsl:param name="skipMeasurement" select="true()"/>
		<xsl:param name="numSpaces" select="0"/>
		<xsl:param name="includeAttributes"/>
		<xsl:param name="includeMeasurements"/>
		<xsl:param name="includeLimits"/>
		<xsl:param name="colors"/>
		<xsl:if test="count(tr:Outcome)=0 or not($skipMeasurement)">
			<xsl:choose>
				<xsl:when test="$skipMeasurement">
					<xsl:for-each select="tr:TestData|tr:TestLimits">
						<xsl:apply-templates select=".">
							<xsl:with-param name="parentNode" select="../.."/>
							<xsl:with-param name="objectPath" select="concat('TestResult.',../@name)"/>
							<xsl:with-param name="numSpaces" select="$numSpaces"/>
							<xsl:with-param name="includeAttributes" select="$includeAttributes"/>
							<xsl:with-param name="includeMeasurements" select="$includeMeasurements"/>
							<xsl:with-param name="includeLimits" select="$includeLimits"/>
						</xsl:apply-templates>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<tr>
						<td style="padding-left:{$gSingleSpaceValue * 2}px">
							<xsl:value-of select="@name"/>
						</td>
						<td style="text-align:center;">
							<xsl:variable name="statusColor">
								<xsl:call-template name="GetStatusColor">
									<xsl:with-param name="colors" select="$colors"/>
									<xsl:with-param name="status" select="tr:Outcome/@value"/>
									<xsl:with-param name="qualifier" select="tr:Outcome/@qualifier"/>
								</xsl:call-template>
							</xsl:variable>
							<span style="color:{$statusColor};">
								<xsl:choose>
									<xsl:when test="tr:Outcome/@qualifier">
										<xsl:value-of select="tr:Outcome/@qualifier"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="tr:Outcome/@value"/>
									</xsl:otherwise>
								</xsl:choose>
							</span>
						</td>
						<td style="text-align:right;">
							<xsl:choose>
								<xsl:when test="$includeMeasurements">
										<xsl:apply-templates select="tr:TestData/c:Datum">
										<xsl:with-param name="includeAttributes" select="$includeAttributes"/>
										<xsl:with-param name="includeMeasurements" select="$includeMeasurements"/>
										<xsl:with-param name="includeLimits" select="$includeLimits"/>	
										<xsl:with-param name="addProperty" select="true()"/>
									</xsl:apply-templates>
								</xsl:when>
							</xsl:choose>						
						</td>
						<xsl:apply-templates select="tr:TestLimits">
							<xsl:with-param name="numSpaces" select="2"/>
							<xsl:with-param name="parentNode" select=".."/>
							<xsl:with-param name="objectPath" select="@name"/>
							<xsl:with-param name="skipMeasurement" select="$skipMeasurement"/>
							<xsl:with-param name="includeAttributes" select="$includeAttributes"/>
							<xsl:with-param name="includeMeasurements" select="$includeMeasurements"/>
							<xsl:with-param name="includeLimits" select="$includeLimits"/>
						</xsl:apply-templates>
						<xsl:if test="tr:Extension/ts:TSLimitProperties/ts:IsComparisonTypeLog/@value = 'true'">
							<xsl:call-template name="LogNoComparison"/>
						</xsl:if>
					</tr>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<xsl:template match="tr:TestResult[(@name='Numeric' or @name='String') and (count(tr:TestLimits)=1 or count(tr:Extension/ts:TSLimitProperties/ts:IsComparisonTypeLog)=1)]">
		<xsl:param name="includeAttributes"/>
		<xsl:param name="includeMeasurements"/>
		<xsl:param name="includeLimits"/>
		<xsl:variable name="alignValue">
			<xsl:choose>
				<xsl:when test="tr:TestData/c:Datum[@xsi:type='c:string'] or tr:TestData/c:Datum[@xsi:type='ts:TS_string']">left</xsl:when>
				<xsl:otherwise>right</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<td style="text-align:{$alignValue};">
			<xsl:choose>
				<xsl:when test="$includeMeasurements">
					<xsl:apply-templates select="tr:TestData/c:Datum">
						<xsl:with-param name="includeAttributes" select="$includeAttributes"/>
						<xsl:with-param name="includeMeasurements" select="$includeMeasurements"/>
						<xsl:with-param name="includeLimits" select="$includeLimits"/>	
						<xsl:with-param name="addProperty" select="true()"/>
					</xsl:apply-templates>
				</xsl:when>
			</xsl:choose>
		</td>
		<xsl:apply-templates select="tr:TestLimits">
			<xsl:with-param name="includeAttributes" select="$includeAttributes"/>
			<xsl:with-param name="includeMeasurements" select="$includeMeasurements"/>
			<xsl:with-param name="includeLimits" select="$includeLimits"/>							
		</xsl:apply-templates>
		<xsl:if test="tr:Extension/ts:TSLimitProperties/ts:IsComparisonTypeLog/@value='true'">
			<xsl:call-template name="LogNoComparison"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="tr:TestResult[@name='ReportText']">
		<xsl:param name="bgColor"/>
		<tr>
			<td style="color:{$bgColor};padding-left:{$gSingleSpaceValue}px;">
				ReportText:
			</td>
			<td colspan="{$gValueSpan}" style="color:{$bgColor}">
				<xsl:if test="tr:TestData/c:Datum/c:Value">
					<xsl:call-template name="ReplaceNewLineWithBreak">
						<xsl:with-param name="inputString" select="tr:TestData/c:Datum/c:Value"/>
					</xsl:call-template>
				</xsl:if>
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="tr:TestData">
		<xsl:param name="numSpaces" select="0"/>
		<xsl:param name="parentNode"/>
		<xsl:param name="objectPath" select="''"/>
		<xsl:param name="includeAttributes"/>
		<xsl:param name="includeMeasurements"/>
		<xsl:param name="includeLimits"/>
		<xsl:choose>
			<xsl:when test="c:Collection">
				<xsl:variable name="dataValue">
					<xsl:apply-templates select="c:Collection">
						<xsl:with-param name="numSpaces" select="$numSpaces + 1"/>
						<xsl:with-param name="parentNode" select="$parentNode"/>
						<xsl:with-param name="objectPath" select="$objectPath"/>
						<xsl:with-param name="includeAttributes" select="$includeAttributes"/>
						<xsl:with-param name="includeMeasurements" select="$includeMeasurements"/>
						<xsl:with-param name="includeLimits" select="$includeLimits"/>
					</xsl:apply-templates>
				</xsl:variable>
				<xsl:variable name="shouldInclude">
					<xsl:choose>
						<xsl:when test="$dataValue != ''">
							<xsl:value-of select="true()"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:for-each select="c:Collection">
								<xsl:call-template name="GetIsIncludeInReport"/>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:if test="string($shouldInclude) = string(true()) and $dataValue!=''">
					<xsl:if test="not(c:Collection/@xsi:type and c:Collection/@xsi:type ='ts:NI_TDMSReference')">
						<xsl:variable name="visibility">
							<xsl:choose>
								<xsl:when test="$numSpaces > 2">
									<xsl:value-of select="'hidden'"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="'visible'"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<tr class="{$visibility} level:{$numSpaces} state:0">
							<xsl:variable name="indentation">
								<xsl:choose>
									<xsl:when test="$dataValue != '' and $dataValue!=' '"><xsl:value-of select="$gSingleSpaceValue * $numSpaces - $gImageWidthValue"/></xsl:when>
									<xsl:otherwise><xsl:value-of select="$gSingleSpaceValue * $numSpaces"/></xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<td style="vertical-align:top;padding-left:{$indentation}px;" colspan="{$gHeadingSpan}">
								<xsl:if test="$dataValue != '' and $dataValue!=' '">
								<img alt="" src="{$gPlusImage}" onclick="expandCollapseTR(event)" class="trExpanded"/>
								</xsl:if>
								<xsl:value-of select="../@name"/>:</td>
						</tr>
					</xsl:if>
					<xsl:if test="$dataValue != ''">
						<xsl:copy-of select="$dataValue"/>
					</xsl:if>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="dataValue">
					<xsl:apply-templates select="c:IndexedArray|c:Datum">
						<xsl:with-param name="parentNode" select="$parentNode"/>
						<xsl:with-param name="objectPath" select="$objectPath"/>
						<xsl:with-param name="numSpaces" select="$numSpaces + 1"/>
						<xsl:with-param name="includeAttributes" select="$includeAttributes"/>
						<xsl:with-param name="includeMeasurements" select="$includeMeasurements"/>
						<xsl:with-param name="includeLimits" select="$includeLimits"/>
					</xsl:apply-templates>
				</xsl:variable>
				<xsl:variable name="shouldInclude">
					<xsl:choose>
						<xsl:when test="$dataValue != ''">
							<xsl:value-of select="true()"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="c:IndexedArray">
									<xsl:for-each select="c:IndexedArray">
										<xsl:call-template name="GetIsIncludeInReport"/>
									</xsl:for-each>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="false()"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:if test="string($shouldInclude) = string(true()) and ($dataValue!='' or count(c:IndexedArray/ts:Element)=0)">
					<xsl:variable name="dataAttribute">
						<xsl:choose>
							<xsl:when test="$parentNode!=''">
								<xsl:call-template name="ProcessAttributes">
									<xsl:with-param name="node" select="$parentNode"/>
									<xsl:with-param name="objectPath" select="$objectPath"/>
									<xsl:with-param name="numSpaces" select="$numSpaces + 1"/>
									<xsl:with-param name="includeAttributes" select="$includeAttributes"/>
									<xsl:with-param name="includeMeasurements" select="$includeMeasurements"/>
									<xsl:with-param name="includeLimits" select="$includeLimits"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="''"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="hasAttributes" select="$dataAttribute!=''"/>
					<xsl:variable name="paddingLeft">
						<xsl:choose>
							<xsl:when test="$hasAttributes">
								<xsl:value-of select="$gSingleSpaceValue * $numSpaces - $gImageWidthValue"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$gSingleSpaceValue * $numSpaces"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="visibility">
						<xsl:choose>
							<xsl:when test="$numSpaces > 2">
								<xsl:value-of select="'hidden'"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="'visible'"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="state">
						<xsl:choose>
							<xsl:when test="$hasAttributes">
								<xsl:value-of select="'state:0'"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="'state:1'"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<tr class="{$visibility} level:{$numSpaces} {$state}">
						<td style="vertical-align:top;  padding-left:{$paddingLeft}px;">
							<xsl:if test="$hasAttributes">
								<img alt="" src="{$gPlusImage}" onclick="expandCollapseTR(event)" class="trExpanded"/>
							</xsl:if>
							<xsl:value-of select="../@name"/>
							<xsl:if test="c:IndexedArray">
								<xsl:call-template name="GetArraySizeString">
									<xsl:with-param name="dimensionString" select="translate(substring-after(c:IndexedArray/@dimensions,'['),']',',')"/>
									<xsl:with-param name="firstElement" select="translate(substring-after(c:IndexedArray/@lowerBounds,'['),'][',',')"/>
									<xsl:with-param name="lastElement" select="translate(substring-after(c:IndexedArray/@upperBounds,'['),'][',',')"/>
								</xsl:call-template>
							</xsl:if>:</td>
						<td colspan="{$gValueSpan}">
							<xsl:choose>
								<xsl:when test="$dataValue != ''">
									<xsl:copy-of select="$dataValue"/>
								</xsl:when>
								<xsl:otherwise>
									<span style="visibility:hidden;"><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text></span>
								</xsl:otherwise>
							</xsl:choose>
						</td>
					</tr>
					<xsl:copy-of select="$dataAttribute"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="tr:TestLimits">
		<xsl:param name="numSpaces" select="0"/>
		<xsl:param name="parentNode"/>
		<xsl:param name="objectPath" select="''"/>
		<xsl:param name="skipMeasurement" select="true()"/>
		<xsl:param name="includeAttributes"/>
		<xsl:param name="includeMeasurements"/>
		<xsl:param name="includeLimits"/>
		<xsl:choose>
			<xsl:when test="$includeLimits">
				<xsl:apply-templates select="tr:Limits">
				<xsl:with-param name="numSpaces" select="$numSpaces"/>
				<xsl:with-param name="parentNode" select="$parentNode"/>
				<xsl:with-param name="objectPath" select="$objectPath"/>
				<xsl:with-param name="skipMeasurement" select="$skipMeasurement"/>
			</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<td/>
				<td/>
				<td/>
				<td/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="tr:Limits">
		<xsl:param name="numSpaces" select="0"/>
		<xsl:param name="skipMeasurement" select="true()"/>
		<xsl:param name="parentNode"/>
		<xsl:param name="objectPath" select="''"/>
		<xsl:variable name="unit">
			<xsl:choose>
				<xsl:when test="c:Expected|c:SingleLimit|c:LimitPair">
					<xsl:call-template name="GetUnit">
						<xsl:with-param name="node" select="c:Expected/c:Datum|c:SingleLimit/c:Datum|c:LimitPair/c:Limit/c:Datum"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="GetUnit">
						<xsl:with-param name="node" select="../../tr:TestData/c:Datum"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<td>
			<xsl:value-of select="$unit"/>
		</td>
		<xsl:apply-templates select="c:Expected|c:SingleLimit|c:LimitPair">
			<xsl:with-param name="numSpaces" select="$numSpaces + 1"/>
			<xsl:with-param name="parentNode" select="$parentNode"/>
			<xsl:with-param name="objectPath" select="concat($objectPath,'.','Limits')"/>
			<xsl:with-param name="skipMeasurement" select="$skipMeasurement"/>
			<xsl:with-param name="unit" select="$unit"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="c:Expected">
		<xsl:param name="numSpaces"/>
		<xsl:param name="parentNode"/>
		<xsl:param name="objectPath" select="''"/>
		<xsl:param name="skipMeasurement" select="true()"/>
		<xsl:variable name="alignValue">
			<xsl:choose>
				<xsl:when test="c:Datum[@xsi:type='c:string']">left</xsl:when>
				<xsl:otherwise>right</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<td style="text-align:{$alignValue};">
			<xsl:apply-templates select="c:Datum">
				<xsl:with-param name="parentNode" select="$parentNode"/>
				<xsl:with-param name="numSpaces" select="$numSpaces + 1"/>
				<xsl:with-param name="addProperty" select="true()"/>
			</xsl:apply-templates>
		</td>
		<td/>
		<xsl:variable name="comparisonType">
			<xsl:choose>
				<xsl:when test="c:Datum/@xsi:type='ts:TS_string'">
					<xsl:choose>
						<xsl:when test="@comparator='EQ'">CaseSensitive</xsl:when>
						<xsl:otherwise>IgnoreCase</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="GetComparisonTypeText">
						<xsl:with-param name="compText" select="@comparator"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<td style="text-align:center;">
			<xsl:value-of select="$comparisonType"/>
		</td>
	</xsl:template>
	<xsl:template match="c:SingleLimit">
		<xsl:param name="numSpaces"/>
		<xsl:param name="parentNode"/>
		<xsl:param name="objectPath" select="''"/>
		<xsl:param name="skipMeasurement" select="true()"/>
		<td style="text-align:right;">
			<xsl:apply-templates select="c:Datum">
				<xsl:with-param name="parentNode" select="$parentNode"/>
				<xsl:with-param name="objectPath" select="concat($objectPath,'.','Low')"/>
				<xsl:with-param name="numSpaces" select="$numSpaces + 1"/>
				<xsl:with-param name="addProperty" select="true()"/>
			</xsl:apply-templates>
		</td>
		<td/>
		<td style="text-align:center;">
			<xsl:call-template name="GetComparisonTypeText">
				<xsl:with-param name="compText" select="@comparator"/>
			</xsl:call-template>
		</td>
	</xsl:template>
	<xsl:template match="c:LimitPair">
		<xsl:param name="numSpaces"/>
		<xsl:param name="parentNode"/>
		<xsl:param name="objectPath" select="''"/>
		<xsl:param name="skipMeasurement" select="true()"/>
		<xsl:apply-templates select="c:Limit">
			<xsl:with-param name="numSpaces" select="$numSpaces"/>
			<xsl:with-param name="parentNode" select="$parentNode"/>
			<xsl:with-param name="objectPath" select="$objectPath"/>
		</xsl:apply-templates>
		<td style="text-align:center;">
			<xsl:call-template name="GetComparisonTypeText">
				<xsl:with-param name="compText" select="concat(c:Limit[1]/@comparator, c:Limit[2]/@comparator)"/>
			</xsl:call-template>
		</td>
	</xsl:template>
	<xsl:template match="c:Limit">
		<xsl:param name="numSpaces"/>
		<xsl:param name="parentNode"/>
		<xsl:param name="objectPath" select="''"/>
		<td style="text-align:right;">
			<xsl:apply-templates select="c:Datum">
				<xsl:with-param name="parentNode" select="$parentNode"/>
				<xsl:with-param name="objectPath" select="''"/>
				<xsl:with-param name="numSpaces" select="$numSpaces + 1"/>
				<xsl:with-param name="addProperty" select="true()"/>
			</xsl:apply-templates>
		</td>
	</xsl:template>
	<xsl:template match="c:Datum">
		<xsl:param name="parentNode" select="''"/>
		<xsl:param name="objectPath" select="''"/>
		<xsl:param name="numSpaces" select="2"/>
		<xsl:param name="includeAttributes"/>
		<xsl:param name="includeMeasurements"/>
		<xsl:param name="includeLimits"/>
		<xsl:param name="addProperty" select="false()"/>
		<xsl:variable name="dataValue">
			<xsl:call-template name="GetFlaggedDatumValue">
				<xsl:with-param name="includeAttributes" select="$includeAttributes"/>
				<xsl:with-param name="includeMeasurements" select="$includeMeasurements"/>
				<xsl:with-param name="includeLimits" select="$includeLimits"/>
				<xsl:with-param name="addProperty" select="$addProperty"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="@xsi:type='ts:NI_HyperlinkPath'">
				<xsl:variable name="hyperlinkValue">
					<xsl:variable name="hyperLinkAttributeNodesName">
						<xsl:value-of select="concat($objectPath,'.Attributes')"/>
					</xsl:variable>
					<xsl:choose>
						<xsl:when test="$parentNode/tr:Data/c:Collection/c:Item[@name=$hyperLinkAttributeNodesName][1]/c:Collection/c:Item[@name='TestStand']/c:Collection/c:Item[@name='Hyperlink']/c:Datum">
							<xsl:value-of select="$parentNode/tr:Data/c:Collection/c:Item[@name=$hyperLinkAttributeNodesName][1]/c:Collection/c:Item[@name='TestStand']/c:Collection/c:Item[@name='Hyperlink']/c:Datum/@value"/>
						</xsl:when>
						<xsl:when test="$parentNode/c:Collection/c:Item[@name=$hyperLinkAttributeNodesName][1]/c:Collection/c:Item[@name='TestStand']/c:Collection/c:Item[@name='Hyperlink']/c:Datum">
							<xsl:value-of select="$parentNode/c:Collection/c:Item[@name=$hyperLinkAttributeNodesName][1]/c:Collection/c:Item[@name='TestStand']/c:Collection/c:Item[@name='Hyperlink']/c:Datum/@value"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="'false'"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="isHyperLink" select="$hyperlinkValue='true' and ./c:Value != ''"/>
				<xsl:choose>
					<xsl:when test="$isHyperLink">
						<a href="{$dataValue}">
							<xsl:value-of select="$dataValue"/>
						</a>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$dataValue"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$dataValue"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="c:Collection">
		<xsl:param name="numSpaces" select="1"/>
		<xsl:param name="parentNode" select="''"/>
		<xsl:param name="objectPath" select="''"/>
		<xsl:param name="includeAttributes"/>
		<xsl:param name="includeMeasurements"/>
		<xsl:param name="includeLimits"/>
		<xsl:param name="addProperty" select="false()"/>
		<xsl:param name="putAsFlatData" select="false()"/>
		<xsl:variable name="shouldAddProperty">
			<xsl:choose>
				<xsl:when test="@flags">
					<xsl:variable name="shouldIncludeInReport">
						<xsl:call-template name="GetIsIncludeInReport"/>
					</xsl:variable>
					<xsl:variable name="isLimit">
						<xsl:call-template name="GetIsLimit"/>
					</xsl:variable>
					<xsl:variable name="isMeasurement">
						<xsl:call-template name="GetIsMeasurement"/>
					</xsl:variable>
					<xsl:choose>
						<xsl:when test="($shouldIncludeInReport='true' or $addProperty) and ($isLimit='false' or ($isLimit='true' and $includeLimits)) and ($isMeasurement='false' or ($isMeasurement='true' and $includeMeasurements))">
							<xsl:value-of select="true()"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="false()"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="false()"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="$parentNode!='' and $shouldAddProperty='true'">
			<xsl:call-template name="ProcessAttributes">
				<xsl:with-param name="node" select="$parentNode"/>
				<xsl:with-param name="objectPath" select="$objectPath"/>
				<xsl:with-param name="numSpaces" select="$numSpaces"/>
				<xsl:with-param name="includeAttributes" select="$includeAttributes"/>
				<xsl:with-param name="includeMeasurements" select="$includeMeasurements"/>
				<xsl:with-param name="includeLimits" select="$includeLimits"/>
				<xsl:with-param name="putAsFlatData" select="$putAsFlatData"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:apply-templates select="c:Item">
			<xsl:with-param name="numSpaces" select="$numSpaces"/>
			<xsl:with-param name="parentNode" select="$parentNode"/>
			<xsl:with-param name="objectPath" select="$objectPath"/>
			<xsl:with-param name="includeAttributes" select="$includeAttributes"/>
			<xsl:with-param name="includeMeasurements" select="$includeMeasurements"/>
			<xsl:with-param name="includeLimits" select="$includeLimits"/>
			<xsl:with-param name="addProperty" select="$shouldAddProperty='true'"/>
			<xsl:with-param name="putAsFlatData" select="$putAsFlatData"/>
		</xsl:apply-templates>
		<xsl:if test="$shouldAddProperty='true' and count(c:Item)=0">
			<xsl:text> </xsl:text>
		</xsl:if>
	</xsl:template>
	<xsl:template match="c:Collection[@xsi:type='ts:NI_TDMSReference']">
		<xsl:param name="numSpaces" select="0"/>
		<xsl:param name="parentNode" select="''"/>
		<xsl:param name="objectPath" select="''"/>
		<xsl:param name="includeAttributes"/>
		<xsl:param name="includeMeasurements"/>
		<xsl:param name="includeLimits"/>
		<xsl:param name="addProperty" select="false()"/>
		<xsl:param name="putAsFlatData" select="false()"/>
		<xsl:variable name="shouldAddProperty">
			<xsl:choose>
				<xsl:when test="@flags">
					<xsl:variable name="shouldIncludeInReport">
						<xsl:call-template name="GetIsIncludeInReport"/>
					</xsl:variable>
					<xsl:variable name="isLimit">
						<xsl:call-template name="GetIsLimit"/>
					</xsl:variable>
					<xsl:variable name="isMeasurement">
						<xsl:call-template name="GetIsMeasurement"/>
					</xsl:variable>
					<xsl:choose>
						<xsl:when test="($shouldIncludeInReport='true' or $addProperty) and ($isLimit='false' or ($isLimit='true' and $includeLimits)) and ($isMeasurement='false' or ($isMeasurement='true' and $includeMeasurements))">
							<xsl:value-of select="true()"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="false()"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="false()"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="filePath" select="c:Item[@name='File']/c:Datum/c:Value"/>
		<xsl:variable name="pluginValue" select="c:Item[@name='Plugin']/c:Datum/c:Value"/>
		<xsl:variable name="channelGroupValue" select="c:Item[@name='ChannelGroup']/c:Datum/c:Value"/>
		<xsl:variable name="channelValue" select="c:Item[@name='Channel']/c:Datum/c:Value"/>
		<xsl:variable name="hyperlinkValue">
			<xsl:choose>
				<xsl:when test="$parentNode!=''">
					<xsl:variable name="hyperLinkAttributeNodesName">
						<xsl:value-of select="concat($objectPath,'.File.Attributes')"/>
					</xsl:variable>
					<xsl:choose>
						<xsl:when test="$parentNode/tr:Data/c:Collection/c:Item[@name=$hyperLinkAttributeNodesName][1]/c:Collection/c:Item[@name='TestStand']/c:Collection/c:Item[@name='Hyperlink']/c:Datum">
							<xsl:value-of select="$parentNode/tr:Data/c:Collection/c:Item[@name=$hyperLinkAttributeNodesName][1]/c:Collection/c:Item[@name='TestStand']/c:Collection/c:Item[@name='Hyperlink']/c:Datum/@value"/>
						</xsl:when>
						<xsl:when test="$parentNode/c:Collection/c:Item[@name=$hyperLinkAttributeNodesName][1]/c:Collection/c:Item[@name='TestStand']/c:Collection/c:Item[@name='Hyperlink']/c:Datum">
							<xsl:value-of select="$parentNode/c:Collection/c:Item[@name=$hyperLinkAttributeNodesName][1]/c:Collection/c:Item[@name='TestStand']/c:Collection/c:Item[@name='Hyperlink']/c:Datum/@value"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="'false'"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'false'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="isHyperLink" select="$hyperlinkValue='true' and $filePath != ''"/>
		<xsl:choose>
			<xsl:when test="$pluginValue!='' or $channelGroupValue!='' or $channelValue!=''">
				<!-- Display As Container-->
				<xsl:variable name="visibility">
					<xsl:choose>
						<xsl:when test="($numSpaces - 1) > 2">
							<xsl:value-of select="'hidden'"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="'visible'"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:if test="$putAsFlatData=false()">
					<tr class="{$visibility} level:{$numSpaces - 1} state:0">
						<td colspan="{$gHeadingSpan}" style="vertical-align:top;padding-left:{$gSingleSpaceValue * ($numSpaces - 1) - $gImageWidthValue}px;">
							<img alt="" src="{$gPlusImage}" onclick="expandCollapseTR(event)" class="trExpanded"/>
							<xsl:choose>
								<xsl:when test="../@name">
									<xsl:value-of select="../@name"/>:</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="../../@name"/>:</xsl:otherwise>
							</xsl:choose>
						</td>
					</tr>
				</xsl:if>
				<xsl:if test="$parentNode!=''">
					<xsl:call-template name="ProcessAttributes">
						<xsl:with-param name="node" select="$parentNode"/>
						<xsl:with-param name="objectPath" select="$objectPath"/>
						<xsl:with-param name="numSpaces" select="$numSpaces"/>
						<xsl:with-param name="includeAttributes" select="$includeAttributes"/>
						<xsl:with-param name="includeMeasurements" select="$includeMeasurements"/>
						<xsl:with-param name="includeLimits" select="$includeLimits"/>
						<xsl:with-param name="putAsFlatData" select="$putAsFlatData"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:apply-templates select="c:Item[@name='File']">
					<xsl:with-param name="numSpaces" select="$numSpaces"/>
					<xsl:with-param name="parentNode" select="$parentNode"/>
					<xsl:with-param name="objectPath" select="$objectPath"/>
					<xsl:with-param name="includeAttributes" select="$includeAttributes"/>
					<xsl:with-param name="includeMeasurements" select="$includeMeasurements"/>
					<xsl:with-param name="includeLimits" select="$includeLimits"/>
					<xsl:with-param name="addProperty" select="$shouldAddProperty='true'"/>
					<xsl:with-param name="putAsFlatData" select="$putAsFlatData"/>
				</xsl:apply-templates>		
				<xsl:if test="$pluginValue!=''">
					<xsl:apply-templates select="c:Item[@name='Plugin']">
						<xsl:with-param name="numSpaces" select="$numSpaces"/>
						<xsl:with-param name="parentNode" select="$parentNode"/>
						<xsl:with-param name="objectPath" select="$objectPath"/>
						<xsl:with-param name="includeAttributes" select="$includeAttributes"/>
						<xsl:with-param name="includeMeasurements" select="$includeMeasurements"/>
						<xsl:with-param name="includeLimits" select="$includeLimits"/>
						<xsl:with-param name="addProperty" select="$shouldAddProperty='true'"/>
						<xsl:with-param name="putAsFlatData" select="$putAsFlatData"/>
					</xsl:apply-templates>
				</xsl:if>
				<xsl:if test="$channelGroupValue!=''">
					<xsl:apply-templates select="c:Item[@name='ChannelGroup']">
						<xsl:with-param name="numSpaces" select="$numSpaces"/>
						<xsl:with-param name="parentNode" select="$parentNode"/>
						<xsl:with-param name="objectPath" select="$objectPath"/>
						<xsl:with-param name="includeAttributes" select="$includeAttributes"/>
						<xsl:with-param name="includeMeasurements" select="$includeMeasurements"/>
						<xsl:with-param name="includeLimits" select="$includeLimits"/>
						<xsl:with-param name="addProperty" select="$shouldAddProperty='true'"/>
						<xsl:with-param name="putAsFlatData" select="$putAsFlatData"/>
					</xsl:apply-templates>
				</xsl:if>
				<xsl:if test="$channelValue!=''">
					<xsl:apply-templates select="c:Item[@name='Channel']">
						<xsl:with-param name="numSpaces" select="$numSpaces"/>
						<xsl:with-param name="parentNode" select="$parentNode"/>
						<xsl:with-param name="objectPath" select="$objectPath"/>
						<xsl:with-param name="includeAttributes" select="$includeAttributes"/>
						<xsl:with-param name="includeMeasurements" select="$includeMeasurements"/>
						<xsl:with-param name="includeLimits" select="$includeLimits"/>
						<xsl:with-param name="addProperty" select="$shouldAddProperty='true'"/>
						<xsl:with-param name="putAsFlatData" select="$putAsFlatData"/>
					</xsl:apply-templates>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<!--Display only  string-->
				<xsl:variable name="visibility">
					<xsl:choose>
						<xsl:when test="($numSpaces - 1) > 2">
							<xsl:value-of select="'hidden'"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="'visible'"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="attributes">
					<xsl:if test="$parentNode!=''">
					<xsl:call-template name="ProcessAttributes">
						<xsl:with-param name="node" select="$parentNode"/>
						<xsl:with-param name="objectPath" select="$objectPath"/>
						<xsl:with-param name="numSpaces" select="$numSpaces"/>
						<xsl:with-param name="includeAttributes" select="$includeAttributes"/>
						<xsl:with-param name="includeMeasurements" select="$includeMeasurements"/>
						<xsl:with-param name="includeLimits" select="$includeLimits"/>
						<xsl:with-param name="putAsFlatData" select="$putAsFlatData"/>
					</xsl:call-template>
				    </xsl:if>
				</xsl:variable>	
				<xsl:choose>
					<xsl:when test="$putAsFlatData">
						<tr>
							<td style="font-weight:bold;">
								<xsl:choose>
									  <xsl:when test="$objectPath!=''">	   
										  <xsl:value-of select="$objectPath"/>
									  </xsl:when>
									  <xsl:otherwise> 
										  <xsl:value-of select="@name"/>
									  </xsl:otherwise>
									</xsl:choose>
					       </td>
							<td>
							<xsl:choose>
								<xsl:when test="$filePath!=''">
									<xsl:choose>
										<xsl:when test="$isHyperLink">
											<a href="{$filePath}">
												<xsl:value-of select="$filePath"/>
											</a>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$filePath"/>
										</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
								<xsl:otherwise>''</xsl:otherwise>
							</xsl:choose>
							</td>
						</tr>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="paddingLeftValue">
							<xsl:choose>
								<xsl:when test="$attributes!=''"><xsl:value-of select="$gSingleSpaceValue * ($numSpaces - 1) - $gImageWidthValue"/></xsl:when>
								<xsl:otherwise><xsl:value-of select="$gSingleSpaceValue * ($numSpaces - 1)"/></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<tr class="{$visibility} level:{$numSpaces - 1} state:0">
							<td style="vertical-align:top;padding-left:{$paddingLeftValue}px;">
							<xsl:if test="$attributes!=''">
								<img alt="" src="{$gPlusImage}" onclick="expandCollapseTR(event)" class="trExpanded"/>
							</xsl:if>
								<xsl:choose>
									<xsl:when test="../@name">
										<xsl:value-of select="../@name"/>:</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="../../@name"/>:</xsl:otherwise>
								</xsl:choose>
							</td>
							<td colspan="{$gValueSpan}">
							<xsl:choose>
								<xsl:when test="$filePath!=''">
									<xsl:choose>
										<xsl:when test="$isHyperLink">
											<a href="{$filePath}">
												<xsl:value-of select="$filePath"/>
											</a>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$filePath"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:otherwise>''</xsl:otherwise>
							</xsl:choose>
							</td>
						</tr>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:if test="$attributes!=''"><xsl:copy-of select="$attributes"/></xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="c:Item">
		<xsl:param name="numSpaces" select="1"/>
		<xsl:param name="parentNode" select="''"/>
		<xsl:param name="objectPath" select="''"/>
		<xsl:param name="includeAttributes"/>
		<xsl:param name="includeMeasurements"/>
		<xsl:param name="includeLimits"/>
		<xsl:param name="addProperty" select="false()"/>
		<xsl:param name="putAsFlatData" select="false()"/>
		<xsl:choose>
			<xsl:when test="c:Collection">
				<xsl:variable name="dataValue">
					<xsl:apply-templates select="c:Collection">
						<xsl:with-param name="numSpaces" select="$numSpaces + 1"/>
						<xsl:with-param name="parentNode" select="$parentNode"/>
						<xsl:with-param name="objectPath">
							<xsl:choose>
								<xsl:when test="$objectPath=''">
									<xsl:value-of select="@name"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="concat($objectPath,'.',@name)"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:with-param>
						<xsl:with-param name="includeAttributes" select="$includeAttributes"/>
						<xsl:with-param name="includeMeasurements" select="$includeMeasurements"/>
						<xsl:with-param name="includeLimits" select="$includeLimits"/>
						<xsl:with-param name="addProperty" select="$addProperty"/>
						<xsl:with-param name="putAsFlatData" select="$putAsFlatData"/>
					</xsl:apply-templates>
				</xsl:variable>
				<xsl:variable name="shouldInclude">
					<xsl:choose>
						<xsl:when test="$dataValue != ''">
							<xsl:value-of select="true()"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="$addProperty">
									<xsl:value-of select="true()"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:for-each select="c:Collection">
										<xsl:call-template name="GetIsIncludeInReport"/>
									</xsl:for-each>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:if test="string($shouldInclude) = string(true()) and $dataValue!=''">
					<xsl:variable name="visibility">
						<xsl:choose>
							<xsl:when test="$numSpaces > 2">
								<xsl:value-of select="'hidden'"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="'visible'"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:if test="$putAsFlatData=false()">
						<xsl:if test="not(c:Collection/@xsi:type and c:Collection/@xsi:type ='ts:NI_TDMSReference')">
							<tr class="{$visibility} level:{$numSpaces} state:0">
								<xsl:variable name="paddingLeft">
									<xsl:choose>
										<xsl:when test="$dataValue != '' and $dataValue!=' '">
											<xsl:value-of select="$numSpaces * $gSingleSpaceValue - $gImageWidthValue"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$numSpaces * $gSingleSpaceValue"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<td colspan="{$gHeadingSpan}" style="vertical-align:top; padding-left:{$paddingLeft}px;">
									<xsl:if test="$dataValue != '' and $dataValue!=' '">
										<img alt="" src="{$gPlusImage}" onclick="expandCollapseTR(event)" class="trExpanded"/>
									</xsl:if>
									<xsl:value-of select="@name"/>:
								</td>
							</tr>
						</xsl:if>
					</xsl:if>
					<xsl:if test="$dataValue != ''">
						<xsl:copy-of select="$dataValue"/>
					</xsl:if>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="dataValue">
					<xsl:apply-templates select="c:IndexedArray|c:Datum">
						<xsl:with-param name="parentNode" select="$parentNode"/>
						<xsl:with-param name="objectPath">
							<xsl:choose>
								<xsl:when test="$objectPath=''">
									<xsl:value-of select="@name"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="concat($objectPath,'.',@name)"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:with-param>
						<xsl:with-param name="numSpaces" select="$numSpaces + 1"/>
						<xsl:with-param name="includeAttributes" select="$includeAttributes"/>
						<xsl:with-param name="includeMeasurements" select="$includeMeasurements"/>
						<xsl:with-param name="includeLimits" select="$includeLimits"/>
						<xsl:with-param name="addProperty" select="$addProperty"/>
						<xsl:with-param name="putAsFlatData" select="$putAsFlatData"/>
					</xsl:apply-templates>
				</xsl:variable>
				<xsl:variable name="shouldInclude">
					<xsl:choose>
						<xsl:when test="$dataValue != ''">
							<xsl:value-of select="true()"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="c:IndexedArray">
									<xsl:choose>
										<xsl:when test="$addProperty">
											<xsl:value-of select="true()"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:for-each select="c:IndexedArray">
												<xsl:call-template name="GetIsIncludeInReport"/>
											</xsl:for-each>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="false()"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:if test="string($shouldInclude) = string(true()) and ($dataValue!='' or count(c:IndexedArray/ts:Element)=0)">
					<xsl:variable name="dataAttribute">
						<xsl:choose>
							<xsl:when test="$parentNode!=''">
								<xsl:call-template name="ProcessAttributes">
									<xsl:with-param name="node" select="$parentNode"/>
									<xsl:with-param name="objectPath">
										<xsl:choose>
											<xsl:when test="$objectPath=''">
												<xsl:value-of select="@name"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="concat($objectPath,'.',@name)"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:with-param>
									<xsl:with-param name="numSpaces" select="$numSpaces + 1"/>
									<xsl:with-param name="includeAttributes" select="$includeAttributes"/>
									<xsl:with-param name="includeMeasurements" select="$includeMeasurements"/>
									<xsl:with-param name="includeLimits" select="$includeLimits"/>
									<xsl:with-param name="putAsFlatData" select="$putAsFlatData"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="''"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="hasAttributes" select="$dataAttribute!=''"/>
					<xsl:variable name="paddingLeft">
						<xsl:choose>
							<xsl:when test="$hasAttributes">
								<xsl:value-of select="$gSingleSpaceValue * $numSpaces - $gImageWidthValue"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$gSingleSpaceValue * $numSpaces"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="visibility">
						<xsl:choose>
							<xsl:when test="$numSpaces > 2">
								<xsl:value-of select="'hidden'"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="'visible'"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="state">
						<xsl:choose>
							<xsl:when test="$hasAttributes">
								<xsl:value-of select="'state:0'"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="'state:1'"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:choose>
						<xsl:when test="$putAsFlatData">
							<tr>
								<td style="font-weight:bold;">
									<xsl:choose>
									  <xsl:when test="$objectPath!=''">	   
										<xsl:value-of select="$objectPath"/>.<xsl:value-of select="@name"/>
									  </xsl:when>
									  <xsl:otherwise> 
										  <xsl:value-of select="@name"/>
									  </xsl:otherwise>
									</xsl:choose>	
									<xsl:if test="c:IndexedArray">
										<xsl:call-template name="GetArraySizeString">
											<xsl:with-param name="dimensionString" select="translate(substring-after(c:IndexedArray/@dimensions,'['),']',',')"/>
									<xsl:with-param name="firstElement" select="translate(substring-after(c:IndexedArray/@lowerBounds,'['),'][',',')"/>
									<xsl:with-param name="lastElement" select="translate(substring-after(c:IndexedArray/@upperBounds,'['),'][',',')"/>
										</xsl:call-template>
									</xsl:if>:</td>
								<td>
									<xsl:choose>
										<xsl:when test="$dataValue != ''">
											<xsl:copy-of select="$dataValue"/>
										</xsl:when>
										<xsl:otherwise>
											<span style="visibility:hidden;"><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text></span>
										</xsl:otherwise>
									</xsl:choose>
								</td>
							</tr>
						</xsl:when>
						<xsl:otherwise>
							<tr class="{$visibility} level:{$numSpaces} {$state}">
								<td style="vertical-align:top;  padding-left:{$paddingLeft}px;">
									<xsl:if test="$hasAttributes">
										<img alt="" src="{$gPlusImage}" onclick="expandCollapseTR(event)" class="trExpanded"/>
									</xsl:if>
									<xsl:value-of select="@name"/>
									<xsl:if test="c:IndexedArray">
										<xsl:call-template name="GetArraySizeString">
											<xsl:with-param name="dimensionString" select="translate(substring-after(c:IndexedArray/@dimensions,'['),']',',')"/>
									<xsl:with-param name="firstElement" select="translate(substring-after(c:IndexedArray/@lowerBounds,'['),'][',',')"/>
									<xsl:with-param name="lastElement" select="translate(substring-after(c:IndexedArray/@upperBounds,'['),'][',',')"/>
										</xsl:call-template>
									</xsl:if>:</td>
								<td colspan="{$gValueSpan}">
									<xsl:choose>
										<xsl:when test="$dataValue != ''">
											<xsl:copy-of select="$dataValue"/>
										</xsl:when>
										<xsl:otherwise>
											<span style="visibility:hidden;"><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text></span>
										</xsl:otherwise>
									</xsl:choose>
								</td>
							</tr>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:copy-of select="$dataAttribute"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="c:IndexedArray">
		<xsl:param name="parentNode"/>
		<xsl:param name="objectPath" select="''"/>
		<xsl:param name="numSpaces" select="1"/>
		<xsl:param name="includeAttributes"/>
		<xsl:param name="includeMeasurements"/>
		<xsl:param name="includeLimits"/>
		<xsl:param name="addProperty" select="false()"/>
		<xsl:call-template name="GetFlaggedArrayValue">
			<xsl:with-param name="includeAttributes" select="$includeAttributes"/>
			<xsl:with-param name="includeMeasurements" select="$includeMeasurements"/>
			<xsl:with-param name="includeLimits" select="$includeLimits"/>
			<xsl:with-param name="addProperty" select="$addProperty"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="ts:InteractiveExecutionId">
		<tr>
			<td style="padding-left:{$gSingleSpaceValue}px; vertical-align:middle;">Interactive Execution #:</td>
			<td colspan="{$gValueSpan}">
				<xsl:value-of select="@value"/>
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="ts:RemoteServerId">
		<tr>
			<td style="padding-left:{$gSingleSpaceValue}px; vertical-align:middle;">Server:</td>
			<td colspan="{$gValueSpan}">
				<xsl:value-of select="./text()"/>
			</td>
		</tr>
	</xsl:template>
	<xsl:template name="GetFlaggedDatumValue">
		<xsl:param name="includeAttributes"/>
		<xsl:param name="includeMeasurements"/>
		<xsl:param name="includeLimits"/>
		<xsl:param name="addProperty" select="false()"/>
		<xsl:choose>
			<xsl:when test="@flags">
				<xsl:variable name="shouldIncludeInReport">
					<xsl:call-template name="GetIsIncludeInReport"/>
				</xsl:variable>
				<xsl:if test="$shouldIncludeInReport = 'true' or $addProperty">
					<xsl:variable name="isLimit">
						<xsl:call-template name="GetIsLimit"/>
					</xsl:variable>
					<xsl:if test="$isLimit='false' or ($isLimit='true' and $includeLimits)">
						<xsl:variable name="isMeasurement">
							<xsl:call-template name="GetIsMeasurement"/>
						</xsl:variable>
						<xsl:if test="$isMeasurement='false' or ($isMeasurement='true' and $includeMeasurements)">
							<xsl:call-template name="GetDatumValue"/>
						</xsl:if>
					</xsl:if>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="GetDatumValue"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="GetDatumValue">
		<xsl:choose>
			<xsl:when test="@xsi:type = 'c:string' or @xsi:type = 'ts:TS_string'">
				<xsl:choose>
					<xsl:when test="c:Value = ''">''</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="c:Value"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="@xsi:type = 'ts:NI_HyperlinkPath'">
				<xsl:choose>
					<xsl:when test="c:Value = ''">''</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="c:Value"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="@xsi:type = 'c:binary' or @xsi:type = 'ts:TS_binary'">
				<!-- Here, '0b' is prepended to designate binary representation -->
				<xsl:value-of select="concat('0b',@value)"/>
			</xsl:when>
			<xsl:when test="@xsi:type = 'c:octal' or @xsi:type = 'ts:TS_octal'">
				<!-- Here, '0c' is prepended to designate octal representation -->
				<xsl:value-of select="concat('0c',@value)"/>
			</xsl:when>
			<xsl:when test="@xsi:type = 'c:boolean' or @xsi:type = 'ts:TS_boolean'">
				<xsl:choose>
					<xsl:when test="@value='true'">True</xsl:when>
					<xsl:otherwise>False</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="@value"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="GetTestGroupNameAndPath">
		<xsl:param name="testGroupNameAndPath"/>
		<xsl:param name="displayPath" select="true()"/>
		<xsl:param name="indentation"/>
		<xsl:choose>
			<xsl:when test="contains($testGroupNameAndPath, '#')">
				<span style="margin-left:{$indentation}px;font-size:11px;font-weight:bold;">
					<xsl:choose>
						<xsl:when test="$displayPath">Begin Sequence: </xsl:when>
						<xsl:otherwise>End Sequence: </xsl:otherwise>
					</xsl:choose>
					<xsl:value-of select="substring-after($testGroupNameAndPath, '#')"/>
				</span>
				<br/>
				<xsl:if test="$displayPath">
					<span style="margin-left:{$indentation}px;font-size:11px;font-weight:bold;">
					(<xsl:value-of select="substring-before($testGroupNameAndPath, '#')"/>)
				</span>
					<br/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<span style="margin-left:{$indentation}px;font-size:11px;font-weight:bold;">
					<xsl:choose>
						<xsl:when test="$displayPath">Begin Sequence: </xsl:when>
						<xsl:otherwise>End Sequence: </xsl:otherwise>
					</xsl:choose>
				</span>
				<br/>
				<span style="margin-left:{$indentation}px;font-size:11px;font-weight:bold;">
				(<xsl:value-of select="$testGroupNameAndPath"/>)
				</span>
			</xsl:otherwise>
		</xsl:choose>
		<br/>
	</xsl:template>
	<xsl:template name="ReportError">
		<xsl:param name="eventsNode"/>
		<xsl:param name="reportOptions"/>
		<xsl:param name="colspan" select="7"/>
		<tr style="color:{$reportOptions/c:Item[@name='Colors']/c:Collection/c:Item[@name='Error']}">
			<td style="padding-left:{$gSingleSpaceValue}px; vertical-align:top;">Error Message:</td>
			<td colspan="{$colspan - 1}" style="white-space:normal;text-align:left;vertical-align:middle;">
				<xsl:if test="$eventsNode/tr:Event[@ID='Error Message']">
					<xsl:variable name="errorMsg">
						<xsl:apply-templates select="$eventsNode/tr:Event[@ID='Error Message']/tr:Data/c:Datum">
							<xsl:with-param name="addProperty" select="true()"/>
						</xsl:apply-templates>
					</xsl:variable>
					<xsl:call-template name="ReplaceNewLineWithBreak">
						<xsl:with-param name="inputString" select="$errorMsg"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="$eventsNode/tr:Event[@ID='Error Code']">[Error Code: <xsl:apply-templates select="$eventsNode/tr:Event[@ID='Error Code']/tr:Data/c:Datum"><xsl:with-param name="addProperty" select="true()"/></xsl:apply-templates>]
				</xsl:if>
			</td>
		</tr>
	</xsl:template>
	<xsl:template name="ReplaceSubString">
		<xsl:param name="inputString"/>
		<xsl:param name="oldSubString"/>
		<xsl:param name="newSubString"/>
		<xsl:variable name="head">
			<xsl:value-of select="substring-before($inputString,$oldSubString)"/>
		</xsl:variable>
		<xsl:variable name="tail">
			<xsl:value-of select="substring-after($inputString,$oldSubString)"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="string-length($tail)=0">
				<xsl:value-of select="$inputString"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="ReplaceSubString">
					<xsl:with-param name="inputString" select="concat($head,$newSubString,$tail)"/>
					<xsl:with-param name="oldSubString" select="$oldSubString"/>
					<xsl:with-param name="newSubString" select="$newSubString"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="ReplaceNewLineWithBreak">
		<xsl:param name="inputString"/>
		<xsl:value-of select="user:RemoveIllegalCharacters(string($inputString))" disable-output-escaping="yes"/>
	</xsl:template>
	<xsl:template name="GetFlaggedArrayValue">
		<xsl:param name="includeAttributes"/>
		<xsl:param name="includeMeasurements"/>
		<xsl:param name="includeLimits"/>
		<xsl:param name="addProperty" select="false()"/>
		<xsl:choose>
			<xsl:when test="@flags">
				<xsl:variable name="shouldIncludeInReport">
					<xsl:call-template name="GetIsIncludeInReport"/>
				</xsl:variable>
				<xsl:if test="$shouldIncludeInReport = 'true' or $addProperty">
					<xsl:variable name="isLimit">
						<xsl:call-template name="GetIsLimit"/>
					</xsl:variable>
					<xsl:if test="$isLimit='false' or ($isLimit='true' and $includeLimits)">
						<xsl:variable name="isMeasurement">
							<xsl:call-template name="GetIsMeasurement"/>
						</xsl:variable>
						<xsl:if test="$isMeasurement='false' or ($isMeasurement='true' and $includeMeasurements)">
							<xsl:call-template name="GetArrayValue"/>
						</xsl:if>
					</xsl:if>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="GetArrayValue"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="GetArrayValue">
		<xsl:choose>
			<xsl:when test="@xsi:type='c:stringArray' or @xsi:type = 'ts:TS_stringArray'">
				<xsl:for-each select="ts:Element">
					<xsl:call-template name="ReplaceSubString">
						<xsl:with-param name="inputString" select="@position"/>
						<xsl:with-param name="oldSubString" select="','"/>
						<xsl:with-param name="newSubString" select="']['"/>
					</xsl:call-template>
					<xsl:value-of select="' = '"/>
					<xsl:text disable-output-escaping="yes">&apos;</xsl:text>
					<xsl:if test="c:Value != ''">
						<xsl:value-of select="c:Value"/>
					</xsl:if>
					<xsl:text disable-output-escaping="yes">&apos;</xsl:text>
					<br/>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="@xsi:type='c:binaryArray' or @xsi:type = 'ts:TS_binaryArray'">
				<xsl:for-each select="ts:Element">
					<xsl:call-template name="ReplaceSubString">
						<xsl:with-param name="inputString" select="@position"/>
						<xsl:with-param name="oldSubString" select="','"/>
						<xsl:with-param name="newSubString" select="']['"/>
						<!-- Here, '0b' is prepended to designate binary representation -->
					</xsl:call-template>
					<xsl:value-of select="' = '"/>
					<xsl:text disable-output-escaping="yes">&apos;</xsl:text>
					<xsl:value-of select="concat('0b',@value)"/>
					<xsl:text disable-output-escaping="yes">&apos;</xsl:text>
					<br/>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="@xsi:type='c:octalArray' or @xsi:type = 'ts:TS_octalArray'">
				<xsl:for-each select="ts:Element">
					<xsl:call-template name="ReplaceSubString">
						<xsl:with-param name="inputString" select="@position"/>
						<xsl:with-param name="oldSubString" select="','"/>
						<xsl:with-param name="newSubString" select="']['"/>
						<!-- Here, '0c' is prepended to designate octal representation -->
					</xsl:call-template>
					<xsl:value-of select="' = '"/>
					<xsl:text disable-output-escaping="yes">&apos;</xsl:text>
					<xsl:value-of select="concat('0c',@value)"/>
					<xsl:text disable-output-escaping="yes">&apos;</xsl:text>
					<br/>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="@xsi:type='c:booleanArray' or @xsi:type = 'ts:TS_booleanArray'">
				<xsl:for-each select="ts:Element">
					<xsl:call-template name="ReplaceSubString">
						<xsl:with-param name="inputString" select="@position"/>
						<xsl:with-param name="oldSubString" select="','"/>
						<xsl:with-param name="newSubString" select="']['"/>
					</xsl:call-template>
					<xsl:value-of select="' = '"/>
					<xsl:choose>
						<xsl:when test="@value='true'">
							<xsl:text disable-output-escaping="yes">&apos;True&apos;</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text disable-output-escaping="yes">&apos;False&apos;</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
					<br/>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="@xsi:type='c:hexadecimalArray' or @xsi:type = 'ts:TS_hexadecimalArray'">
				<xsl:call-template name="GetArrayValueAsTable"/>
			</xsl:when>
			<xsl:when test="function-available('user:GetIncludeArrayMeasurement')">
				<xsl:variable name="includeArrayMeasurement" select="user:GetIncludeArrayMeasurement()"/>
				<xsl:choose>
					<xsl:when test="$includeArrayMeasurement = 2 and $gGraphControlInstalled = 1">
						<xsl:variable name="arrayElementList" select="ts:Element"/>
						<xsl:variable name="numDimensions" select="user:GetDimensions($arrayElementList)"/>
						<xsl:variable name="graphCounter" select="user:GetGraphCounter()"/>
						<xsl:choose>
							<xsl:when test="$numDimensions &gt; 2 or count(ts:Element)=0">
								<xsl:call-template name="GetArrayValueAsTable"/>
							</xsl:when>
							<xsl:otherwise>
								<object classid='clsid:39C3B7BF-DCEF-432B-BDB3-711F1711FA4B' name='TsGraphControl2.GraphControl2' id='CWGRAPH{$graphCounter}' height='200' style='left: 0px; top: 0px' width='100%'> </object>
								<script defer='defer' type='text/vbscript'>
									<xsl:choose>
										<xsl:when test="$numDimensions = 1">
											<xsl:value-of select="user:Get1DimensionGraphScript($arrayElementList, $graphCounter)"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="user:Get2DimensionGraphScript($arrayElementList, $graphCounter)"/>
										</xsl:otherwise>
									</xsl:choose>
								</script>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="GetArrayValueAsTable"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="GetArrayValueAsTable"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="GetArrayValueAsTable">
		<xsl:for-each select="ts:Element">
			<xsl:call-template name="ReplaceSubString">
				<xsl:with-param name="inputString" select="@position"/>
				<xsl:with-param name="oldSubString" select="','"/>
				<xsl:with-param name="newSubString" select="']['"/>
			</xsl:call-template>
			<xsl:value-of select="' = '"/>
			<xsl:text disable-output-escaping="yes">&apos;</xsl:text>
			<xsl:value-of select="@value"/>
			<xsl:text disable-output-escaping="yes">&apos;</xsl:text>
			<br/>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="GetIsIncludeInReport">
		<xsl:choose>
			<xsl:when test="@flags">
				<xsl:variable name="flags" select="@flags"/>
				<xsl:variable name="hexDigit" select="substring($flags,string-length($flags)-3,1)"/>
				<xsl:choose>
					<xsl:when test="$hexDigit='2' or $hexDigit='3' or $hexDigit='6' or $hexDigit='7' or $hexDigit='a' or $hexDigit='b' or $hexDigit='e' or $hexDigit='f'">
						<xsl:value-of select="true()"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="false()"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="true()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="GetIsLimit">
			<xsl:choose>
				<xsl:when test="@flags">
					<xsl:variable name="flags" select="@flags"/>
					<xsl:variable name="hexDigit" select="substring($flags,string-length($flags)-3,1)"/>
					<xsl:choose>
						<xsl:when test="$hexDigit='1' or $hexDigit='3' or $hexDigit='5' or $hexDigit='7' or $hexDigit='9' or $hexDigit='b' or $hexDigit='d' or $hexDigit='f'">
							<xsl:value-of select="true()"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="false()"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="false()"/>
				</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="GetIsMeasurement">
		<xsl:choose>
				<xsl:when test="@flags">
					<xsl:variable name="flags" select="@flags"/>
					<xsl:variable name="hexDigit" select="substring($flags,string-length($flags)-2,1)"/>
					<xsl:choose>						
						<xsl:when test="$hexDigit='4' or $hexDigit='5' or $hexDigit='6' or $hexDigit='7' or $hexDigit='c' or $hexDigit='d' or $hexDigit='e' or $hexDigit='f'">
							<xsl:value-of select="true()"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="false()"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="false()"/>
				</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="Substring-before-last">
		<xsl:param name="string1" select="''"/>
		<xsl:param name="string2" select="''"/>
		<xsl:choose>
			<xsl:when test="$string1 != '' and $string2 != ''">
				<xsl:variable name="head" select="substring-before($string1, $string2)"/>
				<xsl:variable name="tail" select="substring-after($string1, $string2)"/>
				<xsl:value-of select="concat($head, $string2)"/>
				<xsl:if test="contains($tail, $string2)">
					<xsl:call-template name="Substring-before-last">
						<xsl:with-param name="string1" select="$tail"/>
						<xsl:with-param name="string2" select="$string2"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="ReplaceBackwardSlashInPath">
		<xsl:param name="filepath"/>
		<xsl:choose>
			<xsl:when test="contains($filepath, '\')">
				<xsl:value-of select="translate($filepath, '\', '/')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$filepath"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="GetUUTTime">
		<xsl:param name="dateTime"/>
		<xsl:variable name="time" select="substring-before(substring-after($dateTime, 'T'), '.')"/>
		<xsl:variable name="hours" select="substring-before($time, ':')"/>
		<xsl:variable name="minsSecs" select="substring-after($time, ':')"/>
		<xsl:variable name="timeIn12HrFormat">
			<xsl:choose>
				<xsl:when test="$hours > 11">
					<xsl:choose>
						<xsl:when test="$hours - 12 = 0">12</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$hours - 12"/>
						</xsl:otherwise>
					</xsl:choose>:<xsl:value-of select="$minsSecs"/> PM
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="$hours = 0">12</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$hours"/>
						</xsl:otherwise>
					</xsl:choose>:<xsl:value-of select="$minsSecs"/> AM
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$timeIn12HrFormat"/>
	</xsl:template>
	<xsl:template name="GetStatusColor">
		<xsl:param name="colors"/>
		<xsl:param name="status"/>
		<xsl:param name="qualifier"/>
		<xsl:choose>
			<xsl:when test="$status = 'Passed'">
				<xsl:value-of select="$colors/c:Item[@name = 'Passed']/c:Datum/c:Value"/>
			</xsl:when>
			<xsl:when test="$status = 'Done'">
				<xsl:value-of select="$colors/c:Item[@name = 'Done']/c:Datum/c:Value"/>
			</xsl:when>
			<xsl:when test="$status = 'Failed'">
				<xsl:value-of select="$colors/c:Item[@name = 'Failed']/c:Datum/c:Value"/>
			</xsl:when>
			<xsl:when test="$status = 'Aborted'">
				<xsl:choose>
					<xsl:when test="$qualifier = 'Error'">
						<xsl:value-of select="$colors/c:Item[@name = 'Error']/c:Datum/c:Value"/>
					</xsl:when>
					<xsl:when test="$qualifier = 'Terminated'">
						<xsl:value-of select="$colors/c:Item[@name = 'Terminated']/c:Datum/c:Value"/>
					</xsl:when>					
					<xsl:otherwise>
						<xsl:value-of select="$colors/c:Item[@name = 'Done']/c:Datum/c:Value"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$status = 'UserDefined'">
				<xsl:choose>
					<xsl:when test="$qualifier = 'Running'">
						<xsl:value-of select="$colors/c:Item[@name = 'Running']/c:Datum/c:Value"/>
					</xsl:when>
					<xsl:when test="$qualifier = 'Skipped'">
						<xsl:value-of select="$colors/c:Item[@name = 'Skipped']/c:Datum/c:Value"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$colors/c:Item[@name = 'Done']/c:Datum/c:Value"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="GetStatusBgColor">
		<xsl:param name="colors"/>
		<xsl:param name="status"/>
		<xsl:param name="qualifier"/>
		<xsl:choose>
			<xsl:when test="$status = 'Passed'">
				<xsl:value-of select="$colors/c:Item[@name = 'PassedBg']/c:Datum/c:Value"/>
			</xsl:when>
			<xsl:when test="$status = 'Done'">
				<xsl:value-of select="$colors/c:Item[@name = 'DoneBg']/c:Datum/c:Value"/>
			</xsl:when>
			<xsl:when test="$status = 'Failed'">
				<xsl:value-of select="$colors/c:Item[@name = 'FailedBg']/c:Datum/c:Value"/>
			</xsl:when>
			<xsl:when test="$status = 'Aborted'">
				<xsl:choose>
					<xsl:when test="$qualifier = 'Error'">
						<xsl:value-of select="$colors/c:Item[@name = 'ErrorBg']/c:Datum/c:Value"/>
					</xsl:when>
					<xsl:when test="$qualifier = 'Terminated'">
						<xsl:value-of select="$colors/c:Item[@name = 'TerminatedBg']/c:Datum/c:Value"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$colors/c:Item[@name = 'DoneBg']/c:Datum/c:Value"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$status = 'UserDefined'">
			<xsl:choose>
				<xsl:when test="$qualifier = 'Running'">
					<xsl:value-of select="$colors/c:Item[@name = 'RunningBg']/c:Datum/c:Value"/>
				</xsl:when>
				<xsl:when test="$qualifier = 'Skipped'">
					<xsl:value-of select="$colors/c:Item[@name = 'SkippedBg']/c:Datum/c:Value"/>
				</xsl:when>
				<xsl:otherwise>
						<xsl:value-of select="$colors/c:Item[@name = 'DoneBg']/c:Datum/c:Value"/>
				</xsl:otherwise>
			</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="GetStepGroupBgColor">
		<xsl:param name="stepGroupName"/>
		<xsl:param name="colors"/>
		<xsl:variable name="stepGroup">
			<xsl:choose>
				<xsl:when test="$stepGroupName=''">
					Main
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$stepGroupName"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$stepGroup = 'Main'">
				<xsl:value-of select="$colors/c:Item[@name = 'MainBg']/c:Datum/c:Value"/>
			</xsl:when>
			<xsl:when test="$stepGroup = 'Setup'">
				<xsl:value-of select="$colors/c:Item[@name = 'SetupBg']/c:Datum/c:Value"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$colors/c:Item[@name = 'CleanupBg']/c:Datum/c:Value"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="GetExpandCollapseState">
		<xsl:param name="outcome"/>
		<xsl:param name="qualifier"/>
		<xsl:choose>
			<xsl:when test="$outcome='Failed'">
				<xsl:value-of select="'expanded'"/>
			</xsl:when>
			<xsl:when test="$outcome='Aborted'">
				<xsl:choose>
					<xsl:when test="$qualifier='Error'">
						<xsl:value-of select="'expanded'"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="'collapsed'"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="'collapsed'"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="GetIndentationMargin">
		<xsl:param name="blockLevel" select="0"/>
		<xsl:value-of select="$blockLevel *40 + 20"/>
	</xsl:template>
	<xsl:template name="GetUUTDate">
		<xsl:param name="date"/>
		<xsl:variable name="year" select="substring-before($date,'-')"/>
		<xsl:variable name="month" select="substring-before(substring-after($date,'-'),'-')"/>
		<xsl:variable name="d" select="substring-after(substring-after($date,'-'),'-')"/>
		<xsl:variable name="Y">
			<xsl:choose>
				<xsl:when test="$month &lt; 3">
					<xsl:value-of select="$year - 1"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$year"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="c" select="number(substring($Y,1,2))"/>
		<xsl:variable name="y" select="number(substring($Y,3))"/>
		<xsl:variable name="m" select="(($month + 9) mod 12) + 1"/>
		<xsl:variable name="w" select=" ($d + floor(2.6 * $m - 0.2) + $y + floor($y div 4) + floor($c div 4) - (2 * $c) + 70) mod 7"/>
		<xsl:choose>
			<xsl:when test="$w = 0">Sunday</xsl:when>
			<xsl:when test="$w = 1">Monday</xsl:when>
			<xsl:when test="$w = 2">Tuesday</xsl:when>
			<xsl:when test="$w = 3">Wednesday</xsl:when>
			<xsl:when test="$w = 4">Thursday</xsl:when>
			<xsl:when test="$w = 5">Friday</xsl:when>
			<xsl:otherwise>Saturday</xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="', '"/>
		<xsl:choose>
			<xsl:when test="$month = 1">January</xsl:when>
			<xsl:when test="$month = 2">February</xsl:when>
			<xsl:when test="$month = 3">March</xsl:when>
			<xsl:when test="$month = 4">April</xsl:when>
			<xsl:when test="$month = 5">May</xsl:when>
			<xsl:when test="$month = 6">June</xsl:when>
			<xsl:when test="$month = 7">July</xsl:when>
			<xsl:when test="$month = 8">August</xsl:when>
			<xsl:when test="$month = 9">September</xsl:when>
			<xsl:when test="$month = 10">October</xsl:when>
			<xsl:when test="$month = 11">November</xsl:when>
			<xsl:otherwise>December</xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="' '"/>
		<xsl:value-of select="$d"/>
		<xsl:value-of select="', '"/>
		<xsl:value-of select="$year"/>
	</xsl:template>
	<xsl:template name="GetUnit">
		<xsl:param name="node"/>
		<xsl:choose>
			<xsl:when test="$node/@unit">
				<xsl:value-of select="$node/@unit"/>
			</xsl:when>
			<xsl:when test="$node/@nonStandardUnit">
				<xsl:value-of select="$node/@nonStandardUnit"/>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="PutMeasurements">
		<xsl:param name="includeAttributes"/>
		<xsl:param name="includeMeasurements"/>
		<xsl:param name="includeLimits"/>
		<xsl:param name="colors"/>
		<xsl:param name="node"/>
		<xsl:if test="count(tr:TestResult/tr:Outcome)!=0">
			<tr>
				<td colspan="{$gHeadingSpan}" style="padding-left:{$gSingleSpaceValue}px; vertical-align:middle;">Measurement:</td>
			</tr>
			<xsl:for-each select="tr:TestResult/tr:Outcome">
				<xsl:apply-templates select="parent::node()">
					<xsl:with-param name="skipMeasurement" select="false()"/>
					<xsl:with-param name="includeAttributes" select="$includeAttributes"/>
					<xsl:with-param name="includeMeasurements" select="$includeMeasurements"/>
					<xsl:with-param name="includeLimits" select="$includeLimits"/>
					<xsl:with-param name="colors" select="$colors"/>
				</xsl:apply-templates>
				<xsl:variable name="testResultName">
					<xsl:value-of select="parent::node()/@name"/>
				</xsl:variable>
				<xsl:variable name="lowLimitAttributes">
					<xsl:call-template name="ProcessAttributes">
						<xsl:with-param name="node" select="$node"/>
						<xsl:with-param name="objectPath" select="concat($testResultName,'.Limits.Low')"/>
						<xsl:with-param name="numSpaces" select="5"/>
						<xsl:with-param name="includeAttributes" select="$includeAttributes"/>
						<xsl:with-param name="includeMeasurements" select="$includeMeasurements"/>
						<xsl:with-param name="includeLimits" select="$includeLimits"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="highLimitAttributes">
					<xsl:call-template name="ProcessAttributes">
						<xsl:with-param name="node" select="$node"/>
						<xsl:with-param name="objectPath" select="concat($testResultName,'.Limits.High')"/>
						<xsl:with-param name="numSpaces" select="5"/>
						<xsl:with-param name="includeAttributes" select="$includeAttributes"/>
						<xsl:with-param name="includeMeasurements" select="$includeMeasurements"/>
						<xsl:with-param name="includeLimits" select="$includeLimits"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:if test="($lowLimitAttributes!='' or $highLimitAttributes!='') and $includeLimits">
					<tr class="visible level:1 state:0">
						<td colspan="{$gHeadingSpan}" style="padding-left:{(3 * $gSingleSpaceValue) - $gImageWidthValue}px; vertical-align:middle;">
							<img alt="" src="{$gPlusImage}" onclick="expandCollapseTR(event)" class="trExpanded"/>Limits:</td>
					</tr>
					<xsl:if test="$lowLimitAttributes!=''">
						<tr class="hidden level:2 state:0">
							<td colspan="{$gHeadingSpan}" style="padding-left:{$gSingleSpaceValue * 4 - $gImageWidthValue}px; vertical-align:middle;">
								<img alt="" src="{$gPlusImage}" onclick="expandCollapseTR(event)" class="trExpanded"/>Low:</td>
						</tr>
						<xsl:copy-of select="$lowLimitAttributes"/>
					</xsl:if>
					<xsl:if test="$highLimitAttributes!=''">
						<tr class="hidden level:2 state:0">
							<td colspan="{$gHeadingSpan}" style="padding-left:{$gSingleSpaceValue * 4 - $gImageWidthValue}px; vertical-align:middle;">
								<img alt="" src="{$gPlusImage}" onclick="expandCollapseTR(event)" class="trExpanded"/>High:</td>
						</tr>
						<xsl:copy-of select="$highLimitAttributes"/>
					</xsl:if>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<xsl:template name="LogNoComparison">
		<xsl:variable name="unit">
			<xsl:call-template name="GetUnit">
				<xsl:with-param name="node" select="tr:TestData/c:Datum"/>
			</xsl:call-template>
		</xsl:variable>
		<td>
			<xsl:value-of select="$unit"/>
		</td>
		<td/>
		<td/>
		<td style="text-align:center;">LOG</td>
	</xsl:template>
	<xsl:template name="CheckIfTypeFlow">
		<xsl:variable name="nodeName" select="@name"/>
		<xsl:choose>
			<xsl:when test="tr:Extension/ts:TSStepProperties/ts:StepType">
				<xsl:variable name="stepType"><xsl:value-of select="tr:Extension/ts:TSStepProperties/ts:StepType"/></xsl:variable>
				<xsl:choose>
					<xsl:when test="contains($stepType, 'NI_Flow_') and $stepType!='NI_Flow_Else'  and $stepType!='NI_Flow_Break' and $stepType!='NI_Flow_Continue'">True</xsl:when>
					<xsl:otherwise>False</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>False</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="GetArraySizeString">
		<xsl:param name="dimensionString"/>
		<xsl:param name="firstElement"/>
		<xsl:param name="lastElement"/>
		<xsl:variable name="arraySizeString">
			<xsl:choose>
				<xsl:when test="$dimensionString=''"/>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="substring-before($dimensionString,',')=0">
						[0..empty]
					</xsl:when>
						<xsl:otherwise>
						[<xsl:value-of select="substring-before($firstElement,',')"/>..<xsl:value-of select="substring-before($lastElement,',')"/>]
						<xsl:call-template name="GetArraySizeString">
								<xsl:with-param name="dimensionString" select="substring-after($dimensionString,',')"/>
								<xsl:with-param name="firstElement" select="substring-after($firstElement,',')"/>
								<xsl:with-param name="lastElement" select="substring-after($lastElement,',')"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$arraySizeString"/>
	</xsl:template>
	<xsl:template name="ProcessAttributes">
		<xsl:param name="node"/>
		<xsl:param name="objectPath"/>
		<xsl:param name="numSpaces" select="1"/>
		<xsl:param name="includeAttributes"/>
		<xsl:param name="includeMeasurements"/>
		<xsl:param name="includeLimits"/>
		<xsl:param name="putAsFlatData" select="false()"/>
		<xsl:variable name="attributesNodeName">
			<xsl:value-of select="concat($objectPath,'.Attributes')"/>
		</xsl:variable>
		<xsl:if test="$includeAttributes">
			<xsl:if test="$node/tr:Data/c:Collection/c:Item[@name=$attributesNodeName]|$node/c:Collection/c:Item[@name=$attributesNodeName]">
				<xsl:variable name="dataValue">
					<xsl:apply-templates select="$node/tr:Data/c:Collection/c:Item[@name = $attributesNodeName][1]/c:Collection|$node/c:Collection/c:Item[@name=$attributesNodeName][1]/c:Collection">
						<xsl:with-param name="numSpaces" select="$numSpaces + 1"/>
						<xsl:with-param name="includeAttributes" select="$includeAttributes"/>
						<xsl:with-param name="includeMeasurements" select="$includeMeasurements"/>
						<xsl:with-param name="includeLimits" select="$includeLimits"/>
						<xsl:with-param name="parentNode" select="$node"/>
						<xsl:with-param name="objectPath" select="$attributesNodeName"/>
						<xsl:with-param name="putAsFlatData" select="$putAsFlatData"/>
					</xsl:apply-templates>
				</xsl:variable>
				<xsl:if test="$dataValue!=''">
						<tr class="hidden level:{$numSpaces} state:0">
							<td colspan="{$gHeadingSpan}" style="padding-left:{$numSpaces * $gSingleSpaceValue - $gImageWidthValue}px; vertical-align:middle;">
								<img alt="" src="{$gPlusImage}" onclick="expandCollapseTR(event)" class="trExpanded"/>Attributes:</td>
						</tr>
					<xsl:copy-of select="$dataValue"/>
				</xsl:if>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template name="AddTableElement">
		<xsl:param name="indentation"/>
		<xsl:param name="reportOptions"/>
		<xsl:value-of select="concat('&lt;','table ')" disable-output-escaping="yes"/> class="stepTable" style="margin-left:<xsl:value-of select="$indentation"/>px;"<xsl:value-of select="'>'" disable-output-escaping="yes"/>
		<tr>
			<td rowspan="2" valign="bottom" style="text-align:center;" width="30%">
				<b>Step</b>
			</td>
			<td rowspan="2" valign="bottom" style="text-align:center;" width="6%">
				<b>Status</b>
			</td>
			<td rowspan="2" valign="bottom" style="text-align:center;" width="10%">
				<b>Measurement</b>
			</td>
			<td rowspan="2" valign="bottom" style="text-align:center;" width="7%">
				<b>Units</b>
			</td>
			<td colspan="3" style="text-align:center;" width="33%">
				<b>Limits</b>
			</td>
			<!--CREATE_EXTRA_COLUMNS-->
			<!--td rowspan="2" valign="bottom" style="text-align:center;" width="10%">
				<b>StepID</b>
			</td-->
		</tr>
		<tr>
			<td width="10%" style="text-align:center;">
				<b>Low Limit</b>
			</td>
			<td width="10%" style="text-align:center;">
				<b>High Limit</b>
			</td>
			<td width="13%" style="text-align:center; white-space:nowrap;">
				<b>Comparison Type</b>
			</td>
		</tr>
	</xsl:template>
	<xsl:template name="GetNextBlockLevel">
		<xsl:variable name="nextBlockLevel">
			<xsl:choose>
				<xsl:when test="tr:Extension">
					<xsl:choose>
						<xsl:when test="following-sibling::*[1]/tr:Extension/ts:TSStepProperties/ts:BlockLevel">
			<xsl:value-of select="following-sibling::*[1]/tr:Extension/ts:TSStepProperties/ts:BlockLevel/@value"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="tr:Extension/ts:TSStepProperties/ts:BlockLevel/@value"/>
			</xsl:otherwise>
		</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="following-sibling::*[1]/@userDefinedType">
							<xsl:variable name="blockLevel">
								<xsl:value-of select="substring-after(following-sibling::*[1]/@userDefinedType, 'bl = ')"/>
							</xsl:variable>
							<xsl:value-of select="number(substring($blockLevel,2,string-length($blockLevel)-2))"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="blockLevel">
								<xsl:value-of select="substring-after(@userDefinedType, 'bl = ')"/>
							</xsl:variable>
							<xsl:value-of select="number(substring($blockLevel,2,string-length($blockLevel)-2))"/>
						</xsl:otherwise>
					</xsl:choose>				
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="number($nextBlockLevel)"/>
	</xsl:template>
	<xsl:template name="GetUutResultColor">
		<xsl:param name="status"/>
		<xsl:param name="colors"/>
		<xsl:choose>
			<xsl:when test="$status = 'Passed'"><xsl:value-of select="$colors/c:Item[@name='Passed']/c:Datum/c:Value"/></xsl:when>
			<xsl:when test="$status = 'Done'"><xsl:value-of select="$colors/c:Item[@name = 'Done']/c:Datum/c:Value"/></xsl:when>
			<xsl:when test="$status = 'Failed'"><xsl:value-of select="$colors/c:Item[@name = 'Failed']/c:Datum/c:Value"/></xsl:when>
			<xsl:when test="$status = 'Error'"><xsl:value-of select="$colors/c:Item[@name = 'Error']/c:Datum/c:Value"/></xsl:when>
			<xsl:when test="$status = 'Terminated'"><xsl:value-of select="$colors/c:Item[@name = 'Terminated']/c:Datum/c:Value"/></xsl:when>
			<xsl:when test="$status = 'Running'"><xsl:value-of select="$colors/c:Item[@name = 'Running']/c:Datum/c:Value"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$colors/c:Item[@name = 'Skipped']/c:Datum/c:Value"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="PutBatchUutLink">
		<xsl:if test="tr:Extension/ts:TSResultSetProperties/ts:TestSocketIndex">
			<a name="{concat(tr:Extension/ts:TSResultSetProperties/ts:TestSocketIndex/@value,'-',tr:ResultSet/@startDateTime)}"/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="AddCriticalFailureStack">
		<xsl:param name="criticalFailureStackNode"/>
		<xsl:param name="uniqueDivId" select="''"/>
		<br/>
		<table class="criticalFailureTable">
			<tr>
				<th colspan="3">Failure Chain</th>
			</tr>
			<tr>
				<th>Step</th>
				<th>Sequence</th>
				<th>Sequence File</th>
			</tr>
			<xsl:for-each select="$criticalFailureStackNode/ts:CriticalFailureStackEntry">
				<xsl:sort select="@resultID" order="descending"/>
				<tr>
					<td>
						<a href="#ResultId{@resultID}" onclick="expandAllTables(event);" class="{$uniqueDivId}">
							<xsl:value-of select="@stepName"/>
						</a>
					</td>
					<td>
						<xsl:value-of select="@sequenceName"/>
					</td>
					<td>
						<xsl:choose>
							<xsl:when test="@sequenceFileName!=''">
								<xsl:value-of select="@sequenceFileName"/>
							</xsl:when>
							<xsl:otherwise>
								<span style="visibility:hidden;"><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text></span>
							</xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>
			</xsl:for-each>
		</table>
		<br/>
	</xsl:template>
	<xsl:template name="GetBlockLevel">
		<xsl:choose>
			<xsl:when test="tr:Extension/ts:TSStepProperties/ts:BlockLevel/@value">
				<xsl:value-of select="tr:Extension/ts:TSStepProperties/ts:BlockLevel/@value"/>
			</xsl:when>
			<xsl:when test="@userDefinedType">
				<xsl:variable name="blockLevel">
					<xsl:value-of select="substring-after(@userDefinedType, 'bl = ')"/>
				</xsl:variable>
				<xsl:value-of select="number(substring($blockLevel,2,string-length($blockLevel)-2))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="../tr:Extension/ts:TSStepProperties/ts:BlockLevel/@value">
						<xsl:value-of select="../tr:Extension/ts:TSStepProperties/ts:BlockLevel/@value"/>
					</xsl:when>
					<xsl:when test="../@userDefinedType">
						<xsl:variable name="blockLevel">
							<xsl:value-of select="substring-after(@userDefinedType, 'bl = ')"/>
						</xsl:variable>
						<xsl:value-of select="number(substring($blockLevel,2,string-length($blockLevel)-2))"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="0"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="processing-instruction('xml-stylesheet')" name="GetStylesheetPath">
		<xsl:variable name="PI" select="./processing-instruction('xml-stylesheet')"/>
		<xsl:variable name="fullFilePath">
			<xsl:call-template name="ReplaceBackwardSlashInPath">
				<xsl:with-param name="filepath" select="substring-before(substring-after($PI, 'href=&quot;'), '&quot;')"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="contains($fullFilePath,'/')">
				<xsl:call-template name="Substring-before-last">
					<xsl:with-param name="string1" select="$fullFilePath"/>
					<xsl:with-param name="string2" select="'/'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="GetImageAbsolutePath">
		<xsl:param name="imageName"/>
		<xsl:choose>
			<xsl:when test="substring-before($gStylesheetPath, '/')">
				<xsl:value-of select="concat($gStylesheetPath, $imageName)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$imageName"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="GetComparisonTypeText">
		<xsl:param name="compText"/>
		<xsl:value-of select="$compText"/>
		<xsl:choose>
			<xsl:when test="$compText='EQ'">
				<xsl:text>(==)</xsl:text>
			</xsl:when>
			<xsl:when test="$compText='NE'">
				<xsl:text>(!=)</xsl:text>
			</xsl:when>
			<xsl:when test="$compText='GT'">
				<xsl:text disable-output-escaping="yes">(&gt;)</xsl:text>
			</xsl:when>
			<xsl:when test="$compText='GE'">
				<xsl:text disable-output-escaping="yes">(&gt;=)</xsl:text>
			</xsl:when>
			<xsl:when test="$compText='LT'">
				<xsl:text disable-output-escaping="yes">(&lt;)</xsl:text>
			</xsl:when>
			<xsl:when test="$compText='LE'">
				<xsl:text disable-output-escaping="yes">(&lt;=)</xsl:text>
			</xsl:when>
			<xsl:when test="$compText='GTLT'">
				<xsl:text disable-output-escaping="yes">(&gt; &lt;)</xsl:text>
			</xsl:when>
			<xsl:when test="$compText='GELT'">
				<xsl:text disable-output-escaping="yes">(&gt;= &lt;)</xsl:text>
			</xsl:when>
			<xsl:when test="$compText='GELE'">
				<xsl:text disable-output-escaping="yes">(&gt;= &lt;=)</xsl:text>
			</xsl:when>
			<xsl:when test="$compText='GTLE'">
				<xsl:text disable-output-escaping="yes">(&gt; &lt;=)</xsl:text>
			</xsl:when>
			<xsl:when test="$compText='LTGT'">
				<xsl:text disable-output-escaping="yes">(&lt; &gt;)</xsl:text>
			</xsl:when>
			<xsl:when test="$compText='LTGE'">
				<xsl:text disable-output-escaping="yes">(&lt; &gt;=)</xsl:text>
			</xsl:when>
			<xsl:when test="$compText='LEGE'">
				<xsl:text disable-output-escaping="yes">(&lt;= &gt;=)</xsl:text>
			</xsl:when>
			<xsl:when test="$compText='LEGT'">
				<xsl:text disable-output-escaping="yes">(&lt;= &gt;)</xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="PutNDivOpenTags">
		<xsl:param name="n" select="0"/>
		<xsl:if test="$n != 0">
			<xsl:value-of select="concat('&lt;','div >')" disable-output-escaping="yes"/>
			<xsl:call-template name="PutNDivOpenTags">
				<xsl:with-param name="n" select="$n -1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="PutNDivCloseTags">
		<xsl:param name="n" select="0"/>
		<xsl:if test="$n != 0">
			<xsl:value-of select="concat('&lt;/','div >')" disable-output-escaping="yes"/>
			<xsl:call-template name="PutNDivCloseTags">
				<xsl:with-param name="n" select="$n -1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
