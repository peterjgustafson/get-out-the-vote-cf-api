<cfquery name="getClientEmailContent" datasource="GOTV">
	SELECT     ClientEmailHeader, ClientEmailFooter, ClientRegEmailCopy, SendersEmailAddress, SendersName, PostmarkSender, ClientId
	FROM         dbo.Clients_Master
	WHERE     (ClientId = #clientId#)
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
	<cfset EmailBody = replace(EmailBody,"{mailingAddress}", nhExceptiopn, "all")>
</cfif>
<cfset EmailBody = replace(EmailBody,"{signature}", getClientEmailContent.SendersName, "all")>
<cfset TextEmailBody = stripHTML(EmailBody)>
<cfset _attachmentStruct = StructNew()>
<cfset _attachmentStruct._attachment1 = "#attachmentPath#">
<cfsavecontent variable="emailBodyHTML"><cfinclude template="RNCEmailStart.cfm">
		<cfoutput>#EmailBody#</cfoutput>
		<cfinclude template="RNCEmailEnd.cfm"></cfsavecontent>
<cfinvoke component="PostMarkAPI" method="sendMail" returnVariable="pmCode" argumentCollection="#_attachmentStruct#">
    <cfinvokeargument name="mailTo" value="#url.Email#">
    <cfinvokeargument name="mailFrom" value="#getClientEmailContent.SendersEmailAddress#">
    <cfinvokeargument name="mailSubject" value="Voter Registration Form">
    <cfinvokeargument name="apiKey" value="#getClientEmailContent.PostmarkAPIKey#">
    <cfinvokeargument name="mailHTML" value="#emailBodyHTML#">
</cfinvoke>
<!---<cfmail from="vote@gop.com" subject="Voter Registration Form" to="#url.Email#" remove="true" server="smtp.postmarkapp.com" username="40cec44b-5099-4223-9204-9cf152336eb5" password="40cec44b-5099-4223-9204-9cf152336eb5" >
	<cfmailparam file="#parentDirectory#US\temp\#fileName#" disposition="attachment">
	<cfmailpart type="text" wraptext="74"><cfoutput>#TextEmailBody#</cfoutput></cfmailpart>
    <cfmailpart type="html">
		<cfinclude template="RNCEmailStart.cfm">
		<cfoutput>#EmailBody#</cfoutput>
		<cfinclude template="RNCEmailEnd.cfm">
    </cfmailpart>
</cfmail>--->