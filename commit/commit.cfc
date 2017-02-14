<!--- component with attributes rest and restpath --->
<cfcomponent rest="true"
             restpath="/Commit">
			 	 
	<cffunction name="commitHandler" restpath="{stateAbbr}" httpmethod="GET" displayname="commitHandler" access="remote" output="true" returnFormat="plain" returntype="string">
        
        <cfargument name="stateAbbr" restargsource="Path" type="string" required="true">
		
		<cfset var clientId = 0>		
    	<cfset var userIsAuthorized = application.bypassSecurity>
		<cfinclude template="../security.cfm" runonce="true">
		<cfif NOT userIsAuthorized>
			<cfheader statuscode="403" statustext="Unauthorized API Access">
			<cfreturn "UnauthorizedAccess">
			<cfabort>
		</cfif>
    
    	<cfset var thankYou = structNew()>
    	
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
        
        <!---<cfif clientId EQ 7>
			<cfinclude template="../includes/emails/RNCCivicLocationEmail.cfm">
		<cfelse>
			<cfinclude template="../includes/emails/ClientCivicLocationEmail.cfm">
		</cfif>--->
        
        <cfquery name="saveVoter" datasource="GOTV">
			IF NOT EXISTS (SELECT Email FROM Voters WHERE Email = '#url.email#' AND gotv = 'Commit')
			BEGIN
				INSERT INTO [Voters]
				([email]
				,[gotv]
				,[rsta]
				<cfif isDefined("clientId")>,[client_id]</cfif>
				<cfif isDefined("url.fname")>,[fname]</cfif>
				<cfif isDefined("url.lname")>,[lname]</cfif>
				<cfif isDefined("url.rzip5")>,[rzip5]</cfif>
		        <cfif isDefined("url.referrer")>,[referrer]</cfif>)
				VALUES
				('#url.email#'
				,'Commit'
				,'#arguments.stateAbbr#'
				<cfif isDefined("clientId")>,#clientId#</cfif>
				<cfif isDefined("url.fname")>,'#url.fname#'</cfif>
				<cfif isDefined("url.lname")>,'#url.lname#'</cfif>
				<cfif isDefined("url.rzip5")>,'#url.rzip5#'</cfif>
		        <cfif isDefined("url.referrer")>,'#url.referrer#'</cfif>)
			END
			ELSE
				UPDATE Voters
				SET client_id = #clientId#
				,rsta = '#arguments.stateAbbr#'
				<cfif isDefined("url.fname")>,fname = '#url.fname#'</cfif>
				<cfif isDefined("url.lname")>,lname = '#url.lname#'</cfif>
				<cfif isDefined("url.rzip5")>,rzip5 = '#url.rzip5#'</cfif>
				<cfif isDefined("url.referrer")>,referrer = '#url.referrer#'</cfif>
				WHERE email = '#url.email#' AND gotv = 'Commit'
		</cfquery>
        
        <cfif clientId EQ 7>
			<cfinclude template="../includes/emails/RNCCommitEmail.cfm">
		<cfelse>
			<cfinclude template="../includes/emails/ClientCommitEmail.cfm">
		</cfif>
        
        <cfset thankYou.success = "true">
        
        <cfset var data = thankYou>
            <!--- serialize --->
        <cfset data = serializeJSON(thankYou)>
        
        <cfif structKeyExists(url, "callback")>
			<cfset data = url.callback & "(" & data & ")">
        </cfif>
        
        <cfreturn data>
    </cffunction>
</cfcomponent>