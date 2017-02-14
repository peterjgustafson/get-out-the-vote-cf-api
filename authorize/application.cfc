<cfcomponent output="false">
    <cfset this.name="GOTV">
	<!---<cfset this.restsettings.cfclocation = "./rest">--->
    <cfset this.restsettings.skipcfcwitherror = true>
	<cfset this.sessionManagement = true>
	<cfset this.sessionTimeout = CreateTimeSpan(0,0,20,0) />
	<cfset this.setClientCookies = true />
</cfcomponent>