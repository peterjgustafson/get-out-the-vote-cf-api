<cfif isDefined("emailContent") >
	<cfif (cgi.SERVER_NAME EQ "api-dev.targetedgotv.com" AND clientId EQ 5) OR (cgi.SERVER_NAME EQ "api.targetedgotv.com" AND clientId EQ 7)>
	<cfinclude template="RNCABEmail.cfm">
	<!---<cfelseif (cgi.SERVER_NAME EQ "api-dev.targetedgotv.com" AND clientId EQ 4) OR (cgi.SERVER_NAME EQ "api.targetedgotv.com" AND clientId EQ 6)>
	<cfinclude template="ABEmailWithOptions.cfm">--->
	<cfelse>
	<cfinclude template="ClientABEmail.cfm">
	</cfif>
<cfelse>
	<cfinclude template="ABEmailNoOptions.cfm">
</cfif>