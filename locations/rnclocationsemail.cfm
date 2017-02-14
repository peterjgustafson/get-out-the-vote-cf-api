<cfquery name="getClientEmailContent" datasource="GOTV">
	SELECT     ClientEmailHeader, ClientEmailFooter, ClientVotingLocEmailCopy, SendersEmailAddress, SendersName, PostmarkSender, ClientId, PostmarkAPIKey
	FROM         dbo.Clients_Master
	WHERE     (ClientId = #clientId#)
</cfquery>
<cfquery name="getEVDeadline" datasource="GOTV">
	SELECT     TOP 1 dbo.Elections.EVEndDisplayDate
		FROM         dbo.Elections INNER JOIN
		                      dbo.States ON dbo.Elections.State = dbo.States.State
		WHERE     (DATEDIFF(d, GETDATE(), dbo.Elections.ElectionDate) > 0)
		AND (dbo.Elections.State = '#loc.State#')
		ORDER BY dbo.Elections.ElectionDate
</cfquery>

<cfinclude template="../includes/util/StripHTML.cfm" >
<cfsavecontent variable="location"><cfoutput>
<b>Here's your polling information:</b><br>
#trim(loc.LocationName)#<br>
#loc.Address1#<br><cfif len(trim(loc.Address2))>
#loc.Address2#<br></cfif>
#loc.City#, 
#loc.State# #loc.ZipCode#<br>
#LocationInfo#<br>
#loc.PhoneNumber#<br>
#loc.Website#</cfoutput></cfsavecontent>
<cfset EmailBody = getClientEmailContent.ClientVotingLocEmailCopy>
<cfset EmailBody = replace(EmailBody,"{locationInfo}", location, "all")>
<cfset EmailBody = replace(EmailBody,"{evDeadline}", dateFormat(getEVDeadline.EVEndDisplayDate, "mmm d, yyyy"), "all")>
<cfset EmailBody = replace(EmailBody,"{signature}", getClientEmailContent.SendersName, "all")>
<cfset TextEmailBody = stripHTML(EmailBody)>
<cfsavecontent variable="emailBodyHTML"><cfinclude template="../includes/emails/RNCEmailStart.cfm">
		<cfoutput>#EmailBody#</cfoutput>
		<cfinclude template="../includes/emails/RNCEmailEnd.cfm"></cfsavecontent>
<cfinvoke component="PostMarkAPI" method="sendMail" returnVariable="pmCode">
    <cfinvokeargument name="mailTo" value="#url.Email#">
    <cfinvokeargument name="mailFrom" value="#getClientEmailContent.SendersEmailAddress#">
    <cfinvokeargument name="mailSubject" value="Your Early Voting Location">
    <cfinvokeargument name="apiKey" value="#getClientEmailContent.PostmarkAPIKey#">
    <cfinvokeargument name="mailHTML" value="#emailBodyHTML#">
</cfinvoke>
<!---<cfmail from="vote@gop.com" subject="Your Early Voting Location" to="#url.Email#" remove="true" server="smtp.postmarkapp.com" username="40cec44b-5099-4223-9204-9cf152336eb5" password="40cec44b-5099-4223-9204-9cf152336eb5" >
	<cfmailpart type="text" wraptext="74"><cfoutput>#TextEmailBody#</cfoutput></cfmailpart>
    <cfmailpart type="html"><cfinclude template="../includes/emails/RNCEmailStart.cfm">
	<cfoutput>#EmailBody#</cfoutput>
	<cfinclude template="../includes/emails/RNCEmailEnd.cfm">
	</cfmailpart>
</cfmail>--->