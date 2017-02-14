<cfquery name="getAddress" datasource="GOTV">
SELECT     dbo.Counties_Master.county_name, dbo.Counties_Master.OfficialOfficeName, dbo.Counties_Master.ClerkFullName, dbo.Counties_Master.ClerkEmailAddress, dbo.Counties_Master.ClerkPhone AS Phone, 
                      dbo.Counties_Master.ClerkAddress1 AS ABAddress1, dbo.Counties_Master.ClerkAddress2 AS ABAddress2, dbo.Counties_Master.ClerkCity AS ABCity, dbo.Counties_Master.ClerkZip AS ABZip, dbo.Counties_Master.ClerkFax AS Fax
FROM         dbo.Counties_Master INNER JOIN
                      dbo.Zip_Counties ON dbo.Counties_Master.county_key = dbo.Zip_Counties.county_key
WHERE     (dbo.Zip_Counties.zipcode = '#url.rzip5#') AND Len(dbo.Counties_Master.ClerkAddress1) > 0;
</cfquery>
<cfif getAddress.recordCount GT 1 AND structKeyExists(url, "cust_county")>
	<cfquery name="getAddress" datasource="GOTV">
		SELECT     dbo.Counties_Master.county_name, dbo.Counties_Master.OfficialOfficeName, dbo.Counties_Master.ClerkFullName, dbo.Counties_Master.ClerkEmailAddress, 
                      dbo.Counties_Master.ClerkPhone AS Phone, dbo.Counties_Master.ClerkAddress1 AS ABAddress1, dbo.Counties_Master.ClerkAddress2 AS ABAddress2, 
                      dbo.Counties_Master.ClerkCity AS ABCity, dbo.Counties_Master.ClerkZip AS ABZip, dbo.Counties_Master.ClerkFax AS Fax
		FROM         dbo.Counties_Master INNER JOIN
		                  dbo.States ON dbo.Counties_Master.state_name = dbo.States.StateFull
		WHERE     (dbo.States.State = '#stateAbbr#') AND (dbo.Counties_Master.county_name LIKE '#trim(url.cust_county)#%')
		</cfquery>
</cfif>