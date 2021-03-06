		<cfinclude template="../sql/countyMailingAddressLookup.cfm" >
		
		<cfset addressLookupURL = "https://vip.sos.nd.gov/WhereToVote.aspx?tab=ElectionOfficial&ptlPKID=7&ptlhPKID=53">
		<cfset mailingAddressDefaulHtml = "Use the link below to find the correct mailing address.<br/><a href='#addressLookupURL#'>#addressLookupURL#</a>">
		
		<cfset formReturnData.PDFURL = "http://#cgi.server_name#/#stateAbbr#/temp/#fileName#">
		<cfset formReturnData.ThankYou = structNew()>
		<cfset formReturnData.Parameters = serializeJSON(url)>
		<cfset formReturnData.ThankYou.ShowId = "false">
		<cfset formReturnData.ThankYou.ShowSignature = "true">
		<cfset formReturnData.ThankYou.ShowMailer = "true">
		<cfset formReturnData.ThankYou.ShowMailingAddress = "true">
		<cfif getAddress.recordCount>
			<cfsavecontent variable="formattedAddress">
				<cfoutput query="getAddress"><cfif len(trim(ClerkFullName))>#ClerkFullName#<br></cfif><cfif len(trim(OfficialOfficeName))>#OfficialOfficeName#<br></cfif>#ABAddress1#<cfif len(trim(ABAddress2))><br>#ABAddress2#</cfif><br>#ABCity#, #stateAbbr# #ABZip#<cfif len(trim(Phone))><br>Phone: #Phone#</cfif><cfif len(trim(Fax))><br>Fax: #Fax#</cfif><cfif currentRow NEQ recordCount><br><br></cfif></cfoutput>
			</cfsavecontent>
			<cfset formReturnData.ThankYou.MailingAddress = "#formattedAddress#">
		<cfelse>
			<cfset formReturnData.ThankYou.MailingAddress = "#mailingAddressDefaulHtml#">
		</cfif>
		
		<!---We will want to drive this from the database later --->

		<cfset emailContent = structNew()>
		<cfset emailContent.firstName = "#url.fname#">
		
		<!---Mailing address or link to lookup --->
		<cfif getAddress.recordCount>
			<cfset emailContent.mailingAddressHeader = "Your clerk's address is:">
			<cfset emailContent.mailingAddress = "#formattedAddress#">
			<!---Mailing address lookup footer on  --->
			<cfset emailContent.mailingAddressFooter = "<p>P.S. You can also see a full list of <a href=""#addressLookupURL#"">mailing addresses here</a></p>">
		<cfelse>
			<cfset emailContent.mailingAddressHeader = "Find your clerk's address:">
			<cfset emailContent.mailingAddress = "<a href=""#addressLookupURL#"">#addressLookupURL#</a>">
			<!--- Blank Footer  --->
			<cfset emailContent.mailingAddressFooter = "">
		</cfif>
		
		<!---Array of bullet point to display in the email --->
		<cfset emailContent.emailBullets = arrayNew(1)>
		<cfset arrayAppend(emailContent.emailBullets, "Review and complete all additional required fields")>
		<cfset arrayAppend(emailContent.emailBullets, "Sign and date the application")>
		<cfset arrayAppend(emailContent.emailBullets, "Mail it to your county clerk's office.")>
		
		<!---Get upcoming election for the current state so we can put the dates in the email --->
		<cfquery name="getUpcomingElection" datasource="GOTV">	
		SELECT TOP 1 ElectionName, ABEndDate, ElectionDate
		FROM         dbo.Elections
		WHERE DateDiff(d, GetDate(), ElectionDate) > 0
		AND State = '#stateAbbr#'
		ORDER BY ElectionDate;
		</cfquery>
		<cfif getUpcomingElection.recordCount>
			<cfset emailContent.abDeadline = " #dateFormat(getUpcomingElection.ABEndDate, "mmmm d, yyyy")#">
			<cfset emailContent.electionDate = " #dateFormat(getUpcomingElection.ElectionDate, "mmmm d, yyyy")#">
		<cfelse>
			<cfset emailContent.abDeadline = "  ">
			<cfset emailContent.electionDate = " ">
		</cfif>
		
		<cfset emailContent.shareURL = "http://gotv.prosperitypac.com/#stateAbbr#">