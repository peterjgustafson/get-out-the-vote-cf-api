<!--- Security Check --->
		<cfset requestHeaders = getHttpRequestData().headers />
			
		<cfset authenitcationMethod = "whitelist">	
		
		<cfif len(trim(cgi.HTTP_REFERER))>
			<!---Logic to lockdown serverside only functionality --->
			<cfscript>
				writeLog(file="GOTVSecurity", text="Is Client Side: #cgi.HTTP_REFERER# | #listGetAt(cgi.HTTP_REFERER,2,"/")#");
			</cfscript>
			<cfset authenitcationMethod = "client">
		<cfelseif structKeyExists(requestHeaders, "username") AND structKeyExists(requestHeaders, "password")>
			<cfset authenitcationMethod = "keyAndSecret">
		</cfif>
			
		<cfset userIsAuthorized = false>
			
		<cfswitch expression="#authenitcationMethod#">
			<cfcase value="whitelist">
				<!--- IP WHitelist --->
				<cfquery name="checkSandbox" datasource="GOTV">
				SELECT SandboxedIP from SandboxedIPs WHERE SandboxedIP = '#cgi.REMOTE_ADDR#';
				</cfquery>
				<cfif checkSandbox.recordCount>
					<cfset userIsAuthorized = "true">
				</cfif>
				<!--- END IP WHitelist --->	
			</cfcase>
			<cfcase value="keyAndSecret">
				<!--- API Key and Secret --->
				<cfquery name="checkClientKeyAndSecret" datasource="GOTV">
				SELECT ClientId, ClientName, APIKey, APISecret from Clients_Master WHERE APIKey = '#requestHeaders.username#' AND APISecret = '#requestHeaders.password#';
				</cfquery>
				<cfif checkClientKeyAndSecret.recordCount>
					<cfscript>
							writeLog(file="GOTVSecurity", text="ServerSide Request: #checkClientKeyAndSecret.ClientName#");
					</cfscript>
					<cfset session.currentClientId = checkClientKeyAndSecret.ClientId>
					<cfset userIsAuthorized = "true">
				</cfif>
				<!--- END API Key and Secret --->
			</cfcase> 
			<cfcase value="client">
				<!--- Client Side Token Verification --->
				<cfif structKeyExists(url, "authToken")>
					<cfquery name="checkToken" datasource="GOTV">
					Select * FROM UserTokens
					WHERE UserToken = '#url.authToken#';
					</cfquery>
					<cfif checkToken.RecordCount>
						<cfquery name="checkClientSite" datasource="GOTV">
						SELECT     dbo.Clients_DomainNames.DomainName, dbo.Clients_Master.ClientId, dbo.Clients_Master.APISecret
						FROM         dbo.Clients_DomainNames INNER JOIN
						                      dbo.Clients_Master ON dbo.Clients_DomainNames.ClientID = dbo.Clients_Master.ClientId
						WHERE     dbo.Clients_DomainNames.DomainName = '#listGetAt(cgi.HTTP_REFERER,2,"/")#' AND dbo.Clients_Master.ClientId = #checkToken.ClientId#;
						</cfquery>
						<cfif checkClientSite.RecordCount>
							<cfheader name="Access-Control-Allow-Origin" value="*">
							<cfscript>
									writeLog(file="GOTVSecurity", text="Token Valid. Referrer: #cgi.HTTP_REFERER# | #listGetAt(cgi.HTTP_REFERER,2,"/")#");
							</cfscript>
							<cfset userIsAuthorized = "true">
						</cfif>
					<cfelse>
					<cfscript>
						writeLog(file="GOTVSecurity", text="Token Invalid. Referrer: #cgi.HTTP_REFERER# | #listGetAt(cgi.HTTP_REFERER,2,"/")#");
					</cfscript>
					</cfif>
					<!---<cfquery name="checkClientSite" datasource="GOTV">
					SELECT     dbo.Clients_DomainNames.DomainName, dbo.Clients_Master.ClientId, dbo.Clients_Master.APISecret
					FROM         dbo.Clients_DomainNames INNER JOIN
					                      dbo.Clients_Master ON dbo.Clients_DomainNames.ClientID = dbo.Clients_Master.ClientId
					WHERE     dbo.Clients_DomainNames.DomainName = '#listGetAt(cgi.HTTP_REFERER,2,"/")#';
					</cfquery>
					<!---If the domain is in the client list, check the token using the API Secret as the key --->
					<cfif checkClientSite.RecordCount>
						<cfif CSRFVerifyToken(url.authToken, checkClientSite.APISecret)>
							<cfset session.currentClientId = checkClientSite.ClientId>
							<cfset userIsAuthorized = "true">
						<cfelse>
						<cfscript>
							writeLog(file="GOTVSecurity", text="Token Invalid. Referrer: #cgi.HTTP_REFERER# | #listGetAt(cgi.HTTP_REFERER,2,"/")#");
						</cfscript>
						</cfif>
					<cfelse>
						<cfscript>
							writeLog(file="GOTVSecurity", text="Referring Site not in installation table. Referrer: cgi.HTTP_REFERER | #listGetAt(cgi.HTTP_REFERER,2,"/")#");
						</cfscript>
					</cfif>--->
					<cfelse>
					<cfscript>
						writeLog(file="GOTVSecurity", text="No Auth Token Passed. Referrer: cgi.HTTP_REFERER | #listGetAt(cgi.HTTP_REFERER,2,"/")#");
					</cfscript>
				</cfif>
				<!--- End Client Side Token Verification --->
			</cfcase>
			<cfdefaultcase>
				
			</cfdefaultcase>
		</cfswitch>
			
		<cfif NOT userIsAuthorized>
			<cfreturn false>
		<cfelse>
			<cfreturn true>
		</cfif>
			
		

<!--- End Security Check --->