<cfcomponent rest="true"
             restpath="/crudService">

    <!--- handle GET request (httpmethod),
          take argument in restpath(restpath={customerID}),
          return query data in json format(produces=text/json) ---> 
    <cffunction name="getHandlerJSON"
                access="remote"
                httpmethod="GET"
                restpath="{locationId}"
                returntype="Struct" 
                produces="application/json">
					
		<cfargument name="locationId"
                    required="true"
                    restargsource="Path"
                    type="numeric"/>
    
    	<cfset var locations = structNew()>
    
         <cfquery name="loc" dataSource="GOTV" cachedwithin="#createTimeSpan(0,1,0,0)#">
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
            <cfset locs[i]["ZipCode"] = "#ZipCode#">
            <cfset locs[i]["Latitude"] = "#Lat#">
            <cfset locs[i]["Longitude"] = "#Lon#">
            <cfset locs[i]["Phone"] = "#PhoneNumber#">
            <cfset locs[i]["LocationDetails"] = "#JSStringFormat(Replace(HoursOfOperation, " | ", "<br/>", "all"))#">
            <cfset locs[i]["DefaultMapsURL"] = "http://maps.google.com/maps?daddr=#Address1#,#City#,#State#">
            <cfset locs[i]["IOSMapsURL"] = "http://maps.apple.com/maps?daddr=#Address1#,#City#,#State#">
            <cfset locs[i]["MapImage1"] = "http://maps.googleapis.com/maps/api/staticmap?center=#Lat#,#Lon#&zoom=16&size=320x320&maptype=roadmap
&markers=color:green%7C40.702147,-74.015794&sensor=false">
            <cfset locs[i]["MapImage2"] = "http://maps.googleapis.com/maps/api/staticmap?center=#Lat#,#Lon#&zoom=15&size=320x320&maptype=roadmap
&markers=color:green%7C40.702147,-74.015794&sensor=false">
            <cfset locs[i]["MapImage3"] = "http://maps.googleapis.com/maps/api/staticmap?center=#Lat#,#Lon#&zoom=14&size=320x320&maptype=roadmap
&markers=color:green%7C40.702147,-74.015794&sensor=false">
            
        
        </cfoutput>
		
		<cfset var data = locs>
            <!--- serialize --->
        <cfset data = serializeJSON(locations)>
        
        <cfif structKeyExists(url, "callback")>
			<cfset data = url.callback & "(" & data & ")">
        </cfif>
		
        <cfreturn desrializeJSON(data)>
    </cffunction>   
</cfcomponent>