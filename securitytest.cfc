<cfcomponent rest="true"
             restpath="/Security">
	<cffunction name="getHandler"
                access="remote"
                httpmethod="GET"
                restpath="test"
                returntype="String" 
                produces="text/plain">
				
		<cfset var secuirty = structNew()>
		<cfset var info = structNew()>
		
		<cfset info.referrer = cgi.HTTP_REFERER>
		<cfset info.agent = cgi.HTTP_USER_AGENT>
		<cfset info.ip = cgi.REMOTE_ADDR>
		<cfset info.authType = "Not Authenticated">
		
		<cfquery name="checkSandbox" datasource="GOTV" cachedwithin="#createTimeSpan(0,0,0,30)#">
		SELECT SandboxedIP from SandboxedIPs WHERE SandboxedIP = '#info.ip#';
		</cfquery>
		<cfif checkSandbox.recordCount>
			<cfset info.authType = "Sandboxed IP Address">
		</cfif>
		<cfquery name="checkClientSite" datasource="GOTV" cachedwithin="#createTimeSpan(0,0,0,30)#">
		SELECT ClientId from Clients_DomainNames WHERE DomainName = '#info.referrer#';
		</cfquery>
		<cfif checkClientSite.recordCount>
			<cfset info.authType = "Client Site">
		</cfif>
		
		<cfset secuirty.info = info>
		
		<cfset var data = serializeJSON(secuirty)>  		
					
		<cfif structKeyExists(url, "callback")>
			<cfset data = url.callback & "(" & data & ")">
        </cfif>
        
        <cfreturn data>
    </cffunction>
</cfcomponent>