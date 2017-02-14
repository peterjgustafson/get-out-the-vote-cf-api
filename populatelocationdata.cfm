<cfquery name="loc" dataSource="GOTV">
SELECT *
FROM EarlyVotingLocations
WHERE Lat IS NULL OR Lat = '0'
</cfquery>
<cfoutput query="loc">
Address: #Address1#, #City#, #State#<br>
	<cfset currentLat = Lat>
	<cfset currentLon = Lon>
	<cfset success = 1>
		<cftry>
		<cfinvoke component="com.targetedvictory.googlegeocoder3" method="googlegeocoder3" returnvariable="variables.geocodeQuery">	  
		  <cfinvokeargument name="address" value="#Address1#, #City#, #State#">
		  <cfinvokeargument name="ShowDetails" value="false">
		</cfinvoke>
		<cfset currentLat = geocodeQuery.Latitude>
		<cfset currentLon = geocodeQuery.Longitude>
		<cfcatch type="any"><cfset success = 0></cfcatch>
		</cftry>
	<cfif success>
	<cfquery name="update" dataSource="GOTV">
	UPDATE EarlyVotingLocations
	SET Lat = '#currentLat#', Lon = '#currentLon#'
	WHERE LocationId = #LocationId#
	</cfquery>
	
	<cfdump var="#variables.geocodeQuery#">
	
	</cfif>
	
	<cfflush>
</cfoutput>