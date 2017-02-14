<cfquery name="locTemp" dataSource="GOTV">
SELECT *
FROM dbo.AZLocationsTemp
WHERE Imported IS NULL
ORDER BY County
</cfquery>
<cfoutput query="locTemp">
	<cfset hours = "">
	<cfif len(trim(HoursOfOperation5))>
	<cfset hours = "#HoursOfOperation# | #HoursOfOperation2# | #HoursOfOperation3# | #HoursOfOperation4# | #HoursOfOperation5#">
	<cfelseif len(trim(HoursOfOperation4))>
	<cfset hours = "#HoursOfOperation# | #HoursOfOperation2# | #HoursOfOperation3# | #HoursOfOperation4#">
	<cfelseif len(trim(HoursOfOperation3))>
	<cfset hours = "#HoursOfOperation# | #HoursOfOperation2# | #HoursOfOperation3#">
	<cfelseif len(trim(HoursOfOperation2))>
	<cfset hours = "#HoursOfOperation# | #HoursOfOperation2#">
	<cfelse>
	<cfset hours = HoursOfOperation>
	</cfif>
	<cfset importSuccess = 1>
	<cftry>
		<!--- <cfquery name="import" dataSource="VoteVA">
			UPDATE dbo.EarlyVotingLocations
			SET PhoneNumber = '#PhoneNumber#'
			WHERE Address1 = '#Address1#' AND City = '#City#' AND ZipCode = '#ZipCode#'
		</cfquery> --->
		<cfquery name="import" dataSource="GOTV">
		INSERT INTO dbo.EarlyVotingLocations
		(County,LocationName,Address1,Address2,City,State,ZipCode,HoursOfOperation,PhoneNumber,Email,Website)
		VALUES
		('#County#','#LocationName#','#Address#','#Address2#','#City#','AZ','#Zip#','#Hours#','#Phone#','#Email#','#Email#')
		</cfquery>
		<cfcatch type="any">
			<cfset importSuccess = 0>
            <cfoutput>#cfcatch.message#</cfoutput><br><br>
		</cfcatch>
	</cftry>
	<cfif importSuccess>
		<cfquery name="success" dataSource="GOTV">
		UPDATE dbo.AZLocationsTemp
		SET Imported = 1
		WHERE LocationId = #LocationId#
		</cfquery>
	</cfif>
</cfoutput>