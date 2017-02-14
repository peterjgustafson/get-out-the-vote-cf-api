<cfquery name="getClientEmailContent" datasource="GOTV">
	SELECT     ClientEmailHeader, ClientEmailFooter, ClientABEmailCopy, SendersEmailAddress, SendersName, PostmarkSender, ClientId, PostmarkAPIKey
	FROM         dbo.Clients_Master
	WHERE     (ClientId = #clientId#)
</cfquery>
<cfquery name="getStateName" datasource="GOTV">
	SELECT     StateFull
	FROM         dbo.States
	WHERE     (State = '#stateAbbr#')
</cfquery>
<cfinclude template="../util/StripHTML.cfm" >
<cfsavecontent variable="bullets"><ul>
<cfloop index="x" from="1" to="#arrayLen(emailContent.emailBullets)#"><li><p><cfoutput>#emailContent.emailBullets[x]#</cfoutput></p></li></cfloop>
</ul></cfsavecontent>
<cfset EmailBody = getClientEmailContent.ClientABEmailCopy>
<cfset EmailBody = replace(EmailBody,"{firstName}", emailContent.firstName, "all")>
<cfset EmailBody = replace(EmailBody,"{bullets}", bullets, "all")>
<cfset EmailBody = replace(EmailBody,"{mailingAddress}", "<strong>#emailContent.mailingAddressHeader#</strong><br>#emailContent.mailingAddress#", "all")>
<cfset EmailBody = replace(EmailBody,"{abDeadline}", emailContent.abDeadline, "all")>
<cfset EmailBody = replace(EmailBody,"{electionDate}", emailContent.electionDate, "all")>
<cfset EmailBody = replace(EmailBody,"{state}", getStateName.StateFull, "all")>
<cfif len(trim(cgi.HTTP_REFERER))>
	<cfset linkToForm = replace(emailContent.shareURL, "gotv.prosperitypac.com", listGetAt(cgi.HTTP_REFERER,2,"/"), "all")>
<cfelse>
	<cfset linkToForm = replace(emailContent.shareURL, "gotv.prosperitypac.com", "targetedgotv.com", "all")>
</cfif>
<cfset EmailBody = replace(EmailBody,"{linkToForm}",linkToForm, "all")>
<cfset EmailBody = replace(EmailBody,"{signature}", getClientEmailContent.SendersName, "all")>
<cfif structKeyExists(emailContent, "mailingAddressFooter")><cfset EmailBody = replace(EmailBody,"{lookupURL}", emailContent.mailingAddressFooter, "all")></cfif>
<cfset TextEmailBody = stripHTML(EmailBody)>
<cfset _attachmentStruct = StructNew()>
<cfset _attachmentStruct._attachment1 = "#attachmentPath#">
<cfsavecontent variable="emailBodyHTML"><cfinclude template="RNCEmailStart.cfm">
		<cfoutput>#EmailBody#</cfoutput>
		<cfinclude template="RNCEmailEnd.cfm"></cfsavecontent>
<cfinvoke component="PostMarkAPI" method="sendMail" returnVariable="pmCode" argumentCollection="#_attachmentStruct#">
    <cfinvokeargument name="mailTo" value="#url.Email#">
    <cfinvokeargument name="mailFrom" value="#getClientEmailContent.SendersEmailAddress#">
    <cfinvokeargument name="mailSubject" value="Absentee Ballot application">
    <cfinvokeargument name="apiKey" value="#getClientEmailContent.PostmarkAPIKey#">
    <cfinvokeargument name="mailHTML" value="#emailBodyHTML#">
</cfinvoke>
<!---<cfmail from="vote@gop.com" subject="Absentee Ballot application" to="#url.Email#" remove="true" server="smtp.postmarkapp.com" username="40cec44b-5099-4223-9204-9cf152336eb5" password="40cec44b-5099-4223-9204-9cf152336eb5" >
	<cfmailparam file="#attachmentPath#" disposition="attachment">
    <cfmailpart type="html">
		<cfinclude template="RNCEmailStart.cfm">
		<cfoutput>#EmailBody#</cfoutput>
		<cfinclude template="RNCEmailEnd.cfm">
    </cfmailpart>
	<cfmailpart type="text" wraptext="74"><cfoutput>#TextEmailBody#</cfoutput></cfmailpart>
</cfmail>--->