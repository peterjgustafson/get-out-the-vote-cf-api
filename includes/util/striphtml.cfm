<cfscript>
/**
 * Removes HTML from the string.
 * v2 - Mod by Steve Bryant to find trailing, half done HTML.        
 * v4 mod by James Moberg - empties out script/style blocks
 * 
 * @param string 	 String to be modified. (Required)
 * @return Returns a string. 
 * @author Raymond Camden (&#114;&#97;&#121;&#64;&#99;&#97;&#109;&#100;&#101;&#110;&#102;&#97;&#109;&#105;&#108;&#121;&#46;&#99;&#111;&#109;) 
 * @version 4, October 4, 2010 
 */
function stripHTML(str) {
	str = reReplaceNoCase(str, "<*style.*?>(.*?)</style>","","all");
	str = reReplaceNoCase(str, "<*script.*?>(.*?)</script>","","all");

	str = reReplaceNoCase(str, "<.*?>","","all");
	//get partial html in front
	str = reReplaceNoCase(str, "^.*?>","");
	//get partial html at end
	str = reReplaceNoCase(str, "<.*$","");
	return trim(str);
}
</cfscript>