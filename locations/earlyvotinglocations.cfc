<!--- component with attributes rest and restpath --->
<cfcomponent rest="true"
             restpath="/VotingLocations">

    <cffunction name="deleteHandler"
                access="remote"
                httpmethod="DELETE"
                restpath="{locationId}"
                returntype="String" 
                produces="text/plain">
					
		<cfargument name="locationId"
                    required="true"
                    restargsource="Path"
                    type="numeric"/>
					
        <cfargument name="callback" type="string" required="false">
    
    	<cfset var locations = structNew()>
    
         <cfquery name="loc" dataSource="GOTV">
        DELETE FROM EarlyVotingLocations
        WHERE LocationId = #arguments.locationId#
        </cfquery>
        
        <cfset var message = "record deleted">
        
		
		<cfset locations.message = message>
		
		<cfset var data = locations>
            <!--- serialize --->
        <cfset data = serializeJSON(locations)>
        
        <cfif structKeyExists(url, "callback")>
			<cfset data = url.callback & "(" & data & ")">
        </cfif>
		
        <cfreturn data>
    </cffunction>
    <cffunction name="getHandlerJSON"
                access="remote"
                httpmethod="GET"
                restpath="{locationId}"
                returntype="String" 
                produces="text/plain">
					
		<cfargument name="locationId"
                    required="true"
                    restargsource="Path"
                    type="numeric"/>
					
        <cfargument name="callback" type="string" required="false">
    
    	<cfset var locations = structNew()>
    
         <cfquery name="loc" dataSource="GOTV">
        SELECT *
        FROM EarlyVotingLocations
        WHERE LocationId = #arguments.locationId#
        </cfquery>
        
        <cfset var locs = []>
        <cfset var i = 0>
        <cfoutput query="loc">
        	<cfset i = i + 1>
			<cfset locs[i]["LocationId"] = "#LocationId#">
            <cfset locs[i]["County"] = "#County#">
            <cfset locs[i]["LocationName"] = "#JSStringFormat(LocationName)#">
            <cfset locs[i]["Address1"] = "#JSStringFormat(Address1)#">
            <cfset locs[i]["Address2"] = "#JSStringFormat(Address2)#">
            <cfset locs[i]["City"] = "#City#">
            <cfset locs[i]["State"] = "#State#">
            <cfset locs[i]["ZipCode"] = "#numberFormat(ZipCode,"00000")#">
            <cfset locs[i]["Latitude"] = "#Lat#">
            <cfset locs[i]["Longitude"] = "#Lon#">
            <cfset locs[i]["Phone"] = "#PhoneNumber#">
            <cfset locs[i]["LocationDetails"] = "#JSStringFormat(Replace(HoursOfOperation, "|", "<br/>", "all"))#">
            <cfset locs[i]["DefaultMapsURL"] = "http://maps.google.com/maps?daddr=#Address1#,#City#,#State#">
            <cfset locs[i]["IOSMapsURL"] = "http://maps.apple.com/maps?daddr=#Address1#,#City#,#State#">
            <cfset locs[i]["MapImage1"] = "http://maps.googleapis.com/maps/api/staticmap?center=#Lat#,#Lon#&zoom=16&size=320x320&maptype=roadmap
&markers=color:green%7C#Lat#,#Lon#&sensor=false">
            <cfset locs[i]["MapImage2"] = "http://maps.googleapis.com/maps/api/staticmap?center=#Lat#,#Lon#&zoom=15&size=320x320&maptype=roadmap
&markers=color:green%7C#Lat#,#Lon#&sensor=false">
            <cfset locs[i]["MapImage3"] = "http://maps.googleapis.com/maps/api/staticmap?center=#Lat#,#Lon#&zoom=14&size=320x320&maptype=roadmap
&markers=color:green%7C#Lat#,#Lon#&sensor=false">
            <cfset locs[i]["Website"] = "#Website#">
            
        
        </cfoutput>
		
		<cfset locations.location = locs>
		
		<cfset var data = locations>
            <!--- serialize --->
        <cfset data = serializeJSON(locations)>
        
        <cfif structKeyExists(url, "callback")>
			<cfset data = url.callback & "(" & data & ")">
        </cfif>
		
        <cfreturn data>
    </cffunction>
    <cffunction name="listHandler"
                access="remote"
                httpmethod="GET"
                returntype="String"
				restpath="list"
                produces="text/plain">
					
		<cfset var userIsAuthorized = application.bypassSecurity>
		<cfinclude template="security.cfm" runonce="true">
		<cfif NOT userIsAuthorized>
			<cfheader statuscode="403" statustext="Unauthorized API Access">
			<cfreturn "UnauthorizedAccess">
			<cfabort>
		</cfif>			
				
		<cfif not structKeyExists(url, "startRow")>
			<cfset startRow = 1>
		<cfelse>
			<cfset startRow = url.startRow>
		</cfif>	
				
		<cfif not structKeyExists(url, "maxRows")>
			<cfset count = 100>
		<cfelse>
			<cfset count = url.maxRows>
		</cfif>	
				
		
		
        
        <!---<cfargument name="locationId" type="string">
        <cfargument name="state" type="string" default="TX">
        <cfargument name="zip" type="string">
        <cfargument name="county" type="string">
        <cfargument name="startRow" type="string" default="1">
        <cfargument name="count" type="numeric" default="10">
        <cfargument name="callback" type="string" required="false">--->
		
        <cfset var locations = structNew()>
        
        <cfif isDefined("url.zip") AND len(url.zip) EQ 4>
			<cfset url.zip = numberFormat(url.zip,"00000")>
		</cfif>
		<cfif structKeyExists(url, "zip")>
			<cfquery name="getCountyName" dataSource="GOTV">
	        SELECT     dbo.Counties_Master.state_key, dbo.Counties_Master.state_name, dbo.Counties_Master.county_key, dbo.Counties_Master.county_name, 
	                   dbo.Zip_Counties.zipcode
			FROM         dbo.Counties_Master INNER JOIN
			                      dbo.Zip_Counties ON dbo.Counties_Master.county_key = dbo.Zip_Counties.county_key
			WHERE     (dbo.Zip_Counties.zipcode = '#url.zip#')
	        </cfquery>
	        <cftry>
			<cfif getCountyName.recordCount and (getCountyName.state_name EQ "Alaska" OR getCountyName.state_name EQ "District of Columbia")>
				<cfquery name="loc" dataSource="GOTV">
		        SELECT     dbo.EarlyVotingLocations.County, dbo.EarlyVotingLocations.LocationName, dbo.EarlyVotingLocations.Address1, dbo.EarlyVotingLocations.Address2, 
	                      dbo.EarlyVotingLocations.City, dbo.EarlyVotingLocations.State, dbo.EarlyVotingLocations.ZipCode, dbo.EarlyVotingLocations.HoursOfOperation, 
	                      dbo.EarlyVotingLocations.PhoneNumber, dbo.EarlyVotingLocations.LocationId, dbo.EarlyVotingLocations.Lat, dbo.EarlyVotingLocations.Lon, 
	                      dbo.EarlyVotingLocations.DefaultZoom, dbo.EarlyVotingLocations.ElectionId, dbo.EarlyVotingLocations.Website, dbo.EarlyVotingLocations.Email
				FROM       dbo.EarlyVotingLocations INNER JOIN
				           dbo.Zip_Counties ON dbo.EarlyVotingLocations.ZipCode = dbo.Zip_Counties.zipcode
				<cfif getCountyName.state_name EQ "District of Columbia">
					WHERE EarlyVotingLocations.State = 'DC'
				<cfelse>
					WHERE EarlyVotingLocations.State = 'AK'
				</cfif>
				</cfquery>
			<cfelse>
				<cfquery name="loc" dataSource="GOTV">
		        SELECT     dbo.EarlyVotingLocations.County, dbo.EarlyVotingLocations.LocationName, dbo.EarlyVotingLocations.Address1, dbo.EarlyVotingLocations.Address2, 
	                      dbo.EarlyVotingLocations.City, dbo.EarlyVotingLocations.State, dbo.EarlyVotingLocations.ZipCode, dbo.EarlyVotingLocations.HoursOfOperation, 
	                      dbo.EarlyVotingLocations.PhoneNumber, dbo.EarlyVotingLocations.LocationId, dbo.EarlyVotingLocations.Lat, dbo.EarlyVotingLocations.Lon, 
	                      dbo.EarlyVotingLocations.DefaultZoom, dbo.EarlyVotingLocations.ElectionId, dbo.EarlyVotingLocations.Website, dbo.EarlyVotingLocations.Email
				FROM       dbo.EarlyVotingLocations INNER JOIN
				           dbo.Zip_Counties ON dbo.EarlyVotingLocations.ZipCode = dbo.Zip_Counties.zipcode
				WHERE Zip_Counties.county_key IN (SELECT county_key FROM Zip_Counties WHERE zipcode = '#url.zip#')
				<cfif getCountyName.recordCount GT 1>
					AND (
					<cfoutput query="getCountyName"><cfif currentRow NEQ 1>OR </cfif>dbo.EarlyVotingLocations.County LIKE '#getCountyName.county_name#%'
					</cfoutput>
					)
				<cfelseif getCountyName.recordCount EQ 1>
					AND dbo.EarlyVotingLocations.County LIKE '#getCountyName.county_name#%'
				</cfif>
				ORDER BY 
					CASE dbo.EarlyVotingLocations.ZipCode
				      WHEN '#url.zip#' THEN 1
				      ELSE 2
				   END, dbo.EarlyVotingLocations.County
		        </cfquery>
			</cfif>
	        	<cfcatch><cfreturn cfcatch.SQL></cfcatch>
			</cftry>
		<cfelse>
	        <cfquery name="loc" dataSource="GOTV" cachedwithin="#createTimeSpan(0,0,0,30)#">
	        SELECT *
	        FROM EarlyVotingLocations
	        <cfif structKeyExists(url, "state")>
				WHERE State = '#url.state#'
				</cfif><cfif structKeyExists(url, "county")>
				WHERE State = '#url.state#' AND County = '#url.county#'
				</cfif>
	        </cfquery>
		</cfif>
        <cfif isDefined("url.zip") AND left(url.zip,1) EQ "0">
			<cfset url.zip = right(url.zip,4)>
		</cfif>
        <cfif loc.recordCount EQ 0 AND  structKeyExists(url, "zip")>
			<cfquery name="lookupCounty" datasource="GOTV">
			SELECT     dbo.Counties_Master.county_name, dbo.States.State
			FROM         dbo.Counties_Master INNER JOIN
                      		dbo.Zip_Counties ON dbo.Counties_Master.county_key = dbo.Zip_Counties.county_key INNER JOIN
                      			dbo.States ON dbo.Counties_Master.state_name = dbo.States.StateFull
			WHERE     (dbo.Zip_Counties.zipcode = '#url.zip#')
			</cfquery>
			<cfif lookupCounty.recordCount>
				<cfquery name="loc" dataSource="GOTV" cachedwithin="#createTimeSpan(0,0,0,30)#">
		        SELECT *
		        FROM EarlyVotingLocations
				WHERE State = '#lookupCounty.State#' AND County = '#lookupCounty.county_name#'
		        </cfquery>
			</cfif>
		</cfif>
        <!---<cfquery name="loc" dataSource="VoteVA" cachedwithin="#createTimeSpan(0,1,0,0)#">
        SELECT *
        FROM VotingLocations
        <cfif isDefined("arguments.zip")>WHERE ZipCode = '#arguments.zip#'<cfelseif isDefined("arguments.state")>WHERE State = '#arguments.state#'<cfelseif isDefined("arguments.county")>WHERE State = '#arguments.state#' AND County = '#arguments.county#'<cfelseif isDefined("arguments.locationId")>WHERE LocationId = #arguments.locationId#
        AND Lat IS NOT Null
        </cfquery> --->
        <cfset var locs = []>
        <cfset var i = 0>
        <cfoutput query="loc" startrow="#startRow#" maxrows="#count#" group="LocationId">
        	<cfset i = i + 1>
			<cfset locs[i]["LocationId"] = "#LocationId#">
            <cfset locs[i]["County"] = "#County#">
            <cfset locs[i]["LocationName"] = "#JSStringFormat(LocationName)#">
            <cfset locs[i]["Address1"] = "#JSStringFormat(Address1)#">
            <cfset locs[i]["Address2"] = "#JSStringFormat(Address2)#">
            <cfset locs[i]["City"] = "#City#">
            <cfset locs[i]["State"] = "#State#">
            <cfset locs[i]["ZipCode"] = "#numberFormat(ZipCode,"00000")#">
            <cfset locs[i]["Latitude"] = "#Lat#">
            <cfset locs[i]["Longitude"] = "#Lon#">
            <cfset locs[i]["Phone"] = "#PhoneNumber#">
            <cfset locs[i]["LocationDetails"] = "#JSStringFormat(Replace(HoursOfOperation, "|", "<br/>", "all"))#">
            <cfset locs[i]["DefaultMapsURL"] = "http://maps.google.com/maps?daddr=#Address1#,#City#,#State#">
            <cfset locs[i]["IOSMapsURL"] = "http://maps.apple.com/maps?daddr=#Address1#,#City#,#State#">
            <cfset locs[i]["MapImage1"] = "http://maps.googleapis.com/maps/api/staticmap?center=#Lat#,#Lon#&zoom=16&size=320x320&maptype=roadmap
&markers=color:green%7C#Lat#,#Lon#&sensor=false">
            <cfset locs[i]["MapImage2"] = "http://maps.googleapis.com/maps/api/staticmap?center=#Lat#,#Lon#&zoom=15&size=320x320&maptype=roadmap
&markers=color:green%7C#Lat#,#Lon#&sensor=false">
            <cfset locs[i]["MapImage3"] = "http://maps.googleapis.com/maps/api/staticmap?center=#Lat#,#Lon#&zoom=14&size=320x320&maptype=roadmap
&markers=color:green%7C#Lat#,#Lon#&sensor=false">
            <cfset locs[i]["Website"] = "#Website#">
            
        
        </cfoutput>
        	<cfset locations.locations = locs>
           
        
        <cfset var data = locations>
            <!--- serialize --->
        <cfset data = serializeJSON(locations)>
        
        <cfif structKeyExists(url, "callback")>
			<cfset data = url.callback & "(" & data & ")">
        </cfif>
        
        <cfreturn data>
        
    </cffunction>
    <cffunction name="listHandlerJSON"
                access="remote"
                httpmethod="GET"
                returntype="Struct"
				restpath="listjson"
                produces="application/json">
					
					
				
		<cfif not structKeyExists(url, "startRow")>
			<cfset startRow = 1>
		<cfelse>
			<cfset startRow = url.startRow>
		</cfif>	
				
		<cfif not structKeyExists(url, "maxRows")>
			<cfset count = 10>
		<cfelse>
			<cfset count = url.maxRows>
		</cfif>	
				
		
		
        
        <!---<cfargument name="locationId" type="string">
        <cfargument name="state" type="string" default="TX">
        <cfargument name="zip" type="string">
        <cfargument name="county" type="string">
        <cfargument name="startRow" type="string" default="1">
        <cfargument name="count" type="numeric" default="10">
        <cfargument name="callback" type="string" required="false">--->
		
        <cfset var locations = structNew()>
        
        <cfquery name="loc" dataSource="GOTV" cachedwithin="#createTimeSpan(0,1,0,0)#">
        SELECT *
        FROM EarlyVotingLocations
        WHERE Lat IS NOT Null <cfif structKeyExists(url, "zip")>
			AND ZipCode = '#url.zip#'
			</cfif><cfif structKeyExists(url, "state")>
			AND State = '#url.state#'
			</cfif><cfif structKeyExists(url, "county")>
			AND State = '#url.state#' AND County = '#url.county#'
			</cfif>
        </cfquery>
        <!---<cfquery name="loc" dataSource="VoteVA" cachedwithin="#createTimeSpan(0,1,0,0)#">
        SELECT *
        FROM VotingLocations
        <cfif isDefined("arguments.zip")>WHERE ZipCode = '#arguments.zip#'<cfelseif isDefined("arguments.state")>WHERE State = '#arguments.state#'<cfelseif isDefined("arguments.county")>WHERE State = '#arguments.state#' AND County = '#arguments.county#'<cfelseif isDefined("arguments.locationId")>WHERE LocationId = #arguments.locationId#
        AND Lat IS NOT Null
        </cfquery> --->
        <cfset var locs = []>
        <cfset var i = 0>
        <cfoutput query="loc" startrow="#startRow#" maxrows="#count#">
        	<cfset i = i + 1>
			<cfset locs[i]["LocationId"] = "#LocationId#">
            <cfset locs[i]["County"] = "#County#">
            <cfset locs[i]["LocationName"] = "#JSStringFormat(LocationName)#">
            <cfset locs[i]["Address1"] = "#JSStringFormat(Address1)#">
            <cfset locs[i]["Address2"] = "#JSStringFormat(Address2)#">
            <cfset locs[i]["City"] = "#City#">
            <cfset locs[i]["State"] = "#State#">
            <cfset locs[i]["ZipCode"] = "#numberFormat(ZipCode,"00000")#">
            <cfset locs[i]["Latitude"] = "#Lat#">
            <cfset locs[i]["Longitude"] = "#Lon#">
            <cfset locs[i]["Phone"] = "#PhoneNumber#">
            <cfset locs[i]["LocationDetails"] = "#JSStringFormat(Replace(HoursOfOperation, "|", "<br/>", "all"))#">
            <cfset locs[i]["DefaultMapsURL"] = "http://maps.google.com/maps?daddr=#Address1#,#City#,#State#">
            <cfset locs[i]["IOSMapsURL"] = "http://maps.apple.com/maps?daddr=#Address1#,#City#,#State#">
            <cfset locs[i]["MapImage1"] = "http://maps.googleapis.com/maps/api/staticmap?center=#Lat#,#Lon#&zoom=16&size=320x320&maptype=roadmap
&markers=color:green%7C#Lat#,#Lon#&sensor=false">
            <cfset locs[i]["MapImage2"] = "http://maps.googleapis.com/maps/api/staticmap?center=#Lat#,#Lon#&zoom=15&size=320x320&maptype=roadmap
&markers=color:green%7C#Lat#,#Lon#&sensor=false">
            <cfset locs[i]["MapImage3"] = "http://maps.googleapis.com/maps/api/staticmap?center=#Lat#,#Lon#&zoom=14&size=320x320&maptype=roadmap
&markers=color:green%7C#Lat#,#Lon#&sensor=false">
            <cfset locs[i]["Website"] = "#Website#">
            
        
        </cfoutput>
        	<cfset locations.locations = locs>
           
        
        <!---<cfset var data = locations>
            <!--- serialize --->
        <cfset data = serializeJSON(locations)>
        
        <cfif structKeyExists(url, "callback")>
			<cfset data = url.callback & "(" & data & ")">
        </cfif>--->
        
        <cfreturn locations>
        
    </cffunction>
    <cffunction name="putHandlerJSON"
                access="remote"
                httpmethod="PUT"
                returntype="String"
                restpath="{locationId}"
                produces="text/plain">
					
					
    	<cfargument name="locationId"
                    required="true"
                    restargsource="Path"
                    type="numeric"/>
    	<!---<cfargument name="county" required="yes">
    	<cfargument name="locationName" required="yes">
    	<cfargument name="address1" required="yes">
    	<cfargument name="address2" required="no">
    	<cfargument name="city" required="yes">
    	<cfargument name="state" required="yes">
    	<cfargument name="zip" required="yes">
    	<cfargument name="lat" required="yes">
    	<cfargument name="lon" required="yes">
    	<cfargument name="defaultZoomLevel" required="yes">
    	<cfargument name="phone" required="yes">
    	<cfargument name="hours" required="yes">
    	<cfargument name="callback" type="string">--->
    	
    	<cfset var requestBody = toString( getHttpRequestData().content ) />
 
		<!--- Double-check to make sure it's a JSON value. --->
		<cfif isJSON( requestBody )>
		 
		    <!--- Echo back POST data. --->
		    <cfset requestObject = deserializeJSON(requestBody)>
		    <cfset var newLocationObject = requestObject.Location[1]>
		 
		</cfif>
        
		
        <cfset var locations = structNew()>
        <cfset var response = "success">
        <cftry>
        <cfquery name="updateLocation" dataSource="GOTV">
        UPDATE EarlyVotingLocations
            SET County = '#newLocationObject.county#',
            LocationName = '#newLocationObject.locationName#',
            Address1 = '#newLocationObject.address1#',
            Address2 = '#newLocationObject.address2#',
            City = '#newLocationObject.city#',
            State = '#newLocationObject.state#',
            ZipCode = '#newLocationObject.ZipCode#',
            Lat = '#newLocationObject.Latitude#',
            Lon = '#newLocationObject.Longitude#',
            PhoneNumber = '#newLocationObject.phone#',
            HoursOfOperation = '#newLocationObject.LocationDetails#',
            DefaultZoom = 12<cfif structKeyExists(newLocationObject, "Website")>,
			Website = '#newLocationObject.Website#'</cfif>
        WHERE LocationId = #locationId#;
		Select * FROM EarlyVotingLocations WHERE LocationId = #locationId#; 
        </cfquery>
        
        <cfset var locs = []>
        <cfset var i = 0>
        <cfoutput query="updateLocation">
        	<cfset i = i + 1>
			<cfset locs[i]["LocationId"] = "#LocationId#">
            <cfset locs[i]["County"] = "#County#">
            <cfset locs[i]["LocationName"] = "#JSStringFormat(LocationName)#">
            <cfset locs[i]["Address1"] = "#JSStringFormat(Address1)#">
            <cfset locs[i]["Address2"] = "#JSStringFormat(Address2)#">
            <cfset locs[i]["City"] = "#City#">
            <cfset locs[i]["State"] = "#State#">
            <cfset locs[i]["ZipCode"] = "#numberFormat(ZipCode,"00000")#">
            <cfset locs[i]["Latitude"] = "#Lat#">
            <cfset locs[i]["Longitude"] = "#Lon#">
            <cfset locs[i]["Phone"] = "#PhoneNumber#">
            <cfset locs[i]["LocationDetails"] = "#JSStringFormat(Replace(HoursOfOperation, " | ", "<br/>", "all"))#">
            <cfset locs[i]["DefaultMapsURL"] = "http://maps.google.com/maps?daddr=#Address1#,#City#,#State#">
            <cfset locs[i]["IOSMapsURL"] = "http://maps.apple.com/maps?daddr=#Address1#,#City#,#State#">
            <cfset locs[i]["MapImage1"] = "http://maps.googleapis.com/maps/api/staticmap?center=#Lat#,#Lon#&zoom=16&size=320x320&maptype=roadmap
&markers=color:green%7C#Lat#,#Lon#&sensor=false">
            <cfset locs[i]["MapImage2"] = "http://maps.googleapis.com/maps/api/staticmap?center=#Lat#,#Lon#&zoom=15&size=320x320&maptype=roadmap
&markers=color:green%7C#Lat#,#Lon#&sensor=false">
            <cfset locs[i]["MapImage3"] = "http://maps.googleapis.com/maps/api/staticmap?center=#Lat#,#Lon#&zoom=14&size=320x320&maptype=roadmap
&markers=color:green%7C#Lat#,#Lon#&sensor=false">
            <cfset locs[i]["Website"] = "#Website#">
            
        
        </cfoutput>
        	<cfset locations.location = locs>
			
		
        	<cfcatch>
				<cfset locations.error = "#cfcatch.Message#">
				<cfif locations.error EQ "Error Executing Database Query.">
				<cfset locations.error = locations.error & " #cfcatch.SQL#">
				</cfif>
			</cfcatch>
        </cftry>
        
        <cfset var data = locations>
            <!--- serialize --->
        <cfset data = serializeJSON(locations)>
        
        <cfif structKeyExists(url, "callback")>
			<cfset data = url.callback & "(" & data & ")">
        </cfif>
        
        <!---<cfif structKeyExists(arguments, "callback")>
			<cfset response = arguments.callback & "(" & response & ")">
        </cfif>--->
        
        <cfreturn data>
        
    </cffunction> 
    <cffunction name="postHandlerJSON"
                access="remote"
                httpmethod="POST"
                returntype="String"
                produces="text/plain">
					
					
    	<!---<cfargument name="county" required="yes">
    	<cfargument name="locationName" required="yes">
    	<cfargument name="address1" required="yes">
    	<cfargument name="address2" required="no">
    	<cfargument name="city" required="yes">
    	<cfargument name="state" required="yes">
    	<cfargument name="zip" required="yes">
    	<cfargument name="lat" required="yes">
    	<cfargument name="lon" required="yes">
    	<cfargument name="defaultZoomLevel" required="yes">
    	<cfargument name="phone" required="yes">
    	<cfargument name="hours" required="yes">
    	<cfargument name="callback" type="string">--->
        
		
        <cfset var locations = structNew()>
        <cfset var response = "success">
        <cftry>
        <cfquery name="createLocation" dataSource="GOTV">
        INSERT INTO EarlyVotingLocations
            (County, LocationName, Address1, Address2, City, State, ZipCode, Lat, Lon, PhoneNumber, HoursOfOperation<cfif structKeyExists(form, "Website")>, Website</cfif>)
            VALUES
            ('#county#', '#locationName#', '#address1#', '#address2#', '#city#', '#state#', '#ZipCode#', '#Latitude#', '#Longitude#', '#phone#', '#LocationDetails#'<cfif structKeyExists(form, "Website")>, '#Website#'</cfif>);
		Select TOP 1 * FROM EarlyVotingLocations ORDER BY LocationId DESC; 
        </cfquery>
        
        <cfset var locs = []>
        <cfset var i = 0>
        <cfoutput query="createLocation">
        	<cfset i = i + 1>
			<cfset locs[i]["LocationId"] = "#LocationId#">
            <cfset locs[i]["County"] = "#County#">
            <cfset locs[i]["LocationName"] = "#JSStringFormat(LocationName)#">
            <cfset locs[i]["Address1"] = "#JSStringFormat(Address1)#">
            <cfset locs[i]["Address2"] = "#JSStringFormat(Address2)#">
            <cfset locs[i]["City"] = "#City#">
            <cfset locs[i]["State"] = "#State#">
            <cfset locs[i]["ZipCode"] = "#numberFormat(ZipCode,"00000")#">
            <cfset locs[i]["Latitude"] = "#Lat#">
            <cfset locs[i]["Longitude"] = "#Lon#">
            <cfset locs[i]["Phone"] = "#PhoneNumber#">
            <cfset locs[i]["LocationDetails"] = "#JSStringFormat(Replace(HoursOfOperation, " | ", "<br/>", "all"))#">
            <cfset locs[i]["DefaultMapsURL"] = "http://maps.google.com/maps?daddr=#Address1#,#City#,#State#">
            <cfset locs[i]["IOSMapsURL"] = "http://maps.apple.com/maps?daddr=#Address1#,#City#,#State#">
            <cfset locs[i]["MapImage1"] = "http://maps.googleapis.com/maps/api/staticmap?center=#Lat#,#Lon#&zoom=16&size=320x320&maptype=roadmap
&markers=color:green%7C#Lat#,#Lon#&sensor=false">
            <cfset locs[i]["MapImage2"] = "http://maps.googleapis.com/maps/api/staticmap?center=#Lat#,#Lon#&zoom=15&size=320x320&maptype=roadmap
&markers=color:green%7C#Lat#,#Lon#&sensor=false">
            <cfset locs[i]["MapImage3"] = "http://maps.googleapis.com/maps/api/staticmap?center=#Lat#,#Lon#&zoom=14&size=320x320&maptype=roadmap
&markers=color:green%7C#Lat#,#Lon#&sensor=false">
            <cfset locs[i]["Website"] = "#Website#">
            
        
        </cfoutput>
        	<cfset locations.location = locs>
			
		
    	<cfcatch><cfset locations.error = "#cfcatch.Message#"></cfcatch>
        </cftry>
        
        <cfset var data = locations>
            <!--- serialize --->
        <cfset data = serializeJSON(locations)>
        
        <cfif structKeyExists(url, "callback")>
			<cfset data = url.callback & "(" & data & ")">
        </cfif>
        
        <cfreturn data>
        
    </cffunction>
    <cffunction name="sendLocationEmail" restpath="send/{locationId}" httpmethod="GET" displayname="sendLocationEmail" access="remote" output="true" returnFormat="plain" returntype="string">
        
        <cfargument name="locationId"
                    required="true"
                    restargsource="Path"
                    type="numeric"/>
		
		<cfset var clientId = 0>		
    	<cfset var userIsAuthorized = application.bypassSecurity>
		<cfinclude template="security.cfm" runonce="true">
		<cfif NOT userIsAuthorized>
			<cfheader statuscode="403" statustext="Unauthorized API Access">
			<cfreturn "UnauthorizedAccess">
			<cfabort>
		</cfif>
    
    	<cfset var locations = structNew()>
    
    	<cfparam name="url.zip" default="">
    
         <cfquery name="loc" dataSource="GOTV" cachedwithin="#createTimeSpan(0,0,0,30)#">
        SELECT *
        FROM EarlyVotingLocations
        WHERE LocationId = #arguments.locationId#
        </cfquery>
        <cfif loc.RecordCount>
			<cfset url.zip = loc.ZipCode>
		</cfif>
        
        <cfset var LocationInfo = Replace(loc.HoursOfOperation, " | ", "<br/>", "all")>
        
        <cfif (cgi.SERVER_NAME EQ "api-dev.targetedgotv.com" AND clientId EQ 5) OR (cgi.SERVER_NAME EQ "api.targetedgotv.com" AND clientId EQ 7)>
			<cfinclude template="RNCLocationsEmail.cfm">
		<cfelse>
			<cfinclude template="ClientLocationsEmail.cfm">
		</cfif>
        
        <cfquery name="saveVoter" datasource="GOTV">
			INSERT INTO [Voters]
			([email]
			,[gotv]
			<cfif isDefined("clientId")>,[client_id]</cfif>
			<cfif isDefined("url.zip")>,[rzip5]</cfif>
	        <cfif isDefined("url.evseachzip")>,[evseachzip]</cfif>
	        <cfif isDefined("url.evsearchzip")>,[evseachzip]</cfif>
	        <cfif isDefined("url.referrer")>,[referrer]</cfif>)
			VALUES
			('#url.email#'
			,'EV'
			<cfif isDefined("clientId")>,#clientId#</cfif>
			<cfif isDefined("url.zip")>,'#url.zip#'</cfif>
	       	<cfif isDefined("url.evseachzip")>,'#url.evseachzip#'</cfif>
	       	<cfif isDefined("url.evsearchzip")>,'#url.evsearchzip#'</cfif>
	        <cfif isDefined("url.referrer")>,'#url.referrer#'</cfif>)
		</cfquery>
        
        <cfset locations.success = "true">
        
        <cfset var data = locations>
            <!--- serialize --->
        <cfset data = serializeJSON(locations)>
        
        <cfif structKeyExists(url, "callback")>
			<cfset data = url.callback & "(" & data & ")">
        </cfif>
        
        <cfreturn data>
    </cffunction>
</cfcomponent>