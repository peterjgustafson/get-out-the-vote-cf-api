<cfif isDefined("url.tel_num") AND isDefined("url.cust_telephone_full")>
	<cfif len(trim(url.cust_telephone_full))>
		<cfset phone = trim(url.cust_telephone_full)>
	<cfelseif len(trim(url.tel_num))>
		<cfset phone = trim(url.tel_num)>
	</cfif>
<cfelseif isDefined("url.tel_num")>
		<cfset phone = trim(url.tel_num)>
<cfelseif isDefined("url.cust_telephone_full")>
		<cfset phone = trim(url.cust_telephone_full)>
</cfif>

<!---

evseachzip; step1complete; dtrustmatch; dtrustnomatch; dtrustmatchcorrect; dtrustmatchincorrect; dtrustmoreinfo; step3complete; step4complete
 --->

<cfquery name="saveVoter" datasource="GOTV">
			IF NOT EXISTS (SELECT Email FROM Voters WHERE Email = '#url.email#' AND gotv = 'Absentee')
			BEGIN
				INSERT INTO Voters
	           ([email]
	           ,[rsta]
	           ,[gotv]
	           <cfif isDefined("clientId")>,[client_id]</cfif>
	           <cfif isDefined("VoterKey")>,[voter_key]</cfif>
	           <cfif isDefined("PersonKey")>,[personkey]</cfif>
	           <cfif isDefined("RNCID") AND isNumeric(RNCID)>,[rnc_id]</cfif>
	           <cfif isDefined("url.rnc_regid") AND isNumeric(url.rnc_regid)>,[rnc_regid]</cfif>
	           <cfif isDefined("url.captured_at") AND isNumeric(url.captured_at)>,[captured_at]</cfif>
	           <cfif isDefined("url.fname")>,[fname]</cfif>
	           <cfif isDefined("url.mname")>,[mname]</cfif>
	           <cfif isDefined("url.lname")>,[lname]</cfif>
	           <cfif isDefined("url.sfx")>,[sfx]</cfif>
	           <cfif isDefined("url.cust_dobyear") AND isNumeric(url.cust_dobyear)>,[dobyear]</cfif>
	           <cfif isDefined("url.cust_dobmonth") AND isNumeric(url.cust_dobmonth)>,[dobmonth]</cfif>
	           <cfif isDefined("url.cust_dobday") AND isNumeric(url.cust_dobday)>,[dobday]</cfif>
	           <!---<cfif isDefined("url.age")>,[age]</cfif>--->
	           <cfif isDefined("Gender")>,[sex]</cfif>
	           <cfif isDefined("phone")>,[tel_area]</cfif>
	           <cfif isDefined("phone")>,[tel_num]</cfif>
	           <cfif isDefined("url.telhome_num")>,[telhome_area]</cfif>
	           <cfif isDefined("url.telhome_num")>,[telhome_num]</cfif>
	           <cfif isDefined("url.telmob_area")>,[telmob_area]</cfif>
	           <cfif isDefined("url.telmob_num")>,[telmob_num]</cfif>
	           <cfif isDefined("url.raddr1")>,[raddr1]</cfif>
	           <cfif isDefined("url.raddr2")>,[raddr2]</cfif>
	           <cfif isDefined("url.city")>,[rcity]<cfelseif isDefined("url.rcity")>,[rcity]</cfif>
	           <cfif isDefined("url.rzip5")>,[rzip5]</cfif>
	           <cfif isDefined("url.maddr1")>,[maddr1]</cfif>
	           <cfif isDefined("url.maddr2")>,[maddr2]</cfif>
	           <cfif isDefined("url.mcity")>,[mcity]</cfif>
	           <cfif isDefined("url.msta")>,[msta]</cfif>
	           <cfif isDefined("url.mzip5")>,[mzip5]</cfif>
	           <cfif isDefined("url.evseachzip")>,[evseachzip]</cfif>
	           <cfif isDefined("url.step1complete")>,[step1complete]</cfif>
	           <cfif isDefined("url.dtrustmatch")>,[dtrustmatch]</cfif>
	           <cfif isDefined("url.dtrustnomatch")>,[dtrustnomatch]</cfif>
	           <cfif isDefined("url.dtrustmatchcorrect")>,[dtrustmatchcorrect]</cfif>
	           <cfif isDefined("url.dtrustmatchincorrect")>,[dtrustmatchincorrect]</cfif>
	           <cfif isDefined("url.dtrustmoreinfo")>,[dtrustmoreinfo]</cfif>
	           <cfif isDefined("url.step3complete")>,[step3complete]</cfif>
	           <cfif isDefined("url.step4complete")>,[step4complete]</cfif>)
	     VALUES
	           ('#url.email#'
	           ,'#saveState#'
			   ,'Absentee'
			   <cfif isDefined("clientId")>,#clientId#</cfif>
	           <cfif isDefined("VoterKey")>,#VoterKey#</cfif>
	           <cfif isDefined("PersonKey")>,#PersonKey#</cfif>
	           <cfif isDefined("RNCID") AND isNumeric(RNCID)>,#RNCID#</cfif>
	           <cfif isDefined("url.rnc_regid") AND isNumeric(url.rnc_regid)>,'#url.rnc_regid#'</cfif>
	           <cfif isDefined("url.captured_at") AND isNumeric(url.captured_at)>,'#url.captured_at#'</cfif>
	           <cfif isDefined("url.fname")>,'#url.fname#'</cfif>
	           <cfif isDefined("url.mname")>,'#url.mname#'</cfif>
	           <cfif isDefined("url.lname")>,'#url.lname#'</cfif>
	           <cfif isDefined("url.sfx")>,'#url.sfx#'</cfif>
	           <cfif isDefined("url.cust_dobyear") AND isNumeric(url.cust_dobyear)>,#url.cust_dobyear#</cfif>
	           <cfif isDefined("url.cust_dobmonth") AND isNumeric(url.cust_dobmonth)>,#url.cust_dobmonth#</cfif>
	           <cfif isDefined("url.cust_dobday") AND isNumeric(url.cust_dobday)>,#url.cust_dobday#</cfif>
	           <!---<cfif isDefined("url.age")>,#url.age#</cfif>--->
	           <cfif isDefined("Gender")>,'#Gender#'</cfif>
	           <cfif isDefined("phone")>,'#left(phone,3)#'
			   ,'#right(replaceNoCase(phone,"-", "", "ALL"),7)#'</cfif>
	           <cfif isDefined("url.telhome_area")>,'#left(url.telhome_area,3)#'</cfif>
	           <cfif isDefined("url.telhome_num")>,'#right(url.telhome_num,7)#'</cfif>
	           <cfif isDefined("url.telhome_num")>,'#url.telmob_area#'</cfif>
	           <cfif isDefined("url.telmob_num")>,'#url.telmob_num#'</cfif>
	           <cfif isDefined("url.raddr1")>,'#url.raddr1#'</cfif>
	           <cfif isDefined("url.raddr2")>,'#url.raddr2#'</cfif>
	           <cfif isDefined("url.city")>,'#url.city#'<cfelseif isDefined("url.rcity")>,'#url.rcity#'</cfif>
	           <cfif isDefined("url.rzip5")>,'#url.rzip5#'</cfif>
	           <cfif isDefined("url.maddr1")>,'#url.maddr1#'</cfif>
	           <cfif isDefined("url.maddr2")>,'#url.maddr2#'</cfif>
	           <cfif isDefined("url.mcity")>,'#url.mcity#'</cfif>
	           <cfif isDefined("url.msta")>,'#url.msta#'</cfif>
	           <cfif isDefined("url.mzip5")>,'#url.mzip5#'</cfif>
	           <cfif isDefined("url.evseachzip")>,'#url.evseachzip#'</cfif>
	           <cfif isDefined("url.step1complete")>,'#url.step1complete#'</cfif>
	           <cfif isDefined("url.dtrustmatch")>,'#url.dtrustmatch#'</cfif>
	           <cfif isDefined("url.dtrustnomatch")>,'#url.dtrustnomatch#'</cfif>
	           <cfif isDefined("url.dtrustmatchcorrect")>,'#url.dtrustmatchcorrect#'</cfif>
	           <cfif isDefined("url.dtrustmatchincorrect")>,'#url.dtrustmatchincorrect#'</cfif>
	           <cfif isDefined("url.dtrustmoreinfo")>,'#url.dtrustmoreinfo#'</cfif>
	           <cfif isDefined("url.step3complete")>,'#url.step3complete#'</cfif>
	           <cfif isDefined("url.step4complete")>,'#url.step4complete#'</cfif>)
		END
			ELSE
				UPDATE Voters
	           SET [email] = '#url.email#'
	           <cfif isDefined("clientId")>,[client_id] = #clientId#</cfif>
	           <cfif isDefined("VoterKey")>,[voter_key] = #VoterKey#</cfif>
	           <cfif isDefined("PersonKey")>,[personkey]  = #PersonKey#</cfif>
	           <cfif isDefined("RNCID")>,[rnc_id] = #RNCID#</cfif>
	           <cfif isDefined("url.rnc_regid")>,[rnc_regid] = '#url.rnc_regid#'</cfif>
	           <cfif isDefined("url.captured_at")>,[captured_at] = '#url.captured_at#'</cfif>
	           <cfif isDefined("url.gotv")>,[gotv] = 'Absentee'</cfif>
	           <cfif isDefined("url.fname")>,[fname] = '#url.fname#'</cfif>
	           <cfif isDefined("url.mname")>,[mname] = '#url.mname#'</cfif>
	           <cfif isDefined("url.lname")>,[lname] = '#url.lname#'</cfif>
	           <cfif isDefined("url.sfx")>,[sfx] = '#url.sfx#'</cfif>
	           <cfif isDefined("url.dobyear")>,[dobyear] = #url.dobyear#</cfif>
	           <cfif isDefined("url.dobmonth")>,[dobmonth] = #url.dobmonth#</cfif>
	           <cfif isDefined("url.dobday")>,[dobday] = #url.dobday#</cfif>
	           <cfif isDefined("url.Gender")>,[sex] = '#Gender#'</cfif>
	           <cfif isDefined("url.phone")>,[tel_area] = '#left(phone,3)#'
			   ,[tel_num] = '#right(replaceNoCase(phone,"-", "", "ALL"),7)#'</cfif>
	           <cfif isDefined("url.raddr1")>,[raddr1] = '#url.raddr1#'</cfif>
	           <cfif isDefined("url.raddr2")>,[raddr2] = '#url.raddr2#'</cfif>
	           <cfif isDefined("url.city")>,[rcity] = '#url.city#'<cfelseif isDefined("url.rcity")>,[rcity] = '#url.rcity#'</cfif>
	           <cfif isDefined("url.rsta")>,[rsta] = '#url.rsta#'</cfif>
	           <cfif isDefined("url.rzip5")>,[rzip5] = '#url.rzip5#'</cfif>
	           <cfif isDefined("url.maddr1")>,[maddr1] = '#url.maddr1#'</cfif>
	           <cfif isDefined("url.maddr2")>,[maddr2] = '#url.maddr2#'</cfif>
	           <cfif isDefined("url.mcity")>,[mcity] = '#url.mcity#'</cfif>
	           <cfif isDefined("url.msta")>,[msta] = '#url.msta#'</cfif>
	           <cfif isDefined("url.mzip5")>,[mzip5] = '#url.mzip5#'</cfif>
	           <cfif isDefined("url.evseachzip")>,[evseachzip] = '#url.evseachzip#'</cfif>
	           <cfif isDefined("url.step1complete")>,[step1complete] = '#url.step1complete#'</cfif>
	           <cfif isDefined("url.dtrustmatch")>,[dtrustmatch] = '#url.dtrustmatch#'</cfif>
	           <cfif isDefined("url.dtrustnomatch")>,[dtrustnomatch] = '#url.dtrustnomatch#'</cfif>
	           <cfif isDefined("url.dtrustmatchcorrect")>,[dtrustmatchcorrect] = '#url.dtrustmatchcorrect#'</cfif>
	           <cfif isDefined("url.dtrustmatchincorrect")>,[dtrustmatchincorrect] = '#url.dtrustmatchincorrect#'</cfif>
	           <cfif isDefined("url.dtrustmoreinfo")>,[dtrustmoreinfo] = '#url.dtrustmoreinfo#'</cfif>
	           <cfif isDefined("url.step3complete")>,[step3complete] = '#url.step3complete#'</cfif>
	           <cfif isDefined("url.step4complete")>,[step4complete] = '#url.step4complete#'</cfif>
			   WHERE email = '#url.email#' AND gotv = 'Absentee';
			   <!---

evseachzip; step1complete; dtrustmatch; dtrustnomatch; dtrustmatchcorrect; dtrustmatchincorrect; dtrustmoreinfo; step3complete; step4complete
 --->
		</cfquery>