<cfquery name="getClientEmailContent" datasource="GOTV">
	SELECT     ClientEmailHeader, ClientEmailFooter, ClientRegEmailCopy, SendersEmailAddress, SendersName, PostmarkSender, ClientId, PostmarkAPIKey
	FROM         dbo.Clients_Master
	WHERE     (ClientId = #clientId#)
</cfquery>
<cfquery name="getStateName" datasource="GOTV">
	SELECT     StateFull
	FROM         dbo.States
	WHERE     (State = '#stateAbbr#')
</cfquery>
<cfinclude template="../util/StripHTML.cfm" >

<cfset EmailBody = getClientEmailContent.ClientRegEmailCopy>
<cfif structKeyExists(url,"fname_new_voter_reg")>
	<cfset EmailBody = replace(EmailBody,"{firstName}", url.fname_new_voter_reg, "all")>
<cfelse>
	<cfset EmailBody = replace(EmailBody,"{firstName}", url.fname, "all")>
</cfif>
<cfif stateAbbr NEQ "NH">
	<cfset EmailBody = replace(EmailBody,"{mailingAddress}", formReturnData.ThankYou.MailingAddress, "all")>
<cfelse>
	<cfset nhExceptiopn = "Thank you for registering to vote. Don't forget to print your form, add your ID number, sign your full name, print today's date, and mail to your state office">
	<cfset EmailBody = replace(EmailBody,"{mailingAddress}", "", "all")>
</cfif>
<cfset EmailBody = replace(EmailBody,"{signature}", getClientEmailContent.SendersName, "all")>
<cfset EmailBody = replace(EmailBody,"{state}", getStateName.StateFull, "all")>
<cfset TextEmailBody = stripHTML(EmailBody)>
<cfset _attachmentStruct = StructNew()>
<cfset _attachmentStruct._attachment1 = "#attachmentPath#">
<cfsavecontent variable="emailBodyHTML"><cfinclude template="ClientEmailStart.cfm">
		<cfoutput>#EmailBody#</cfoutput>
		<cfinclude template="ClientEmailEnd.cfm"></cfsavecontent>
<cfinvoke component="PostMarkAPI" method="sendMail" returnVariable="pmCode" argumentCollection="#_attachmentStruct#">
    <cfinvokeargument name="mailTo" value="#url.Email#">
    <cfinvokeargument name="mailFrom" value="#getClientEmailContent.SendersEmailAddress#">
    <cfinvokeargument name="mailSubject" value="Voter Registration Form">
    <cfinvokeargument name="apiKey" value="#getClientEmailContent.PostmarkAPIKey#">
    <cfinvokeargument name="mailHTML" value="#emailBodyHTML#">
</cfinvoke>
<!---<cfmail from="#getClientEmailContent.SendersEmailAddress#" subject="Voter Registration Form" to="#url.Email#" remove="true" server="smtp.postmarkapp.com" username="#getClientEmailContent.PostmarkAPIKey#" password="#getClientEmailContent.PostmarkAPIKey#" >
	<cfmailparam file="#parentDirectory#US\temp\#fileName#" disposition="attachment">
	<cfmailpart type="text" wraptext="74"><cfoutput>#TextEmailBody#</cfoutput></cfmailpart>
    <cfmailpart type="html">
		<cfinclude template="ClientEmailStart.cfm">
		<cfoutput>#EmailBody#</cfoutput>
		<cfinclude template="ClientEmailEnd.cfm">
    </cfmailpart>
</cfmail>--->