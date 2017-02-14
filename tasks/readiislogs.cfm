<cfset logList = "u_ex141016.log">

<cfloop index="i" from="1" to="#listLen(logList)#">

	<cfset fileToRead = "C:\inetpub\logs\LogFiles\W3SVC1\#listGetAt(logList, i)#">
	
	<cfloop index="line" file="#fileToRead#">
	    <!--- ignore lines with # in front --->
	    <!--- except for fields, which will help us define the query, and SHOULD come first --->
	    <!--- also, IIS tends to repeat, so if we have data already, ignore --->
	    <cfif left(line, 1) is "##">
	        <cfif findNoCase("##Fields:", line) is 1 and not isDefined("data")>
	            <cfset cols = replace(line, "##Fields: ","")>
	            <!--- iis has cols with - in it, change to _ --->
	            <cfset cols = replace(cols, "-", "_", "all")>
	            <!--- also may have ...() --->
	            <cfset cols = replace(cols, "(","_","all")>
	            <cfset cols = replace(cols, ")","_","all")>
	            <cfset colArray = listToArray(cols," ")>
	            <!--- search for a col with trailing _, not critical, but nice --->
	            <cfloop index="x" from="1" to="#arrayLen(colArray)#">
	                <cfif right(colArray[x],1) is "_">
	                    <cfset colArray[x] = left(colArray[x], len(colArray[x])-1)>
	                </cfif>
	            </cfloop>
	            <cfset data = queryNew(arrayToList(colArray))>    
	        </cfif>
	    <cfelse>
	        <cfif not isDefined("data") or not isQuery(data)>
	            <cfthrow message="#fileToRead# seems to be invalid. No Fields line found. Line #line#">
	        </cfif>
	    	
	        <cfset queryAddRow(data)>
	
	        <!--- begin parsing --->
	        <cfloop index="x" from="1" to="#arrayLen(colArray)#">
	            <cfset value = listGetAt(line, x," ")>
	            <cfset col = colArray[x]>
	            <cfset querySetCell(data, col, value)>
	        </cfloop>
	
	    </cfif>
	</cfloop>
	
	<cfoutput>#listGetAt(logList, i)#<br>Total number of requests: #data.recordCount#...</cfoutput>
	
	<cfflush>
	<cfquery name="checkLogs" dbtype="query">
	select     *
	from    data
	where (CS_URI_STEM LIKE '%/ABRequest' OR CS_URI_STEM LIKE '%/Registration')
	AND NOT CS_URI_STEM LIKE '%Config%'
	<!---AND NOT CS_URI_QUERY LIKE '%gotvtest%40targetedvictory.com%'--->
	</cfquery>
	<cfset currentVoter = structNew()>
	<cfoutput query="checkLogs">
		<!--- query string --->
		<cfset str = CS_URI_QUERY>
		<cfset queryStringCheck = 1>
		<cftry>
		<!--- local structure --->
		<cfset data = StructNew()>
			<!--- loop our query string values and set them in our structure --->
			<cfloop list="#str#" index="key" delimiters="&">
			    <cfset data["#listFirst(key,'=')#"] = urlDecode(listLast(key,"="))>
			</cfloop>
			<cfcatch><cfset queryStringCheck = 0></cfcatch>
		</cftry>
		<cfif queryStringCheck and isDefined("data.email") and findNoCase("@targetedvictory.com",data.email) eq 0 and findNoCase("petergustafson",data.email) eq 0 and findNoCase("checkett",data.email) eq 0>
			<cfif listLast(CS_URI_STEM,"/") EQ "ABRequest">Absentee<cfset gotv = "Absentee"><cfelse>Reg<cfset gotv = "Reg"></cfif><br>
			#data.email#<br>
			<cfif isDefined("data.fname")>#data.fname#<cfelseif isDefined("data.fname_new_voter_reg")>#data.fname_new_voter_reg#</cfif>
			<cfif isDefined("data.lname")>#data.lname#<cfset lname = data.lname><cfelseif isDefined("data.lname_new_voter_reg")>#data.lname_new_voter_reg#<cfset lname = data.lname_new_voter_reg></cfif><br>
			<cfif isDefined("data.city")>#data.city#<cfset city = data.city><cfelseif isDefined("data.city_new_voter_reg")><cfset city = data.city_new_voter_reg>#data.city_new_voter_reg#</cfif><br>
			<cfif isDefined("data.tel_num")>#data.tel_num#<cfset phone = data.tel_num><cfelseif isDefined("data.cust_telephone_full")><cfset phone = data.cust_telephone_full>#data.cust_telephone_full#</cfif><br>
			<br><br>
			<cfquery name="saveVoter" datasource="GOTV">
				IF EXISTS (SELECT Email FROM Voters WHERE Email = '#data.email#' AND gotv = '#gotv#')
				BEGIN
					UPDATE Voters
					SET Email = '#data.email#'
		           <cfif isDefined("lname")>,[lname] = '#lname#'</cfif>
		           <cfif isDefined("city")>,[rcity] = '#city#'</cfif>
		           <cfif isDefined("phone")>,[tel_area] = '#left(phone,3)#'
				   ,[tel_num] = '#right(replaceNoCase(phone,"-", "", "ALL"),7)#'</cfif>
				   WHERE email = '#data.email#' AND gotv = '#gotv#'
				 END
			</cfquery>
		</cfif>
		<cfif currentRow mod 50 EQ 0><cfflush></cfif>
	</cfoutput>
<br><cfflush>
</cfloop>

<!---<cfdump var="#test#" top="100">--->