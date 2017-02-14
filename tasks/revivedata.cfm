	<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath())#US_Chamber_1339.txt" variable="RNCData" >
	<cfset messages = deserializeJSON(RNCData).Messages>
	<cfloop index="i" from="1" to="#arrayLen(messages)#">
		<cfoutput>
		#messages[i].Subject#
		<br>
		#messages[i].Recipients[1]#
		<br>
		#dateFormat(left(messages[i].ReceivedAt,10), "mm/dd/yyyy")#
		<br>
		</cfoutput>
		
		<cfquery name="searchVoter" datasource="GOTV">
			SELECT TOP 1 VoterId FROM Voters
			WHERE email = '#messages[i].Recipients[1]#'
		</cfquery>
		
		<cfif searchVoter.RecordCount GT 0>Voter Found In DB (<cfoutput>#searchVoter.VoterId#</cfoutput>)<cfelse>VOTER NOT FOUND</cfif><br>
		
		<cfif findNoCase("absentee", messages[i].Subject)>
			Absentee
			<cfset gotv = "Absentee">
		<cfelseif findNoCase("registration", messages[i].Subject)>
			Registration
			<cfset gotv = "Reg">
		<cfelse>
			EarlyVote
			<cfset gotv = "EV">
		</cfif>
		
		<cfif searchVoter.recordCount>
		<cfquery name="updateVoter" datasource="GOTV">
			UPDATE Voters
			SET gotv = '#gotv#'
			,date_created = <cfqueryparam value="#dateFormat(left(messages[i].ReceivedAt,10), "mm/dd/yyyy")#" cfsqltype="cf_sql_timestamp">
			WHERE VoterId = #searchVoter.VoterId#
		</cfquery>
		</cfif>
		
		<br>
		<br>
	</cfloop>