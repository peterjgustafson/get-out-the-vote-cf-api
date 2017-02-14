<cfpdfform source="#parentDirectory#US\GOTV_Nationwide_Voter_Reg_#stateabbr#.pdf" destination="#parentDirectory#US\temp\#fileName#" action="populate" overwriteData="true">
	        
	        <!---They wouldnt be here is they didn't check yes on the eligibility boxes in the web form. So we will just check these. --->
	        <cfpdfformparam name="are_you_citizen_yes_check" value="Yes">
	    	<cfpdfformparam name="are_you_18_yes_check" value="Yes">
	        
	        <!---Generic Fields --->
<!---			
	http://api-dev.targetedgotv.com/rest/GOTV/WI/Registration?lname=Gustafsonfname_new_voter_reg&fname=Peter&mname=Jude&title=&sfx=&raddr1=2261%20Floyd%20Rd&raddr2=&city=Springdale&rzip5=72762&cust_dobmonth=04&cust_dobday=09&cust_dobyear=1973&tel_num=2034307748&email=petergustafson@gmail.com&party=Rep&race=WHite&addr1=1234%20Fake%20Street&oaddr2=&ocity=Test&ozip5=05346&authToken=9A16C24FC0F3393F1201EB0FF66C3481B52B3C10&callback=gotvJSONPcall0
--->
	    		
	        <cfif isDefined("url.fname_new_voter_reg")>
				<!---New Voter --->
				
	    		<cfpdfformparam name="lname_new_voter_reg" value="#url.lname_new_voter_reg#">
	    		<cfpdfformparam name="fname_new_voter_reg" value="#url.fname_new_voter_reg#">
	    		<cfpdfformparam name="mname_new_voter_reg" value="#url.mname_new_voter_reg#">
	    		<cfpdfformparam name="lname" value="#url.lname_new_voter_reg#">
	    		<cfpdfformparam name="fname" value="#url.fname_new_voter_reg#">
	    		<cfpdfformparam name="mname" value="#url.mname_new_voter_reg#">
				<cfset voter.lname = url.lname_new_voter_reg>
				<cfset voter.fname = url.fname_new_voter_reg>
				<cfset voter.mname = url.mname_new_voter_reg>
				
				
				<cfif structKeyExists(url, "title")>
					<cfswitch expression="#url.title#">
						<cfcase value="mr,mr.">
							<cfpdfformparam name="prefix_mr_check_new_voter_reg" value="Yes">
						</cfcase>
						<cfcase value="sr,sr.">
							<cfpdfformparam name="prefix_mrs_check_new_voter_reg" value="Yes">
						</cfcase>
						<cfcase value="miss">
							<cfpdfformparam name="prefix_miss_check_new_voter_reg" value="Yes">
						</cfcase>
						<cfcase value="ms,ms.">
							<cfpdfformparam name="prefix_ms_check_new_voter_reg" value="Yes">
						</cfcase>
						<cfdefaultcase></cfdefaultcase>
					</cfswitch>
				</cfif>
				<cfif structKeyExists(url, "sfx")>
					<cfswitch expression="#url.sfx#">
						<cfcase value="sfx_jr_check_new_voter_reg">
							<cfpdfformparam name="sfx_jr_check_new_voter_reg" value="Yes">
							<cfset voter.sfx = "Jr.">
						</cfcase>
						<cfcase value="sfx_sr_check_new_voter_reg">
							<cfpdfformparam name="sfx_sr_check_new_voter_reg" value="Yes">
							<cfset voter.sfx = "Sr.">
						</cfcase>
						<cfcase value="sfx_ii_check_new_voter_reg">
							<cfpdfformparam name="sfx_ii_check_new_voter_reg" value="Yes">
							<cfset voter.sfx = "II">
						</cfcase>
						<cfcase value="sfx_iii_check_new_voter_reg">
							<cfpdfformparam name="sfx_iii_check_new_voter_reg" value="Yes">
							<cfset voter.sfx = "III">
						</cfcase>
						<cfcase value="sfx_iv_check_new_voter_reg">
							<cfpdfformparam name="sfx_iv_check_new_voter_reg" value="Yes">
							<cfset voter.sfx = "IV">
						</cfcase>
						<cfdefaultcase><cfset voter.sfx = ""></cfdefaultcase>
					</cfswitch>
				</cfif>
				
				
				<!--- Date of Birth --->
				<cfif isDate("#cust_dob_new_voter_regmonth#/#cust_dob_new_voter_regday#/#cust_dob_new_voter_regyear#")>
	    		<cfpdfformparam name="cust_dob_new_voter_reg" value="#cust_dob_new_voter_regmonth#/#cust_dob_new_voter_regday#/#cust_dob_new_voter_regyear#">
					<cfset voter.dobmonth = cust_dob_new_voter_regmonth>
					<cfset voter.dobday = cust_dob_new_voter_regday>
					<cfset voter.dobyear = cust_dob_new_voter_regyear>
				</cfif>
				<!--- End DOB --->
				
				<!--- Telephone Number --->
				<cfif structKeyExists(url, "cust_telephone_full")>
					<cfif len(trim(url.cust_telephone_full)) EQ 10 and isNumeric(trim(url.cust_telephone_full))>
		    			<cfpdfformparam name="cust_telephone_full" value="#url.cust_telephone_full#">
						<cfset voter.telhomearea = left(trim(url.cust_telephone_full),3)>
						<cfset voter.telhomenumber = right(trim(url.cust_telephone_full),7)>
					<cfelseif len(trim(url.cust_telephone_full)) EQ 12 and isNumeric(replace(trim(url.cust_telephone_full),"-","","all"))>
		    			<cfpdfformparam name="cust_telephone_full" value="#url.cust_telephone_full#">
						<cfset voter.telhomearea = left(replace(trim(url.cust_telephone_full),"-","","all"),3)>
						<cfset voter.telhomenumber = right(replace(trim(url.cust_telephone_full),"-","","all"),7)>
					</cfif>
				</cfif>
				<!---End Telephone --->
					
				<!--- Address Info --->
				<cfpdfformparam name="raddr1_new_voter_reg" value="#url.raddr1_new_voter_reg#">
	    		<cfpdfformparam name="raddr2_new_voter_reg" value="#url.raddr2_new_voter_reg#">
	    		<cfpdfformparam name="city_new_voter_reg" value="#url.city_new_voter_reg#">
	    		<cfpdfformparam name="rsta_new_voter_reg" value="#stateAbbr#">
	    		<cfpdfformparam name="rzip5_new_voter_reg" value="#url.rzip5_new_voter_reg#">
				
				<cfset voter.raddr1 = url.raddr1_new_voter_reg>
				<cfset voter.raddr2 = url.raddr2_new_voter_reg>
				<cfset voter.city = url.city_new_voter_reg>
				<cfset voter.rsta = stateAbbr>
				<cfset voter.rzip5 = url.rzip5_new_voter_reg>
				
				<!---Mailing Address --->
				<cfif structKeyExists(url, "maddr1_new_voter_reg")>
					<cfpdfformparam name="maddr1_new_voter_reg" value="#url.maddr1_new_voter_reg#">
		    		<cfpdfformparam name="maddr2_new_voter_reg" value="#url.maddr2_new_voter_reg#">
		    		<cfpdfformparam name="mcity_new_voter_reg" value="#url.mcity_new_voter_reg#">
		    		<cfpdfformparam name="msta_new_voter_reg" value="#url.msta_new_voter_reg#">
		    		<cfpdfformparam name="mzip5_new_voter_reg" value="#url.mzip5_new_voter_reg#">
				
					<cfset voter.maddr1 = url.maddr1_new_voter_reg>
					<cfset voter.maddr2 = url.maddr2_new_voter_reg>
					<cfset voter.mcity = url.mcity_new_voter_reg>
					<cfset voter.msta = url.msta_new_voter_reg>
					<cfset voter.mzip5 = url.mzip5_new_voter_reg>
				
				</cfif>
				<!---End Address --->
				
				
				<!---End New Voter --->
			<cfelse>
				
				<!---Other Registration Types --->
				
	    		<cfpdfformparam name="lname_new_voter_reg" value="#url.lname#">
	    		<cfpdfformparam name="fname_new_voter_reg" value="#url.fname#">
	    		<cfpdfformparam name="mname_new_voter_reg" value="#url.mname#">
	    		<cfpdfformparam name="lname" value="#url.lname#">
	    		<cfpdfformparam name="fname" value="#url.fname#">
	    		<cfpdfformparam name="mname" value="#url.mname#">
				<cfset voter.lname = url.lname>
				<cfset voter.fname = url.fname>
				<cfset voter.mname = url.mname>
				
				
				<cfif structKeyExists(url, "title")>
					<cfswitch expression="#url.title#">
						<cfcase value="mr,mr.">
							<cfpdfformparam name="prefix_mr_check_new_voter_reg" value="Yes">
						</cfcase>
						<cfcase value="sr,sr.">
							<cfpdfformparam name="prefix_mrs_check_new_voter_reg" value="Yes">
						</cfcase>
						<cfcase value="miss">
							<cfpdfformparam name="prefix_miss_check_new_voter_reg" value="Yes">
						</cfcase>
						<cfcase value="ms,ms.">
							<cfpdfformparam name="prefix_ms_check_new_voter_reg" value="Yes">
						</cfcase>
						<cfdefaultcase></cfdefaultcase>
					</cfswitch>
				</cfif>
							
				<!---Suffix is passed as text for some reason in the other form types, so we handle it differently --->
				<cfif structKeyExists(url, "sfx")>
					<cfswitch expression="#url.sfx#">
						<cfcase value="sfx_jr_check_new_voter_reg">
							<cfpdfformparam name="sfx_jr_check_new_voter_reg" value="Yes">
							<cfset voter.sfx = "Jr.">
						</cfcase>
						<cfcase value="sfx_sr_check_new_voter_reg">
							<cfpdfformparam name="sfx_sr_check_new_voter_reg" value="Yes">
							<cfset voter.sfx = "Sr.">
						</cfcase>
						<cfcase value="sfx_ii_check_new_voter_reg">
							<cfpdfformparam name="sfx_ii_check_new_voter_reg" value="Yes">
							<cfset voter.sfx = "II">
						</cfcase>
						<cfcase value="sfx_iii_check_new_voter_reg">
							<cfpdfformparam name="sfx_iii_check_new_voter_reg" value="Yes">
							<cfset voter.sfx = "III">
						</cfcase>
						<cfcase value="sfx_iv_check_new_voter_reg">
							<cfpdfformparam name="sfx_iv_check_new_voter_reg" value="Yes">
							<cfset voter.sfx = "IV">
						</cfcase>
						<cfdefaultcase><cfset voter.sfx = ""></cfdefaultcase>
					</cfswitch>
				</cfif>
				
				
				<!--- Date of Birth --->
				<cfif isDate("#cust_dobmonth#/#cust_dobday#/#cust_dobyear#")>
	    		<cfpdfformparam name="cust_dob_new_voter_reg" value="#cust_dobmonth#/#cust_dobday#/#cust_dobyear#">
					<cfset voter.dobmonth = cust_dobmonth>
					<cfset voter.dobday = cust_dobday>
					<cfset voter.dobyear = cust_dobyear>
				</cfif>
				<!--- End DOB --->
				
				<!--- Telephone Number --->
				<cfif structKeyExists(url, "tel_num")>
					<cfif len(trim(url.tel_num)) EQ 10 and isNumeric(trim(url.tel_num))>
	    			<cfpdfformparam name="v" value="#url.tel_num#">
					<cfset voter.telhomearea = left(trim(url.tel_num),3)>
					<cfset voter.telhomenumber = right(trim(url.tel_num),7)>
					</cfif>
				</cfif>
				<!---End Telephone --->
					
				<!---Address Info --->
				<cfpdfformparam name="raddr1_new_voter_reg" value="#url.raddr1#">
	    		<cfpdfformparam name="raddr2_new_voter_reg" value="#url.raddr2#">
	    		<cfpdfformparam name="city_new_voter_reg" value="#url.city#">
	    		<cfpdfformparam name="rsta_new_voter_reg" value="#stateAbbr#">
	    		<cfpdfformparam name="rzip5_new_voter_reg" value="#url.rzip5#">
				
				<cfset voter.raddr1 = url.raddr1>
				<cfset voter.raddr2 = url.raddr2>
				<cfset voter.city = url.city>
				<cfset voter.rsta = stateAbbr>
				<cfset voter.rzip5 = url.rzip5>
				
				<!---Mailing Address --->
				<cfif structKeyExists(url, "maddr1")>
					<cfpdfformparam name="maddr1_new_voter_reg" value="#url.maddr1#">
		    		<cfpdfformparam name="maddr2_new_voter_reg" value="#url.maddr2#">
		    		<cfpdfformparam name="mcity_new_voter_reg" value="#url.mcity#">
		    		<cfpdfformparam name="msta_new_voter_reg" value="#url.msta#">
					
					<cfset voter.maddr1 = url.maddr1>
					<cfset voter.maddr2 = url.maddr2>
					<cfset voter.mcity = url.mcity>
					<cfset voter.msta = url.msta>
					
					<cfif structKeyExists(url, "mzip5")>
		    			<cfpdfformparam name="mzip5_new_voter_reg" value="#url.mzip5#">
					<cfset voter.mzip5 = url.mzip5>
					<cfelseif structKeyExists(url, "mzip5_new_voter_reg")>
		    			<cfpdfformparam name="mzip5_new_voter_reg" value="#url.mzip5_new_voter_reg#">
					<cfset voter.mzip5 = url.mzip5_new_voter_reg>
					</cfif>
				
				</cfif>
				
				<!---End Address --->
				
			<!---End Other Registration Types --->
				
			</cfif>
			<!---End Generic Fields --->
			
			
	        <cfif structKeyExists(url, "ozip5")>
			<!---Change of Address --->
				<cfpdfformparam name="change_raddr1" value="#url.addr1#">
	    		<cfpdfformparam name="change_raddr2" value="#url.oaddr2#">
	    		<cfpdfformparam name="change_city" value="#url.ocity#">
	    		<cfpdfformparam name="change_rsta" value="#url.osta#">
	    		<cfpdfformparam name="change_rzip5" value="#url.ozip5#">
			<!---End COD --->
			<cfelseif structKeyExists(url, "olname")>
			<!---Change of Name --->
				<cfpdfformparam name="lname_change_name" value="#url.olname#">
	    		<cfpdfformparam name="fname_change_name" value="#url.ofname#">
	    		<cfpdfformparam name="mname_change_name" value="#url.omname#">
				
					
				<!---Suffix is passed as text for some reason in the other form types, so we handle it differently --->
				<cfif structKeyExists(url, "otitle")>
					<cfswitch expression="#url.otitle#">
						<cfcase value="mr,mr.">
							<cfpdfformparam name="prefix_mr_check_change_name" value="Yes">
						</cfcase>
						<cfcase value="sr,sr.">
							<cfpdfformparam name="prefix_mrs_check_change_name" value="Yes">
						</cfcase>
						<cfcase value="miss">
							<cfpdfformparam name="prefix_miss_checks_change_name" value="Yes">
						</cfcase>
						<cfcase value="ms,ms.">
							<cfpdfformparam name="prefix_ms_check_change_name" value="Yes">
						</cfcase>
						<cfdefaultcase></cfdefaultcase>
					</cfswitch>
				</cfif>
				<cfif structKeyExists(url, "osfx")>
					<cfswitch expression="#url.osfx#">
						<cfcase value="sfx_jr_check_new_voter_reg">
							<cfpdfformparam name="sfx_jr_check_change_name" value="Yes">
						</cfcase>
						<cfcase value="sfx_sr_check_new_voter_reg">
							<cfpdfformparam name="sfx_sr_check_change_name" value="Yes">
						</cfcase>
						<cfcase value="sfx_ii_check_new_voter_reg">
							<cfpdfformparam name="sfx_ii_check_change_name" value="Yes">
						</cfcase>
						<cfcase value="sfx_iii_check_new_voter_reg">
							<cfpdfformparam name="sfx_iii_check_change_name" value="Yes">
						</cfcase>
						<cfcase value="sfx_iv_check_new_voter_reg">
							<cfpdfformparam name="sfx_iv_check_change_name" value="Yes">
						</cfcase>
						<cfdefaultcase></cfdefaultcase>
					</cfswitch>
				</cfif>
			<!---End CON --->
			<cfelseif structKeyExists(url, "oparty")>
			<!---Change of Party --->
				<!---Nothing special to do here but maybe later. --->
			<!---End Party Change --->
			</cfif>
			
			
			
			<!---<cfset raceRequested = "AL,FL,GA,LA,NC,PA,SC">
			<cfif listFindNoCase(raceRequested,voter.rsta)>--->
				<!--- race_ethnic_group,race,race,race --->
					<cfif structKeyExists(url, "race_ethnic_group")>
	    				<cfpdfformparam name="race_ethnic_group" value="#url.race_ethnic_group#">
						<cfset voter.race = url.race_ethnic_group>
					<cfelseif structKeyExists(url, "race")>
	    				<cfpdfformparam name="race_ethnic_group" value="#url.race#">
						<cfset voter.race = url.race>
					</cfif>
			<!---</cfif>
			<cfif structKeyExists(url, "race_ethnic_group")>
				<cfset voter.race = url.race_ethnic_group>
			</cfif>--->
			
	        <cfif structKeyExists(url, "choice_of_party")>
				<cfpdfformparam name="choice_of_party" value="#url.choice_of_party#">
				<cfpdfformparam name="cust_party" value="#url.choice_of_party#">
			<cfelseif structKeyExists(url, "party")>
				<cfpdfformparam name="choice_of_party" value="#url.party#">
				<cfpdfformparam name="cust_party" value="#url.party#">
			</cfif>
	        
	    </cfpdfform>