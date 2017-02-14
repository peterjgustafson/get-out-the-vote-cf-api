<cfcomponent rest="true"
             restpath="/IL">

    <!--- handle GET request (httpmethod),
          take argument in restpath(restpath={customerID}),
          return query data in json format(produces=text/json) ---> 
     <cffunction name="configHadler"
                access="remote"
                httpmethod="GET"
                restpath="Config/{formType}"
                returntype="String" 
                produces="text/plain">
	 	 
	 	 <cfargument name="formType"
                    required="true"
                    restargsource="Path"
                    type="string"/>
		
		<cfset var clientId = 0>
		<cfset var userIsAuthorized = application.bypassSecurity>
		<cfinclude template="../security.cfm" runonce="true">
		<cfif NOT userIsAuthorized>
			<cfheader statuscode="403" statustext="Unauthorized API Access">
			<cfreturn "UnauthorizedAccess">
			<cfabort>
		</cfif>	
			
		<cfset returnText = "Please specify a valid form type">
		
		<cfif arguments.formType EQ "ABRequest">
			<cfsavecontent variable="returnText"><cfinclude template="abrequest.json"></cfsavecontent>
		</cfif>
		
		<cfset var data = returnText>
		
        <cfif structKeyExists(url, "callback")>
			<cfset data = url.callback & "(" & data & ")">
        </cfif>
        
		<cfreturn data>
	 	 
	 </cffunction>
     <cffunction name="abhandler"
                access="remote"
                httpmethod="GET"
                restpath="ABRequest"
                returntype="String" 
                produces="text/plain">
		
		<cfset var stateAbbr = "IL">
		<cfset var clientId = 0>
		<cfset var userIsAuthorized = application.bypassSecurity>
		<cfinclude template="../security.cfm" runonce="true">
		<cfif NOT userIsAuthorized>
			<cfheader statuscode="403" statustext="Unauthorized API Access">
			<cfreturn "UnauthorizedAccess">
			<cfabort>
		</cfif>			
		
		<cftry>
		<cfparam name="url.fname" default="">
		<cfparam name="url.lname" default="">
		<cfparam name="url.mname" default="">
		<cfparam name="url.sfx" default="">
		<cfparam name="url.email" default="">
		<cfparam name="url.cust_dob" default="">
		<cfparam name="url.cust_telephone_full" default="">
		<cfparam name="url.cust_dobmonth" default="1">
		<cfparam name="url.cust_dobday" default="1">
		<cfparam name="url.cust_dobyear" default="1900">
		<cfparam name="url.raddr1" default="">
		<cfparam name="url.raddr2" default="">
		<cfparam name="url.rzip5" default="">
		<cfparam name="url.city" default="">
		<cfparam name="url.maddr1" default="">
		<cfparam name="url.maddr2" default="">
		<cfparam name="url.mcity" default="">
		<cfparam name="url.msta" default="">
		<cfparam name="url.mzip5" default="">
		<cfparam name="url.deliverto" default="cust_recieve_ballot_by_mail">
		<cfparam name="url.cust_former_name" default="">
		
		<cflock type="exclusive" scope="server" timeout="#createTimeSpan(0,0,0,30)#">
			<cfset fileName = "#stateAbbr#AbsenteeBallotApplication-#CreateUUID()#.pdf">
			<cfpdfform source="#getDirectoryFromPath(getCurrentTemplatePath())#ABIllinois.pdf" destination="#getDirectoryFromPath(getCurrentTemplatePath())#temp\#fileName#" action="populate" overwriteData="true">
	        <cfpdfformparam name="fname" value="#url.fname#">
	        <cfpdfformparam name="lname" value="#url.lname#">
	        <cfpdfformparam name="email" value="#url.email#">
	        <cfif Len(Trim(url.mname)) GT 0>
	        <cfpdfformparam name="mname" value="#url.mname#">
	        </cfif>
	        <cfpdfformparam name="sfx" value="#url.sfx#">
	        <cfpdfformparam name="cust_former_name" value="#url.cust_former_name#">
			
			
	        <cfpdfformparam name="cust_dob" value="#url.cust_dobmonth#/#url.cust_dobday#/#url.cust_dobyear#">
		
	        
	        <cfpdfformparam name="raddr1" value="#URLDecode(url.raddr1)#">
	        <cfpdfformparam name="raddr2" value="#URLDecode(url.raddr2)#">
	        <cfpdfformparam name="city" value="#URLDecode(url.city)#">
	        <cfpdfformparam name="rzip5" value="#rzip5#">
	        
	        <cfif url.deliverto EQ "home">
		        <cfpdfformparam name="maddr1" value="#URLDecode(url.raddr1)#">
		        <cfpdfformparam name="maddr2" value="#URLDecode(url.raddr2)#">
		        <cfpdfformparam name="mcity" value="#URLDecode(url.city)#">
		        <cfif structKeyExists(url, "rsta")><cfpdfformparam name="msta" value="#URLDecode(url.rsta)#"><cfelse><cfpdfformparam name="msta" value="#stateAbbr#"></cfif>
		        <cfpdfformparam name="mzip5" value="#url.rzip5#">
			<cfelse>
		        <cfpdfformparam name="maddr1" value="#URLDecode(url.maddr1)#">
		        <cfpdfformparam name="maddr2" value="#URLDecode(url.maddr2)#">
		        <cfpdfformparam name="mcity" value="#URLDecode(url.mcity)#">
		        <cfpdfformparam name="msta" value="#url.msta#">
		        <cfpdfformparam name="mzip5" value="#url.mzip5#">
			</cfif>
			
			
			<cfpdfformparam name="email" value="#url.email#">
			<cfif len(trim(url.cust_telephone_full))>
				<cfpdfformparam name="cust_telephone_full" value="#url.cust_telephone_full#">
			<cfelse>
				<cfpdfformparam name="cust_telephone_full" value="#url.tel_num#">
			</cfif>
			<cfpdfformparam name="cust_county" value="#url.cust_county#">
			
	    </cfpdfform>
	    
	    
	            
	    <cfpdf action="write" flatten="yes" source="#getDirectoryFromPath(getCurrentTemplatePath())#temp\#fileName#"
	    destination="#getDirectoryFromPath(getCurrentTemplatePath())#ABPDF\#fileName#" overwrite="yes">
	    
	    <!---Save the Voter record. --->
		<!---THE JS SKD is not properly sending voter info the the API so instead I am saving the voter record here --->
		
			
		<!---Save to the database --->	
		
		<cfset var saveState = stateAbbr>
		<cfinclude template="../includes/sql/saveVoter.cfm" >
			
		<!--- End Save Voter --->
	    
	    	
		
		<cfset var formReturnData = structNew()>
		
		<cfinclude template="../includes/thankYou/il.cfm" >
        
        <cfset var data = serializeJSON(formReturnData)>
        
        <cfset var attachmentPath = "#getDirectoryFromPath(getCurrentTemplatePath())#ABPDF\#fileName#">
		<cfinclude template="../includes/emails/ABEMail.cfm" >
			
			
			<!---<cfmail from="gotv@prosperitypac.com" subject="Absentee Ballot application" to="#url.Email#" remove="true" server="smtp.postmarkapp.com" username="43a619df-47a9-45f0-83e6-9f003a81fe2b" password="43a619df-47a9-45f0-83e6-9f003a81fe2b" >
				<cfmailparam file="#getDirectoryFromPath(getCurrentTemplatePath())#ABPDF\#fileName#" disposition="attachment">
				<cfmailpart type="text" wraptext="74">
			        Thank you for requesting your absentee ballot! 
					
					<cfif isDefined("formattedAddress")><p>Your mailing address is:
					#formattedAddress#
					
					</cfif>Please make sure that after you print this application, you sign the application and mail it to your County Clerk office. 
					
					The application must be received by your County Clerk by 5pm on Thursday, August 7th to apply to vote by mail for the August 12th, 2014 Primary Election. 
					
					With all that's at stake, your support will make a difference in this election. Encourage your family and friends to request their absentee ballot at http://gotv.prosperitypac.com/wi/absentee/. 
					
					Thanks again!
			    </cfmailpart>
			    <cfmailpart type="html">
				       <cfinclude template="EmailTemplate.html"> 
			    </cfmailpart>
			</cfmail>--->
		
		
	</cflock>
		<cfcatch>
			<cfset var error = structNew()>
			<cfset error.errorMessage = "#cfcatch.Message#">
			<cfif error.errorMessage EQ "Error Executing Database Query.">
			<cfset error.sqlQuery = "#cfcatch.SQL#">
			<cfset error.sqlError = "#cfcatch.queryError#">
			</cfif>
			<cfset var data = serializeJSON(error)>
		</cfcatch>
	</cftry>
		
        
	        <cfif structKeyExists(url, "callback")>
				<cfset data = url.callback & "(" & data & ")">
	        </cfif>
		<cfreturn data>
	</cffunction>
	<cffunction name="regHandler"
                access="remote"
                httpmethod="GET"
                restpath="Registration"
                returntype="String" 
                produces="text/plain">
				
		<cfset var clientId = 0>
		<cfset var stateAbbr = "IL">
		<cfset var userIsAuthorized = application.bypassSecurity>
		<cfinclude template="../security.cfm" runonce="true">
		<cfif NOT userIsAuthorized>
			<cfheader statuscode="403" statustext="Unauthorized API Access">
			<cfreturn "UnauthorizedAccess">
			<cfabort>
		</cfif>			
		
		
	    <cfinclude template="../US/DefaultParams.cfm"> 
					
					
		<cftry>
		
		<cflock type="exclusive" scope="server" timeout="#createTimeSpan(0,0,0,30)#">
		<cfset currentDirectory = getDirectoryFromPath(getCurrentTemplatePath()) />
		<cfset parentDirectory = (currentDirectory & "../") />
		<cfset fileName = "VoterRegistrationApplication-#CreateUUID()#.pdf">
		<cfset var voter = structNew()>
		<cfset voter.email = url.email>
		
	    <cfinclude template="../US/NationwidePDFForm.cfm"> 
		
	            
	    <cfpdf action="write" flatten="yes" source="#parentDirectory#US\temp\#fileName#"
	    destination="#parentDirectory#US\ABPDF\#fileName#" overwrite="yes">
	    
	    	
		
		<cfset var formReturnData = structNew()>
		<cfset formReturnData.PDFURL = "http://#cgi.server_name#/US/ABPDF/#fileName#">
		
		<cfset formReturnData.Parameters = serializeJSON(url)>
		
		<cfinclude template="../includes/thankYou/us.cfm">
		
		<cfset var data = serializeJSON(formReturnData)>
		
		
			
		<cfif clientId NEQ 0>
			<cfinclude template="../includes/emails/RegEmail.cfm">
<cfelse>
	<cfmail from="gotv@prosperitypac.com" subject="Voter Registration Form" to="#url.Email#" remove="true" server="smtp.postmarkapp.com" username="43a619df-47a9-45f0-83e6-9f003a81fe2b" password="43a619df-47a9-45f0-83e6-9f003a81fe2b" >
			<cfmailparam file="#parentDirectory#US\temp\#fileName#" disposition="attachment">
			<cfmailpart type="text" wraptext="74">
		        Thank you for requesting your absentee ballot! 
				
				<cfif isDefined("formattedAddress")><p>Your mailing address is:
				#formattedAddress#
				
				</cfif>Please make sure that after you print this application, you sign the application and follow the instruction specific to the state in which you are registering. 
				
				Thanks again!
		    </cfmailpart>
		    <cfmailpart type="html">
			       <cfinclude template="../US/VoterRegEmailTemplate.html"> 
		    </cfmailpart>
		</cfmail>
</cfif>
		
		
		<cfset var saveState = "#stateAbbr#">
		<cfinclude template="../includes/sql/saveRegVoter.cfm" >
		
	</cflock>
		<cfcatch>
			<cfset var error = structNew()>
			<cfset error.errorMessage = "#cfcatch.Message#">
			<cfset error.parentDir = "#parentDirectory#">
			<cfif error.errorMessage EQ "Error Executing Database Query.">
				<cfset error.sqlQuery = "#cfcatch.SQL#">
				<cfset error.sqlError = "#cfcatch.queryError#">
			</cfif>
			<cfset var data = serializeJSON(error)>
		</cfcatch>
	</cftry>
		
        
	        <cfif structKeyExists(url, "callback")>
				<cfset data = url.callback & "(" & data & ")">
	        </cfif>
		<cfreturn data>
	</cffunction>
	    <cffunction name="getEDHandlerJSON"
				restpath="ElectionDay"
                access="remote"
                httpmethod="GET"
                returntype="String"
                produces="text/plain">
				
		<cfset var clientId = 0>
		<cfset var userIsAuthorized = application.bypassSecurity>
		<cfinclude template="../security.cfm" runonce="true">
		<cfif NOT userIsAuthorized>
			<cfheader statuscode="403" statustext="Unauthorized API Access">
			<cfreturn "UnauthorizedAccess">
			<cfabort>
		</cfif>	
				
		<cfset var voters = structNew()>

		<cftry>			
		<cfquery name="saveVoter" datasource="GOTV">
			IF NOT EXISTS (SELECT Email FROM Voters WHERE Email = '#url.email#')
			BEGIN
				INSERT INTO [GOTV].[dbo].[Voters]
	           ([email]
	           ,[rsta]
	           <cfif isDefined("clientId")>,[client_id]</cfif>
	           <cfif isDefined("url.voter_key")>,[voter_key]</cfif>
	           <cfif isDefined("url.personkey")>,[personkey]</cfif>
	           <cfif isDefined("url.rnc_id")>,[rnc_id]</cfif>
	           <cfif isDefined("url.rnc_regid")>,[rnc_regid]</cfif>
	           <cfif isDefined("url.captured_at")>,[captured_at]</cfif>
	           <cfif isDefined("url.gotv")>,[gotv]</cfif>
	           <cfif isDefined("url.fname")>,[fname]</cfif>
	           <cfif isDefined("url.mname")>,[mname]</cfif>
	           <cfif isDefined("url.lname")>,[lname]</cfif>
	           <cfif isDefined("url.sfx")>,[sfx]</cfif>
	           <cfif isDefined("url.dobyear")>,[dobyear]</cfif>
	           <cfif isDefined("url.dobmonth")>,[dobmonth]</cfif>
	           <cfif isDefined("url.dobday")>,[dobday]</cfif>
	           <cfif isDefined("url.age")>,[age]</cfif>
	           <cfif isDefined("url.sex")>,[sex]</cfif>
	           <cfif isDefined("url.tel_area")>,[tel_area]</cfif>
	           <cfif isDefined("url.tel_num")>,[tel_num]</cfif>
	           <cfif isDefined("url.telhome_area")>,[telhome_area]</cfif>
	           <cfif isDefined("url.telhome_num")>,[telhome_num]</cfif>
	           <cfif isDefined("url.telmob_area")>,[telmob_area]</cfif>
	           <cfif isDefined("url.telmob_num")>,[telmob_num]</cfif>
	           <cfif isDefined("url.raddr1")>,[raddr1]</cfif>
	           <cfif isDefined("url.raddr2")>,[raddr2]</cfif>
	           <cfif isDefined("url.rcity")>,[rcity]</cfif>
	           <cfif isDefined("url.rsta")>,[rsta]</cfif>
	           <cfif isDefined("url.rzip5")>,[rzip5]</cfif>
	           <cfif isDefined("url.rzip4")>,[rzip4]</cfif>
	           <cfif isDefined("url.maddr1")>,[maddr1]</cfif>
	           <cfif isDefined("url.maddr2")>,[maddr2]</cfif>
	           <cfif isDefined("url.mcity")>,[mcity]</cfif>
	           <cfif isDefined("url.msta")>,[msta]</cfif>
	           <cfif isDefined("url.mzip5")>,[mzip5]</cfif>
	           <cfif isDefined("url.mzip4")>,[mzip4]</cfif>)
	     VALUES
	           ('#url.email#',
			   'WY'
			   <cfif isDefined("clientId")>,#clientId#</cfif>
	           <cfif isDefined("url.voter_key")>,#url.voter_key#</cfif>
	           <cfif isDefined("url.personkey")>,#url.personkey#</cfif>
	           <cfif isDefined("url.rnc_id")>,#url.rnc_id#</cfif>
	           <cfif isDefined("url.rnc_regid")>,'#url.rnc_regid#'</cfif>
	           <cfif isDefined("url.captured_at")>,'#url.captured_at#'</cfif>
	           <cfif isDefined("url.gotv")>,'#url.gotv#'</cfif>
	           <cfif isDefined("url.fname")>,'#url.fname#'</cfif>
	           <cfif isDefined("url.mname")>,'#url.mname#'</cfif>
	           <cfif isDefined("url.lname")>,'#url.lname#'</cfif>
	           <cfif isDefined("url.sfx")>,'#url.sfx#'</cfif>
	           <cfif isDefined("url.dobyear")>,#url.dobyear#</cfif>
	           <cfif isDefined("url.dobmonth")>,#url.dobmonth#</cfif>
	           <cfif isDefined("url.dobday")>,#url.dobday#</cfif>
	           <cfif isDefined("url.age")>,#url.age#</cfif>
	           <cfif isDefined("url.sex")>,'#url.sex#'</cfif>
	           <cfif isDefined("url.tel_area")>,'#url.tel_area#'</cfif>
	           <cfif isDefined("url.tel_num")>,'#url.tel_num#'</cfif>
	           <cfif isDefined("url.telhome_area")>,'#url.telhome_area#'</cfif>
	           <cfif isDefined("url.telhome_num")>,'#url.telhome_num#'</cfif>
	           <cfif isDefined("url.telmob_area")>,'#url.telmob_area#'</cfif>
	           <cfif isDefined("url.telmob_num")>,'#url.telmob_num#'</cfif>
	           <cfif isDefined("url.raddr1")>,'#url.raddr1#'</cfif>
	           <cfif isDefined("url.raddr2")>,'#url.raddr2#'</cfif>
	           <cfif isDefined("url.rcity")>,'#url.rcity#'</cfif>
	           <cfif isDefined("url.rsta")>,'#url.rsta#'</cfif>
	           <cfif isDefined("url.rzip5")>,'#url.rzip5#'</cfif>
	           <cfif isDefined("url.rzip4")>,'#url.rzip4#'</cfif>
	           <cfif isDefined("url.maddr1")>,'#url.maddr1#'</cfif>
	           <cfif isDefined("url.maddr2")>,'#url.maddr2#'</cfif>
	           <cfif isDefined("url.mcity")>,'#url.mcity#'</cfif>
	           <cfif isDefined("url.msta")>,'#url.msta#'</cfif>
	           <cfif isDefined("url.mzip5")>,'#url.mzip5#'</cfif>
	           <cfif isDefined("url.mzip4")>,'#url.mzip4#'</cfif>)
		END
			<!---ELSE
				UPDATE [GOTV].[dbo].[Voters]
	           SET [email] = '#url.email#'
	           <cfif isDefined("url.client_id")>,[client_id] = #url.client_id#</cfif>
	           <cfif isDefined("url.voter_key")>,[voter_key] = #url.voter_key#</cfif>
	           <cfif isDefined("url.personkey")>,[personkey]  = #url.personkey#</cfif>
	           <cfif isDefined("url.rnc_id")>,[rnc_id] = #url.rnc_id#</cfif>
	           <cfif isDefined("url.rnc_regid")>,[rnc_regid] = '#url.rnc_regid#'</cfif>
	           <cfif isDefined("url.captured_at")>,[captured_at] = '#url.captured_at#'</cfif>
	           <cfif isDefined("url.gotv")>,[gotv] = '#url.gotv#'</cfif>
	           <cfif isDefined("url.fname")>,[fname] = '#url.fname#'</cfif>
	           <cfif isDefined("url.mname")>,[mname] = '#url.mname#'</cfif>
	           <cfif isDefined("url.lname")>,[lname] = '#url.lname#'</cfif>
	           <cfif isDefined("url.sfx")>,[sfx] = '#url.sfx#'</cfif>
	           <cfif isDefined("url.dobyear")>,[dobyear] = #url.dobyear#</cfif>
	           <cfif isDefined("url.dobmonth")>,[dobmonth] = #url.dobmonth#</cfif>
	           <cfif isDefined("url.dobday")>,[dobday] = #url.dobday#</cfif>
	           <cfif isDefined("url.age")>,[age] = #url.age#</cfif>
	           <cfif isDefined("url.sex")>,[sex] = '#url.sex#'</cfif>
	           <cfif isDefined("url.tel_area")>,[tel_area] = '#url.tel_area#'</cfif>
	           <cfif isDefined("url.tel_num")>,[tel_num] = '#url.tel_num#'</cfif>
	           <cfif isDefined("url.telhome_area")>,[telhome_area] = '#url.telhome_area#'</cfif>
	           <cfif isDefined("url.telhome_num")>,[telhome_num] = '#url.telhome_num#'</cfif>
	           <cfif isDefined("url.telmob_area")>,[telmob_area] = '#url.telmob_area#'</cfif>
	           <cfif isDefined("url.telmob_num")>,[telmob_num] = '#url.telmob_num#'</cfif>
	           <cfif isDefined("url.raddr1")>,[raddr1] = '#url.raddr1#'</cfif>
	           <cfif isDefined("url.raddr2")>,[raddr2] = '#url.raddr2#'</cfif>
	           <cfif isDefined("url.rcity")>,[rcity] = '#url.rcity#'</cfif>
	           <cfif isDefined("url.rsta")>,[rsta] = '#url.rsta#'</cfif>
	           <cfif isDefined("url.rzip5")>,[rzip5] = '#url.rzip5#'</cfif>
	           <cfif isDefined("url.rzip4")>,[rzip4] = '#url.rzip4#'</cfif>
	           <cfif isDefined("url.maddr1")>,[maddr1] = '#url.maddr1#'</cfif>
	           <cfif isDefined("url.maddr2")>,[maddr2] = '#url.maddr2#'</cfif>
	           <cfif isDefined("url.mcity")>,[mcity] = '#url.mcity#'</cfif>
	           <cfif isDefined("url.msta")>,[msta] = '#url.msta#'</cfif>
	           <cfif isDefined("url.mzip5")>,[mzip5] = '#url.mzip5#'</cfif>
	           <cfif isDefined("url.mzip4")>,[mzip4] = '#url.mzip4#'</cfif>
			   WHERE email = '#url.email#';--->
		</cfquery>
		
			
		<cfset voters.electionDayURL = saveVoter.EDWebsite>	
		<cfset voters.clientId = clientId>	
		
			<cfcatch type="any">
				<cfset voters.errorMsg = cfcatch.Detail>
			</cfcatch>
		</cftry>
			
		<cfset var data = serializeJSON(voters)>		
			
					
		<cfif structKeyExists(url, "callback")>
			<cfset data = url.callback & "(" & data & ")">
        </cfif>
        
        <cfreturn data>
        
    </cffunction>
</cfcomponent>