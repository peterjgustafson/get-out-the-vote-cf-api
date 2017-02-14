<cfquery name="getLatestZips" datasource="GOTV">	
Select zipcode, county_key FROM Zip_CountiesTemp
</cfquery>

<cfoutput query="getLatestZips">
	<cfquery name="checkZip" datasource="GOTV">	
	Select zipcode, county_key FROM Zip_Counties
	WHERE zipcode = '#zipcode#' AND county_key = #county_key#
	</cfquery>
	<cfif checkZip.RecordCount EQ 0>
		<cfquery name="newZip" datasource="GOTV">	
		Insert Into Zip_Counties
		(zipcode, county_key)
		Values
		('#zipcode#',#county_key#)
		</cfquery>
		Zip County Combo Inserted ('#zipcode#',#county_key#) <br><br>
	</cfif>
</cfoutput>