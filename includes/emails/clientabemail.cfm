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
<cfquery name="getUpcomingElection" datasource="GOTV">	
		SELECT TOP 1 ElectionName, ABEndDisplayDate, ElectionDate
		FROM         dbo.Elections
		WHERE DateDiff(d, GetDate(), ElectionDate) > 0
		AND State = '#stateAbbr#'
		ORDER BY ElectionDate;
</cfquery>
<cfif getUpcomingElection.recordCount>
	<cfset abDeadline = " #dateFormat(getUpcomingElection.ABEndDisplayDate, "mmmm d, yyyy")#">
	<cfset electionDate = " #dateFormat(getUpcomingElection.ElectionDate, "mmmm d, yyyy")#">
<cfelse>
	<cfset abDeadline = "  ">
	<cfset electionDate = " ">
</cfif>
<cfinclude template="../util/StripHTML.cfm" >
<cfsavecontent variable="bullets"><ul>
<cfloop index="x" from="1" to="#arrayLen(emailContent.emailBullets)#"><li><p><cfoutput>#emailContent.emailBullets[x]#</cfoutput></p></li></cfloop>
</ul></cfsavecontent>
<cfset EmailBody = getClientEmailContent.ClientABEmailCopy>
<cfset EmailBody = replace(EmailBody,"{firstName}", emailContent.firstName, "all")>
<cfset EmailBody = replace(EmailBody,"{bullets}", bullets, "all")>
<cfset EmailBody = replace(EmailBody,"{mailingAddress}", "<strong>#emailContent.mailingAddressHeader#</strong><br>#emailContent.mailingAddress#", "all")>
<cfset EmailBody = replace(EmailBody,"{abDeadline}", abDeadline, "all")>
<cfset EmailBody = replace(EmailBody,"{electionDate}", electionDate, "all")>
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
<cfsavecontent variable="emailBodyHTML"><cfinclude template="ClientEmailStart.cfm">
		<cfoutput>#EmailBody#</cfoutput>
		<cfinclude template="ClientEmailEnd.cfm"></cfsavecontent>
<cfinvoke component="PostMarkAPI" method="sendMail" returnVariable="pmCode" argumentCollection="#_attachmentStruct#">
    <cfinvokeargument name="mailTo" value="#url.Email#">
    <cfinvokeargument name="mailFrom" value="#getClientEmailContent.SendersEmailAddress#">
    <cfinvokeargument name="mailSubject" value="Absentee Ballot application">
    <cfinvokeargument name="apiKey" value="#getClientEmailContent.PostmarkAPIKey#">
    <cfinvokeargument name="mailHTML" value="#emailBodyHTML#">
</cfinvoke>
<!---<cfmail from="#getClientEmailContent.SendersEmailAddress#" subject="Absentee Ballot application" to="#url.Email#" remove="true" server="smtp.postmarkapp.com" username="#getClientEmailContent.PostmarkAPIKey#" password="#getClientEmailContent.PostmarkAPIKey#" >
	<cfmailparam file="#attachmentPath#" disposition="attachment">
	<cfmailpart type="text" wraptext="74"><cfoutput>#TextEmailBody#</cfoutput></cfmailpart>
    <cfmailpart type="html">
		<cfinclude template="ClientEmailStart.cfm">
		<cfoutput>#EmailBody#</cfoutput>
		<cfinclude template="ClientEmailEnd.cfm">
    </cfmailpart>
</cfmail>--->