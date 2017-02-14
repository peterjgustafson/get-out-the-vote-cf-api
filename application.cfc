<cfcomponent output="false">
    <cfset this.name="GOTV">
	<!---<cfset this.restsettings.cfclocation = "./rest">--->
    <cfset this.restsettings.skipcfcwitherror = false>
	<cfset this.sessionManagement = true>
	<cfset this.sessionTimeout = CreateTimeSpan(0,0,20,0) />
	<cfset this.setClientCookies = true />

	
	<!---<cffunction name="onApplicationStart">
		<cfset RestInitApplication("C:\wwwroot\inetpub\", "GOTV")>
		<cfscript>
			writeLog(file=this.name, text="#getFunctionCalledName()# called");
		</cfscript>
	</cffunction>--->
	
	<!---<cffunction name="onSessionStart" output="false">
		<cfheader name="Set-Cookie" value="CFID=#session.CFID#;secure;HTTPOnly" />
		<cfheader name="Set-Cookie" value="CFTOKEN=#session.CFTOKEN#;secure;HTTPOnly" />
	</cffunction>--->
	
	<cffunction name="onRequestStart">
		
		<cfset application.bypassSecurity = false>
		
		<!---<cfscript>
			writeLog(file=this.name, text="#getFunctionCalledName()# called");
		</cfscript>--->
		
		<!---<cfset session.AuthorizedAPIUser = false>
		<cfset session.ClientId = 0>--->
		<!---<cfset var userIsAuthorized = false>--->
		
		<!---<cfinclude template="SecurityCheck.cfm" >
		
		<cfif NOT userIsAuthorized>
			<cfreturn false>
			<cfabort>
		<cfelse>
			<cfreturn true>
		</cfif>--->
		
		<!--- Security Check --->
			
		<!--- IP WHitelist --->
		
		<!--- END IP WHitelist --->	
			
		<!--- API Key and Secret --->
		
		<!--- END API Key and Secret --->
			
		<!--- Client Side Token Verification --->
	</cffunction>
	
	
	<!---<cffunction name="onRequestEnd">
		
		<cfscript>
			writeLog(file=this.name, text="#getFunctionCalledName()# called");
		</cfscript>
		
	</cffunction>
	
	<cffunction name="onCfcRequest">
		
		<cfscript>
			writeLog(file=this.name, text="#getFunctionCalledName()# called");
	        var o = createObject(arguments.cfc);
	        var metadata = getMetadata(o[method]); 
	        
	        if (structKeyExists(metadata, "access") && metadata.access == "remote"){
	            return invoke(o, method, args);
	        }else{
	            throw(type="InvalidMethodException", message="Invalid method called", detail="The method #method# does not exists or is inaccessible remotely");
	        }
		</cfscript>
		
	</cffunction>--->
	
</cfcomponent>