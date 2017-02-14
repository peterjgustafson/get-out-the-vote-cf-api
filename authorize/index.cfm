<cfheader name="Access-Control-Allow-Origin" value="*">
<cfif len(trim(cgi.HTTP_REFERER))>
	<cfquery name="checkClientSite" datasource="GOTV">
	SELECT     dbo.Clients_DomainNames.DomainName, dbo.Clients_Master.ClientId, dbo.Clients_Master.APISecret
	FROM         dbo.Clients_DomainNames INNER JOIN
	                      dbo.Clients_Master ON dbo.Clients_DomainNames.ClientID = dbo.Clients_Master.ClientId
	WHERE     dbo.Clients_DomainNames.DomainName = '#listGetAt(cgi.HTTP_REFERER, 2, "/")#';
	</cfquery>
	
	<cfset localDate = now() />
	<cfset utcDate = dateConvert( "local2utc", localDate ) />
	
		<cfif structKeyExists(url, "authKey") AND structKeyExists(url, "timestamp") AND checkClientSite.recordCount>
			<cfset secondsPast = abs(utcDate.getTime()-url.timestamp) / 1000>
			<!--- Encoding using timestamp using the api secret and compare to the authKey If we have a match return a CSRF token --->
			<cfif secondsPast LTE 60 AND lcase(hmac(url.timestamp, checkClientSite.APISecret, "HmacSHA256" )) EQ lcase(url.authKey)>
				<!---<cfset authResponse = CSRFGenerateToken(checkClientSite.APISecret, true)>--->
					<cfset authResponse = CSRFGenerateToken()>
					<cfquery name="insertToken" datasource="GOTV">
					INSERT INTO UserTokens
					(UserToken, ClientId)
					VALUES
					('#authResponse#', #checkClientSite.ClientId#);
					</cfquery>
				<cfif structKeyExists(url, "callback")>
					<cfset authResponse = url.callback & "(" & authResponse & ")">
		        </cfif>
		        <!---Success --->
				<cfoutput>#authResponse#</cfoutput>
			<cfelse>
				<!---<cfheader statuscode="403" statustext="Unauthorized">--->
				<cfoutput>
					
		        	<!---IF the first line and second line don't match then wrong secret or encryption method was used. If they do then timestamp is off by more than 60 seconds --->
					#hmac(url.timestamp, checkClientSite.APISecret, "HmacSHA256")#
					<br>
					#url.authKey#
					<br>
					#utcDate.getTime()#
					<br>
					#secondsPast#
				</cfoutput>
			</cfif>
		<cfelse>
			<!---<cfheader statuscode="403" statustext="Unauthorized">--->
			<cfoutput>
				#utcDate.getTime()#
				<br>
				#localDate.getTime()#
			</cfoutput>
			<cfdump var="#checkClientSite#">
			<cfdump var="#cgi#">
		</cfif>
<cfelse>
		<!---<cfheader statuscode="403" statustext="Unauthorized">--->
		NO REFERER SENT
</cfif>



<!---<cfoutput>
	#hmac("1406502410037", "E4D97AAA-4761-42D0-9A5F-7A110267A27D", "HmacSHA256" )#
	<br>
	#localDate.getTime()#
	<br>
	#utcDate.getTime()#
	
	<br>
	#secondsPast#
</cfoutput>--->