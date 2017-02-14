		<cfif left(url.rzip5,1) EQ "0">
			<cfset url.rzip5 = right(url.rzip5,4)>
		</cfif>
		<cfquery name="getAddress" dataSource="GOTV" maxrows="1">
		SELECT     dbo.States.StateFull, dbo.States.State, dbo.Counties_Master.county_key, dbo.Counties_Master.county_name, dbo.Municipalities.MunicipalityId, 
		              dbo.Municipalities.MunicipalityName, dbo.Municipalities.county_key AS Expr1, dbo.Municipalities.ABEmailAddress, dbo.Municipalities.ABAddress1, 
		              dbo.Municipalities.ABAddress2, dbo.Municipalities.ABCity, dbo.Municipalities.ABZip, dbo.Municipalities.RegEmailAddress, dbo.Municipalities.RegAddress1, 
		              dbo.Municipalities.RegAddress2, dbo.Municipalities.RegCity, dbo.Municipalities.RegZip, dbo.Municipalities.ClerkFullName, dbo.Municipalities.OfficialOfficeName, dbo.Municipalities.Phone, dbo.Municipalities.Fax
		FROM         dbo.Counties_Master INNER JOIN
		                      dbo.Municipalities ON dbo.Counties_Master.county_key = dbo.Municipalities.county_key INNER JOIN
		                      dbo.States ON dbo.Counties_Master.state_name = dbo.States.StateFull
		WHERE dbo.Municipalities.ABZip = '#url.rzip5#'
		</cfquery>
		<cfif getAddress.recordCount EQ 0>
			<cfquery name="getAddress" dataSource="GOTV" maxrows="1">
		    SELECT     dbo.States.StateFull, dbo.States.State, dbo.Counties_Master.county_key, dbo.Counties_Master.county_name, dbo.Municipalities.MunicipalityId, 
		                  dbo.Municipalities.MunicipalityName, dbo.Municipalities.county_key AS Expr1, dbo.Municipalities.ABEmailAddress, dbo.Municipalities.ABAddress1, 
		                  dbo.Municipalities.ABAddress2, dbo.Municipalities.ABCity, dbo.Municipalities.ABZip, dbo.Municipalities.RegEmailAddress, dbo.Municipalities.RegAddress1, 
		                  dbo.Municipalities.RegAddress2, dbo.Municipalities.RegCity, dbo.Municipalities.RegZip, dbo.Municipalities.ClerkFullName, dbo.Municipalities.OfficialOfficeName, dbo.Municipalities.Phone, dbo.Municipalities.Fax
			FROM         dbo.Counties_Master INNER JOIN
			                      dbo.Municipalities ON dbo.Counties_Master.county_key = dbo.Municipalities.county_key INNER JOIN
			                      dbo.States ON dbo.Counties_Master.state_name = dbo.States.StateFull
			WHERE dbo.Municipalities.ABZip = '#url.rzip5#' AND dbo.Counties_Master.county_name = '#url.cust_county#';
		    </cfquery>
		</cfif>
		<cfif getAddress.recordCount EQ 0>
			<cfquery name="getAddress" dataSource="GOTV" maxrows="1">
		    SELECT     dbo.States.StateFull, dbo.States.State, dbo.Counties_Master.county_key, dbo.Counties_Master.county_name, dbo.Municipalities.MunicipalityId, 
		                  dbo.Municipalities.MunicipalityName, dbo.Municipalities.county_key AS Expr1, dbo.Municipalities.ABEmailAddress, dbo.Municipalities.ABAddress1, 
		                  dbo.Municipalities.ABAddress2, dbo.Municipalities.ABCity, dbo.Municipalities.ABZip, dbo.Municipalities.RegEmailAddress, dbo.Municipalities.RegAddress1, 
		                  dbo.Municipalities.RegAddress2, dbo.Municipalities.RegCity, dbo.Municipalities.RegZip, dbo.Municipalities.ClerkFullName, dbo.Municipalities.OfficialOfficeName, dbo.Municipalities.Phone, dbo.Municipalities.Fax
			FROM         dbo.Counties_Master INNER JOIN
			                      dbo.Municipalities ON dbo.Counties_Master.county_key = dbo.Municipalities.county_key INNER JOIN
			                      dbo.States ON dbo.Counties_Master.state_name = dbo.States.StateFull
			WHERE dbo.States.State = 'WI' AND dbo.Municipalities.MunicipalityName = '#url.city#';
		    </cfquery>
		</cfif>