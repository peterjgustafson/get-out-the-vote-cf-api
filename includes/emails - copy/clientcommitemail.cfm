<cfquery name="getClientEmailContent" datasource="GOTV">
	SELECT     ClientEmailHeader, ClientEmailFooter, CommitEmailCopy, SendersEmailAddress, SendersName, PostmarkSender, ClientId, PostmarkAPIKey
	FROM         dbo.Clients_Master
	WHERE     (ClientId = #clientId#)
</cfquery>

<cfquery name="getStateName" datasource="GOTV">
	SELECT     StateFull
	FROM         dbo.States
	WHERE     (State = '#arguments.stateAbbr#')
</cfquery>
<cfinclude template="../util/StripHTML.cfm" >
<cfset EmailBody = getClientEmailContent.CommitEmailCopy>
<cfif isDefined("url.fname")><cfset EmailBody = replace(EmailBody,"{firstName}", url.fname)><cfelse><cfset EmailBody = replace(EmailBody,"<p>{firstName}<p/>", "")></cfif>
<cfset EmailBody = replace(EmailBody,"{electionDay}", "Nov. 4, 2014")>
<cfset EmailBody = replace(EmailBody,"{signature}", getClientEmailContent.SendersName, "all")>
<cfset EmailBody = replace(EmailBody,"{state}", getStateName.StateFull, "all")>
<cfset TextEmailBody = stripHTML(EmailBody)>
<cfsavecontent variable="emailBodyHTML"><cfinclude template="ClientEmailStart.cfm">
		<cfoutput>#EmailBody#</cfoutput>
		<cfinclude template="ClientEmailEnd.cfm"></cfsavecontent>
<cfinvoke component="PostMarkAPI" method="sendMail" returnVariable="pmCode">
    <cfinvokeargument name="mailTo" value="#url.Email#">
    <cfinvokeargument name="mailFrom" value="#getClientEmailContent.SendersEmailAddress#">
    <cfinvokeargument name="mailSubject" value="Your Election Day Voting Location">
    <cfinvokeargument name="apiKey" value="#getClientEmailContent.PostmarkAPIKey#">
    <cfinvokeargument name="mailHTML" value="#emailBodyHTML#">
</cfinvoke>
<!---<cfmail from="#getClientEmailContent.SendersEmailAddress#" subject="Your Election Day Voting Location" to="#url.Email#" remove="true" server="smtp.postmarkapp.com" username="#getClientEmailContent.PostmarkAPIKey#" password="#getClientEmailContent.PostmarkAPIKey#" >
	<cfmailpart type="text" wraptext="74"><cfoutput>#TextEmailBody#</cfoutput></cfmailpart>
    <cfmailpart type="html"><cfinclude template="ClientEmailStart.cfm">
	<cfoutput>#EmailBody#</cfoutput>
	<cfinclude template="ClientEmailEnd.cfm">
	</cfmailpart>
</cfmail>--->