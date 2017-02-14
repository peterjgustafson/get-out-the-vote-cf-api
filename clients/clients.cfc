<!--- component with attributes rest and restpath --->
<cfcomponent rest="true"
             restpath="/Clients">

					
	<cffunction name="getAllHandler"
                access="remote"
                httpmethod="GET"
                returntype="String" 
                produces="text/plain">
					
		<cfset var clients = structNew()>

		<cftry>			
		<cfquery name="getClients" datasource="GOTV">
			SELECT * FROM Clients_Master ORDER BY ClientID DESC;
		</cfquery>
		<cfset var clientArray = []>
		
        <cfset var i = 0>
        <cfoutput query="getClients">
			<cfset i = i + 1>
            <cfset clientArray[i]["ClientId"] = "#ClientId#">
            <cfset clientArray[i]["ClientName"] = "#ClientName#">
            <cfset clientArray[i]["ClientCode"] = "#ClientCode#">
			<cfset clientArray[i]["ClientEmailHeader"] = "#ClientEmailHeader#">
            <cfset clientArray[i]["ClientEmailFooter"] = "#ClientEmailFooter#">
            <cfset clientArray[i]["ClientABEmailCopy"] = "#ClientABEmailCopy#">
            <cfset clientArray[i]["ClientABEmail_ForEmailProcess"] = "#ClientABEmail_ForEmailProcess#">
			<cfset clientArray[i]["ClientRegEmailCopy"] = "#ClientRegEmailCopy#">
            <cfset clientArray[i]["ClientVotingLocEmailCopy"] = "#ClientVotingLocEmailCopy#">
            <cfset clientArray[i]["APIKey"] = "#APIKey#">
			<cfset clientArray[i]["APISecret"] = "#APISecret#">
            <cfset clientArray[i]["PostmarkAPIKey"] = "#PostmarkAPIKey#">
            <cfset clientArray[i]["SendersEmailAddress"] = "#SendersEmailAddress#">
			<cfset clientArray[i]["SendersName"] = "#SendersName#">
		</cfoutput>
			
		<cfset clients.client = clientArray>	
		
		
			<cfcatch type="any">
				<cfset clients.errorMsg = cfcatch.Detail>
			</cfcatch>
		</cftry>			
		
		<cfset var data = serializeJSON(clients)>	
			
		<cfif structKeyExists(url, "callback")>
			<cfset data = url.callback & "(" & data & ")">
        </cfif>
        
        <cfreturn data>
    </cffunction>	
    
    <cffunction name="getHandler"
                access="remote"
                httpmethod="GET"
                restpath="{clientId}"
                returntype="String" 
                produces="text/plain">
					
		<cfargument name="clientId"
                    required="true"
                    restargsource="Path"
                    type="numeric"/>
					
		<cfset var clients = structNew()>

		<cftry>			
		<cfquery name="getClient" datasource="GOTV">
			SELECT * FROM Clients_Master WHERE ClientId = #arguments.clientId#;
		</cfquery>
		<cfset var clientArray = []>
		
        <cfset var i = 0>
        <cfoutput query="getClient">
			<cfset i = i + 1>
            <cfset clientArray[i]["ClientId"] = "#ClientId#">
            <cfset clientArray[i]["ClientName"] = "#ClientName#">
            <cfset clientArray[i]["ClientCode"] = "#ClientCode#">
			<cfset clientArray[i]["ClientEmailHeader"] = "#ClientEmailHeader#">
            <cfset clientArray[i]["ClientEmailFooter"] = "#ClientEmailFooter#">
            <cfset clientArray[i]["ClientABEmailCopy"] = "#ClientABEmailCopy#">
            <cfset clientArray[i]["ClientABEmail_ForEmailProcess"] = "#ClientABEmail_ForEmailProcess#">
			<cfset clientArray[i]["ClientRegEmailCopy"] = "#ClientRegEmailCopy#">
			<cfset clientArray[i]["EDayLocationEmail"] = "#EDayLocationEmail#">
			<cfset clientArray[i]["CommitEmailCopy"] = "#CommitEmailCopy#">
            <cfset clientArray[i]["ClientVotingLocEmailCopy"] = "#ClientVotingLocEmailCopy#">
            <cfset clientArray[i]["APIKey"] = "#APIKey#">
			<cfset clientArray[i]["APISecret"] = "#APISecret#">
            <cfset clientArray[i]["PostmarkAPIKey"] = "#PostmarkAPIKey#">
            <cfset clientArray[i]["SendersEmailAddress"] = "#SendersEmailAddress#">
			<cfset clientArray[i]["SendersName"] = "#SendersName#">
		</cfoutput>
			
		<cfset clients.client = clientArray>	
		
		
			<cfcatch type="any">
				<cfset clients.errorMsg = cfcatch.Detail>
			</cfcatch>
		</cftry>			
		
		<cfset var data = serializeJSON(clients)>	
			
		<cfif structKeyExists(url, "callback")>
			<cfset data = url.callback & "(" & data & ")">
        </cfif>
        
        <cfreturn data>
    </cffunction>

    <cffunction name="putHandlerJSON"
                access="remote"
                httpmethod="PUT"
                returntype="String"
				restpath="{clientId}"
                produces="text/plain">
					
		
    	<cfargument name="clientId"
                    required="true"
                    restargsource="Path"
                    type="numeric"/>
		
		<cfset requestBody = toString( getHttpRequestData().content ) />
		
		<cfset var clients = structNew()>
		
		<cfif isJSON( requestBody )>
		 
		    <!--- Echo back POST data. --->
		    <cfset requestObject = deserializeJSON(requestBody)>
		    <cfset clientObject = requestObject.Client[1]>
		 
		</cfif>
		

		<cftry>			
		<cfquery name="createClient" datasource="GOTV">
		UPDATE [Clients_Master]
		           SET [ClientName] = '#clientObject.ClientName#'
		           ,[ClientCode] = '#clientObject.ClientCode#'
		           ,[ClientEmailHeader] = '#clientObject.ClientEmailHeader#'
		           ,[ClientEmailFooter] = '#clientObject.ClientEmailFooter#'
		           ,[ClientABEmailCopy] = '#clientObject.ClientABEmailCopy#'
		           ,[ClientABEmail_ForEmailProcess] = '#clientObject.ClientABEmail_ForEmailProcess#'
		           ,[ClientRegEmailCopy] = '#clientObject.ClientRegEmailCopy#'
		           ,[ClientVotingLocEmailCopy] = '#clientObject.ClientVotingLocEmailCopy#'
		           ,[PostmarkAPIKey] = '#clientObject.PostmarkAPIKey#'
		           ,[SendersEmailAddress] = '#clientObject.SendersEmailAddress#'
		           ,[SendersName] = '#clientObject.SendersName#'
				   <cfif structKeyExists(clientObject, "EDayLocationEmail")>,[EDayLocationEmail] = '#clientObject.EDayLocationEmail#'</cfif>
				   <cfif structKeyExists(clientObject, "CommitEmailCopy")>,[CommitEmailCopy] = '#clientObject.CommitEmailCopy#'</cfif>
		WHERE ClientId = #arguments.clientId#
		SELECT * FROM Clients_Master WHERE ClientId = '#clientObject.ClientId#';
		</cfquery>
		<cfset var clientArray = []>
		
        <cfset var i = 0>
        <cfoutput query="createClient">
			<cfset i = i + 1>
            <cfset clientArray[i]["ClientId"] = "#ClientId#">
            <cfset clientArray[i]["ClientName"] = "#ClientName#">
            <cfset clientArray[i]["ClientCode"] = "#ClientCode#">
			<cfset clientArray[i]["ClientEmailHeader"] = "#ClientEmailHeader#">
            <cfset clientArray[i]["ClientEmailFooter"] = "#ClientEmailFooter#">
            <cfset clientArray[i]["ClientABEmailCopy"] = "#ClientABEmailCopy#">
            <cfset clientArray[i]["ClientABEmail_ForEmailProcess"] = "#ClientABEmail_ForEmailProcess#">
			<cfset clientArray[i]["ClientRegEmailCopy"] = "#ClientRegEmailCopy#">
            <cfset clientArray[i]["ClientVotingLocEmailCopy"] = "#ClientVotingLocEmailCopy#">
			<cfset clientArray[i]["CommitEmailCopy"] = "#CommitEmailCopy#">
			<cfset clientArray[i]["EDayLocationEmail"] = "#EDayLocationEmail#">
            <cfset clientArray[i]["APIKey"] = "#APIKey#">
			<cfset clientArray[i]["APISecret"] = "#APISecret#">
            <cfset clientArray[i]["PostmarkAPIKey"] = "#PostmarkAPIKey#">
            <cfset clientArray[i]["SendersEmailAddress"] = "#SendersEmailAddress#">
			<cfset clientArray[i]["SendersName"] = "#SendersName#">
		</cfoutput>
			
		<cfset clients.client = clientArray>	
		
		
			<cfcatch type="any">
				<cfset clients.errorMsg = cfcatch.Message>
			</cfcatch>
		</cftry>
			
		<cfset var data = serializeJSON(clients)>				
					
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
				
		<cfset var clients = structNew()>

		<cftry>			
		<cfquery name="createClient" datasource="GOTV">
			IF NOT EXISTS (SELECT ClientName FROM Clients_Master WHERE ClientName = '#form.ClientName#')
			BEGIN
				INSERT INTO [Clients_Master]
			           ([ClientName]
			           ,[ClientCode]
			           ,[ClientEmailHeader]
			           ,[ClientEmailFooter]
			           ,[ClientABEmailCopy]
			           ,[ClientABEmail_ForEmailProcess]
			           ,[ClientRegEmailCopy]
			           ,[ClientVotingLocEmailCopy]
			           ,[PostmarkAPIKey]
			           ,[SendersEmailAddress]
			           ,[SendersName]
			           <cfif structKeyExists(form, "EDayLocationEmail")>,[EDayLocationEmail]</cfif>)
			     VALUES
			           ('#form.ClientName#'
			           ,'#form.ClientCode#'
			           ,'#form.ClientEmailHeader#'
			           ,'#form.ClientEmailFooter#'
			           ,'#form.ClientABEmailCopy#'
					   ,'#form.ClientABEmail_ForEmailProcess#'
			           ,'#form.ClientRegEmailCopy#'
			           ,'#form.ClientVotingLocEmailCopy#'
			           ,'#form.PostmarkAPIKey#'
			           ,'#form.SendersEmailAddress#'
			           ,'#form.SendersName#'
					   <cfif structKeyExists(form, "EDayLocationEmail")>,'#form.EDayLocationEmail#'</cfif>)
			END
		SELECT * FROM Clients_Master WHERE ClientName = '#form.ClientName#';
		</cfquery>
		<cfset var clientArray = []>
		
        <cfset var i = 0>
        <cfoutput query="createClient">
			<cfset i = i + 1>
            <cfset clientArray[i]["ClientId"] = "#ClientId#">
            <cfset clientArray[i]["ClientName"] = "#ClientName#">
            <cfset clientArray[i]["ClientCode"] = "#ClientCode#">
			<cfset clientArray[i]["ClientEmailHeader"] = "#ClientEmailHeader#">
            <cfset clientArray[i]["ClientEmailFooter"] = "#ClientEmailFooter#">
            <cfset clientArray[i]["ClientABEmailCopy"] = "#ClientABEmailCopy#">
            <cfset clientArray[i]["ClientABEmail_ForEmailProcess"] = "#ClientABEmail_ForEmailProcess#">
			<cfset clientArray[i]["ClientRegEmailCopy"] = "#ClientRegEmailCopy#">
            <cfset clientArray[i]["ClientVotingLocEmailCopy"] = "#ClientVotingLocEmailCopy#">
            <cfset clientArray[i]["APIKey"] = "#APIKey#">
			<cfset clientArray[i]["APISecret"] = "#APISecret#">
            <cfset clientArray[i]["PostmarkAPIKey"] = "#PostmarkAPIKey#">
            <cfset clientArray[i]["SendersEmailAddress"] = "#SendersEmailAddress#">
			<cfset clientArray[i]["SendersName"] = "#SendersName#">
		</cfoutput>
			
		<cfset clients.client = clientArray>	
		
		
			<cfcatch type="any">
				<cfset clients.errorMsg = cfcatch.Detail>
			</cfcatch>
		</cftry>
			
		<cfset var data = serializeJSON(clients)>				
					
		<cfif structKeyExists(url, "callback")>
			<cfset data = url.callback & "(" & data & ")">
        </cfif>
        
        <cfreturn data>
        
    </cffunction>
</cfcomponent>