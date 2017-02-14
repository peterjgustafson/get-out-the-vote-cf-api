<!--- component with attributes rest and restpath --->
<cfcomponent rest="true"
             restpath="/Elections">

    <!--- handle GET request (httpmethod),
          take argument in restpath(restpath={customerID}),
          return query data in json format(produces=text/json) ---> 
     
     <cffunction name="countiesHandler"
                access="remote"
                httpmethod="GET"
                restpath="counties/list"
                returntype="String" 
                produces="text/plain">
					
		<cfset var userIsAuthorized = application.bypassSecurity>
		<cfinclude template="security.cfm" runonce="true">
		<cfif NOT userIsAuthorized>
			<cfheader statuscode="403" statustext="Unauthorized API Access">
			<cfreturn "UnauthorizedAccess">
			<cfabort>
		</cfif>			
					
		<cfquery name="getCounties" dataSource="GOTV" cachedwithin="#createTimeSpan(0,0,1,0)#">
        SELECT *
        FROM Counties
        <cfif structKeyExists(url, "state")>
			WHERE State = '#url.state#'
			</cfif>
        ORDER BY State, CountyName
        </cfquery>
        <cfset var counties = structNew()>
		<cfset var countyArray = []>
		
        <cfset var i = 0>
        <cfoutput query="getCounties">
			<cfset i = i + 1>
			<cfset countyArray[i]["CountyId"] = "#CountyId#">
            <cfset countyArray[i]["CountyName"] = "#CountyName#">
			<cfset countyArray[i]["State"] = "#State#">
            <cfset countyArray[i]["ClerkEmail"] = "#ClerkEmail#">
			<cfif len(ClerkMailingInfo)>
            <cfset countyArray[i]["ClerkMailingInfo"] = "#JSStringFormat(ClerkMailingInfo)#">
			</cfif>
		</cfoutput>
		
		<cfset counties.counties = countyArray>
        
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
                    type="numeric"/>
			
		<cfset var userIsAuthorized = application.bypassSecurity>
		<cfinclude template="security.cfm" runonce="true">
		<cfif NOT userIsAuthorized>
			<cfheader statuscode="403" statustext="Unauthorized API Access">
			<cfreturn "UnauthorizedAccess">
			<cfabort>
		</cfif>		
		
		<cfquery name="getCounties" dataSource="GOTV" cachedwithin="#createTimeSpan(0,0,1,0)#">
        SELECT *
        FROM Counties
        WHERE CountyId = #arguments.countyId#
        ORDER BY State, CountyName
        </cfquery>
        <cfset var counties = structNew()>
		<cfset var countyArray = []>
		
        <cfset var i = 0>
        <cfoutput query="getCounties">
			<cfset i = i + 1>
			<cfset countyArray[i]["CountyId"] = "#CountyId#">
            <cfset countyArray[i]["CountyName"] = "#CountyName#">
			<cfset countyArray[i]["State"] = "#State#">
            <cfset countyArray[i]["ClerkEmail"] = "#ClerkEmail#">
			<cfif len(ClerkMailingInfo)>
            <cfset countyArray[i]["ClerkMailingInfo"] = "#JSStringFormat(ClerkMailingInfo)#">
			</cfif>
		</cfoutput>
		
		<cfset counties.counties = countyArray>
        
        <cfset var data = serializeJSON(counties)>
        
        <cfif structKeyExists(url, "callback")>
			<cfset data = url.callback & "(" & data & ")">
        </cfif>
        
        <cfreturn data>
					
	</cffunction>
    <cffunction name="deleteHandler"
                access="remote"
                httpmethod="DELETE"
                restpath="{electionId}"
                returntype="String" 
                produces="text/plain">
					
		<cfargument name="electionId"
                    required="true"
                    restargsource="Path"
                    type="numeric"/>
        <cfargument name="callback" type="string" required="false">
    
    	<cfset var userIsAuthorized = application.bypassSecurity>
		<cfinclude template="security.cfm" runonce="true">
		<cfif NOT userIsAuthorized>
			<cfheader statuscode="403" statustext="Unauthorized API Access">
			<cfreturn "UnauthorizedAccess">
			<cfabort>
		</cfif>
    
    	<cfset var elections = structNew()>
    	<cfquery name="getElection" dataSource="GOTV">
        DELETE FROM Elections
        WHERE ElectionId = #arguments.electionId#
        </cfquery>
        
        <cfset var message = "deleted">
       	<cfset elections.message = "deleted">
		
		<cfset var data = elections>
            <!--- serialize --->
        <cfset data = serializeJSON(elections)>
        
        <cfif structKeyExists(url, "callback")>
			<cfset data = url.callback & "(" & data & ")">
        </cfif>
		
        <cfreturn data>
    </cffunction>
    <cffunction name="getHandler"
                access="remote"
                httpmethod="GET"
                restpath="{electionId}"
                returntype="String" 
                produces="text/plain">
					
		<cfargument name="electionId"
                    required="true"
                    restargsource="Path"
                    type="numeric"/>
        <cfargument name="callback" type="string" required="false">
    
    	<cfset var userIsAuthorized = application.bypassSecurity>
		<cfinclude template="security.cfm" runonce="true">
		<cfif NOT userIsAuthorized>
			<cfheader statuscode="403" statustext="Unauthorized API Access">
			<cfreturn "UnauthorizedAccess">
			<cfabort>
		</cfif>
    
    	<cfset var elections = structNew()>
    	<cftry>
         <cfquery name="getElection" dataSource="GOTV">
        SELECT *
        FROM Elections
        WHERE ElectionId = #arguments.electionId#
        </cfquery>
        
        <cfset var election = []>
        <cfset var i = 0>
        <cfoutput query="getElection">
        	<cfset i = i + 1>
			<cfset election[i]["ElectionId"] = "#ElectionId#">
			<cfset election[i]["State"] = "#ucase(State)#">
            <cfset election[i]["ElectionName"] = "#JSStringFormat(ElectionName)#">
            <cfset election[i]["ElectionDate"] = "#DateFormat(ElectionDate, "mm/dd/yyyy")#">
			<cfif isDate(EDStartDate)>
            	<cfset election[i]["EDStartDate"] = "#DateFormat(EDStartDate, "mm/dd/yyyy")#">
			<cfelse>
            	<cfset election[i]["EDStartDate"] = "">
			</cfif>
			<cfif isDate(EDEndDate)>
            	<cfset election[i]["EDEndDate"] = "#DateFormat(EDEndDate, "mm/dd/yyyy")#">
			<cfelse>
            	<cfset election[i]["EDEndDate"] = "">
			</cfif>
			<cfset election[i]["EDUseGoogleCivic"] = "#EDUseGoogleCivic#">
            <cfset election[i]["RegistrationEndDate"] = "#DateFormat(RegistrationEndDate, "mm/dd/yyyy")#">
            <cfset election[i]["EVStartDate"] = "#DateFormat(EVStartDate, "mm/dd/yyyy")#">
            <cfset election[i]["EVEndDate"] = "#DateFormat(EVEndDate, "mm/dd/yyyy")#">
            <cfset election[i]["ABStartDate"] = "#DateFormat(ABStartDate, "mm/dd/yyyy")#">
            <cfset election[i]["ABEndDate"] = "#DateFormat(ABEndDate, "mm/dd/yyyy")#">
            <cfset election[i]["ABEmailAddress"] = "#ABEmailAddress#">
            <cfset election[i]["ABRequestPDFPath"] = "#ABRequestPDFPath#">
            <cfset election[i]["ABUseEmailProcess"] = "#ABUseEmailProcess#">
			<cfset election[i]["ABMailingInfo"] = "#ABMailingInfo#">
            <cfset election[i]["ABUseCountyClerkContactInfo"] = "#ABUseCountyClerkContactInfo#">
            <cfset election[i]["ABMicroFormat"] = "#ABMicroFormat#">
            <cfset election[i]["RegMicroFormat"] = "#RegMicroFormat#">
            <cfset election[i]["ElectionDayDisplayDate"] = "#DateFormat(ElectionDayDisplayDate, "mm/dd/yyyy")#">
            <cfset election[i]["ABEndDisplayDate"] = "#DateFormat(ABEndDisplayDate, "mm/dd/yyyy")#">
            <cfset election[i]["EVEndDisplayDate"] = "#DateFormat(EVEndDisplayDate, "mm/dd/yyyy")#">
        </cfoutput>
		
		<cfset elections.election = election>
			<cfcatch><cfset elections.errorMessage = "#cfcatch.Message#"></cfcatch>
		</cftry>
		
		<cfset var data = elections>
            <!--- serialize --->
        <cfset data = serializeJSON(elections)>
        
        <cfif structKeyExists(url, "callback")>
			<cfset data = url.callback & "(" & data & ")">
        </cfif>
		
        <cfreturn data>
    </cffunction>
    <cffunction name="getHandlerJSON"
                access="remote"
                httpmethod="GET"
                restpath="json/{electionId}"
                returntype="Struct" 
                produces="appication/json">
					
		<cfargument name="electionId"
                    required="true"
                    restargsource="Path"
                    type="numeric"/>
        <cfargument name="callback" type="string" required="false">
    
    	<cfset var userIsAuthorized = application.bypassSecurity>
		<cfinclude template="security.cfm" runonce="true">
		<cfif NOT userIsAuthorized>
			<cfheader statuscode="403" statustext="Unauthorized API Access">
			<cfreturn "UnauthorizedAccess">
			<cfabort>
		</cfif>
    
    	<cfset var elections = structNew()>
    
         <cfquery name="getElection" dataSource="GOTV">
        SELECT *
        FROM Elections
        WHERE ElectionId = #arguments.electionId#
        </cfquery>
        
        <cfset var election = []>
        <cfset var i = 0>
        <cfoutput query="getElection">
        	<cfset i = i + 1>
			<cfset election[i]["ElectionId"] = "#ElectionId#">
			<cfset election[i]["State"] = "#ucase(State)#">
            <cfset election[i]["ElectionName"] = "#JSStringFormat(ElectionName)#">
            <cfset election[i]["ElectionDate"] = "#DateFormat(ElectionDate, "mm/dd/yyyy")#">
			<cfif isDate(EDStartDate)>
            	<cfset election[i]["EDStartDate"] = "#DateFormat(EDStartDate, "mm/dd/yyyy")#">
			<cfelse>
            	<cfset election[i]["EDStartDate"] = "">
			</cfif>
			<cfif isDate(EDEndDate)>
            	<cfset election[i]["EDEndDate"] = "#DateFormat(EDEndDate, "mm/dd/yyyy")#">
			<cfelse>
            	<cfset election[i]["EDEndDate"] = "">
			</cfif>
			<cfset election[i]["EDUseGoogleCivic"] = "#EDUseGoogleCivic#">
            <cfset election[i]["RegistrationEndDate"] = "#DateFormat(RegistrationEndDate, "mm/dd/yyyy")#">
            <cfset election[i]["EVStartDate"] = "#DateFormat(EVStartDate, "mm/dd/yyyy")#">
            <cfset election[i]["EVEndDate"] = "#DateFormat(EVEndDate, "mm/dd/yyyy")#">
            <cfset election[i]["ABStartDate"] = "#DateFormat(ABStartDate, "mm/dd/yyyy")#">
            <cfset election[i]["ABEndDate"] = "#DateFormat(ABEndDate, "mm/dd/yyyy")#">
            <cfset election[i]["ABEmailAddress"] = "#ABEmailAddress#">
            <cfset election[i]["ABRequestPDFPath"] = "#ABRequestPDFPath#">
            <cfset election[i]["ABUseEmailProcess"] = "#ABUseEmailProcess#">
			<cfset election[i]["ABMailingInfo"] = "#ABMailingInfo#">
            <cfset election[i]["ABUseCountyClerkContactInfo"] = "#ABUseCountyClerkContactInfo#">
            <cfset election[i]["ABMicroFormat"] = "#ABMicroFormat#">
            <cfset election[i]["RegMicroFormat"] = "#RegMicroFormat#">
            <cfset election[i]["ElectionDayDisplayDate"] = "#DateFormat(ElectionDayDisplayDate, "mm/dd/yyyy")#">
            <cfset election[i]["ABEndDisplayDate"] = "#DateFormat(ABEndDisplayDate, "mm/dd/yyyy")#">
            <cfset election[i]["EVEndDisplayDate"] = "#DateFormat(EVEndDisplayDate, "mm/dd/yyyy")#">
        </cfoutput>
		
		<cfset elections.election = election>
		
		<!---<cfset var data = elections>
            <!--- serialize --->
        <cfset data = serializeJSON(elections)>
        
        <cfif structKeyExists(url, "callback")>
			<cfset data = url.callback & "(" & data & ")">
        </cfif>--->
		
        <cfreturn elections>
    </cffunction>
    <cffunction name="listHandlerText"
                access="remote"
                httpmethod="GET"
                returntype="String"
				restpath="list"
                produces="text/plain">
					
		<cfset var userIsAuthorized = application.bypassSecurity>
		<cfinclude template="security.cfm" runonce="true">
		<cfif NOT userIsAuthorized>
			<cfheader statuscode="403" statustext="Unauthorized API Access">
			<cfreturn "UnauthorizedAccess">
			<cfabort>
		</cfif>			
		
        <cfset var elections = structNew()>
         <cfquery name="getElection" dataSource="GOTV"><!--- cachedwithin="#createTimeSpan(0,0,1,0)#" --->
        SELECT     dbo.Elections.*
		FROM         dbo.Elections INNER JOIN
		                      dbo.States ON dbo.Elections.State = dbo.States.State
		WHERE     (DATEDIFF(d, GETDATE(), dbo.Elections.ElectionDate) > -2)<cfif structKeyExists(url, "state")>
		AND (dbo.Elections.State = '#url.state#')
		</cfif>
		ORDER BY dbo.States.StateFull, dbo.Elections.ElectionDate
        </cfquery>
        
        <cfset var election = []>
        <cfset var i = 0>
        <cfoutput query="getElection">
        	<cfset i = i + 1>
			<cfset election[i]["ElectionId"] = "#ElectionId#">
			<cfset election[i]["State"] = "#ucase(State)#">
            <cfset election[i]["ElectionName"] = "#JSStringFormat(ElectionName)#">
			<cfif isDate(EDStartDate)>
            	<cfset election[i]["EDStartDate"] = "#DateFormat(EDStartDate, "mm/dd/yyyy")#">
			<cfelse>
            	<cfset election[i]["EDStartDate"] = "">
			</cfif>
			<cfif isDate(EDEndDate)>
            	<cfset election[i]["EDEndDate"] = "#DateFormat(EDEndDate, "mm/dd/yyyy")#">
			<cfelse>
            	<cfset election[i]["EDEndDate"] = "">
			</cfif>
			<cfset election[i]["EDUseGoogleCivic"] = "#EDUseGoogleCivic#">
            <cfset election[i]["ElectionDate"] = "#DateFormat(ElectionDate, "mm/dd/yyyy")#">
            <cfset election[i]["RegistrationEndDate"] = "#DateFormat(RegistrationEndDate, "mm/dd/yyyy")#">
            <cfset election[i]["EVStartDate"] = "#DateFormat(EVStartDate, "mm/dd/yyyy")#">
            <cfset election[i]["EVEndDate"] = "#DateFormat(EVEndDate, "mm/dd/yyyy")#">
            <cfset election[i]["ABStartDate"] = "#DateFormat(ABStartDate, "mm/dd/yyyy")#">
            <cfset election[i]["ABEndDate"] = "#DateFormat(ABEndDate, "mm/dd/yyyy")#">
            <cfset election[i]["ABEmailAddress"] = "#ABEmailAddress#">
            <cfset election[i]["ABMailingInfo"] = "#ABMailingInfo#">
            <cfset election[i]["ABRequestPDFPath"] = "#ABRequestPDFPath#">
            <cfset election[i]["ABUseEmailProcess"] = "#ABUseEmailProcess#">
            <cfset election[i]["ABUseCountyClerkContactInfo"] = "#ABUseCountyClerkContactInfo#">
            <cfset election[i]["ElectionDayDisplayDate"] = "#DateFormat(ElectionDayDisplayDate, "mm/dd/yyyy")#">
            <cfset election[i]["ABEndDisplayDate"] = "#DateFormat(ABEndDisplayDate, "mm/dd/yyyy")#">
            <cfset election[i]["EVEndDisplayDate"] = "#DateFormat(EVEndDisplayDate, "mm/dd/yyyy")#">
        </cfoutput>
        
        	<cfset elections.elections = election>
           
        
        <cfset var data = elections>
            <!--- serialize --->
        <cfset data = serializeJSON(elections)>
        
        <cfif structKeyExists(url, "callback")>
			<cfset data = url.callback & "(" & data & ")">
        </cfif>
        
        <cfreturn data>
        
    </cffunction>
    <cffunction name="listHandlerJSON"
                access="remote"
                httpmethod="GET"
                returntype="Struct"
				restpath="listJSON"
                produces="application/json">
					
		<cfset var userIsAuthorized = application.bypassSecurity>
		<cfinclude template="security.cfm" runonce="true">
		<cfif NOT userIsAuthorized>
			<cfheader statuscode="403" statustext="Unauthorized API Access">
			<cfreturn "UnauthorizedAccess">
			<cfabort>
		</cfif>			
		
        <cfset var elections = structNew()>
         <cfquery name="getElection" dataSource="GOTV"><!--- cachedwithin="#createTimeSpan(0,0,0,0)#" --->
        SELECT *
        FROM Elections
        WHERE DateDiff(d, GetDate(), ElectionDate) > 0<cfif structKeyExists(url, "state")>
			AND State = '#url.state#'
			</cfif>
		ORDER BY State, ElectionDate ASC
        </cfquery>
        <cfset var election = []>
        <cfoutput query="getElection" group="State">
			<cfset election = []>
        	<cfset var i = 0>
			<cfoutput group="ElectionDate">
        	<cfset i = i + 1>
				<cfset election[i]["ElectionId"] = "#ElectionId#">
	            <cfset election[i]["ElectionName"] = "#JSStringFormat(ElectionName)#">
	            <cfset election[i]["ElectionDate"] = "#DateFormat(ElectionDate, "mm/dd/yyyy")#">
				<cfif isDate(EDStartDate)>
	            	<cfset election[i]["EDStartDate"] = "#DateFormat(EDStartDate, "mm/dd/yyyy")#">
				<cfelse>
	            	<cfset election[i]["EDStartDate"] = "">
				</cfif>
				<cfif isDate(EDEndDate)>
	            	<cfset election[i]["EDEndDate"] = "#DateFormat(EDEndDate, "mm/dd/yyyy")#">
				<cfelse>
	            	<cfset election[i]["EDEndDate"] = "">
				</cfif>
				<cfset election[i]["EDUseGoogleCivic"] = "#EDUseGoogleCivic#">
	            <cfset election[i]["RegistrationEndDate"] = "#DateFormat(RegistrationEndDate, "mm/dd/yyyy")#">
	            <cfset election[i]["EVStartDate"] = "#DateFormat(EVStartDate, "mm/dd/yyyy")#">
	            <cfset election[i]["EVEndDate"] = "#DateFormat(EVEndDate, "mm/dd/yyyy")#">
	            <cfset election[i]["ABStartDate"] = "#DateFormat(ABStartDate, "mm/dd/yyyy")#">
	            <cfset election[i]["ABEndDate"] = "#DateFormat(ABEndDate, "mm/dd/yyyy")#">
	            <cfset election[i]["ABEmailAddress"] = "#ABEmailAddress#">
            	<cfset election[i]["ABMailingInfo"] = "#ABMailingInfo#">
	            <cfset election[i]["ABRequestPDFPath"] = "#ABRequestPDFPath#">
            	<cfset election[i]["ABUseEmailProcess"] = "#ABUseEmailProcess#">
            	<cfset election[i]["ABUseCountyClerkContactInfo"] = "#ABUseCountyClerkContactInfo#">
	            <cfset election[i]["ElectionDayDisplayDate"] = "#DateFormat(ElectionDayDisplayDate, "mm/dd/yyyy")#">
	            <cfset election[i]["ABEndDisplayDate"] = "#DateFormat(ABEndDisplayDate, "mm/dd/yyyy")#">
	            <cfset election[i]["EVEndDisplayDate"] = "#DateFormat(EVEndDisplayDate, "mm/dd/yyyy")#">
			</cfoutput>
			<cfset temp = structInsert(elections, State, election)>
        </cfoutput>
           
        
        <!---<cfset var data = elections>
            <!--- serialize --->
        <cfset data = serializeJSON(elections)>
        
        <cfif structKeyExists(url, "callback")>
			<cfset data = url.callback & "(" & data & ")">
        </cfif>--->
        
        <cfreturn elections>
        
    </cffunction>
    <cffunction name="putHandlerJSON"
                access="remote"
                httpmethod="PUT"
                returntype="String"
                restpath="{electionId}"
                produces="text/plain">
					
					
    	<cfargument name="electionId"
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
					
    	<cfset requestBody = toString( getHttpRequestData().content ) />
 
		<!--- Double-check to make sure it's a JSON value. --->
		<cfif isJSON( requestBody )>
		 
		    <!--- Echo back POST data. --->
		    <cfset requestObject = deserializeJSON(requestBody)>
		    <cfset newElectionObject = requestObject.Election>
		 
		</cfif>
        
       <cfset var elections = structNew()>
         <cftry>
		<cflock scope="Server" timeout="#createTimeSpan(0,0,0,2)#" >
	        <cfquery name="updateElection" dataSource="GOTV">
	        UPDATE Elections
				SET State = '#newElectionObject[1].State#',
				ElectionName = '#newElectionObject[1].ElectionName#',
				ElectionDate = '#newElectionObject[1].ElectionDate#',
				ABStartDate = '#newElectionObject[1].ABStartDate#',
				ABEndDate = '#newElectionObject[1].ABEndDate#',
				EVStartDate = '#newElectionObject[1].EVStartDate#',
				EVEndDate = '#newElectionObject[1].EVEndDate#',
				RegistrationEndDate = '#newElectionObject[1].RegistrationEndDate#',
				ABEmailAddress = '#newElectionObject[1].ABEmailAddress#',
				ABRequestPDFPath = '#newElectionObject[1].ABRequestPDFPath#'
				<cfif structKeyExists(newElectionObject[1], "ABUseEmailProcess")>, ABUseEmailProcess = #newElectionObject[1].ABUseEmailProcess#</cfif>
				<cfif structKeyExists(newElectionObject[1], "ABUseCountyClerkContactInfo")>, ABUseCountyClerkContactInfo = #newElectionObject[1].ABUseCountyClerkContactInfo#</cfif>
				<cfif structKeyExists(newElectionObject[1], "ABMailingAddress")>, ABMailingAddress = '#newElectionObject[1].ABMailingAddress#'</cfif>
				<cfif structKeyExists(newElectionObject[1], "ABMicroFormat")>, ABMicroFormat = '#newElectionObject[1].ABMicroFormat#'</cfif>
				<cfif structKeyExists(newElectionObject[1], "RegMicroFormat")>, RegMicroFormat = '#newElectionObject[1].RegMicroFormat#'</cfif>
				<cfif structKeyExists(newElectionObject[1], "EDStartDate")>, EDStartDate = '#newElectionObject[1].EDStartDate#'</cfif>
				<cfif structKeyExists(newElectionObject[1], "EDEndDate")>, EDEndDate = '#newElectionObject[1].EDEndDate#'</cfif>
				<cfif structKeyExists(newElectionObject[1], "EDUseGoogleCivic")>, EDUseGoogleCivic = '#newElectionObject[1].EDUseGoogleCivic#'</cfif>
				<cfif structKeyExists(newElectionObject[1], "ElectionDayDisplayDate")>, ElectionDayDisplayDate = '#newElectionObject[1].ElectionDayDisplayDate#'</cfif>
				<cfif structKeyExists(newElectionObject[1], "ABEndDisplayDate")>, ABEndDisplayDate = '#newElectionObject[1].ABEndDisplayDate#'</cfif>
				<cfif structKeyExists(newElectionObject[1], "EVEndDisplayDate")>, EVEndDisplayDate = '#newElectionObject[1].EVEndDisplayDate#'</cfif>
	            WHERE ElectionId = #arguments.electionId#;
			SELECT * FROM Elections WHERE ElectionId = #arguments.electionId#;
	        </cfquery>
        </cflock>
        	<cfcatch><cfset elections.errorMessage = "#cfcatch.Message# #cfcatch.Detail#"></cfcatch>
        </cftry>
        <cfset var election = []>
        <cfset var i = 0>
		<cfif isDefined("updateElection")>
	        <cfoutput query="updateElection">
	        	<cfset i = i + 1>
				<cfset election[i]["ElectionId"] = "#ElectionId#">
				<cfset election[i]["State"] = "#State#">
	            <cfset election[i]["ElectionName"] = "#JSStringFormat(ElectionName)#">
	            <cfset election[i]["ElectionDate"] = "#DateFormat(ElectionDate, "mm/dd/yyyy")#">
				<cfif isDate(EDStartDate)>
	            	<cfset election[i]["EDStartDate"] = "#DateFormat(EDStartDate, "mm/dd/yyyy")#">
				<cfelse>
	            	<cfset election[i]["EDStartDate"] = "">
				</cfif>
				<cfif isDate(EDEndDate)>
	            	<cfset election[i]["EDEndDate"] = "#DateFormat(EDEndDate, "mm/dd/yyyy")#">
				<cfelse>
	            	<cfset election[i]["EDEndDate"] = "">
				</cfif>
				<cfset election[i]["EDUseGoogleCivic"] = "#EDUseGoogleCivic#">
	            <cfset election[i]["RegistrationEndDate"] = "#DateFormat(RegistrationEndDate, "mm/dd/yyyy")#">
	            <cfset election[i]["EVStartDate"] = "#DateFormat(EVStartDate, "mm/dd/yyyy")#">
	            <cfset election[i]["EVEndDate"] = "#DateFormat(EVEndDate, "mm/dd/yyyy")#">
	            <cfset election[i]["ABStartDate"] = "#DateFormat(ABStartDate, "mm/dd/yyyy")#">
	            <cfset election[i]["ABEndDate"] = "#DateFormat(ABEndDate, "mm/dd/yyyy")#">
	            <cfset election[i]["ABEmailAddress"] = "#ABEmailAddress#">
	            <cfset election[i]["ABRequestPDFPath"] = "#ABRequestPDFPath#">
            	<cfset election[i]["ABUseEmailProcess"] = "#ABUseEmailProcess#">
            	<cfset election[i]["ABUseCountyClerkContactInfo"] = "#ABUseCountyClerkContactInfo#">
            	<cfset election[i]["ABMailingInfo"] = "#ABMailingInfo#">
            	<cfset election[i]["ABMicroFormat"] = "#ABMicroFormat#">
            	<cfset election[i]["RegMicroFormat"] = "#RegMicroFormat#">
	            <cfset election[i]["ElectionDayDisplayDate"] = "#DateFormat(ElectionDayDisplayDate, "mm/dd/yyyy")#">
	            <cfset election[i]["ABEndDisplayDate"] = "#DateFormat(ABEndDisplayDate, "mm/dd/yyyy")#">
	            <cfset election[i]["EVEndDisplayDate"] = "#DateFormat(EVEndDisplayDate, "mm/dd/yyyy")#">
	        </cfoutput>
		</cfif>
		<cfset elections.election = election>
		
		<cfset var data = elections>
            <!--- serialize --->
        <cfset data = serializeJSON(elections)>
        
        <cfif structKeyExists(url, "callback")>
			<cfset data = url.callback & "(" & data & ")">
        </cfif>
        
        
        <cfreturn data>
        
    </cffunction> 
    <cffunction name="postHandlerJSON"
                access="remote"
                httpmethod="POST"
                returntype="String"
                produces="text/plain">
					
		<cfset var userIsAuthorized = application.bypassSecurity>
		<cfinclude template="security.cfm" runonce="true">
		<cfif NOT userIsAuthorized>
			<cfheader statuscode="403" statustext="Unauthorized API Access">
			<cfreturn "UnauthorizedAccess">
			<cfabort>
		</cfif>
					
    	<!---<cfargument name="county" required="yes">
    	<cfargument name="locationName" required="yes">
    	<cfargument name="address1" required="yes">
    	<cfargument name="address2" required="no">
    	<cfargument name="city" required="yes">
    	<cfargument name="state" required="yes">
    	<cfargument name="zip" required="yes">
    	<cfargument name="lat" required="yes">
    	<cfargument name="lon" required="yes">
    	<cfargument name="defaultZoomLevel" required="yes">
    	<cfargument name="phone" required="yes">
    	<cfargument name="hours" required="yes">
    	<cfargument name="callback" type="string">--->
        
        <cftry>
        <cfset var elections = structNew()>
			<cfset var ABMicro = "">
				<cfif isDefined("form.ABMicroFormat")><cfset ABMicro = ABMicroFormat></cfif>
			<cfset var RegMicro = "">
				<cfif isDefined("form.RegMicroFormat")><cfset RegMicro = RegMicroFormat></cfif>
			<cfset var MailInfo = "">
				<cfif isDefined("form.ABMailingInfo")><cfset MailInfo = ABMailingInfo></cfif>
			<cflock scope="Server" timeout="#createTimeSpan(0,0,0,2)#" >
		        <cfquery name="createElection" dataSource="GOTV">
		        INSERT INTO Elections
		            (State, ElectionName, ElectionDate, ABStartDate, ABEndDate, EVStartDate, EVEndDate, RegistrationEndDate, ABEmailAddress, ABRequestPDFPath, ABMicroFormat, RegMicroFormat, ABMailingInfo)
		            VALUES
		            ('#ucase(State)#', '#ElectionName#', '#ElectionDate#', '#ABStartDate#', '#ABEndDate#', '#EVStartDate#', '#EVEndDate#', '#RegistrationEndDate#', '#ABEmailAddress#', '#ABRequestPDFPath#', '#ABMicro#', '#RegMicroFormat#', '#MailInfo#');
				SELECT TOP 1 * FROM Elections Order By ElectionId DESC;
		        </cfquery>
	        </cflock>
        <cfset var election = []>
        <cfset var i = 0>
		<cfif isDefined("createElection")>
	        <cfoutput query="createElection">
	        	<cfset i = i + 1>
				<cfset election[i]["ElectionId"] = "#ElectionId#">
				<cfset election[i]["State"] = "#State#">
	            <cfset election[i]["ElectionName"] = "#JSStringFormat(ElectionName)#">
	            <cfset election[i]["ElectionDate"] = "#DateFormat(ElectionDate, "mm/dd/yyyy")#">
				<cfif isDate(EDStartDate)>
	            	<cfset election[i]["EDStartDate"] = "#DateFormat(EDStartDate, "mm/dd/yyyy")#">
				<cfelse>
	            	<cfset election[i]["EDStartDate"] = "">
				</cfif>
	            <cfset election[i]["RegistrationEndDate"] = "#DateFormat(RegistrationEndDate, "mm/dd/yyyy")#">
	            <cfset election[i]["EVStartDate"] = "#DateFormat(EVStartDate, "mm/dd/yyyy")#">
	            <cfset election[i]["EVEndDate"] = "#DateFormat(EVEndDate, "mm/dd/yyyy")#">
	            <cfset election[i]["ABStartDate"] = "#DateFormat(ABStartDate, "mm/dd/yyyy")#">
	            <cfset election[i]["ABEndDate"] = "#DateFormat(ABEndDate, "mm/dd/yyyy")#">
	            <cfset election[i]["ABEmailAddress"] = "#ABEmailAddress#">
	            <cfset election[i]["ABRequestPDFPath"] = "#ABRequestPDFPath#">
           		<cfset election[i]["ABUseEmailProcess"] = "#ABUseEmailProcess#">
            	<cfset election[i]["ABMailingInfo"] = "#ABMailingInfo#">
            	<cfset election[i]["ABUseCountyClerkContactInfo"] = "#ABUseCountyClerkContactInfo#">
            	<cfset election[i]["ABMicroFormat"] = "#ABMicroFormat#">
            	<cfset election[i]["RegMicroFormat"] = "#RegMicroFormat#">
	        </cfoutput>
		</cfif>
		<cfset elections.election = election>
		
	        	<cfcatch><cfset elections.errorMessage = "#cfcatch.Message#"></cfcatch>
        </cftry>
		<cfset var data = elections>
            <!--- serialize --->
        <cfset data = serializeJSON(elections)>
        
        <cfif structKeyExists(url, "callback")>
			<cfset data = url.callback & "(" & data & ")">
        </cfif>
        
        
        <cfreturn data>
        
    </cffunction>    
</cfcomponent>