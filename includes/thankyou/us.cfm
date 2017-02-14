		<cfinclude template="../sql/stateRegAddressLookup.cfm" >

		<cfset attachmentPath = "#parentDirectory#US\temp\#fileName#">
		
		<cfset addressLookupURL = "">
		<cfset mailingAddressDefaulHtml = "">
		
		<cfset formReturnData.PDFURL = "http://#cgi.server_name#/US/ABPDF/#fileName#">
		
		<cfset formReturnData.ThankYou = structNew()>
		<cfset formReturnData.Parameters = serializeJSON(url)>
		<cfset formReturnData.ThankYou.ShowId = "true">
		<cfset formReturnData.ThankYou.ShowSignature = "true">
		<cfset formReturnData.ThankYou.ShowMailer = "true">
		<cfset formReturnData.ThankYou.ShowMailingAddress = "true">
		<cfif stateAbbr EQ "NH">
			<cfset formReturnData.ThankYou.MailingAddress = "The application should be mailed to your town or city clerk at your zip code.  These addresses are listed on the Secretary of State web site at <a href=""www.state.nh.us/sos/clerks.htm"">www.state.nh.us/sos/clerks.htm</a>">
		<cfelseif getAddress.recordCount>
			<cfsavecontent variable="formattedAddress">
				<cfoutput query="getAddress"><cfif len(trim(OfficialOfficeName))>#OfficialOfficeName#<br></cfif>#Address1#<cfif len(trim(Address2))><br>#Address2#</cfif><br>#City#, #stateAbbr# #Zip#<cfif len(trim(Email))><br>Email: #email#</cfif><cfif currentRow NEQ recordCount><br><br></cfif></cfoutput>
			</cfsavecontent>
			<cfset formReturnData.ThankYou.MailingAddress = "#formattedAddress#">
		<cfelse>
			<cfset formReturnData.ThankYou.MailingAddress = "#mailingAddressDefaulHtml#">
		</cfif>
		
		