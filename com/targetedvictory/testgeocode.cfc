
	<cfinvoke component="com.targetedvictory.googlegeocoder3" method="googlegeocoder3" returnvariable="variables.geocode_query1">	  
	  <cfinvokeargument name="address" value="1600 Amphitheatre Parkway, Mountain View, CA">
	  <cfinvokeargument name="ShowDetails" value="false">
	</cfinvoke>

	<cfdump var="#variables.geocode_query1#">
	

