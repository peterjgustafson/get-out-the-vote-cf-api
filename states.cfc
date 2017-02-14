<cfcomponent rest="true"
             restpath="/States">
	<cffunction name="isAuthorized" access="public" returntype="boolean">
		
		<cfif NOT Session.AuthorizedAPIUser>
			<cfset var userIsAuthorized = false>
			<cfinclude template="security.cfm" runonce="true">
			<cfif userIsAuthorized>
				<cfreturn true>
			<cfelse>
				<cfreturn false>
			</cfif>
		<cfelse>
			<cfreturn true>
		</cfif>
	</cffunction>
	<cffunction name="statesSecureHandler"
                access="remote"
                httpmethod="GET"
                restpath="list/secuityTest"
                returntype="String" 
                produces="text/plain">
					
		<cfset var userIsAuthorized = application.bypassSecurity>
		<cfinclude template="security.cfm" runonce="true">
		<cfif NOT userIsAuthorized>
			<cfheader statuscode="403" statustext="Unauthorized API Access">
			<cfreturn "UnauthorizedAccess">
			<cfabort>
		</cfif>
		
		
		<cfquery name="getStates" dataSource="GOTV">
        SELECT *
        FROM States
        ORDER BY StateFull
        </cfquery>
        <cftry>
        <cfset var states = structNew()>
		<cfset var stateArray = []>
		
        <cfset var i = 0>
        <cfoutput query="getStates">
			<cfset i = i + 1>
			<cfset stateArray[i]["StateFull"] = "#StateFull#">
			<cfset stateArray[i]["State"] = "#State#">
			<cfset stateArray[i]["HasEarlyVote"] = "#HasEarlyVote#">
            <cfset stateArray[i]["ABUseEmailProcess"] = "#ABUseEmailProcess#">
            <cfset stateArray[i]["RegUseEmailProcess"] = "#RegUseEmailProcess#">
            <cfset stateArray[i]["EmailAddress"] = "#EmailAddress#">
            <cfset stateArray[i]["RegEmailAddress"] = "#RegEmailAddress#">
            <cfset stateArray[i]["Address1"] = "#Address1#">
            <cfset stateArray[i]["Address2"] = "#Address2#">
            <cfset stateArray[i]["City"] = "#City#">
            <cfset stateArray[i]["Zip"] = "#Zip#">
            <cfset stateArray[i]["RegAddress1"] = "#RegAddress1#">
            <cfset stateArray[i]["RegAddress2"] = "#RegAddress2#">
            <cfset stateArray[i]["RegCity"] = "#RegCity#">
            <cfset stateArray[i]["RegZip"] = "#RegZip#">
            <cfset stateArray[i]["ABUseCountyClerkContactInfo"] = "#ABUseCountyClerkContactInfo#">
            <cfset stateArray[i]["RegUseCountyClerkContactInfo"] = "#RegUseCountyClerkContactInfo#">
		</cfoutput>
		
		<cfset states.states = stateArray>
        
	        	<cfcatch><cfset states.errorMessage = "#cfcatch.Message#"></cfcatch>
        </cftry>
        
        <cfset var data = serializeJSON(states)>
        
        <cfif structKeyExists(url, "callback")>
			<cfset data = url.callback & "(" & data & ")">
        </cfif>
        
        <cfreturn data>
					
	</cffunction>
	<cffunction name="statesHandler"
                access="remote"
                httpmethod="GET"
                restpath="list"
                returntype="String" 
                produces="text/plain">
					
		<cfset var userIsAuthorized = application.bypassSecurity>
		<cfinclude template="security.cfm" runonce="true">
		<cfif NOT userIsAuthorized>
			<cfheader statuscode="403" statustext="Unauthorized API Access">
			<cfreturn "UnauthorizedAccess">
			<cfabort>
		</cfif>
		
		
		<cfquery name="getStates" dataSource="GOTV">
        SELECT *
        FROM States
        ORDER BY StateFull
        </cfquery>
        <cftry>
        <cfset var states = structNew()>
		<cfset var stateArray = []>
		
        <cfset var i = 0>
        <cfoutput query="getStates">
			<cfset i = i + 1>
			<cfset stateArray[i]["StateFull"] = "#StateFull#">
			<cfset stateArray[i]["State"] = "#State#">
			<cfset stateArray[i]["HasEarlyVote"] = "#HasEarlyVote#">
            <cfset stateArray[i]["ABUseEmailProcess"] = "#ABUseEmailProcess#">
            <cfset stateArray[i]["RegUseEmailProcess"] = "#RegUseEmailProcess#">
            <cfset stateArray[i]["EmailAddress"] = "#EmailAddress#">
            <cfset stateArray[i]["RegEmailAddress"] = "#RegEmailAddress#">
            <cfset stateArray[i]["Address1"] = "#Address1#">
            <cfset stateArray[i]["Address2"] = "#Address2#">
            <cfset stateArray[i]["City"] = "#City#">
            <cfset stateArray[i]["Zip"] = "#Zip#">
            <cfset stateArray[i]["ABOfficeName"] = "#ABOfficeName#">
            <cfset stateArray[i]["RegOfficeName"] = "#RegOfficeName#">
            <cfset stateArray[i]["RegAddress1"] = "#RegAddress1#">
            <cfset stateArray[i]["RegAddress2"] = "#RegAddress2#">
            <cfset stateArray[i]["RegCity"] = "#RegCity#">
            <cfset stateArray[i]["RegZip"] = "#RegZip#">
            <cfset stateArray[i]["ABUseCountyClerkContactInfo"] = "#ABUseCountyClerkContactInfo#">
            <cfset stateArray[i]["RegUseCountyClerkContactInfo"] = "#RegUseCountyClerkContactInfo#">
		</cfoutput>
		
		<cfset states.states = stateArray>
        
	        	<cfcatch><cfset states.errorMessage = "#cfcatch.Message#"></cfcatch>
        </cftry>
        
        <cfset var data = serializeJSON(states)>
        
        <cfif structKeyExists(url, "callback")>
			<cfset data = url.callback & "(" & data & ")">
        </cfif>
        
        <cfreturn data>
					
	</cffunction>
    
    <cffunction name="stateHandler"
                access="remote"
                httpmethod="GET"
                restpath="{statecode}"
                returntype="String" 
                produces="text/plain">
					
				<cfargument name="statecode"
                    required="true"
                    restargsource="Path"
                    type="string"/>
					
		<cfset var userIsAuthorized = application.bypassSecurity>
		<cfinclude template="security.cfm" runonce="true">
		<cfif NOT userIsAuthorized>
			<cfheader statuscode="403" statustext="Unauthorized API Access">
			<cfreturn "UnauthorizedAccess">
			<cfabort>
		</cfif>
		
        <cfset var states = structNew()>
		
        <cftry>
		<cfset var stateArray = []>
		
		<cfquery name="getStates" dataSource="GOTV">
        SELECT *
        FROM States
        WHERE State = '#arguments.statecode#';
        </cfquery>
		
        <cfset var i = 0>
		<cfif getStates.recordCount>
	         <cfoutput query="getStates">
				<cfset i = i + 1>
				<cfset stateArray[i]["StateFull"] = "#StateFull#">
				<cfset stateArray[i]["State"] = "#State#">
				<cfset stateArray[i]["HasEarlyVote"] = "#HasEarlyVote#">
	            <cfset stateArray[i]["ABUseEmailProcess"] = "#ABUseEmailProcess#">
	            <cfset stateArray[i]["RegUseEmailProcess"] = "#RegUseEmailProcess#">
	            <cfset stateArray[i]["EmailAddress"] = "#EmailAddress#">
	            <cfset stateArray[i]["RegEmailAddress"] = "#RegEmailAddress#">
	            <cfset stateArray[i]["Address1"] = "#Address1#">
	            <cfset stateArray[i]["Address2"] = "#Address2#">
	            <cfset stateArray[i]["City"] = "#City#">
	            <cfset stateArray[i]["Zip"] = "#Zip#">
            	<cfset stateArray[i]["ABOfficeName"] = "#ABOfficeName#">
            	<cfset stateArray[i]["RegOfficeName"] = "#RegOfficeName#">
	            <cfset stateArray[i]["RegAddress1"] = "#RegAddress1#">
	            <cfset stateArray[i]["RegAddress2"] = "#RegAddress2#">
	            <cfset stateArray[i]["RegCity"] = "#RegCity#">
	            <cfset stateArray[i]["RegZip"] = "#RegZip#">
	            <cfset stateArray[i]["ABUseCountyClerkContactInfo"] = "#ABUseCountyClerkContactInfo#">
	            <cfset stateArray[i]["RegUseCountyClerkContactInfo"] = "#RegUseCountyClerkContactInfo#">
			</cfoutput>
		<cfelse>
			<cfset states.errorMessage = "No Records Found">
			<cfsavecontent variable="statesQuery">
			SELECT *
	        FROM States
	        WHERE State = '#arguments.statecode#'
	        ORDER BY StateFull;
			</cfsavecontent>
			<cfset states.queryInfo = "#statesQuery#">
		</cfif>
		
		<cfset states.state = stateArray>
        
             	<cfcatch><cfset states.errorMessage = "#cfcatch.Message#"></cfcatch>
        </cftry>
        
        <cfset var data = serializeJSON(states)>
        
        <cfif structKeyExists(url, "callback")>
			<cfset data = url.callback & "(" & data & ")">
        </cfif>
        
        <cfreturn data>
					
	</cffunction>
	<cffunction name="putStateHandler"
                access="remote"
                httpmethod="PUT"
                restpath="{statecode}"
                returntype="String" 
                produces="text/plain">
				
				<cfargument name="statecode"
                    required="true"
                    restargsource="Path"
                    type="string"/>
					
		<cfset var userIsAuthorized = application.bypassSecurity>
		<cfinclude template="security.cfm" runonce="true">
		<cfif NOT userIsAuthorized>
			<cfheader statuscode="403" statustext="Unauthorized API Access">
			<cfreturn "UnauthorizedAccess">
			<cfabort>
		</cfif>
					
		<cfset requestBody = toString( getHttpRequestData().content ) />
		
        <cfset var states = structNew()>
		
		<cfif isJSON( requestBody )>
		 
		    <!--- Echo back POST data. --->
		    <cfset requestObject = deserializeJSON(requestBody)>
		    <cfset newStateObject = requestObject.State>
		 
		</cfif>
		
        <cftry>
		<cfset var stateArray = []>
		
		<cfquery name="saveState" dataSource="GOTV">
        UPDATE States
		SET HasEarlyVote = '#newStateObject[1].HasEarlyVote#',
		ABUseEmailProcess = #newStateObject[1].ABUseEmailProcess#,
		RegUseEmailProcess = #newStateObject[1].RegUseEmailProcess#,
		EmailAddress = '#newStateObject[1].EmailAddress#',
		Address1 = '#newStateObject[1].Address1#',
		Address2 = '#newStateObject[1].Address2#',
		City = '#newStateObject[1].City#',
		Zip = '#newStateObject[1].Zip#'<cfif structKeyExists(newStateObject[1], "RegAddress1")>,
			RegEmailAddress = '#newStateObject[1].RegEmailAddress#',
			RegAddress1 = '#newStateObject[1].RegAddress1#',
			RegAddress2 = '#newStateObject[1].RegAddress2#',
			RegCity = '#newStateObject[1].RegCity#',
			RegZip = '#newStateObject[1].RegZip#'</cfif>
			<cfif structKeyExists(newStateObject[1], "ABUseCountyClerkContactInfo") and len(newStateObject[1].ABUseCountyClerkContactInfo)>,
			ABUseCountyClerkContactInfo = #newStateObject[1].ABUseCountyClerkContactInfo#</cfif>
			<cfif structKeyExists(newStateObject[1], "RegUseCountyClerkContactInfo") and len(newStateObject[1].RegUseCountyClerkContactInfo)>,
			RegUseCountyClerkContactInfo = #newStateObject[1].RegUseCountyClerkContactInfo#</cfif>
			<cfif structKeyExists(newStateObject[1], "ABOfficeName") and len(newStateObject[1].ABOfficeName)>,
			ABOfficeName = '#newStateObject[1].ABOfficeName#'</cfif>
			<cfif structKeyExists(newStateObject[1], "RegOfficeName") and len(newStateObject[1].RegOfficeName)>,
			RegOfficeName = '#newStateObject[1].RegOfficeName#'</cfif>
		WHERE State = '#arguments.statecode#';
		SELECT *
        FROM States
        WHERE State = '#arguments.statecode#'
        </cfquery>
		
        <cfset var i = 0>
		<cfoutput query="saveState">
			<cfset i = i + 1>
				<cfset stateArray[i]["StateFull"] = "#StateFull#">
				<cfset stateArray[i]["State"] = "#State#">
				<cfset stateArray[i]["HasEarlyVote"] = "#HasEarlyVote#">
	            <cfset stateArray[i]["ABUseEmailProcess"] = "#ABUseEmailProcess#">
	            <cfset stateArray[i]["RegUseEmailProcess"] = "#RegUseEmailProcess#">
	            <cfset stateArray[i]["EmailAddress"] = "#EmailAddress#">
	            <cfset stateArray[i]["RegEmailAddress"] = "#RegEmailAddress#">
	            <cfset stateArray[i]["Address1"] = "#Address1#">
	            <cfset stateArray[i]["Address2"] = "#Address2#">
	            <cfset stateArray[i]["City"] = "#City#">
	            <cfset stateArray[i]["Zip"] = "#Zip#">
            	<cfset stateArray[i]["ABOfficeName"] = "#ABOfficeName#">
            	<cfset stateArray[i]["RegOfficeName"] = "#RegOfficeName#">
	            <cfset stateArray[i]["RegAddress1"] = "#RegAddress1#">
	            <cfset stateArray[i]["RegAddress2"] = "#RegAddress2#">
	            <cfset stateArray[i]["RegCity"] = "#RegCity#">
	            <cfset stateArray[i]["RegZip"] = "#RegZip#">
	            <cfset stateArray[i]["ABUseCountyClerkContactInfo"] = "#ABUseCountyClerkContactInfo#">
	            <cfset stateArray[i]["RegUseCountyClerkContactInfo"] = "#RegUseCountyClerkContactInfo#">
		</cfoutput>
		
		<cfset states.states = stateArray>
        
             	<cfcatch>
				 <cfset states.errorMessage = "#cfcatch.Message#">
				 <cfif states.errorMessage EQ "Error Executing Database Query.">
				 <cfset states.errorMessage = states.errorMessage & " #cfcatch.SQL#">
				 </cfif>
				 </cfcatch>
        </cftry>
        
        <cfset var data = serializeJSON(states)>
        
        <cfif structKeyExists(url, "callback")>
			<cfset data = url.callback & "(" & data & ")">
        </cfif>
        
        <cfreturn data>
					
	</cffunction>
	<cffunction name="countiesHandler"
                access="remote"
                httpmethod="GET"
                restpath="counties/list/{statecode}"
                returntype="String" 
                produces="text/plain">
					
				<cfargument name="statecode"
                    required="true"
                    restargsource="Path"
                    type="string"/>
					
		<cfset var userIsAuthorized = application.bypassSecurity>
		<cfinclude template="security.cfm" runonce="true">
		<cfif NOT userIsAuthorized>
			<cfheader statuscode="403" statustext="Unauthorized API Access">
			<cfreturn "UnauthorizedAccess">
			<cfabort>
		</cfif>
				
		<cfquery name="getStates" dataSource="GOTV">
        SELECT     dbo.States.State, dbo.Counties_Master.state_name, dbo.Counties_Master.county_name, dbo.Counties_Master.county_key, dbo.Counties_Master.ClerkAddress1, 
                      dbo.Counties_Master.ClerkAddress2, dbo.Counties_Master.ClerkCity, dbo.Counties_Master.ClerkZip, dbo.Counties_Master.ClerkEmailAddress, 
                      dbo.Counties_Master.RegEmailAddress, dbo.Counties_Master.RegAddress1, dbo.Counties_Master.RegAddress2, dbo.Counties_Master.RegCity, 
                      dbo.Counties_Master.RegZip, dbo.Counties_Master.ABMailToMunicipality, dbo.Counties_Master.RegMailToMunicipality, dbo.Counties_Master.OfficialOfficeName, dbo.Counties_Master.ClerkPhone, dbo.Counties_Master.ClerkFax, dbo.Counties_Master.ClerkFullName
FROM         dbo.Counties_Master INNER JOIN
                      dbo.States ON dbo.Counties_Master.state_name = dbo.States.StateFull
WHERE dbo.States.State = '#arguments.statecode#'
        </cfquery>
        <cftry>
        <cfset var counties = structNew()>
		<cfset var countiesArray = []>
		
        <cfset var i = 0>
        <cfoutput query="getStates">
			<cfset i = i + 1>
			<cfset countiesArray[i]["StateFull"] = "#state_name#">
			<cfset countiesArray[i]["State"] = "#State#">
			<cfset countiesArray[i]["CountyName"] = "#county_name#">
            <cfset countiesArray[i]["CountyId"] = "#county_key#">
            <cfset countiesArray[i]["OfficialOfficeName"] = "#OfficialOfficeName#">
            <cfset countiesArray[i]["ClerkFullName"] = "#ClerkFullName#">
            <cfset countiesArray[i]["ClerkEmailAddress"] = "#ClerkEmailAddress#">
            <cfset countiesArray[i]["ClerkPhone"] = "#ClerkPhone#">
            <cfset countiesArray[i]["ClerkFax"] = "#ClerkFax#">
            <cfset countiesArray[i]["ClerkAddress1"] = "#ClerkAddress1#">
            <cfset countiesArray[i]["ClerkAddress2"] = "#ClerkAddress2#">
            <cfset countiesArray[i]["ClerkCity"] = "#ClerkCity#">
            <cfset countiesArray[i]["ClerkZip"] = "#ClerkZip#">
            <cfset countiesArray[i]["RegEmailAddress"] = "#RegEmailAddress#">
            <cfset countiesArray[i]["RegAddress1"] = "#RegAddress1#">
            <cfset countiesArray[i]["RegAddress2"] = "#RegAddress2#">
            <cfset countiesArray[i]["RegCity"] = "#RegCity#">
            <cfset countiesArray[i]["RegZip"] = "#RegZip#">
            <cfset countiesArray[i]["ABMailToMunicipality"] = "#ABMailToMunicipality#">
            <cfset countiesArray[i]["RegMailToMunicipality"] = "#RegMailToMunicipality#">
		</cfoutput>
		
		<cfset counties.counties = countiesArray>
        
	        	<cfcatch><cfset counties.errorMessage = "#cfcatch.Message#"></cfcatch>
        </cftry>
        
        <cfset var data = serializeJSON(counties)>
        
        <cfif structKeyExists(url, "callback")>
			<cfset data = url.callback & "(" & data & ")">
        </cfif>
        
        <cfreturn data>
					
	</cffunction>
	<cffunction name="countyHandler"
                access="remote"
                httpmethod="GET"
                restpath="counties/{countyId}"
                returntype="String" 
                produces="text/plain">
					
				<cfargument name="countyId"
                    required="true"
                    restargsource="Path"
                    type="numeric" />
                    
        <cfset var userIsAuthorized = application.bypassSecurity>
		<cfinclude template="security.cfm" runonce="true">
		<cfif NOT userIsAuthorized>
			<cfheader statuscode="403" statustext="Unauthorized API Access">
			<cfreturn "UnauthorizedAccess">
			<cfabort>
		</cfif>
				
		<cfquery name="getStates" dataSource="GOTV">
        SELECT     dbo.States.State, dbo.Counties_Master.state_name, dbo.Counties_Master.county_name, dbo.Counties_Master.county_key, dbo.Counties_Master.ClerkAddress1, 
                      dbo.Counties_Master.ClerkAddress2, dbo.Counties_Master.ClerkCity, dbo.Counties_Master.ClerkZip, dbo.Counties_Master.ClerkEmailAddress, 
                      dbo.Counties_Master.RegEmailAddress, dbo.Counties_Master.RegAddress1, dbo.Counties_Master.RegAddress2, dbo.Counties_Master.RegCity, 
                      dbo.Counties_Master.RegZip, dbo.Counties_Master.ABMailToMunicipality, dbo.Counties_Master.RegMailToMunicipality, dbo.Counties_Master.OfficialOfficeName, dbo.Counties_Master.ClerkPhone, dbo.Counties_Master.ClerkFax, dbo.Counties_Master.ClerkFullName
FROM         dbo.Counties_Master INNER JOIN
                      dbo.States ON dbo.Counties_Master.state_name = dbo.States.StateFull
WHERE dbo.Counties_Master.county_key = '#arguments.countyId#'
        </cfquery>
        <cftry>
        <cfset var counties = structNew()>
		<cfset var countiesArray = []>
		
        <cfset var i = 0>
        <cfoutput query="getStates">
			<cfset i = i + 1>
			<cfset countiesArray[i]["StateFull"] = "#state_name#">
			<cfset countiesArray[i]["State"] = "#State#">
			<cfset countiesArray[i]["CountyName"] = "#county_name#">
            <cfset countiesArray[i]["CountyId"] = "#county_key#">
            <cfset countiesArray[i]["OfficialOfficeName"] = "#OfficialOfficeName#">
            <cfset countiesArray[i]["ClerkFullName"] = "#ClerkFullName#">
            <cfset countiesArray[i]["ClerkEmailAddress"] = "#ClerkEmailAddress#">
            <cfset countiesArray[i]["ClerkPhone"] = "#ClerkPhone#">
            <cfset countiesArray[i]["ClerkFax"] = "#ClerkFax#">
            <cfset countiesArray[i]["ClerkAddress1"] = "#ClerkAddress1#">
            <cfset countiesArray[i]["ClerkAddress2"] = "#ClerkAddress2#">
            <cfset countiesArray[i]["ClerkCity"] = "#ClerkCity#">
            <cfset countiesArray[i]["ClerkZip"] = "#ClerkZip#">
            <cfset countiesArray[i]["RegEmailAddress"] = "#RegEmailAddress#">
            <cfset countiesArray[i]["RegAddress1"] = "#RegAddress1#">
            <cfset countiesArray[i]["RegAddress2"] = "#RegAddress2#">
            <cfset countiesArray[i]["RegCity"] = "#RegCity#">
            <cfset countiesArray[i]["RegZip"] = "#RegZip#">
            <cfset countiesArray[i]["ABMailToMunicipality"] = "#ABMailToMunicipality#">
            <cfset countiesArray[i]["RegMailToMunicipality"] = "#RegMailToMunicipality#">
		</cfoutput>
		
		<cfset counties.county = countiesArray>
        
	        	<cfcatch><cfset states.errorMessage = "#cfcatch.Message#"></cfcatch>
        </cftry>
        
        <cfset var data = serializeJSON(counties)>
        
        <cfif structKeyExists(url, "callback")>
			<cfset data = url.callback & "(" & data & ")">
        </cfif>
        
        <cfreturn data>
					
	</cffunction>
	<cffunction name="countyPutHandler"
                access="remote"
                httpmethod="PUT"
                restpath="counties/{countyId}"
                returntype="String" 
                produces="text/plain">
		
					
				<cfargument name="countyId"
                    required="true"
                    restargsource="Path"
                    type="numeric" />
                    
        <cfset var userIsAuthorized = application.bypassSecurity>
		<cfinclude template="security.cfm" runonce="true">
		<cfif NOT userIsAuthorized>
			<cfheader statuscode="403" statustext="Unauthorized API Access">
			<cfreturn "UnauthorizedAccess">
			<cfabort>
		</cfif>
				
		<cfset requestBody = toString( getHttpRequestData().content ) />
			
		<cfif isJSON( requestBody )>
		 
		    <!--- Echo back POST data. --->
		    <cfset requestObject = deserializeJSON(requestBody)>
		    <cfset newCountyObject = requestObject.County>
		 
		</cfif>
		
        <cftry>
        <cfset var counties = structNew()>
		<cfset var countiesArray = []>
		
		<cfquery name="saveCounty" dataSource="GOTV">
        UPDATE Counties_Master
		SET ClerkEmailAddress = '#newCountyObject[1].ClerkEmailAddress#',
		ClerkAddress1 = '#newCountyObject[1].ClerkAddress1#',
		ClerkAddress2 = '#newCountyObject[1].ClerkAddress2#',
		ClerkCity = '#newCountyObject[1].ClerkCity#',
		ClerkZip = '#newCountyObject[1].ClerkZip#'<cfif structKeyExists(newCountyObject[1], "RegAddress1")>,
			RegEmailAddress = '#newCountyObject[1].RegEmailAddress#',
			RegAddress1 = '#newCountyObject[1].RegAddress1#',
			RegAddress2 = '#newCountyObject[1].RegAddress2#',
			RegCity = '#newCountyObject[1].RegCity#',
			RegZip = '#newCountyObject[1].RegZip#'
		</cfif>
			<cfif structKeyExists(newCountyObject[1], "ABMailToMunicipality") and len(newCountyObject[1].ABMailToMunicipality)>,
			ABMailToMunicipality = #newCountyObject[1].ABMailToMunicipality#</cfif>
			<cfif structKeyExists(newCountyObject[1], "RegMailToMunicipality") and len(newCountyObject[1].RegMailToMunicipality)>,
			RegMailToMunicipality = #newCountyObject[1].RegMailToMunicipality#</cfif>
			<cfif structKeyExists(newCountyObject[1], "OfficialOfficeName")>,
			OfficialOfficeName = '#newCountyObject[1].OfficialOfficeName#'</cfif>
			<cfif structKeyExists(newCountyObject[1], "ClerkPhone")>,
			ClerkPhone = '#newCountyObject[1].ClerkPhone#'</cfif>
			<cfif structKeyExists(newCountyObject[1], "ClerkFax")>,
			ClerkFax = '#newCountyObject[1].ClerkFax#'</cfif>
			<cfif structKeyExists(newCountyObject[1], "ClerkFullName")>,
			ClerkFullName = '#newCountyObject[1].ClerkFullName#'</cfif>
		WHERE county_key = #newCountyObject[1].CountyId#;
        SELECT     dbo.States.State, dbo.Counties_Master.state_name, dbo.Counties_Master.county_name, dbo.Counties_Master.county_key, dbo.Counties_Master.ClerkAddress1, 
                      dbo.Counties_Master.ClerkAddress2, dbo.Counties_Master.ClerkCity, dbo.Counties_Master.ClerkZip, dbo.Counties_Master.ClerkEmailAddress, 
                      dbo.Counties_Master.RegEmailAddress, dbo.Counties_Master.RegAddress1, dbo.Counties_Master.RegAddress2, dbo.Counties_Master.RegCity, 
                      dbo.Counties_Master.RegZip, dbo.Counties_Master.ABMailToMunicipality, dbo.Counties_Master.RegMailToMunicipality, dbo.Counties_Master.OfficialOfficeName, dbo.Counties_Master.ClerkPhone, dbo.Counties_Master.ClerkFax, dbo.Counties_Master.ClerkFullName
		FROM         dbo.Counties_Master INNER JOIN dbo.States ON dbo.Counties_Master.state_name = dbo.States.StateFull
		WHERE dbo.Counties_Master.county_key = #arguments.countyId#;
        </cfquery>
		
        <cfset var i = 0>
        <cfoutput query="saveCounty">
			<cfset i = i + 1>
			<cfset countiesArray[i]["StateFull"] = "#state_name#">
			<cfset countiesArray[i]["State"] = "#State#">
			<cfset countiesArray[i]["CountyName"] = "#county_name#">
            <cfset countiesArray[i]["CountyId"] = "#county_key#">
            <cfset countiesArray[i]["OfficialOfficeName"] = "#OfficialOfficeName#">
            <cfset countiesArray[i]["ClerkFullName"] = "#ClerkFullName#">
            <cfset countiesArray[i]["ClerkEmailAddress"] = "#ClerkEmailAddress#">
            <cfset countiesArray[i]["ClerkPhone"] = "#ClerkPhone#">
            <cfset countiesArray[i]["ClerkFax"] = "#ClerkFax#">
            <cfset countiesArray[i]["ClerkAddress1"] = "#ClerkAddress1#">
            <cfset countiesArray[i]["ClerkAddress2"] = "#ClerkAddress2#">
            <cfset countiesArray[i]["ClerkCity"] = "#ClerkCity#">
            <cfset countiesArray[i]["ClerkZip"] = "#ClerkZip#">
            <cfset countiesArray[i]["RegEmailAddress"] = "#RegEmailAddress#">
            <cfset countiesArray[i]["RegAddress1"] = "#RegAddress1#">
            <cfset countiesArray[i]["RegAddress2"] = "#RegAddress2#">
            <cfset countiesArray[i]["RegCity"] = "#RegCity#">
            <cfset countiesArray[i]["RegZip"] = "#RegZip#">
            <cfset countiesArray[i]["ABMailToMunicipality"] = "#ABMailToMunicipality#">
            <cfset countiesArray[i]["RegMailToMunicipality"] = "#RegMailToMunicipality#">
		</cfoutput>
		
		<cfset counties.county = countiesArray>
        
	        	<cfcatch>
					<cfset counties.errorMessage = "#cfcatch.Message#">
					<cfif counties.errorMessage EQ "Error Executing Database Query.">
				 		<cfset counties.sqlError = "#cfcatch.SQL#">
				 	</cfif>
				 </cfcatch>
        </cftry>
        
        <cfset var data = serializeJSON(counties)>
        
        <cfif structKeyExists(url, "callback")>
			<cfset data = url.callback & "(" & data & ")">
        </cfif>
        
        <cfreturn data>
					
	</cffunction>
	
<cffunction name="munyListHandler"
                access="remote"
                httpmethod="GET"
                restpath="counties/municipalities/list/{countyId}"
                returntype="String" 
                produces="text/plain">
					
				<cfargument name="countyId"
                    required="true"
                    restargsource="Path"
                    type="numeric"/>
					
		<cfset var userIsAuthorized = application.bypassSecurity>
		<cfinclude template="security.cfm" runonce="true">
		<cfif NOT userIsAuthorized>
			<cfheader statuscode="403" statustext="Unauthorized API Access">
			<cfreturn "UnauthorizedAccess">
			<cfabort>
		</cfif>
		
        <cftry>		
		<cfquery name="getStates" dataSource="GOTV">
        SELECT     dbo.States.StateFull, dbo.States.State, dbo.Counties_Master.county_key, dbo.Counties_Master.county_name, dbo.Municipalities.MunicipalityId, 
                      dbo.Municipalities.MunicipalityName, dbo.Municipalities.county_key AS Expr1, dbo.Municipalities.ABEmailAddress, dbo.Municipalities.ABAddress1, 
                      dbo.Municipalities.ABAddress2, dbo.Municipalities.ABCity, dbo.Municipalities.ABZip, dbo.Municipalities.RegEmailAddress, dbo.Municipalities.RegAddress1,
                      dbo.Municipalities.RegAddress2, dbo.Municipalities.RegCity, dbo.Municipalities.RegZip, dbo.Municipalities.ClerkFullName, dbo.Municipalities.OfficialOfficeName, dbo.Municipalities.Phone, dbo.Municipalities.Fax
FROM         dbo.Counties_Master INNER JOIN
                      dbo.Municipalities ON dbo.Counties_Master.county_key = dbo.Municipalities.county_key INNER JOIN
                      dbo.States ON dbo.Counties_Master.state_name = dbo.States.StateFull
WHERE dbo.Counties_Master.county_key = '#arguments.countyId#'
        </cfquery>
        <cfset var municipalities = structNew()>
		<cfset var municipalitiesArray = []>
		
        <cfset var i = 0>
        <cfoutput query="getStates">
			<cfset i = i + 1>
			<cfset municipalitiesArray[i]["StateFull"] = "#StateFull#">
			<cfset municipalitiesArray[i]["State"] = "#State#">
			<cfset municipalitiesArray[i]["CountyName"] = "#county_name#">
            <cfset municipalitiesArray[i]["CountyId"] = "#county_key#">
            <cfset municipalitiesArray[i]["MunicipalityName"] = "#MunicipalityName#">
            <cfset municipalitiesArray[i]["MunicipalityId"] = "#MunicipalityId#">
            <cfset municipalitiesArray[i]["ClerkFullName"] = "#ClerkFullName#">
            <cfset municipalitiesArray[i]["OfficialOfficeName"] = "#OfficialOfficeName#">
            <cfset municipalitiesArray[i]["Phone"] = "#Phone#">
            <cfset municipalitiesArray[i]["Fax"] = "#Fax#">
            <cfset municipalitiesArray[i]["ABEmailAddress"] = "#ABEmailAddress#">
            <cfset municipalitiesArray[i]["ABAddress1"] = "#ABAddress1#">
            <cfset municipalitiesArray[i]["ABAddress2"] = "#ABAddress2#">
            <cfset municipalitiesArray[i]["ABCity"] = "#ABCity#">
            <cfset municipalitiesArray[i]["ABZip"] = "#ABZip#">
            <cfset municipalitiesArray[i]["RegEmailAddress"] = "#RegEmailAddress#">
            <cfset municipalitiesArray[i]["RegAddress1"] = "#RegAddress1#">
            <cfset municipalitiesArray[i]["RegAddress2"] = "#RegAddress1#">
            <cfset municipalitiesArray[i]["RegCity"] = "#RegCity#">
            <cfset municipalitiesArray[i]["RegZip"] = "#RegZip#">
		</cfoutput>
		
		<cfset municipalities.municipalities = municipalitiesArray>
        
	        	<cfcatch><cfset municipalities.errorMessage = "#cfcatch.Message#"></cfcatch>
        </cftry>
        
        <cfset var data = serializeJSON(municipalities)>
        
        <cfif structKeyExists(url, "callback")>
			<cfset data = url.callback & "(" & data & ")">
        </cfif>
        
        <cfreturn data>
					
	</cffunction>
	<cffunction name="munyHandler"
                access="remote"
                httpmethod="GET"
                restpath="municipalities/{municipalityId}"
                returntype="String" 
                produces="text/plain">
					
				<cfargument name="municipalityId"
                    required="true"
                    restargsource="Path"
                    type="numeric" />	
				
		<cfset var userIsAuthorized = application.bypassSecurity>
		<cfinclude template="security.cfm" runonce="true">
		<cfif NOT userIsAuthorized>
			<cfheader statuscode="403" statustext="Unauthorized API Access">
			<cfreturn "UnauthorizedAccess">
			<cfabort>
		</cfif>
				
		<cfquery name="getStates" dataSource="GOTV">
        SELECT     dbo.States.StateFull, dbo.States.State, dbo.Counties_Master.county_key, dbo.Counties_Master.county_name, dbo.Municipalities.MunicipalityId, 
                      dbo.Municipalities.MunicipalityName, dbo.Municipalities.county_key AS Expr1, dbo.Municipalities.ABEmailAddress, dbo.Municipalities.ABAddress1, 
                      dbo.Municipalities.ABAddress2, dbo.Municipalities.ABCity, dbo.Municipalities.ABZip, dbo.Municipalities.RegEmailAddress, dbo.Municipalities.RegAddress1, 
                      dbo.Municipalities.RegAddress2, dbo.Municipalities.RegCity, dbo.Municipalities.RegZip, dbo.Municipalities.ClerkFullName, dbo.Municipalities.OfficialOfficeName, dbo.Municipalities.Phone, dbo.Municipalities.Fax
FROM         dbo.Counties_Master INNER JOIN
                      dbo.Municipalities ON dbo.Counties_Master.county_key = dbo.Municipalities.county_key INNER JOIN
                      dbo.States ON dbo.Counties_Master.state_name = dbo.States.StateFull
WHERE dbo.Municipalities.MunicipalityId = '#arguments.municipalityId#'
        </cfquery>
        <cftry>
        <cfset var municipalities = structNew()>
		<cfset var municipalitiesArray = []>
		
        <cfset var i = 0>
        <cfoutput query="getStates">
			<cfset i = i + 1>
			<cfset municipalitiesArray[i]["StateFull"] = "#StateFull#">
			<cfset municipalitiesArray[i]["State"] = "#State#">
			<cfset municipalitiesArray[i]["CountyName"] = "#county_name#">
            <cfset municipalitiesArray[i]["CountyId"] = "#county_key#">
            <cfset municipalitiesArray[i]["MunicipalityName"] = "#MunicipalityName#">
            <cfset municipalitiesArray[i]["MunicipalityId"] = "#MunicipalityId#">
            <cfset municipalitiesArray[i]["ClerkFullName"] = "#ClerkFullName#">
            <cfset municipalitiesArray[i]["OfficialOfficeName"] = "#OfficialOfficeName#">
            <cfset municipalitiesArray[i]["Phone"] = "#Phone#">
            <cfset municipalitiesArray[i]["Fax"] = "#Fax#">
            <cfset municipalitiesArray[i]["ABEmailAddress"] = "#ABEmailAddress#">
            <cfset municipalitiesArray[i]["ABAddress1"] = "#ABAddress1#">
            <cfset municipalitiesArray[i]["ABAddress2"] = "#ABAddress2#">
            <cfset municipalitiesArray[i]["ABCity"] = "#ABCity#">
            <cfset municipalitiesArray[i]["ABZip"] = "#ABZip#">
            <cfset municipalitiesArray[i]["RegEmailAddress"] = "#RegEmailAddress#">
            <cfset municipalitiesArray[i]["RegAddress1"] = "#RegAddress1#">
            <cfset municipalitiesArray[i]["RegAddress2"] = "#RegAddress1#">
            <cfset municipalitiesArray[i]["RegCity"] = "#RegCity#">
            <cfset municipalitiesArray[i]["RegZip"] = "#RegZip#">
		</cfoutput>
		
		<cfset municipalities.municipality = municipalitiesArray>
        
	        	<cfcatch><cfset states.errorMessage = "#cfcatch.Message#"></cfcatch>
        </cftry>
        
        <cfset var data = serializeJSON(municipalities)>
        
        <cfif structKeyExists(url, "callback")>
			<cfset data = url.callback & "(" & data & ")">
        </cfif>
        
        <cfreturn data>
					
	</cffunction>
	<cffunction name="munyPutHandler"
                access="remote"
                httpmethod="PUT"
                restpath="municipalities/{municipalityId}"
                returntype="String" 
                produces="text/plain">
		
					
				<cfargument name="municipalityId"
                    required="true"
                    restargsource="Path"
                    type="numeric" />
                    
        <cfset var userIsAuthorized = application.bypassSecurity>
		<cfinclude template="security.cfm" runonce="true">
		<cfif NOT userIsAuthorized>
			<cfheader statuscode="403" statustext="Unauthorized API Access">
			<cfreturn "UnauthorizedAccess">
			<cfabort>
		</cfif>
				
		<cfset requestBody = toString( getHttpRequestData().content ) />
			
		<cfif isJSON( requestBody )>
		 
		    <!--- Echo back POST data. --->
		    <cfset requestObject = deserializeJSON(requestBody)>
		    <cfset newCountyObject = requestObject.Municipality>
		 
		</cfif>
		
        <cftry>
        <cfset var municipalities = structNew()>
		<cfset var municipalitiesArray = []>
		
		<cfquery name="saveMuny" dataSource="GOTV">
        UPDATE Municipalities
		SET
		MunicipalityName = '#newCountyObject[1].MunicipalityName#',
		county_key = '#newCountyObject[1].CountyId#',
		ABEmailAddress = '#newCountyObject[1].ABEmailAddress#',
		ABAddress1 = '#newCountyObject[1].ABAddress1#',
		ABAddress2 = '#newCountyObject[1].ABAddress2#',
		ABCity = '#newCountyObject[1].ABCity#',
		ABZip = '#newCountyObject[1].ABZip#'<cfif structKeyExists(newCountyObject[1], "RegAddress1")>,
			RegEmailAddress = '#newCountyObject[1].RegEmailAddress#',
			RegAddress1 = '#newCountyObject[1].RegAddress1#',
			RegAddress2 = '#newCountyObject[1].RegAddress2#',
			RegCity = '#newCountyObject[1].RegCity#',
			RegZip = '#newCountyObject[1].RegZip#'
		</cfif>
		<cfif structKeyExists(newCountyObject[1], "ClerkFullName")>,
		ClerkFullName = '#newCountyObject[1].ClerkFullName#'</cfif>
		WHERE MunicipalityId = #arguments.MunicipalityId#;
        SELECT     dbo.States.StateFull, dbo.States.State, dbo.Counties_Master.county_key, dbo.Counties_Master.county_name, dbo.Municipalities.MunicipalityId, 
                      dbo.Municipalities.MunicipalityName, dbo.Municipalities.county_key AS Expr1, dbo.Municipalities.ABEmailAddress, dbo.Municipalities.ABAddress1, 
                      dbo.Municipalities.ABAddress2, dbo.Municipalities.ABCity, dbo.Municipalities.ABZip, dbo.Municipalities.RegEmailAddress, dbo.Municipalities.RegAddress1, 
                      dbo.Municipalities.RegAddress2, dbo.Municipalities.RegCity, dbo.Municipalities.RegZip, dbo.Municipalities.ClerkFullName, dbo.Municipalities.OfficialOfficeName, dbo.Municipalities.Phone, dbo.Municipalities.Fax
FROM         dbo.Counties_Master INNER JOIN
                      dbo.Municipalities ON dbo.Counties_Master.county_key = dbo.Municipalities.county_key INNER JOIN
                      dbo.States ON dbo.Counties_Master.state_name = dbo.States.StateFull
		WHERE dbo.Municipalities.MunicipalityId = #arguments.MunicipalityId#;
        </cfquery>
		
        <cfset var i = 0>
        <cfoutput query="saveMuny">
			<cfset i = i + 1>
			<cfset municipalitiesArray[i]["StateFull"] = "#StateFull#">
			<cfset municipalitiesArray[i]["State"] = "#State#">
			<cfset municipalitiesArray[i]["CountyName"] = "#county_name#">
            <cfset municipalitiesArray[i]["CountyId"] = "#county_key#">
            <cfset municipalitiesArray[i]["MunicipalityName"] = "#MunicipalityName#">
            <cfset municipalitiesArray[i]["MunicipalityId"] = "#MunicipalityId#">
            <cfset municipalitiesArray[i]["ClerkFullName"] = "#ClerkFullName#">
            <cfset municipalitiesArray[i]["OfficialOfficeName"] = "#OfficialOfficeName#">
            <cfset municipalitiesArray[i]["Phone"] = "#Phone#">
            <cfset municipalitiesArray[i]["Fax"] = "#Fax#">
            <cfset municipalitiesArray[i]["ABEmailAddress"] = "#ABEmailAddress#">
            <cfset municipalitiesArray[i]["ABAddress1"] = "#ABAddress1#">
            <cfset municipalitiesArray[i]["ABAddress2"] = "#ABAddress2#">
            <cfset municipalitiesArray[i]["ABCity"] = "#ABCity#">
            <cfset municipalitiesArray[i]["ABZip"] = "#ABZip#">
            <cfset municipalitiesArray[i]["RegEmailAddress"] = "#RegEmailAddress#">
            <cfset municipalitiesArray[i]["RegAddress1"] = "#RegAddress1#">
            <cfset municipalitiesArray[i]["RegAddress2"] = "#RegAddress1#">
            <cfset municipalitiesArray[i]["RegCity"] = "#RegCity#">
            <cfset municipalitiesArray[i]["RegZip"] = "#RegZip#">
		</cfoutput>
		
		<cfset municipalities.municipality = municipalitiesArray>
        
	        	<cfcatch>
					<cfset municipalities.errorMessage = "#cfcatch.Message#">
					<cfif municipalities.errorMessage EQ "Error Executing Database Query.">
				 		<cfset municipalities.sqlError = "#cfcatch.SQL#">
				 	</cfif>
				 </cfcatch>
        </cftry>
        
        <cfset var data = serializeJSON(municipalities)>
        
        <cfif structKeyExists(url, "callback")>
			<cfset data = url.callback & "(" & data & ")">
        </cfif>
        
        <cfreturn data>
					
	</cffunction>
	<cffunction name="munyPostHandler"
                access="remote"
                httpmethod="POST"
                restpath="municipalities"
                returntype="String" 
                produces="text/plain">
				
		<cfset var userIsAuthorized = application.bypassSecurity>
		<cfinclude template="security.cfm" runonce="true">
		<cfif NOT userIsAuthorized>
			<cfheader statuscode="403" statustext="Unauthorized API Access">
			<cfreturn "UnauthorizedAccess">
			<cfabort>
		</cfif>
		
        <cftry>
        <cfset var municipalities = structNew()>
		<cfset var municipalitiesArray = []>
		
		<cfquery name="saveMuny" dataSource="GOTV">
        INSERT INTO Municipalities
           ([MunicipalityName]
           ,[county_key]
           ,[ABEmailAddress]
           ,[ABAddress1]
           ,[ABAddress2]
           ,[ABCity]
           ,[ABZip]
           ,[RegEmailAddress]
           ,[RegAddress1]
           ,[RegAddress2]
           ,[RegCity]
           ,[RegZip]<cfif structKeyExists(form, "ClerkFullName")>
		   ,ClerkFullName</cfif><cfif structKeyExists(form, "OfficialOfficeName")>
		   ,OfficialOfficeName</cfif><cfif structKeyExists(form, "Phone")>
		   ,Phone</cfif><cfif structKeyExists(form, "Fax")>
		   ,Fax</cfif>)
     VALUES
           ('#form.MunicipalityName#'
           ,#form.CountyId#
           ,'#form.ABEmailAddress#'
           ,'#form.ABAddress1#'
           ,'#form.ABAddress2#'
           ,'#form.ABCity#'
           ,'#form.ABZip#'
           ,'#form.RegEmailAddress#'
           ,'#form.RegAddress1#'
           ,'#form.RegAddress2#'
           ,'#form.RegCity#'
           ,'#form.RegZip#'<cfif structKeyExists(form, "ClerkFullName")>
		   ,'#form.ClerkFullName#'</cfif><cfif structKeyExists(form, "OfficialOfficeName")>
		   ,'#form.OfficialOfficeName#'</cfif><cfif structKeyExists(form, "Phone")>
		   ,'#form.Phone#'</cfif><cfif structKeyExists(form, "Fax")>
		   ,'#form.Fax#'</cfif>);
        SELECT     TOP 1 dbo.States.StateFull, dbo.States.State, dbo.Counties_Master.county_key, dbo.Counties_Master.county_name, dbo.Municipalities.MunicipalityId, 
                      dbo.Municipalities.MunicipalityName, dbo.Municipalities.county_key AS Expr1, dbo.Municipalities.ABEmailAddress, dbo.Municipalities.ABAddress1, 
                      dbo.Municipalities.ABAddress2, dbo.Municipalities.ABCity, dbo.Municipalities.ABZip, dbo.Municipalities.RegEmailAddress, dbo.Municipalities.RegAddress1, 
                      dbo.Municipalities.RegAddress2, dbo.Municipalities.RegCity, dbo.Municipalities.RegZip, dbo.Municipalities.ClerkFullName, dbo.Municipalities.OfficialOfficeName, dbo.Municipalities.Phone, dbo.Municipalities.Fax
FROM         dbo.Counties_Master INNER JOIN
                      dbo.Municipalities ON dbo.Counties_Master.county_key = dbo.Municipalities.county_key INNER JOIN
                      dbo.States ON dbo.Counties_Master.state_name = dbo.States.StateFull
		ORDER BY MunicipalityId DESC
        </cfquery>
		
        <cfset var i = 0>
        <cfoutput query="saveMuny">
			<cfset i = i + 1>
			<cfset municipalitiesArray[i]["StateFull"] = "#StateFull#">
			<cfset municipalitiesArray[i]["State"] = "#State#">
			<cfset municipalitiesArray[i]["CountyName"] = "#county_name#">
            <cfset municipalitiesArray[i]["CountyId"] = "#county_key#">
            <cfset municipalitiesArray[i]["MunicipalityName"] = "#MunicipalityName#">
            <cfset municipalitiesArray[i]["MunicipalityId"] = "#MunicipalityId#">
            <cfset municipalitiesArray[i]["ClerkFullName"] = "#ClerkFullName#">
            <cfset municipalitiesArray[i]["OfficialOfficeName"] = "#OfficialOfficeName#">
            <cfset municipalitiesArray[i]["Phone"] = "#Phone#">
            <cfset municipalitiesArray[i]["Fax"] = "#Fax#">
            <cfset municipalitiesArray[i]["ABEmailAddress"] = "#ABEmailAddress#">
            <cfset municipalitiesArray[i]["ABAddress1"] = "#ABAddress1#">
            <cfset municipalitiesArray[i]["ABAddress2"] = "#ABAddress2#">
            <cfset municipalitiesArray[i]["ABCity"] = "#ABCity#">
            <cfset municipalitiesArray[i]["ABZip"] = "#ABZip#">
            <cfset municipalitiesArray[i]["RegEmailAddress"] = "#RegEmailAddress#">
            <cfset municipalitiesArray[i]["RegAddress1"] = "#RegAddress1#">
            <cfset municipalitiesArray[i]["RegAddress2"] = "#RegAddress1#">
            <cfset municipalitiesArray[i]["RegCity"] = "#RegCity#">
            <cfset municipalitiesArray[i]["RegZip"] = "#RegZip#">
		</cfoutput>
		
		<cfset municipalities.municipality = municipalitiesArray>
        
	        	<cfcatch>
					<cfset municipalities.errorMessage = "#cfcatch.Message#">
					<cfif municipalities.errorMessage EQ "Error Executing Database Query.">
				 		<cfset municipalities.sqlError = "#cfcatch.SQL#">
				 	</cfif>
				 </cfcatch>
        </cftry>
        
        <cfset var data = serializeJSON(municipalities)>
        
        <cfif structKeyExists(url, "callback")>
			<cfset data = url.callback & "(" & data & ")">
        </cfif>
        
        <cfreturn data>
					
	</cffunction>
</cfcomponent>