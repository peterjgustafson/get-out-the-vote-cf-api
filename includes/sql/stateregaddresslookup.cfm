<cfquery name="getAddress" datasource="GOTV">
SELECT     RegOfficeName AS OfficialOfficeName, RegAddress1 AS Address1, RegAddress2 AS Address2, RegCity AS City, RegZip AS Zip, RegEmailAddress as Email
FROM         dbo.States
WHERE State = '#stateAbbr#'
</cfquery>