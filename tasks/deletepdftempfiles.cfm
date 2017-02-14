<!---Delete Tokens --->
<cfquery name="deleteTokens" datasource="GOTV">
DELETE FROM UserTokens
  WHERE DATEDIFF(n, Created ,GetDate()) > 20
</cfquery>
<!---Delete PDFs --->
	
<cfset tenMinutesAgo = dateAdd("n", -10, now())>
<cfset directoryList = "ak,al,ar,az,ca,co,ct,dc,de,fl,ga,hi,ia,id,il,in,ks,KY,la,ma,md,me,mi,mn,mo,ms,mt,nc,nd,ne,nh,nj,nm,nv,ny,oh,ok,or,pa,ri,sc,sd,tn,tx,US,ut,va,wa,WI,wv,wy">

<cfloop index="x" from="1" to="#listLen(directoryList)#" >
	
	<cfset filledFormDirectory = "c:\inetpub\wwwroot\#listGetAt(directoryList,x)#\temp">
	
	<cfdirectory action="list" directory="#filledFormDirectory#" name="files" type="file">
	
	<!--- get older files --->
	<cfquery name="oldfiles" dbtype="query">
	select    name
	from    files
	where    datelastmodified < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#tenMinutesAgo#">
	</cfquery>
	
	<cfoutput><strong>#listGetAt(directoryList,x)#/temp</strong><br> Out of #files.recordCount# files, there are #oldfiles.recordCount# to delete.<br></cfoutput>
	
	<cfif oldfiles.recordCount>
	    <cfloop query="oldfiles">
			
			<cftry>
	        <cffile action="delete" file="#filledFormDirectory#/#name#">
				<cfcatch><cfset canNotDelete = "true"></cfcatch>
			</cftry>
	    </cfloop>
	</cfif>
	
	<cfset flattenedFormDirectory = "c:\inetpub\wwwroot\#listGetAt(directoryList,x)#\ABPDF">
	
	<cfdirectory action="list" directory="#flattenedFormDirectory#" name="files" type="file">
	
	<!--- get older files --->
	<cfquery name="oldfiles" dbtype="query">
	select    name
	from    files
	where    datelastmodified < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#tenMinutesAgo#">
	</cfquery>
	
	<cfoutput><strong>#listGetAt(directoryList,x)#/abpdf</strong><br> Out of #files.recordCount# files, there are #oldfiles.recordCount# to delete.<br></cfoutput>
	<br>
	<cfif oldfiles.recordCount>
	    <cfloop query="oldfiles">
			<cftry>
	        <cffile action="delete" file="#flattenedFormDirectory#/#name#">
				<cfcatch><cfset canNotDelete = "true"></cfcatch>
			</cftry>
	    </cfloop>
	</cfif>
	
</cfloop>