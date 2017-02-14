<!--- component with attributes rest and restpath --->
<cfcomponent rest="true"
             restpath="/Civic">

    <cffunction name="locationLookup" displayname="locationLookup" access="remote" output="true" returnFormat="plain" returntype="string" httpmethod="GET" restpath="/lookup">
		
		<cfset var clientId = 0>		
    	<cfset var userIsAuthorized = application.bypassSecurity>
		<cfinclude template="../security.cfm" runonce="true">
		<cfif NOT userIsAuthorized>
			<cfheader statuscode="403" statustext="Unauthorized API Access">
			<cfreturn "UnauthorizedAccess">
			<cfabort>
		</cfif>
		<cftry>
			<cfhttp  method="get" url="https://www.googleapis.com/civicinfo/v2/voterinfo">
				<cfhttpparam type="url" name="key" value="AIzaSyAFsAI09d_qh5DJ3-KNJCvqM0elvNjtV-4" >
				<cfhttpparam type="url" name="address" value="#urlDecode(url.addressLine1)#, #urlDecode(url.city)#, #url.state#, #url.zip#" >
				<cfhttpparam type="url" name="electionId" value="4101" >
			</cfhttp>
			<cfcatch type="any">
				<cfset returnJson.code = "api error">
				<cfset returnJson.recordFound = "false">
			</cfcatch>
		</cftry>
		<cfset returnJson = structNew()>
		
		<cfif isDefined("cfhttp.FileContent") AND isJson(cfhttp.FileContent) AND len(trim(cfhttp.FileContent)) GT 2>
			<cfset civicData = deserializeJSON(cfhttp.FileContent)>
			<cfif isDefined("civicData.pollingLocations")>
				<cfset address = civicData.pollingLocations[1].address>
				<cfset returnJson.code = "success">
				<cfset returnJson.recordFound = "true">
				<cfif isDefined("address.locationName")>
					<cfset returnJson.locationName = civicData.pollingLocations[1].address.locationName>
				<cfelse>
					<cfset returnJson.locationName = "">
				</cfif>
				<cfset returnJson.address1 = REReplace(civicData.pollingLocations[1].address.line1, "\b(\S)(\S*)\b" , "\u\1\L\2" , "all" )>
				<cfif isDefined("address.line2")>
					<cfset returnJson.address2 = REReplace(civicData.pollingLocations[1].address.line2, "\b(\S)(\S*)\b" , "\u\1\L\2" , "all" )>
				</cfif>
				<cfset returnJson.city = REReplace(civicData.pollingLocations[1].address.city, "\b(\S)(\S*)\b" , "\u\1\L\2" , "all" )>
				<cfset returnJson.state = civicData.pollingLocations[1].address.state>
				<cfif isDefined("address.zip")>
					<cfif civicData.pollingLocations[1].address.zip EQ "00000">
						<cfset returnJson.zip = "">
					<cfelse>
						<cfset returnJson.zip = civicData.pollingLocations[1].address.zip>
					</cfif>
				<cfelse>
					<cfset returnJson.zip = "">
				</cfif>
				<cfif isDefined("address.pollingHours")>
					<cfset returnJson.hours = civicData.pollingLocations[1].pollingHours>
				<cfelse>
					<cfset returnJson.hours = "">
				</cfif>
				<cfset returnJson.mapsURL = "http://maps.google.com/maps?daddr=#civicData.pollingLocations[1].address.line1#,#civicData.pollingLocations[1].address.city#,#civicData.pollingLocations[1].address.state#">
				
				<cfif structKeyExists(url, "email")>
				<cfquery name="saveVoter" datasource="GOTV">
			IF NOT EXISTS (SELECT Email FROM Voters WHERE Email = '#url.email#' AND gotv = 'ED-Civic')
			BEGIN
				INSERT INTO [Voters]
				([email]
				,[gotv]
				,[locationZip]
				<cfif isDefined("clientId")>,[client_id]</cfif>
				<cfif isDefined("url.addressLine1")>,[raddr1]</cfif>
				<cfif isDefined("url.addressLine2")>,[raddr2]</cfif>
				<cfif isDefined("url.city")>,[rcity]</cfif>
				<cfif isDefined("url.state")>,[rsta]</cfif>
				<cfif isDefined("url.zip")>,[rzip5]</cfif>
		        <cfif isDefined("url.referer")>,[referrer]</cfif>)
				VALUES
				('#url.email#'
				,'ED-Civic'
				,'#returnJson.zip#'
				<cfif isDefined("clientId")>,#clientId#</cfif>
				<cfif isDefined("url.addressLine1")>,'#url.addressLine1#'</cfif>
				<cfif isDefined("url.addressLine2")>,'#url.addressLine2#'</cfif>
				<cfif isDefined("url.city")>,'#url.city#'</cfif>
				<cfif isDefined("url.state")>,'#url.state#'</cfif>
				<cfif isDefined("url.zip")>,'#url.zip#'</cfif>
		        <cfif isDefined("url.referer")>,'#url.referer#'</cfif>)
			END
			ELSE
				UPDATE Voters
				SET client_id = #clientId#
				<cfif isDefined("url.addressLine1")>,raddr1 = '#url.addressLine1#'</cfif>
				<cfif isDefined("url.addressLine2")>,raddr2 = '#url.addressLine2#'</cfif>
				<cfif isDefined("url.city")>,rcity = '#url.city#'</cfif>
				<cfif isDefined("url.state")>,rsta = '#url.state#'</cfif>
				<cfif isDefined("url.zip")>,rzip5 = '#url.zip#'</cfif>
				,locationZip = '#returnJson.zip#'
				WHERE email = '#url.email#' AND gotv = 'ED-Civic'
		</cfquery>
				</cfif>
				
			<cfelse>
				
				<cfif structKeyExists(url, "email")>
				<cfquery name="saveVoter" datasource="GOTV">
			IF NOT EXISTS (SELECT Email FROM Voters WHERE Email = '#url.email#' AND gotv = 'ED-Civic')
			BEGIN
				INSERT INTO [Voters]
				([email]
				,[gotv]
				<cfif isDefined("clientId")>,[client_id]</cfif>
				<cfif isDefined("url.addressLine1")>,[raddr1]</cfif>
				<cfif isDefined("url.addressLine2")>,[raddr2]</cfif>
				<cfif isDefined("url.city")>,[rcity]</cfif>
				<cfif isDefined("url.state")>,[rsta]</cfif>
				<cfif isDefined("url.zip")>,[rzip5]</cfif>
		        <cfif isDefined("url.referer")>,[referrer]</cfif>)
				VALUES
				('#url.email#'
				,'ED-Civic'
				<cfif isDefined("clientId")>,#clientId#</cfif>
				<cfif isDefined("url.addressLine1")>,'#url.addressLine1#'</cfif>
				<cfif isDefined("url.addressLine2")>,'#url.addressLine2#'</cfif>
				<cfif isDefined("url.city")>,'#url.city#'</cfif>
				<cfif isDefined("url.state")>,'#url.state#'</cfif>
				<cfif isDefined("url.zip")>,'#url.zip#'</cfif>
		        <cfif isDefined("url.referer")>,'#url.referer#'</cfif>)
			END
			ELSE
				UPDATE Voters
				SET client_id = #clientId#
				<cfif isDefined("url.addressLine1")>,raddr1 = '#url.addressLine1#'</cfif>
				<cfif isDefined("url.addressLine2")>,raddr2 = '#url.addressLine2#'</cfif>
				<cfif isDefined("url.city")>,rcity = '#url.city#'</cfif>
				<cfif isDefined("url.state")>,rsta = '#url.state#'</cfif>
				<cfif isDefined("url.zip")>,rzip5 = '#url.zip#'</cfif>
				,locationZip = ''
				,date_created = GetDate()
				WHERE email = '#url.email#' AND gotv = 'ED-Civic'
		</cfquery>
				</cfif>
				
				<cfset returnJson.code = "record no found">
				<cfset returnJson.recordFound = "false">
			</cfif>
		<cfelse>
				<cfset returnJson.code = "NoContent">
			<cfset returnJson.recordFound = "false">
		</cfif>
		
		<cfset var data = serializeJSON(returnJson)>			
					
		<cfif structKeyExists(url, "callback")>
			<cfset data = url.callback & "(" & data & ")">
        </cfif>
        
        <cfreturn data>
		
	</cffunction>
	<cffunction name="sendLocationEmail" restpath="send" httpmethod="GET" displayname="sendLocationEmail" access="remote" output="true" returnFormat="plain" returntype="string">
        
		
		<cfset var clientId = 0>		
    	<cfset var userIsAuthorized = application.bypassSecurity>
		<cfinclude template="../security.cfm" runonce="true">
		<cfif NOT userIsAuthorized>
			<cfheader statuscode="403" statustext="Unauthorized API Access">
			<cfreturn "UnauthorizedAccess">
			<cfabort>
		</cfif>
    
    	<cfset var locations = structNew()>
    	
    	<cfparam name="url.locationName" default="">
    	<cfparam name="url.locationAddress1" default="">
    	<cfparam name="url.locationAddress2" default="">
    	<cfparam name="url.locationCity" default="">
    	<cfparam name="url.locationState" default="">
    	<cfparam name="url.locationZip" default="">
    	<cfparam name="url.zip" default="">
    	<cfparam name="url.voterAddress1" default="">
    	<cfparam name="url.voterAddress2" default="">
    	<cfparam name="url.voterCity" default="">
    	<cfparam name="url.voterState" default="">
    	<cfparam name="url.voterZip" default="">
    	<cfparam name="url.email" default="">
    	
        <!--- <cfquery name="loc" dataSource="GOTV" cachedwithin="#createTimeSpan(0,0,0,30)#">
        SELECT *
        FROM EarlyVotingLocations
        WHERE LocationId = #arguments.locationId#
        </cfquery>
        <cfif loc.RecordCount>
			<cfset url.zip = loc.ZipCode>
		</cfif>
        
        <cfset var LocationInfo = Replace(loc.HoursOfOperation, " | ", "<br/>", "all")>--->
        
        <cfif clientId EQ 7>
			<cfinclude template="../includes/emails/RNCCivicLocationEmail.cfm">
		<cfelse>
			<cfinclude template="../includes/emails/ClientCivicLocationEmail.cfm">
		</cfif>
        
        <cfquery name="saveVoter" datasource="GOTV">
			IF NOT EXISTS (SELECT Email FROM Voters WHERE Email = '#url.email#' AND gotv = 'ED-Civic')
			BEGIN
				INSERT INTO [Voters]
				([email]
				,[gotv]
				<cfif isDefined("clientId")>,[client_id]</cfif>
				<cfif isDefined("url.address")>,[raddr1]</cfif>
				<cfif isDefined("url.address")>,[raddr2]</cfif>
				<cfif isDefined("url.city")>,[rcity]</cfif>
				<cfif isDefined("url.state")>,[rsta]</cfif>
				<cfif isDefined("url.zipcode")>,[rzip5]</cfif>
				<cfif isDefined("url.locationZip")>,[locationZip]</cfif>
		        <cfif isDefined("url.referer")>,[referrer]</cfif>)
				VALUES
				('#url.email#'
				,'ED-Civic'
				<cfif isDefined("clientId")>,#clientId#</cfif>
				<cfif isDefined("url.address")>,'#url.address#'</cfif>
				<cfif isDefined("url.address2")>,'#url.address2#'</cfif>
				<cfif isDefined("url.city")>,'#url.city#'</cfif>
				<cfif isDefined("url.state")>,'#url.state#'</cfif>
				<cfif isDefined("url.zipcode")>,'#url.zipcode#'</cfif>
				<cfif isDefined("url.locationZip")>,'#url.locationZip#'</cfif>
		        <cfif isDefined("url.referer")>,'#url.referer#'</cfif>)
			END
			ELSE
				UPDATE Voters
				SET client_id = #clientId#
				<cfif isDefined("url.address")>,raddr1 = '#url.address#'</cfif>
				<cfif isDefined("url.address2")>,raddr2 = '#url.address2#'</cfif>
				<cfif isDefined("url.city")>,rcity = '#url.city#'</cfif>
				<cfif isDefined("url.state")>,rsta = '#url.state#'</cfif>
				<cfif isDefined("url.zipcode")>,rzip5 = '#url.zipcode#'</cfif>
				<cfif isDefined("url.locationZip")>,locationZip = '#url.locationZip#'</cfif>
				WHERE email = '#url.email#' AND gotv = 'ED-Civic'
		</cfquery>
        
        <cfset locations.success = "true">
        
        <cfset var data = locations>
            <!--- serialize --->
        <cfset data = serializeJSON(locations)>
        
        <cfif structKeyExists(url, "callback")>
			<cfset data = url.callback & "(" & data & ")">
        </cfif>
        
        <cfreturn data>
    </cffunction>
</cfcomponent>