<cfquery name="getAddress" datasource="GOTV">
SELECT     ABOfficeName AS OfficialOfficeName, Address1 AS ABAddress1, Address2 AS ABAddress2, City AS ABCity, Zip AS ABZip, EmailAddress AS Phone, '' AS Fax, '' AS ClerkFullName
FROM         dbo.States
WHERE State = '#stateAbbr#'
</cfquery>